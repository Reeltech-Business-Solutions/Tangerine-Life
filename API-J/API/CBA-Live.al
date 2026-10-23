codeunit 50669 tangerine_life_cba
{
    procedure HttpGetTangerineLive(start_date: date; end_date: date; ForceRegenerate: Boolean; Refetch: Boolean; normal: Boolean): Boolean
    var
        HttpClient: HttpClient;
        HttpHeaders: HttpHeaders;
        contentHeaders: httpHeaders;
        HttpContent: HttpContent;
        HttpRequestMessage: HttpRequestMessage;
        Response: HttpResponseMessage;
        isSuccessful: Boolean;
        ErrorMessage: Label 'Http Request Failed';
        securityKeyError: Label 'Security key is empty';
        uriError: Label 'uri is empty';
        jsonError: Label 'json is empty';
        JsonToken, InnerToken, MessageToken : JsonToken;
        JsonObject, InnerObject, MessageObject : JsonObject;
        ResponseText: Text;
        uri: Text;
    begin
        // // uri := StrSubstNo('https://ies.tangerinelife.com/demo/api_ies/ies_connect.php?process=glreport&&start_date=%1&&end_date=%2', start_date, end_date);
        // uri := urt;
        // message(uri);

        uri := BuildURL(start_date, end_date, ForceRegenerate, Refetch, normal);

        HttpContent.GetHeaders(contentHeaders);

        if contentHeaders.Contains('Content-Type') then
            contentHeaders.Remove('Content-Type');
        contentHeaders.Add('Content-Type', 'application/json');

        HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + securityKeyValue);
        HttpClient.DefaultRequestHeaders.Add('accept', 'application/json');

        if not HttpClient.Get(uri, Response) then begin
            Error('Http GET request failed for: %1', uri);
            exit(false);
        end;

        Response.Content().ReadAs(ResponseText);

        //  Message('Response %1', ResponseText);

        if not Response.IsSuccessStatusCode() THEN begin
            Error('HTTP %1 -%2', Response.HttpStatusCode(), ResponseText);
            exit(false);
        end;
        GetFetch(ResponseText);
        exit(true);


        if not Response.IsSuccessStatusCode() then begin
            Error('HTTP %1 - %2', Response.HttpStatusCode(), ResponseText);
            exit(false);
        end;
    end;

    procedure BuildURL(start_date: date; end_date: date; ForceRegenerate: Boolean; Refetch: Boolean; normal: boolean): Text
    var
        URL: Text;
        BaseURL: Text;
    begin
        BaseURL := 'https://ies.tangerinelife.com/api_ies/ies_connect.php';
        // BaseURL := 'https://www.ies.tangerinelife.com';

        if Refetch then
            URL := StrSubstNo('%1?process=glreport-refetch&&start_date=%2&&end_date=%3&&refetch=true',
                BaseURL,
                Format(start_date, 0, '<Year4>-<Month,2>-<Day,2>'),
                Format(end_date, 0, '<Year4>-<Month,2>-<Day,2>'))
        else if ForceRegenerate then
            URL := StrSubstNo('%1?process=glreport&&start_date=%2&&end_date=%3&&force_regenerate=true',
                BaseURL,
                Format(start_date, 0, '<Year4>-<Month,2>-<Day,2>'),
                Format(end_date, 0, '<Year4>-<Month,2>-<Day,2>'))
        else if normal then
            URL := StrSubstNo('%1?process=glreport&&start_date=%2&&end_date=%3',
                BaseURL,
                Format(start_date, 0, '<Year4>-<Month,2>-<Day,2>'),
                Format(end_date, 0, '<Year4>-<Month,2>-<Day,2>'));
        // Message('url %1', URL);

        exit(URL);
    end;


    procedure GetFetch(ResponseText: Text)
    var
        Response: HttpResponseMessage;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
        DataArray: JsonArray;
        jsonTokenLoop: JsonToken;
        JsonObjectLoop: JsonObject;
        ResultObject: JsonObject;
        dataToken: JsonToken;
        liveCBA: Record TangerinelifeCBA;
        cba: Record TangerinelifeCBA;
        cbaExists: boolean;
        JsonStartPos: Integer;
        CleanResponse: Text;

    begin

        JsonStartPos := StrPos(ResponseText, '{');
        if JsonStartPos = 0 then
            Error('No JSON found in response. Raw response: %1', CopyStr(ResponseText, 1, 500));

        CleanResponse := CopyStr(ResponseText, JsonStartPos);

        if not JsonResponse.ReadFrom(CleanResponse) then
            Error('Failed to parse JSON. Raw response: %1', CopyStr(ResponseText, 1, 500));

        if not JsonResponse.Get('result', JsonToken) then
            Error('No result found in response');

        ResultObject := JsonToken.AsObject();

        if not ResultObject.Get('data', JsonToken) then
            Error('No data found in result');


        DataArray := JsonToken.AsArray();
        foreach JsonTokenLoop in DataArray do begin
            cbaExists := true;
            JsonObjectLoop := jsonTokenLoop.AsObject();
            Clear(liveCBA);
            liveCBA.Init();

            //  transid

            if JsonObjectLoop.Get('transid', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.No := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('ledger_name', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.Ledger_name := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('ledger_name', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.Ledger_name := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('ledger_code', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.ledger_code := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('account_class_name', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.account_class_name := JsonToken.AsValue().AsText();

            if JsonObjectLoop.Get('account_class_code', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.account_class_code := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('transaction_class_name', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.transaction_class_name := JsonToken.AsValue().AsText();

            if JsonObjectLoop.Get('trasaction_class_code', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.transaction_class_code := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('refnum', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.refnum := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('note', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.note := CopyStr(JsonToken.AsValue().AsText(), 1, 100);

            if JsonObjectLoop.Get('opening_balance', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.opening_balance := JsonToken.AsValue().AsDecimal();

            if JsonObjectLoop.Get('balance_bf', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.balance_bf := JsonToken.AsValue().AsDecimal();

            if JsonObjectLoop.Get('period_balance', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.period_balance := JsonToken.AsValue().AsDecimal();

            if JsonObjectLoop.Get('current_balance', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.current_balance := JsonToken.AsValue().AsInteger();

            if JsonObjectLoop.Get('credit_balance', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.credit_balance := JsonToken.AsValue().AsDecimal();

            if JsonObjectLoop.Get('debit_balance', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.debit_balance := JsonToken.AsValue().AsDecimal();

            if JsonObjectLoop.Get('cheque_num', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.cheque_num := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('effective_date', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.effective_date := JsonToken.AsValue().AsDate();

            if JsonObjectLoop.Get('transaction_date', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.transaction_date := JsonToken.AsValue().Asdate();

            if JsonObjectLoop.Get('entry_date', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.entry_date := JsonToken.AsValue().AsDate();

            if JsonObjectLoop.Get('proposal_number', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.proposal_number := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('policy_number', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.policy_number := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('policy_class', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.policy_class := JsonToken.AsValue().AsCode();


            if JsonObjectLoop.Get('debit_note', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.debit_note := JsonToken.AsValue().AsText();

            if JsonObjectLoop.Get('bank', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.bank := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('bank_refid', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.bank_refid := JsonToken.AsValue().AsText();

            if JsonObjectLoop.Get('branch', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.branch := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('agency', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.agency := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('business_central_gl', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.business_central_gl := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('business_central_bank', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.business_central_bank := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('buscntrl_product_code', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.product_dimension := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('buscntrl_branch_code', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.branch_dimension := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('buscntrl_dept_code', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    liveCBA.department_dimension := JsonToken.AsValue().AsCode();

            if JsonObjectLoop.Get('benef', JsonToken) then
                if not JsonToken.AsValue().IsNull then
                    liveCBA.beneficiary := JsonToken.AsValue().AsCode();
            cba.setRange(No, liveCBA.No);
            if cba.FindFirst() then
                cbaExists := false;

            if cbaExists then
                liveCBA.insert(true);

        end;
        //  Message('Success');
    end;

    var
        myInt: Integer;
        securityKeyValue: Label '3777bc7d601eb766a30a96d965727622';
        // 3777bc7d601eb766a30a96d965727622


        urt: Label 'https://ies.tangerinelife.com/api_ies/ies_connect.php?process=glreport';

}