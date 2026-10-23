codeunit 50615 Subscriber
{
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesCode: Code[20];

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInsertGlobalGLEntry', '', false, false)]
    // local procedure OnAfterInsertGlobalGLEntry(var GLEntry: Record "G/L Entry"; var TempGLEntryBuf: Record "G/L Entry"; var NextEntryNo: Integer; GenJnlLine: Record "Gen. Journal Line")
    // begin
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        // Copy all custom CBA fields from Journal Line to G/L Entry
        GLEntry."CBA Trans ID" := GenJournalLine."CBA Trans ID";
        GLEntry."Account Class Name" := GenJournalLine."Account Class Name";
        GLEntry."Account Class Code" := GenJournalLine."Account Class Code";
        GLEntry."Transaction Class Name" := GenJournalLine."Transaction Class Name";
        GLEntry."Transaction Class Code" := GenJournalLine."Transaction Class Code";
        GLEntry."Effective Date" := GenJournalLine."Effective Date";
        GLEntry."Transaction Date" := GenJournalLine."Transaction Date";
        GLEntry."Cheque Num" := GenJournalLine."Cheque Num";
        GLEntry."Proposal Number" := GenJournalLine."Proposal Number";
        GLEntry."Policy Number" := GenJournalLine."Policy Number";
        GLEntry."Policy Class" := GenJournalLine."Policy Class";
        GLEntry."Branch" := GenJournalLine."Branch";
        GLEntry."Agency" := GenJournalLine."Agency";
        GLEntry."CBA Processed" := GenJournalLine."CBA Processed";
        GLEntry.refnum := GenJournalLine.refnum;
        GLEntry."Bank ref id" := GenJournalLine."Bank ref id";
        GLEntry.beneficiary := GenJournalLine.beneficiary;
    end;

    [EventSubscriber(ObjectType::Table, database::"Approval Entry", 'OnBeforeMarkAllWhereUserisApproverOrSender', '', true, true)]

    local procedure OnBeforeMarkAllWhereUserisApproverOrSender(var ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)
    var
        appr: Page "Approval Entries";
    begin
        IsHandled := true;
    end;


}