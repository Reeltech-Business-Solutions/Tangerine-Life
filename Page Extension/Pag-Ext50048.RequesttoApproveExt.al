pageextension 50601 "Request to ApproveExt." extends "Requests to Approve"
{
    actions
    {
        modify(Reject)
        {
            trigger OnBeforeAction()
            var
                ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                RecRef: RecordRef;

            begin
                RecRef.Get(Rec."Record ID to Approve");
                Clear(ApprovalsMgmt);
                ApprovalsMgmt.GetApprovalCommentForWorkflowStepInstanceID(RecRef, Rec."Workflow Step Instance ID");
            end;
        }
    }
}
