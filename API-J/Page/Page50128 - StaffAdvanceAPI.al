page 50626 StaffAdvance
{
    // APIGroup = 'rbs';
    // APIPublisher = 'rbs';
    // APIVersion = 'v1.0';
    // Caption = 'staffAdvanceAPI';
    // DelayedInsert = true;
    // EntityName = 'StaffAdvance';
    // EntitySetName = 'StaffAdvance';
    // PageType = API;
    ApplicationArea = all;
    SourceTable = "Staff Advance Header";
    ODataKeyFields = "No.";

    layout
    {
        area(content)
        {
            group("General Information")
            {
                Editable = true;
                //ShowCaption = false;
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(No; Rec."No.")
                {
                    //Editable = CreateVouch;
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    NotBlank = true;
                    //Visible = false;
                    Caption = 'Global Dimension 1 Code';
                    ApplicationArea = All;
                }
                field(FunctionName; Rec."Function Name")
                {
                    Caption = 'Description';
                    Editable = false;
                    //Visible = false;
                    ApplicationArea = All;
                }
                field(AccountNo; Rec."Account No.")
                {
                    Caption = 'Staff No.';
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    Caption = 'Staff Name';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(ShortcutDimensionCode; rec."Shortcut Dimension 2 Code")
                {
                    // NotBlank = true;
                    //Editable = CreateVouch;
                    Caption = 'Shortcut Dimension 2 Code';
                    visible = false;
                    ApplicationArea = All;
                }
                field(BudgetCenterName; Rec."Budget Center Name")
                {
                    Caption = 'Description';
                    Editable = false;
                    visible = false;
                    ApplicationArea = All;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                    Editable = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(PayMode; Rec."Pay Mode")
                {
                    //Editable = "Pay ModeEditable";
                    ValuesAllowed = " ", Cash, Cheque, EFT;
                    Visible = true;
                    ApplicationArea = All;
                }
                field(PayingBankAccount; Rec."Paying Bank Account")
                {
                    // Editable = "Paying Bank AccountEditable";
                    Caption = 'Paying Bank Account';
                    Visible = true;
                    ApplicationArea = All;
                }
                field(BankName; Rec."Bank Name")
                {
                    Caption = 'Paying Bank Name';
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    Caption = 'Staff ID';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                    trigger OnValidate()

                    begin
                        // UpdateControls;
                    end;

                }
                field(TotalNetAmount; Rec."Total Net Amount")
                {
                    Caption = 'Total Amount';
                    ApplicationArea = All;
                }
                field(ChequeNo; Rec."Cheque No.")
                {
                    Caption = 'Cheque/EFT No.';
                    ApplicationArea = All;
                    //Editable = "Cheque No.Editable";
                    //Visible = ChequeNoVisible;
                }
            }
            // part(Lines; StaffAdvanceLineAPI)
            // {
            //     EntitySetName = 'Lines';
            //     EntityName = 'Line';
            //     SubPageLink = "Header Id" = field(SystemId);
            // }
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

