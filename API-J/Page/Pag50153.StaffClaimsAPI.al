page 50610 "Staff Claims API"
{
    APIGroup = 'StaffClaHead';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'staffClaimsAPI';
    DelayedInsert = true;
    EntityName = 'StaffClaims';
    EntitySetName = 'StaffclaimAPI';
    PageType = API;
    SourceTable = "Staff Claims Header";

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
                field(shortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    Caption = 'Shortcut Dimension 3 Code';
                    ApplicationArea = All;
                }
                field(ecuCodeDescription; Rec."ECU Code Description")
                {
                    Caption = 'ECU Code Description';
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
                field(totalNetAmountLCY; Rec."Total Net Amount LCY")
                {
                    Caption = 'Total Net Amount LCY';
                    ApplicationArea = All;
                }
                field(paymentReleaseDate; Rec."Payment Release Date")
                {
                    Caption = 'Payment Release Date';
                    ApplicationArea = All;
                }
                field(chequeNo; Rec."Cheque No.")
                {
                    Caption = 'Cheque No.';
                    ApplicationArea = All;
                }
                field(attachment; Rec.Attachment)
                {
                    Caption = 'Attachment';
                    ApplicationArea = All;
                }
                field(responsibilityCenter; Rec."Responsibility Center")
                {
                    Caption = 'Responsibility Center';
                    ApplicationArea = All;
                }
                field(groupHeadToApprove; Rec."Group Head to Approve")
                {
                    Caption = 'Group Head to Approve';
                    ApplicationArea = All;
                }
                field(rebursehandlerID; Rec."Rebursehandler ID")
                {
                    Caption = 'Rebursehandler ID';
                    ApplicationArea = All;
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                    ApplicationArea = All;
                }
            }
        }
    }

    [ServiceEnabled]
    procedure SendClaimApprovalRequest(var actionContext: WebServiceActionContext)
    var
        //StaffAdv: Record "Staff Advance Header";
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.SendClaimApprovalRequest(Rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    [ServiceEnabled]
    procedure CancelClaimApprovalRequest(var actionContext: WebServiceActionContext)
    var
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.CancelClaimApprovalRequest(Rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    [ServiceEnabled]
    procedure RejectClaimApprovalRequest(var actionContext: WebServiceActionContext)
    var
        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.RejectClaimApprovalRequest(Rec."No.");
        actionContext.SetObjectType(ObjectType::Page);
        actionContext.SetObjectId(Page::"Staff Claims API");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    [ServiceEnabled]
    procedure DelegateClaimApprovalRequest(var actionContext: WebServiceActionContext)
    var

        CreateWorkflowAPI: codeunit CreateWorkflowAPI;
    begin
        CreateWorkflowAPI.DelegateClaimApprovalRequest(Rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;


    var
        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
        StaffAdv: Record "Staff Advance Header";
        Retirement: Record "Staff Advanc Surrender Header";
        Claim: Record "Staff Claims Header";
        ApprovalsMgt: Codeunit "Approvals Mgmt.";
}
