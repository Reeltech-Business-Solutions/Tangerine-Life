codeunit 50634 "FnO Exp Attachment Import"
{
    // procedure GetExpAttachedDocumentsBatch(SkipCount: Integer; TopCount: Integer): JsonArray
    // var
    //     Setup: Record "FnO Integration Setup";
    //     TokenMgt: Codeunit "FnO OAuth Token Mgt";
    //     Client: HttpClient;
    //     ResponseMessage: HttpResponseMessage;
    //     AccessToken: Text;
    //     ApiUrl: Text;
    //     ResponseText: Text;
    //     JObj: JsonObject;
    //     JToken: JsonToken;
    // begin
    //     Setup.Get();
    //     AccessToken := TokenMgt.GetAccesToken();

    //     // NOTE: ExpAttachedDocuments does not expose a dataAreaId filter the way
    //     // PurchaseOrderHeaderDocumentAttachments does in the sample payload
    //     // (company is carried in RefCompanyId / ActualCompanyId instead), so no
    //     // company filter is applied here. Add one with $filter if you need to
    //     // scope this to a specific legal entity.
    //     ApiUrl := Setup."F&O Environment URL" +
    //         '/data/ExpAttachedDocuments?$top=' + Format(TopCount) +
    //         '&$skip=' + Format(SkipCount) +
    //         '&$orderby=DocumentId';

    //     Client.DefaultRequestHeaders.Clear();
    //     Client.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

    //     if not Client.Get(ApiUrl, ResponseMessage) then
    //         Error('GET call to F&O failed.');

    //     if not ResponseMessage.IsSuccessStatusCode() then
    //         Error('F&O request failed. Status Code: %1', ResponseMessage.HttpStatusCode());

    //     ResponseMessage.Content().ReadAs(ResponseText);

    //     JObj.ReadFrom(ResponseText);

    //     if not JObj.Get('value', JToken) then
    //         Error('Unexpected response from F&O');

    //     exit(JToken.AsArray());
    // end;

    // procedure ImportBatch(AttachmentsArray: JsonArray; var SkippedCount: Integer): Integer
    // var
    //     ExpDoc: Record "F&OTable";
    //     Base64Convert: Codeunit "Base64 Convert";
    //     TempBlob: Codeunit "Temp Blob";
    //     InStr: InStream;
    //     OutStr: OutStream;
    //     JsonTokenLoop: JsonToken;
    //     JsonObjectLoop: JsonObject;
    //     ShouldProcess: Boolean;
    //     DocumentId: Text;
    //     FileName: Text;
    //     FileExtension: Text;
    //     CapturedDocument: Text;
    //     Base64Payload: Text;
    //     EntRecIdTxt: Text;
    //     RefRecIdTxt: Text;
    //     ValueRecIdTxt: Text;
    //     RefTableIdTxt: Text;
    //     CreatingWorkerTxt: Text;
    //     AuthorTxt: Text;
    //     BigIntValue: BigInteger;
    //     IntValue: Integer;
    //     ImportedCount: Integer;
    // begin
    //     foreach JsonTokenLoop in AttachmentsArray do begin
    //         JsonObjectLoop := JsonTokenLoop.AsObject();
    //         ShouldProcess := true;

    //         if not TryGetTextField(JsonObjectLoop, 'DocumentId', DocumentId) or (DocumentId = '') then
    //             ShouldProcess := false;

    //         if ShouldProcess and ExpDoc.Get(DocumentId) then
    //             ShouldProcess := false; // already imported, don't overwrite

    //         if ShouldProcess then
    //             TryGetTextField(JsonObjectLoop, 'FileName', FileName);

    //         if ShouldProcess then
    //             TryGetTextField(JsonObjectLoop, 'CapturedDocument', CapturedDocument);

    //         if ShouldProcess then
    //             TryGetTextField(JsonObjectLoop, 'FileExtension', FileExtension);

    //         if ShouldProcess then begin
    //             ExpDoc.Init();
    //             ExpDoc."Document Id" := CopyStr(DocumentId, 1, 100);
    //             ExpDoc."File Name" := CopyStr(FileName, 1, 250);
    //             ExpDoc."File Extension" := CopyStr(FileExtension, 1, 20);

    //             if TryGetTextField(JsonObjectLoop, 'ContentType', EntRecIdTxt) then
    //                 ExpDoc."Content Type" := CopyStr(EntRecIdTxt, 1, 100);

    //             if TryGetTextField(JsonObjectLoop, 'RefCompanyId', EntRecIdTxt) then
    //                 ExpDoc."Ref Company Id" := CopyStr(EntRecIdTxt, 1, 20);

    //             if TryGetTextField(JsonObjectLoop, 'ActualCompanyId', EntRecIdTxt) then
    //                 ExpDoc."Actual Company Id" := CopyStr(EntRecIdTxt, 1, 20);

    //             if TryGetTextField(JsonObjectLoop, 'DefaultAttachment', EntRecIdTxt) then
    //                 ExpDoc."Default Attachment" := CopyStr(EntRecIdTxt, 1, 10);

    //             if TryGetTextField(JsonObjectLoop, 'IsJustification', EntRecIdTxt) then
    //                 ExpDoc."Is Justification" := CopyStr(EntRecIdTxt, 1, 10);

    //             if TryGetTextField(JsonObjectLoop, 'IsReceiptAttached', EntRecIdTxt) then
    //                 ExpDoc."Is Receipt Attached" := CopyStr(EntRecIdTxt, 1, 10);

    //             if TryGetTextField(JsonObjectLoop, 'IsReceiptValid', EntRecIdTxt) then
    //                 ExpDoc."Is Receipt Valid" := CopyStr(EntRecIdTxt, 1, 10);

    //             if TryGetTextField(JsonObjectLoop, 'CapturedReceipt', EntRecIdTxt) then
    //                 ExpDoc."Captured Receipt" := CopyStr(EntRecIdTxt, 1, 250);

    //             if TryGetTextField(JsonObjectLoop, 'DocumentCreatedBy', EntRecIdTxt) then
    //                 ExpDoc."Document Created By" := CopyStr(EntRecIdTxt, 1, 100);

    //             if TryGetTextField(JsonObjectLoop, 'Notes', EntRecIdTxt) then
    //                 ExpDoc.Notes := CopyStr(EntRecIdTxt, 1, 250);

    //             if TryGetTextField(JsonObjectLoop, 'ExpTransNumber', EntRecIdTxt) then
    //                 ExpDoc."Exp Trans Number" := CopyStr(EntRecIdTxt, 1, 50);

    //             if TryGetTextField(JsonObjectLoop, 'DocuRefTableName', EntRecIdTxt) then
    //                 ExpDoc."Docu Ref Table Name" := CopyStr(EntRecIdTxt, 1, 100);

    //             if TryGetTextField(JsonObjectLoop, 'CreatingDateTime', EntRecIdTxt) then
    //                 ExpDoc."Creating Date Time" := CopyStr(EntRecIdTxt, 1, 50);

    //             if TryGetTextField(JsonObjectLoop, 'DocumentCreatedDateTime', EntRecIdTxt) then
    //                 ExpDoc."Document Created Date Time" := CopyStr(EntRecIdTxt, 1, 50);

    //             // Numeric fields - read as text from JSON, then evaluate defensively
    //             if TryGetTextField(JsonObjectLoop, 'EntRecId', EntRecIdTxt) and Evaluate(BigIntValue, EntRecIdTxt) then
    //                 ExpDoc."Ent Rec Id" := BigIntValue;

    //             if TryGetTextField(JsonObjectLoop, 'RefRecId', RefRecIdTxt) and Evaluate(BigIntValue, RefRecIdTxt) then
    //                 ExpDoc."Ref Rec Id" := BigIntValue;

    //             if TryGetTextField(JsonObjectLoop, 'ValueRecId', ValueRecIdTxt) and Evaluate(BigIntValue, ValueRecIdTxt) then
    //                 ExpDoc."Value Rec Id" := BigIntValue;

    //             if TryGetTextField(JsonObjectLoop, 'RefTableId', RefTableIdTxt) and Evaluate(IntValue, RefTableIdTxt) then
    //                 ExpDoc."Ref Table Id" := IntValue;

    //             if TryGetTextField(JsonObjectLoop, 'CreatingWorker', CreatingWorkerTxt) and Evaluate(BigIntValue, CreatingWorkerTxt) then
    //                 ExpDoc."Creating Worker" := BigIntValue;

    //             if TryGetTextField(JsonObjectLoop, 'Author', AuthorTxt) and Evaluate(IntValue, AuthorTxt) then
    //                 ExpDoc.Author := IntValue;

    //             // CapturedDocument arrives as a data URI: data:<mime>;base64,<payload>
    //             if CapturedDocument <> '' then begin
    //                 Base64Payload := ExtractBase64Payload(CapturedDocument);
    //                 if Base64Payload <> '' then begin
    //                     Clear(TempBlob);
    //                     TempBlob.CreateOutStream(OutStr);
    //                     Base64Convert.FromBase64(Base64Payload, OutStr);
    //                     TempBlob.CreateInStream(InStr);

    //                     ExpDoc.Attachment.CreateOutStream(OutStr);
    //                     CopyStream(OutStr, InStr);
    //                     ExpDoc."Attachment Size" := TempBlob.Length();
    //                 end;
    //             end;

    //             ExpDoc."Imported DateTime" := CurrentDateTime();
    //             ExpDoc.Insert(true);

    //             ImportedCount += 1;
    //         end else
    //             SkippedCount += 1;
    //     end;

    //     exit(ImportedCount);
    // end;

    // procedure ImportAllAttachments(var TotalImported: Integer; var TotalSkipped: Integer)
    // var
    //     Setup: Record "FnO Integration Setup";
    //     SkipCount: Integer;
    //     BatchSize: Integer;
    //     AttachmentsArray: JsonArray;
    //     BatchImported: Integer;
    //     BatchSkipped: Integer;
    //     RowsInThisPage: Integer;
    // begin
    //     Setup.Get();
    //     BatchSize := Setup."Batch Size";
    //     if BatchSize = 0 then
    //         BatchSize := 20;

    //     SkipCount := 0;
    //     TotalImported := 0;
    //     TotalSkipped := 0;

    //     repeat
    //         AttachmentsArray := GetExpAttachedDocumentsBatch(SkipCount, BatchSize);
    //         RowsInThisPage := AttachmentsArray.Count();

    //         BatchSkipped := 0;
    //         BatchImported := ImportBatch(AttachmentsArray, BatchSkipped);

    //         TotalImported += BatchImported;
    //         TotalSkipped += BatchSkipped;

    //         SkipCount += BatchSize;
    //         Commit(); // persist progress after every batch - important given the source expires tomorrow
    //     until RowsInThisPage < BatchSize;
    // end;

    // local procedure ExtractBase64Payload(FullValue: Text): Text
    // var
    //     CommaPos: Integer;
    // begin
    //     CommaPos := StrPos(FullValue, ',');
    //     if CommaPos = 0 then
    //         exit(FullValue); // no data-URI prefix present, assume it's already raw base64

    //     exit(CopyStr(FullValue, CommaPos + 1));
    // end;

    // [TryFunction]
    // local procedure TryGetTextField(JObj: JsonObject; FieldName: Text; var Value: Text)
    // var
    //     JToken: JsonToken;
    // begin
    //     Value := '';
    //     if not JObj.Get(FieldName, JToken) then
    //         exit;
    //     if JToken.AsValue().IsNull then
    //         exit;
    //     Value := JToken.AsValue().AsText();
    // end;

    procedure GetExpAttachedDocumentsBatch(SkipCount: Integer; TopCount: Integer): JsonArray
    var
        Setup: Record "FnO Integration Setup";
        TokenMgt: Codeunit "FnO OAuth Token Mgt";
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        AccessToken: Text;
        ApiUrl: Text;
        ResponseText: Text;
        JObj: JsonObject;
        JToken: JsonToken;
    begin
        Setup.Get();
        AccessToken := TokenMgt.GetAccesToken();

        // NOTE: ExpAttachedDocuments does not expose a dataAreaId filter the way
        // PurchaseOrderHeaderDocumentAttachments does in the sample payload
        // (company is carried in RefCompanyId / ActualCompanyId instead), so no
        // company filter is applied here. Add one with $filter if you need to
        // scope this to a specific legal entity.
        ApiUrl := Setup."F&O Environment URL" +
            '/data/ExpAttachedDocuments?$top=' + Format(TopCount) +
            '&$skip=' + Format(SkipCount) +
            '&$orderby=DocumentId';

        Client.DefaultRequestHeaders.Clear();
        Client.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

        if not Client.Get(ApiUrl, ResponseMessage) then
            Error('GET call to F&O failed.');

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('F&O request failed. Status Code: %1', ResponseMessage.HttpStatusCode());

        ResponseMessage.Content().ReadAs(ResponseText);

        JObj.ReadFrom(ResponseText);

        if not JObj.Get('value', JToken) then
            Error('Unexpected response from F&O');

        exit(JToken.AsArray());
    end;

    procedure ImportBatch(AttachmentsArray: JsonArray; var SkippedCount: Integer): Integer
    var
        ExpDoc: Record "F&OTable";
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
        JsonTokenLoop: JsonToken;
        JsonObjectLoop: JsonObject;
        ShouldProcess: Boolean;
        DocumentId: Text;
        FileName: Text;
        FileExtension: Text;
        CapturedDocument: Text;
        Base64Payload: Text;
        EntRecIdTxt: Text;
        RefRecIdTxt: Text;
        ValueRecIdTxt: Text;
        RefTableIdTxt: Text;
        CreatingWorkerTxt: Text;
        AuthorTxt: Text;
        BigIntValue: BigInteger;
        IntValue: Integer;
        ImportedCount: Integer;
    begin
        foreach JsonTokenLoop in AttachmentsArray do begin
            JsonObjectLoop := JsonTokenLoop.AsObject();
            ShouldProcess := true;

            if not TryGetTextField(JsonObjectLoop, 'DocumentId', DocumentId) or (DocumentId = '') then
                ShouldProcess := false;

            if ShouldProcess and ExpDoc.Get(DocumentId) then
                ShouldProcess := false; // already imported, don't overwrite

            if ShouldProcess then
                TryGetTextField(JsonObjectLoop, 'FileName', FileName);

            if ShouldProcess then
                TryGetTextField(JsonObjectLoop, 'CapturedDocument', CapturedDocument);

            if ShouldProcess then
                TryGetTextField(JsonObjectLoop, 'FileExtension', FileExtension);

            if ShouldProcess then begin
                ExpDoc.Init();
                ExpDoc."Document Id" := CopyStr(DocumentId, 1, 100);
                ExpDoc."File Name" := CopyStr(FileName, 1, 250);
                ExpDoc."File Extension" := CopyStr(FileExtension, 1, 20);

                if TryGetTextField(JsonObjectLoop, 'ContentType', EntRecIdTxt) then
                    ExpDoc."Content Type" := CopyStr(EntRecIdTxt, 1, 100);

                if TryGetTextField(JsonObjectLoop, 'RefCompanyId', EntRecIdTxt) then
                    ExpDoc."Ref Company Id" := CopyStr(EntRecIdTxt, 1, 20);

                if TryGetTextField(JsonObjectLoop, 'ActualCompanyId', EntRecIdTxt) then
                    ExpDoc."Actual Company Id" := CopyStr(EntRecIdTxt, 1, 20);

                if TryGetTextField(JsonObjectLoop, 'DefaultAttachment', EntRecIdTxt) then
                    ExpDoc."Default Attachment" := CopyStr(EntRecIdTxt, 1, 10);

                if TryGetTextField(JsonObjectLoop, 'IsJustification', EntRecIdTxt) then
                    ExpDoc."Is Justification" := CopyStr(EntRecIdTxt, 1, 10);

                if TryGetTextField(JsonObjectLoop, 'IsReceiptAttached', EntRecIdTxt) then
                    ExpDoc."Is Receipt Attached" := CopyStr(EntRecIdTxt, 1, 10);

                if TryGetTextField(JsonObjectLoop, 'IsReceiptValid', EntRecIdTxt) then
                    ExpDoc."Is Receipt Valid" := CopyStr(EntRecIdTxt, 1, 10);

                if TryGetTextField(JsonObjectLoop, 'CapturedReceipt', EntRecIdTxt) then
                    ExpDoc."Captured Receipt" := CopyStr(EntRecIdTxt, 1, 250);

                if TryGetTextField(JsonObjectLoop, 'DocumentCreatedBy', EntRecIdTxt) then
                    ExpDoc."Document Created By" := CopyStr(EntRecIdTxt, 1, 100);

                if TryGetTextField(JsonObjectLoop, 'Notes', EntRecIdTxt) then
                    ExpDoc.Notes := CopyStr(EntRecIdTxt, 1, 250);

                if TryGetTextField(JsonObjectLoop, 'ExpTransNumber', EntRecIdTxt) then
                    ExpDoc."Exp Trans Number" := CopyStr(EntRecIdTxt, 1, 50);

                if TryGetTextField(JsonObjectLoop, 'DocuRefTableName', EntRecIdTxt) then
                    ExpDoc."Docu Ref Table Name" := CopyStr(EntRecIdTxt, 1, 100);

                if TryGetTextField(JsonObjectLoop, 'CreatingDateTime', EntRecIdTxt) then
                    ExpDoc."Creating Date Time" := CopyStr(EntRecIdTxt, 1, 50);

                if TryGetTextField(JsonObjectLoop, 'DocumentCreatedDateTime', EntRecIdTxt) then
                    ExpDoc."Document Created Date Time" := CopyStr(EntRecIdTxt, 1, 50);

                // Numeric fields - read as text from JSON, then evaluate defensively
                if TryGetTextField(JsonObjectLoop, 'EntRecId', EntRecIdTxt) and Evaluate(BigIntValue, EntRecIdTxt) then
                    ExpDoc."Ent Rec Id" := BigIntValue;

                if TryGetTextField(JsonObjectLoop, 'RefRecId', RefRecIdTxt) and Evaluate(BigIntValue, RefRecIdTxt) then
                    ExpDoc."Ref Rec Id" := BigIntValue;

                if TryGetTextField(JsonObjectLoop, 'ValueRecId', ValueRecIdTxt) and Evaluate(BigIntValue, ValueRecIdTxt) then
                    ExpDoc."Value Rec Id" := BigIntValue;

                if TryGetTextField(JsonObjectLoop, 'RefTableId', RefTableIdTxt) and Evaluate(IntValue, RefTableIdTxt) then
                    ExpDoc."Ref Table Id" := IntValue;

                if TryGetTextField(JsonObjectLoop, 'CreatingWorker', CreatingWorkerTxt) and Evaluate(BigIntValue, CreatingWorkerTxt) then
                    ExpDoc."Creating Worker" := BigIntValue;

                if TryGetTextField(JsonObjectLoop, 'Author', AuthorTxt) and Evaluate(IntValue, AuthorTxt) then
                    ExpDoc.Author := IntValue;

                // CapturedDocument arrives as a data URI: data:<mime>;base64,<payload>
                if CapturedDocument <> '' then begin
                    Base64Payload := ExtractBase64Payload(CapturedDocument);
                    if Base64Payload <> '' then begin
                        Clear(TempBlob);
                        TempBlob.CreateOutStream(OutStr);
                        Base64Convert.FromBase64(Base64Payload, OutStr);
                        TempBlob.CreateInStream(InStr);

                        ExpDoc.Attachment.CreateOutStream(OutStr);
                        CopyStream(OutStr, InStr);
                        ExpDoc."Attachment Size" := TempBlob.Length();
                    end;
                end;

                ExpDoc."Imported DateTime" := CurrentDateTime();
                ExpDoc.Insert(true);

                ImportedCount += 1;
            end else
                SkippedCount += 1;
        end;

        exit(ImportedCount);
    end;

    procedure ImportAllAttachments(var TotalImported: Integer; var TotalSkipped: Integer)
    var
        Setup: Record "FnO Integration Setup";
        ProgressDialog: Dialog;
        SkipCount: Integer;
        BatchSize: Integer;
        AttachmentsArray: JsonArray;
        BatchImported: Integer;
        BatchSkipped: Integer;
        RowsInThisPage: Integer;
        BatchNumber: Integer;
    begin
        Setup.Get();
        BatchSize := Setup."Batch Size";
        if BatchSize = 0 then
            BatchSize := 20;

        SkipCount := 0;
        TotalImported := 0;
        TotalSkipped := 0;
        BatchNumber := 0;

        ProgressDialog.Open(
            'Importing Expense Attached Documents...\' +
            'Batch:      #1######\' +
            'Imported:   #2######\' +
            'Skipped:    #3######\' +
            'Total read: #4######');

        repeat
            BatchNumber += 1;
            ProgressDialog.Update(1, BatchNumber);

            AttachmentsArray := GetExpAttachedDocumentsBatch(SkipCount, BatchSize);
            RowsInThisPage := AttachmentsArray.Count();

            BatchSkipped := 0;
            BatchImported := ImportBatch(AttachmentsArray, BatchSkipped);

            TotalImported += BatchImported;
            TotalSkipped += BatchSkipped;

            ProgressDialog.Update(2, TotalImported);
            ProgressDialog.Update(3, TotalSkipped);
            ProgressDialog.Update(4, TotalImported + TotalSkipped);

            SkipCount += BatchSize;
            Commit(); // persist progress after every batch - important given the source expires tomorrow
        until RowsInThisPage < BatchSize;

        ProgressDialog.Close();
    end;

    local procedure ExtractBase64Payload(FullValue: Text): Text
    var
        CommaPos: Integer;
    begin
        CommaPos := StrPos(FullValue, ',');
        if CommaPos = 0 then
            exit(FullValue); // no data-URI prefix present, assume it's already raw base64

        exit(CopyStr(FullValue, CommaPos + 1));
    end;

    [TryFunction]
    local procedure TryGetTextField(JObj: JsonObject; FieldName: Text; var Value: Text)
    var
        JToken: JsonToken;
    begin
        Value := '';
        if not JObj.Get(FieldName, JToken) then
            exit;
        if JToken.AsValue().IsNull then
            exit;
        Value := JToken.AsValue().AsText();
    end;
}
