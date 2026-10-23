codeunit 50602 "Post Retirement"
{
    trigger OnRun()

    begin
        Retirement.RESET;
        Retirement.SETFILTER("No.", RetirementCode);
        IF Retirement.FINDFIRST THEN BEGIN

            IF ApprovalMgt.CheckAdvanceSurrenderApprovalsWorkflowEnable(Retirement) THEN
                ApprovalMgt.OnSendAdvanceSurrenderForApproval(Retirement);

            Retirement.RESET;
            Retirement.SETFILTER("No.", RetirementCode);
            IF Retirement.FINDFIRST THEN BEGIN
                IF Retirement.Status = Retirement.Status::"Pending Approval" THEN
                    EXIT;
                //ELSE
                // EXIT(FALSE);
            END;

        END;
    end;

    var
        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
        //StaffAdv: Record "Staff Advance Header";
        Retirement: Record "Staff Advanc Surrender Header";
        //Claim: Record "Staff Claims Header";
        RetirementCode: Code[20];

}
