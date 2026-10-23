codeunit 50631 "FnO Vendor Attachment Import"
{

    procedure GetVendorAttachmentsBatch(SkipCount: Integer; TopCount: Integer): jsonArray
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

        ApiUrl := Setup."F&O Environment URL" +
    '/data/PurchaseOrderHeaderDocumentAttachments?$filter=' +
    'dataAreaId eq ''' + LowerCase(Setup."Data Area Id") + '''' +
    ' and FileType ne ''''' +
    ' and AttachmentDescription ne ''''' +
    '&$top=' + Format(TopCount) +
    '&$skip=' + Format(SkipCount) +
    '&$orderby=DocumentId';

        Client.DefaultRequestHeaders.Clear();
        Client.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);

        if not client.Get(ApiUrl, ResponseMessage) then begin
            Error('GET call to F&O failed.');
        end;


        if not ResponseMessage.IsSuccessStatusCode() then
            Error(
                'F&O request failed. Status Code: %1',
                ResponseMessage.HttpStatusCode());

        ResponseMessage.Content().ReadAs(ResponseText);

        JObj.ReadFrom(ResponseText);

        if not JObj.Get('value', JToken) then
            error('Unexpected response from F&O');

        exit(JToken.AsArray());

    end;

    procedure ImportBatch(AttachmentsArray: JsonArray; var skippedCount: integer): Integer
    var
        Vendor: Record Vendor;
        DocumentAttachment: Record "Document Attachment";
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        Tracking: Record "FnO Attachment Import Tracking";
        InStr: InStream;
        OutStr: OutStream;
        // AttachmentsArray: JsonArray;
        RecordToken: JsonToken;
        RecordObj: JsonObject;
        PONumber: Text;
        FileName: Text;
        AttachmentDescription: Text;
        AttachmentBase64: Text;
        i: Integer;
        ImportedCount: Integer;
        JsonTokenLoop: JsonToken;
        JsonObjectLoop: JsonObject;
        shouldProcess: boolean;
        FnODocumentId: Text;
        fileTypes: Text;
        LastAttachment: Record "Document Attachment";
        DocOutStr: OutStream;
        PoAttach: Record POAttach;
        GlEntries: Record "G/L Entry";
        voucherNo: code[20];
        IncomingDocument: Record "Incoming Document";
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        poPostingDate: date;
    begin
        //  AttachmentsArray := GetVendorAttachmentsBatch(SkipCount, TopCount);

        foreach JsonTokenLoop in AttachmentsArray do begin
            JsonObjectLoop := JsonTokenLoop.AsObject();

            shouldProcess := true;

            if not TryGetTextField(JsonObjectLoop, 'DocumentId', FnODocumentId) then
                shouldProcess := false;

            if ShouldProcess and Tracking.Get(FnODocumentId) then
                ShouldProcess := false;

            if ShouldProcess and not TryGetTextField(JsonObjectLoop, 'PurchaseOrderNumber', PONumber) then
                ShouldProcess := false;

            if ShouldProcess and not TryGetTextField(JsonObjectLoop, 'Attachment', AttachmentBase64) then
                ShouldProcess := false;

            if ShouldProcess and not TryGetTextField(JsonObjectLoop, 'FileType', fileTypes) then
                ShouldProcess := false;

            if ShouldProcess then begin
                if not TryGetTextField(JsonObjectLoop, 'AttachmentDescription', AttachmentDescription) then
                    AttachmentDescription := '';
                if not TryGetTextField(JsonObjectLoop, 'FileName', FileName) then
                    FileName := AttachmentDescription;
            end;

            if ShouldProcess and ((PoNumber = '') or (AttachmentBase64 = '')) then
                ShouldProcess := false;

            if ShouldProcess then begin
                IF POAttach.Get(PoNumber) then begin
                    voucherNo := POAttach.Voucher;
                    poPostingDate := pOattach.date;
                end else
                    shouldProcess := false;
            end;

            if shouldProcess then begin
                GlEntries.Reset();
                GlEntries.setRange("Document No.", voucherNo);
                GlEntries.setRange("Posting Date", poPostingDate);
                if not GlEntries.findfirst() then
                    shouldProcess := false;
            end;



            if ShouldProcess then begin
                TempBlob.CreateOutStream(OutStr);
                Base64Convert.FromBase64(AttachmentBase64, OutStr);
                TempBlob.CreateInStream(InStr);

                if TempBlob.Length() = 0 then
                    ShouldProcess := false;
            end;

            if ShouldProcess then begin
                DocumentAttachment.Init();
                DocumentAttachment.Validate("Table ID", Database::"G/L Entry");
                DocumentAttachment.Validate("No.", voucherNo);
                // Document Type intentionally left at its default

                LastAttachment.SetRange("Table ID", Database::"G/L Entry");
                LastAttachment.SetRange("No.", voucherNo);
                LastAttachment.SetRange("Document Type", DocumentAttachment."Document Type");
                if LastAttachment.FindLast() then
                    DocumentAttachment."Line No." := LastAttachment."Line No." + 10000
                else
                    DocumentAttachment."Line No." := 10000;

                DocumentAttachment.Validate("File Name", CopyStr(FileName, 1, 250));
                DocumentAttachment.Validate("File Extension", fileTypes);

                DocumentAttachment."Document Reference ID".ImportStream(InStr, '', CopyStr(FileName, 1, 100));

                DocumentAttachment.Insert(true);

                Tracking.Init();
                Tracking."FnO Document Id" := CopyStr(FnODocumentId, 1, 100);
                Tracking."Vendor No." := voucherNo;
                Tracking."Document Attachment Entry No." := DocumentAttachment."Line No.";
                Tracking."Imported DateTime" := CurrentDateTime();
                Tracking.Insert(true);

                ImportedCount += 1;
            end else
                SkippedCount += 1;
        end;
        // if ShouldProcess then begin
        //     Clear(IncomingDocument);
        //     IncomingDocument.Init();
        //     IncomingDocument."Document Type" := IncomingDocument."Document Type"::Journal;
        //     IncomingDocument."Document No." := CopyStr(VoucherNo, 1, 20);
        //     IncomingDocument."Posting Date" := poPostingDate;
        //     IncomingDocument.Posted := true;
        //     IncomingDocument."Posted Date-Time" := CurrentDateTime();
        //     IncomingDocument.Status := IncomingDocument.Status::Posted;
        //     IncomingDocument."Related Record ID" := GlEntries.RecordId();
        //     IncomingDocument.Insert(true);

        //     IncomingDocumentAttachment.Init();
        //     IncomingDocumentAttachment."Incoming Document Entry No." := IncomingDocument."Entry No.";
        //     IncomingDocument.AddAttachmentFromStream(IncomingDocumentAttachment, FileName, fileTypes, InStr);

        //     Tracking.Init();
        //     Tracking."FnO Document Id" := CopyStr(FnODocumentId, 1, 100);
        //     Tracking."Voucher No." := CopyStr(VoucherNo, 1, 20);
        //     Tracking."Incoming Document Entry No." := IncomingDocument."Entry No.";
        //     Tracking."Imported DateTime" := CurrentDateTime();
        //     Tracking.Insert(true);

        //     ImportedCount += 1;
        // end else
        //     SkippedCount += 1;




    end;
    // end;

    procedure ImportAllAttachments(var TotalImported: Integer; var TotalSkipped: Integer)
    var
        Setup: Record "FnO Integration Setup";
        SkipCount: Integer;
        BatchSize: Integer;
        AttachmentsArray: JsonArray;
        BatchImported: Integer;
        BatchSkipped: Integer;
        RowsInThisPage: Integer;
    begin
        Setup.Get();
        BatchSize := Setup."Batch Size";
        if BatchSize = 0 then
            BatchSize := 20;

        SkipCount := 0;
        TotalImported := 0;
        TotalSkipped := 0;

        repeat
            AttachmentsArray := GetVendorAttachmentsBatch(SkipCount, BatchSize);
            RowsInThisPage := AttachmentsArray.Count();

            BatchSkipped := 0;
            BatchImported := ImportBatch(AttachmentsArray, BatchSkipped);

            TotalImported += BatchImported;
            TotalSkipped += BatchSkipped;

            SkipCount += BatchSize;
            Commit(); // persist progress after every batch
        until RowsInThisPage < BatchSize;
    end;

    [TryFunction]
    local procedure TryGetTextField(JObj: JsonObject; FieldName: Text; var Value: Text)
    var
        JToken: JsonToken;
    begin
        if not JObj.Get(FieldName, JToken) then
            exit;
        if JToken.AsValue().IsNull then
            exit;
        Value := JToken.AsValue().AsText();
    end;




}
