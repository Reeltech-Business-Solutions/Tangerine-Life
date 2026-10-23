page 50611 "Staff Advance Retirment API"
{
    APIGroup = 'Surrender';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'staffAdvanceRetirmentAPI';
    DelayedInsert = true;
    EntityName = 'StaffadvanceSurrHead';
    EntitySetName = 'StaffAdvancesurrHeadAPI';
    PageType = API;
    SourceTable = "Staff Advanc Surrender Header";

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
                field(imprestIssueDocNo; Rec."Imprest Issue Doc. No")
                {
                    Caption = 'Advance Issue Doc. No';
                    ApplicationArea = All;
                }
                field(surrenderDate; Rec."Surrender Date")
                {
                    Caption = 'Surrender Date';
                    ApplicationArea = All;
                }
                field(userID; Rec."User ID")
                {
                    Caption = 'User ID';
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
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                }
                field(responsibilityCenter; Rec."Responsibility Center")
                {
                    Caption = 'Responsibility Center';
                    ApplicationArea = All;
                }
                field(surrendered; Rec.Surrendered)
                {
                    Caption = 'Surrendered';
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
        Claim: Record "Staff Claims Header";
        ApprovalsMgt: Codeunit "Approvals Mgmt.";
}
