codeunit 50601 "Post Claim"
{
    trigger OnRun()
    begin
        Claim.RESET;
        Claim.SETFILTER("No.", ClaimsCode);
        IF Claim.FINDFIRST THEN BEGIN

            IF ApprovalMgt.CheckStaffClaimApprovalsWorkflowEnable(Claim) THEN
                ApprovalMgt.OnSendStaffClaimForApproval(Claim);

            Claim.RESET;
            Claim.SETFILTER("No.", ClaimsCode);
            IF Claim.FINDFIRST then begin
                IF Claim.Status = Claim.Status::"Pending Approval" then
                    exit;

            END;

        END;
    end;

    var
        Claim: Record "Staff Claims Header";
        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
        ClaimsCode: Code[20];
}
