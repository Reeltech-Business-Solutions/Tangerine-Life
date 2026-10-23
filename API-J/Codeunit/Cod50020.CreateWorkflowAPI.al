codeunit 50600 CreateWorkflowAPI
{

    trigger OnRun()
    begin

    end;

    procedure SendClaimApprovalRequest(ClaimsCode: Code[20]): Boolean
    begin
        Claim.RESET;
        Claim.SETFILTER("No.", ClaimsCode);
        IF Claim.FINDFIRST THEN BEGIN

            IF ApprovalMgt.CheckStaffClaimApprovalsWorkflowEnable(Claim) THEN
                ApprovalMgt.OnSendStaffClaimForApproval(Claim);

            Claim.RESET;
            Claim.SETFILTER("No.", ClaimsCode);
            IF Claim.FINDFIRST THEN BEGIN
                IF Claim.Status = Claim.Status::"Pending Approval" THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;
        END;
    end;

    procedure CancelClaimApprovalRequest(ClaimsCode: Code[20]): Boolean
    begin
        Claim.RESET;
        Claim.SETFILTER("No.", ClaimsCode);
        IF Claim.FINDFIRST THEN BEGIN

            //IF ApprovalMgt.CheckStaffClaimApprovalsWorkflowEnable(Claim) THEN
            ApprovalMgt.OnCancelStaffClaimForApproval(claim);

            Claim.RESET;
            Claim.SETFILTER("No.", ClaimsCode);
            IF Claim.FINDFIRST THEN BEGIN
                IF Claim.Status = Claim.Status::Cancelled THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure RejectClaimApprovalRequest(ClaimsCode: Code[20]): Boolean

    begin
        Claim.RESET;
        Claim.SETFILTER("No.", ClaimsCode);
        IF Claim.FINDFIRST THEN BEGIN

            ApprovalsMgt.RejectRecordApprovalRequest(Claim.RecordId);

            Claim.RESET;
            Claim.SETFILTER("No.", ClaimsCode);
            IF Claim.FINDFIRST THEN BEGIN
                IF Claim.Status = Claim.Status::Open THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure DelegateClaimApprovalRequest(ClaimsCode: Code[20]): Boolean

    begin
        Claim.RESET;
        Claim.SETFILTER("No.", ClaimsCode);
        IF Claim.FINDFIRST THEN BEGIN

            ApprovalsMgt.DelegateRecordApprovalRequest(Claim.RecordId);

            Claim.RESET;
            Claim.SETFILTER("No.", ClaimsCode);
            IF Claim.FINDFIRST THEN BEGIN
                IF Claim.Status = Claim.Status::"Pending Approval" THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure SendStaffAdvanceApprovalRequest(StaffAdvCode: Code[20]): Boolean
    begin
        StaffAdv.RESET;
        StaffAdv.SETFILTER("No.", StaffAdvCode);
        IF StaffAdv.FINDFIRST THEN BEGIN

            IF ApprovalMgt.CheckStaffAdvanceApprovalsWorkflowEnable(StaffAdv) THEN
                ApprovalMgt.OnSendStaffAdvanceForApproval(StaffAdv);

            StaffAdv.RESET;
            StaffAdv.SETFILTER("No.", StaffAdvCode);
            IF StaffAdv.FINDFIRST THEN BEGIN
                IF StaffAdv.Status = StaffAdv.Status::"Pending Approval" THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure CancelStaffAdvanceApprovalRequest(StaffAdvCode: Code[20]): Boolean
    begin
        StaffAdv.RESET;
        StaffAdv.SETFILTER("No.", StaffAdvCode);
        IF StaffAdv.FINDFIRST THEN BEGIN

            ApprovalMgt.OnCancelStaffAdvanceForApproval(StaffAdv);

            StaffAdv.RESET;
            StaffAdv.SETFILTER("No.", StaffAdvCode);
            IF StaffAdv.FINDFIRST THEN BEGIN
                IF StaffAdv.Status = StaffAdv.Status::Cancelled THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure RejectStaffAdvanceApprovalRequest(StaffAdvCode: Code[20]): Boolean

    begin
        StaffAdv.RESET;
        StaffAdv.SETFILTER("No.", StaffAdvCode);
        IF StaffAdv.FINDFIRST THEN BEGIN

            ApprovalsMgt.RejectRecordApprovalRequest(StaffAdv.RecordId);

            StaffAdv.RESET;
            StaffAdv.SETFILTER("No.", StaffAdvCode);
            IF StaffAdv.FINDFIRST THEN BEGIN
                IF StaffAdv.Status = StaffAdv.Status::Open THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure DelegateStaffAdvanceApprovalRequest(StaffAdvCode: Code[20]): Boolean

    begin
        StaffAdv.RESET;
        StaffAdv.SETFILTER("No.", StaffAdvCode);
        IF StaffAdv.FINDFIRST THEN BEGIN

            ApprovalsMgt.DelegateRecordApprovalRequest(StaffAdv.RecordId);

            StaffAdv.RESET;
            StaffAdv.SETFILTER("No.", StaffAdvCode);
            IF StaffAdv.FINDFIRST THEN BEGIN
                IF StaffAdv.Status = StaffAdv.Status::"Pending Approval" THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;


    procedure SendRetirementApprovalRequest(RetirementCode: Code[20]): Boolean
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
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure CancelRetirementApprovalRequest(RetirementCode: Code[20]): Boolean
    begin
        Retirement.RESET;
        Retirement.SETFILTER("No.", RetirementCode);
        IF Retirement.FINDFIRST THEN BEGIN

            ApprovalMgt.OnCancelAdvanceSurrenderForApproval(Retirement);

            Retirement.RESET;
            Retirement.SETFILTER("No.", RetirementCode);
            IF Retirement.FINDFIRST THEN BEGIN
                IF Retirement.Status = Retirement.Status::"Pending Approval" THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure RejectRetirementApprovalRequest(RetirementCode: Code[20]): Boolean
    begin
        Retirement.RESET;
        Retirement.SETFILTER("No.", RetirementCode);
        IF Retirement.FINDFIRST THEN BEGIN

            ApprovalsMgt.RejectRecordApprovalRequest(Retirement.RecordId);

            Retirement.RESET;
            Retirement.SETFILTER("No.", RetirementCode);
            IF Retirement.FINDFIRST THEN BEGIN
                IF Retirement.Status = Retirement.Status::Open THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure DelegateRetirementApprovalRequest(RetirementCode: Code[20]): Boolean

    begin
        Retirement.RESET;
        Retirement.SETFILTER("No.", RetirementCode);
        IF Retirement.FINDFIRST THEN BEGIN

            ApprovalsMgt.DelegateRecordApprovalRequest(Retirement.RecordId);

            Retirement.RESET;
            Retirement.SETFILTER("No.", RetirementCode);
            IF Retirement.FINDFIRST THEN BEGIN
                IF Retirement.Status = Retirement.Status::"Pending Approval" THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;
        END;
    end;

    //Payment Header (LC)
    procedure SendPaymentHeaderApprovalRequest(PaymentHeaderCode: Code[20]): Boolean
    begin
        PaymentHeader.RESET;
        PaymentHeader.SETFILTER("No.", PaymentHeaderCode);
        IF PaymentHeader.FINDFIRST THEN BEGIN

            IF ApprovalMgt.CheckPheaderApprovalsWorkflowEnable(PaymentHeader) THEN
                ApprovalMgt.OnSendPheaderForApproval(PaymentHeader);

            PaymentHeader.RESET;
            PaymentHeader.SETFILTER("No.", PaymentHeaderCode);
            IF PaymentHeader.FINDFIRST THEN BEGIN
                IF PaymentHeader.Status = PaymentHeader.Status::"Pending Approval" THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure CancelPaymentHeaderApprovalRequest(PaymentHeaderCode: Code[20]): Boolean
    begin
        PaymentHeader.RESET;
        PaymentHeader.SETFILTER("No.", PaymentHeaderCode);
        IF PaymentHeader.FINDFIRST THEN BEGIN

            ApprovalMgt.OnCancelPheaderForApproval(PaymentHeader);

            PaymentHeader.RESET;
            PaymentHeader.SETFILTER("No.", PaymentHeaderCode);
            IF PaymentHeader.FINDFIRST THEN BEGIN
                IF PaymentHeader.Status = PaymentHeader.Status::"Pending Approval" THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure RejectPaymentHeaderApprovalRequest(PaymentHeaderCode: Code[20]): Boolean
    begin
        PaymentHeader.RESET;
        PaymentHeader.SETFILTER("No.", PaymentHeaderCode);
        IF PaymentHeader.FINDFIRST THEN BEGIN

            ApprovalsMgt.RejectRecordApprovalRequest(PaymentHeader.RecordId);

            PaymentHeader.RESET;
            PaymentHeader.SETFILTER("No.", PaymentHeaderCode);
            IF PaymentHeader.FINDFIRST THEN BEGIN
                IF PaymentHeader.Status = PaymentHeader.Status::Open THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;

        END;
    end;

    procedure DelegatePaymentHeaderApprovalRequest(PaymentHeaderCode: Code[20]): Boolean

    begin
        PaymentHeader.RESET;
        PaymentHeader.SETFILTER("No.", PaymentHeaderCode);
        IF PaymentHeader.FINDFIRST THEN BEGIN

            ApprovalsMgt.DelegateRecordApprovalRequest(PaymentHeader.RecordId);

            PaymentHeader.RESET;
            PaymentHeader.SETFILTER("No.", PaymentHeaderCode);
            IF PaymentHeader.FINDFIRST THEN BEGIN
                IF PaymentHeader.Status = PaymentHeader.Status::"Pending Approval" THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;
        END;
    end;


    ///
    var
        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
        StaffAdv: Record "Staff Advance Header";
        Retirement: Record "Staff Advanc Surrender Header";
        Claim: Record "Staff Claims Header";
        ApprovalsMgt: Codeunit "Approvals Mgmt.";
        PaymentHeader: Record "Payments Header";
}
