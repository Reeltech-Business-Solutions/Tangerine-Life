codeunit 50627 IES2
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        CallAPI: Codeunit tangerine_life_cba;
        GenJnl: codeunit MoveToGeneralJournal2;
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        GenJournalLine: Record "Gen. Journal Line";
        ErrorMessage: Text;
        FromDate: Date;
        ToDate: Date;
        APIHasData: Boolean;

    begin
        // If Parameter String is provided, parse it; otherwise default to Today
        if Rec."Parameter String" <> '' then
            ParseDateParams(Rec."Parameter String", FromDate, ToDate)
        else begin
            FromDate := Today;
            ToDate := Today;
        end;

        CallAPI.HttpGetTangerineLive(FromDate, ToDate, false, true, false);
        CallAPI.HttpGetTangerineLive(FromDate, ToDate, true, false, false);
        CallAPI.HttpGetTangerineLive(FromDate, ToDate, false, false, true);

        // Pass the same date range so only what the API fetched gets moved
        GenJnl.MoveToGeneralJournalLine(FromDate, ToDate);
        Commit();

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", 'CBA');
        GenJournalLine.SetRange("Journal Batch Name", 'CBA');
        if GenJournalLine.IsEmpty() then begin
            SendPostingFailureMailEmptyJournal('No journal lines found in CBA/CBA to post.', FromDate, ToDate);  // will show in job queue log
            exit;
        end;

        // Must be positioned on first record before passing to Post Batch
        GenJournalLine.FindFirst();
        if not GenJnlPostBatch.Run(GenJournalLine) then begin
            ErrorMessage := GetLastErrorText();
            SendPostingFailureMail(ErrorMessage, FromDate, ToDate);
            ClearLastError();
            exit;
        end else
            SendPostingSuccess('General Journal Posted Successfully!!!', FromDate, ToDate);
    end;

    local procedure ParseDateParams(ParamString: Text; var FromDate: Date; var ToDate: Date)
    var
        Parts: List of [Text];
        FromText: Text;
        ToText: Text;
    begin
        Parts := ParamString.Split('-');
        if Parts.Count() < 2 then
            Error('Invalid Parameter String format. Expected YYYYMMDD-YYYYMMDD, got: %1', ParamString);

        Parts.Get(1, FromText);
        Parts.Get(2, ToText);

        FromText := FromText.Trim();
        ToText := ToText.Trim();

        FromDate := TextToDate(FromText);
        ToDate := TextToDate(ToText);
    end;

    local procedure TextToDate(DateText: Text): Date
    var
        Y: Integer;
        M: Integer;
        D: Integer;
    begin
        // Expects YYYYMMDD
        if StrLen(DateText) <> 8 then
            Error('Date must be 8 characters in YYYYMMDD format, got: %1', DateText);

        Evaluate(Y, CopyStr(DateText, 1, 4));  // Year
        Evaluate(M, CopyStr(DateText, 5, 2));  // Month
        Evaluate(D, CopyStr(DateText, 7, 2));  // Day

        exit(DMY2Date(D, M, Y));
    end;

    local procedure SendPostingFailureMail(ErrorMessage: Text; fromDate: Date; ToDate: Date)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        Subject: Text;
        Body: Text;
    begin
        Subject := StrSubstNo('[%1] CBA – General Ledger Posting Failed %2 -%3', CompanyName(), Format(FromDate), Format(ToDate));

        Body := StrSubstNo(
            '<html>' +
            '<body style="font-family: Arial, sans-serif; font-size: 14px;">' +

            '<p>Hello,</p>' +

            '<p>The CBA automated job failed while posting to the General Ledger.</p>' +

            '<hr>' +

            '<h3>Details</h3>' +
            '<p>' +
            '<b>Company:</b> %1<br>' +
            '<b>Date:</b> %2 -%3<br>' +
            '<b>Batch:</b> CBA / CBA' +
            '</p>' +

            '<hr>' +

            '<h3 style="color:red;">Error</h3>' +
            '<p>%4</p>' +

            '<hr>' +

            '<h3>Action Required</h3>' +
            '<ul>' +
            '<li>Open General Journal batch CBA in Business Central</li>' +
            '<li>Review the journal lines</li>' +
            '<li>Fix the error and post manually</li>' +
            '</ul>' +

            '<p style="color:gray;">This is an automated notification.</p>' +

            '</body>' +
            '</html>',
             CompanyName(),
            Format(fromDate),
            Format(ToDate),
            ErrorMessage
        );

        Recipients.Add('rfasasi@reeltechsolutions.com');
        Recipients.Add('oolatinwo@reeltechsolutions.com');
        Recipients.Add('opeyemi.okesola@tangerine.africa');
        Recipients.Add('ayobami.bankole@tangerine.africa');
        Recipients.Add(' hkhalidson@reeltechsolutions.com');
        Recipients.Add('efio-esien.efiom@tangerine.africa');


        // Recipients.Add('efio-esien.efiom@tangerine.africa');
        // Recipients.Add('temitola.ilesanmi@tangerine.africa');
        // Recipients.Add('faith.awokoya@tangerine.africa');
        // Recipients.Add('olabisi.kowobari@tangerine.africa');
        // Recipients.Add('sunday.okolo@tangerine.africa');
        // Recipients.Add('ayobami.bankole@tangerine.africa');
        // Recipients.Add('vivian.okobi@tangerine.africa');
        // Recipients.Add('victor.chiemeke@tangerine.africa');



        EmailMessage.Create(Recipients, Subject, Body, true);

        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    procedure SendPostingFailureMailEmptyJournal(ErrorMessage: Text; fromDate: Date; ToDate: Date)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        Subject: Text;
        Body: Text;
    begin
        Subject := StrSubstNo('[%1] CBA – General Ledger Posting for %2 -%3', CompanyName(), Today, fromDate, ToDate);

        Body := StrSubstNo(
            '<html>' +
            '<body style="font-family: Arial, sans-serif; font-size: 14px;">' +

            '<p>Hello,</p>' +

            '<p>The CBA automated job does not post to the General ledger entries because there is no entry for %1 -%2.</p>' +

            '<hr>' +

            '<h3>Details</h3>' +
            '<p>' +
            '<b>Company:</b> %3<br>' +
            '<b>Date:</b> %4 -%5<br>' +
            '<b>Batch:</b> CBA / CBA' +
            '</p>' +

            '<hr>' +

            //'<h3 style="color:red;">Error</h3>' +
            // '<p>%3</p>' +

            '<hr>' +

            '<h3>Action Required</h3>' +
            '<ul>' +
            '<li>Open General Journal batch CBA2 in Business Central</li>' +
            '<li>Today''s journal lines are empty</li>' +
            '</ul>' +

            '<p style="color:gray;">This is an automated notification.</p>' +

            '</body>' +
            '</html>',
            Format(fromDate),
            Format(ToDate),
            CompanyName(),
            Format(fromDate),
            Format(ToDate)
        //ErrorMessage
        );

        Recipients.Add('rfasasi@reeltechsolutions.com');
        Recipients.Add('oolatinwo@reeltechsolutions.com');
        Recipients.Add('opeyemi.okesola@tangerine.africa');
        Recipients.Add('ayobami.bankole@tangerine.africa');
        Recipients.Add(' hkhalidson@reeltechsolutions.com');
        Recipients.Add('efio-esien.efiom@tangerine.africa');


        EmailMessage.Create(Recipients, Subject, Body, true);

        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    local procedure SendPostingSuccess(SuccessMessage: Text; fromDate: Date; ToDate: Date)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        Subject: Text;
        Body: Text;
    begin
        Subject := StrSubstNo('[%1] CBA – General Ledger Posting for %2 -%3', CompanyName(), Today);

        Body := StrSubstNo(
            '<html>' +
            '<body style="font-family: Arial, sans-serif; font-size: 14px;">' +

            '<p>Hello,</p>' +

            '<p>The CBA automated job has been posted to the general ledger entries successfully for %1.</p>' +

            '<hr>' +

            '<h3>Details</h3>' +
            '<p>' +
            '<b>Company:</b> %2<br>' +
            '<b>Date:</b> %3 -%4<br>' +
            '<b>Batch:</b> CBA / CBA' +
            '</p>' +

            '<hr>' +

            '<h3 style="color:green;"SUCCESS</h3>' +
             '<p>%4</p>' +

            '<hr>' +

            // '<h3>Action Required</h3>' +
            // '<ul>' +
            // '<li>Open General Journal batch CBA2 in Business Central</li>' +
            // '<li>Today''s journal lines are empty</li>' +
            // '</ul>' +

            '<p style="color:gray;">This is an automated notification.</p>' +

            '</body>' +
            '</html>',
             Format(Today),
            CompanyName(),
            Format(fromDate),
            Format(ToDate),
        SuccessMessage
        );

        Recipients.Add('rfasasi@reeltechsolutions.com');
        Recipients.Add('oolatinwo@reeltechsolutions.com');
        Recipients.Add('opeyemi.okesola@tangerine.africa');
        Recipients.Add('ayobami.bankole@tangerine.africa');
        Recipients.Add(' hkhalidson@reeltechsolutions.com');
        Recipients.Add('efio-esien.efiom@tangerine.africa');


        EmailMessage.Create(Recipients, Subject, Body, true);

        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;
}