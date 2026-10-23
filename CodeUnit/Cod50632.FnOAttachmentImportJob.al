codeunit 50632 "FnO Attachment Import Job"
{
    trigger OnRun()
    var
        AttachImport: Codeunit "FnO Vendor Attachment Import";
        ImportLog: Record "FnO Import Log";
        LogEntryNo: Integer;
        TotalImported: Integer;
        TotalSkipped: Integer;
    begin
        ImportLog.Init();
        ImportLog."Start DateTime" := CurrentDateTime();
        ImportLog.Status := ImportLog.Status::"In Process";
        ImportLog.Insert(true);
        LogEntryNo := ImportLog."Entry No.";
        Commit(); // persist the "in process" row before any risk of failure below

        // No TryFunction wrapper — let errors propagate naturally.
        // If ImportAllAttachments errors, this trigger stops here,
        // and the Job Queue Entry itself is automatically marked Error
        // with the message captured in its own Error Message field.
        AttachImport.ImportAllAttachments(TotalImported, TotalSkipped);

        // Only reached if the above succeeded with no error
        ImportLog.Get(LogEntryNo);
        ImportLog."End DateTime" := CurrentDateTime();
        ImportLog."Imported Count" := TotalImported;
        ImportLog."Skipped Count" := TotalSkipped;
        ImportLog.Status := ImportLog.Status::Success;
        ImportLog.Modify(true);
    end;
}