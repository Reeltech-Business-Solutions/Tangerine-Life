page 50608 "Staff Advance API"
{
    APIGroup = 'StaffAdv';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'staffAdvanceAPI';
    DelayedInsert = true;
    EntityName = 'StaffAdv';
    EntitySetName = 'StaffAdvAPI';
    PageType = API;
    SourceTable = "Staff Advance Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                }
                field("date"; Rec."Date")
                {
                    Caption = 'Date';
                    ApplicationArea = All;
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Global Dimension 1 Code';
                    ApplicationArea = All;
                }
                field(functionName; Rec."Function Name")
                {
                    Caption = 'Function Name';
                    ApplicationArea = All;
                }
                field(accountNo; Rec."Account No.")
                {
                    Caption = 'Account No.';
                    ApplicationArea = All;
                }
                field(payee; Rec.Payee)
                {
                    Caption = 'Payee';
                    ApplicationArea = All;
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                    ApplicationArea = All;
                }
                field(budgetCenterName; Rec."Budget Center Name")
                {
                    Caption = 'Budget Center Name';
                    ApplicationArea = All;
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                    ApplicationArea = All;
                }
                field(payMode; Rec."Pay Mode")
                {
                    Caption = 'Pay Mode';
                    ApplicationArea = All;
                }
                field(payingBankAccount; Rec."Paying Bank Account")
                {
                    Caption = 'Paying Bank Account';
                    ApplicationArea = All;
                }
                field(bankName; Rec."Bank Name")
                {
                    Caption = 'Bank Name';
                    ApplicationArea = All;
                }
                field(purpose; Rec.Purpose)
                {
                    Caption = 'Purpose';
                    ApplicationArea = All;
                }
                field(cashier; Rec.Cashier)
                {
                    Caption = 'Cashier';
                    ApplicationArea = All;
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                }
                field(totalNetAmount; Rec."Total Net Amount")
                {
                    Caption = 'Total Net Amount';
                    ApplicationArea = All;
                }
                field(chequeNo; Rec."Cheque No.")
                {
                    Caption = 'Cheque No.';
                    ApplicationArea = All;
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                    ApplicationArea = All;
                }
                part(lines; StaffAdvanceLineAPI)
                {
                    EntitySetName = 'lines';
                    EntityName = 'line';
                    SubPageLink = "Header Id" = field(SystemId);
                }
            }
        }
    }

    [ServiceEnabled]
    procedure SendStaffAdvanceApprovalRequest(var actionContext: WebServiceActionContext)
    var
        StaffAdv: Record "Staff Advance Header";
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.SendStaffAdvanceApprovalRequest(Rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    [ServiceEnabled]
    procedure CancelStaffAdvanceApprovalRequest(var actionContext: WebServiceActionContext)
    var
        StaffAdv: Record "Staff Advance Header";
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.CancelStaffAdvanceApprovalRequest(Rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    [ServiceEnabled]
    procedure RejectStaffAdvanceApprovalRequest(var actionContext: WebServiceActionContext)
    var
        StaffAdv: Record "Staff Advance Header";
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.RejectStaffAdvanceApprovalRequest(Rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    [ServiceEnabled]
    procedure DelegateStaffAdvanceApprovalRequest(var actionContext: WebServiceActionContext)
    var
        StaffAdv: Record "Staff Advance Header";
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.DelegateStaffAdvanceApprovalRequest(Rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    var
        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
        StaffAdv: Record "Staff Advance Header";
        Retirement: Record "Staff Advanc Surrender Header";
        Claim: Record "Staff Claims Header";
        ApprovalsMgt: Codeunit "Approvals Mgmt.";
}
