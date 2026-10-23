codeunit 50625 IES
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        CallAPI: Codeunit tangerine_life_cba;
        GenJnl: codeunit MoveToGeneralJournal;
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        GenJournalLine: Record "Gen. Journal Line";
        CBAStaging: Record TangerinelifeCBA;
        GenLedgerEntries: Record "G/L Entry";
        ErrorMessage: Text;

    //      Notifier: Codeunit "TGL CBA JQ Error Notifier";
    begin
        callAPI.HttpGetTangerineLive(20260101D, 20260131D, false, false, true);
        callAPI.HttpGetTangerineLive(20260101D, 20260131D, true, false, false);
        callAPI.HttpGetTangerineLive(20260101D, 20260131D, false, false, true);
        GenJnl.MoveToGeneralJournalLine();
        commit();
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", 'CBA2');
        if GenJournalLine.IsEmpty() then
            exit;
        if not GenJnlPost.Run(GenJournalLine) then begin
            ErrorMessage := GetLastErrorText();
            SendPostingFailureMail(ErrorMessage);
            ClearLastError();
            exit;
        end;
    end;

    local procedure SendPostingFailureMail(ErrorMessage: Text)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        Subject: Text;
        Body: Text;
    begin
        Subject := StrSubstNo('[%1] CBA – General Ledger Posting Failed %2', CompanyName(), Today);

        Body := StrSubstNo(
            'Hello,\' +
            '\The CBA automated job failed while posting to the General Ledger.\' +
            '\' +
            '───────────────────────────────\' +
            'DETAILS\' +
            '───────────────────────────────\' +
            'Company     : %1\' +
            'Date        : %2\' +
            'Batch       : GENERAL / CBA\' +
            '\' +
            '───────────────────────────────\' +
            'ERROR\' +
            '───────────────────────────────\' +
            '%3\' +
            '\' +
            'ACTION REQUIRED:\' +
            '  - Open General Journal batch CBA in Business Central\' +
            '  - Review the journal lines\' +
            '  - Fix the error and post manually\' +
            '\' +
            'This is an automated notification.',
            CompanyName(),
            Today,
            ErrorMessage
        );

        Recipients.Add('rfasasi@reeltechsolutions.com');
        EmailMessage.Create(Recipients, Subject, Body, false);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;


}
