table 50650 ApprovalRequestlog
{
    Caption = 'ApprovalRequestlog';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Table ID"; Code[20])
        {
            Caption = 'Table ID';
            DataClassification = ToBeClassified;
            
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Action Type"; Enum "Action Type")
        {
            Caption = 'Action Type';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Document Type" = "Document Type"::"Staff Claim" then
                    "Table ID" := '50068';
                if "Document Type" = "Document Type"::"Staff Advance" then
                    "Table ID" := '50063';
                if "Document Type" = "Document Type"::"Advance Retirement" then
                    "Table ID" := '50631';
                if "Document Type" = "Document Type"::"Payment Voucher" then
                    "Table ID" := '50057';
                if "Document Type" = "Document Type"::Requisition then
                    "Table ID" := '38';

            end;
        }
        field(5; "Document Type"; Enum "Approval Document Type")
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        Case "Document Type" of
            "Document Type"::"Staff Claim":
                begin
                    if "Action Type" = "Action Type"::"Send Approval" then
                        SendClaimApprovalRequest;
                    if "Action Type" = "Action Type"::"Cancel Approval" then
                        CancelClaimApprovalRequest();
                    if "Action Type" = "Action Type"::Delegate then
                        DelegateClaimApprovalRequest();
                    if "Action Type" = "Action Type"::Reject then
                        RejectClaimApprovalRequest();
                end;
            "Document Type"::"Staff Advance":
                begin
                    if "Action Type" = "Action Type"::"Send Approval" then
                        SendStaffAdvanceApprovalRequest;
                    if "Action Type" = "Action Type"::"Cancel Approval" then
                        CancelStaffAdvanceApprovalRequest();
                    if "Action Type" = "Action Type"::Delegate then
                        DelegateStaffAdvanceApprovalRequest();
                    if "Action Type" = "Action Type"::Reject then
                        RejectStaffAdvanceApprovalRequest();
                end;
            "Document Type"::"Advance Retirement":
                begin
                    if "Action Type" = "Action Type"::"Send Approval" then
                        SendRetirementApprovalRequest;
                    if "Action Type" = "Action Type"::"Cancel Approval" then
                        CancelRetirementApprovalRequest();
                    if "Action Type" = "Action Type"::Delegate then
                        DelegateRetirementApprovalRequest();
                    if "Action Type" = "Action Type"::Reject then
                        RejectRetirementApprovalRequest();
                end;
            "Document Type"::"Payment Voucher":
                begin
                    if "Action Type" = "Action Type"::"Send Approval" then
                        SendPHeaderApprovalRequest;
                    if "Action Type" = "Action Type"::"Cancel Approval" then
                        CancelPHeaderApprovalRequest();
                    if "Action Type" = "Action Type"::Delegate then
                        DelegatePHeaderApprovalRequest();
                    if "Action Type" = "Action Type"::Reject then
                        RejectPHeaderApprovalRequest();
                end;
        End;
    end;

    var
        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
        StaffAdv: Record "Staff Advance Header";
        Retirement: Record "Staff Advanc Surrender Header";
        Claim: Record "Staff Claims Header";
        ApprovalsMgt: Codeunit "Approvals Mgmt.";
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;


    Local procedure SendClaimApprovalRequest()
    var
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.SendClaimApprovalRequest("Document No.");
    end;

    Local procedure CancelClaimApprovalRequest()
    var
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.CancelClaimApprovalRequest("Document No.");
    end;

    // [ServiceEnabled]
    Local procedure RejectClaimApprovalRequest()
    var
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.RejectClaimApprovalRequest("Document No.");
    end;

    [ServiceEnabled]
    procedure DelegateClaimApprovalRequest()
    var
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.DelegateClaimApprovalRequest("Document No.");
    end;

    //Staff Advance
    procedure SendStaffAdvanceApprovalRequest(): Boolean
    begin
        CreateWorkflowAPI.SendStaffAdvanceApprovalRequest("Document No.");
    end;

    procedure CancelStaffAdvanceApprovalRequest(): Boolean
    begin
        CreateWorkflowAPI.CancelStaffAdvanceApprovalRequest("Document No.");
    end;

    procedure RejectStaffAdvanceApprovalRequest(): Boolean

    begin
        CreateWorkflowAPI.RejectStaffAdvanceApprovalRequest("Document No.");
    end;

    procedure DelegateStaffAdvanceApprovalRequest(): Boolean
    begin
        CreateWorkflowAPI.DelegateStaffAdvanceApprovalRequest("Document No.");
    end;

    procedure SendRetirementApprovalRequest(): Boolean
    begin
        CreateWorkflowAPI.SendRetirementApprovalRequest("Document No.");
    end;

    procedure CancelRetirementApprovalRequest(): Boolean
    begin
        CreateWorkflowAPI.CancelRetirementApprovalRequest("Document No.");
    end;

    procedure RejectRetirementApprovalRequest(): Boolean
    begin
        CreateWorkflowAPI.RejectRetirementApprovalRequest("Document No.");
    end;

    procedure DelegateRetirementApprovalRequest(): Boolean

    begin
        CreateWorkflowAPI.RejectRetirementApprovalRequest("Document No.");
    end;
    //Payment header

    procedure SendPHeaderApprovalRequest(): Boolean
    begin
        CreateWorkflowAPI.SendPaymentHeaderApprovalRequest("Document No.");
    end;

    procedure CancelPHeaderApprovalRequest(): Boolean
    begin
        CreateWorkflowAPI.CancelPaymentHeaderApprovalRequest("Document No.");
    end;

    procedure RejectPHeaderApprovalRequest(): Boolean
    begin
        CreateWorkflowAPI.RejectPaymentHeaderApprovalRequest("Document No.");
    end;

    procedure DelegatePHeaderApprovalRequest(): Boolean

    begin
        CreateWorkflowAPI.RejectPaymentHeaderApprovalRequest("Document No.");
    end;
}
