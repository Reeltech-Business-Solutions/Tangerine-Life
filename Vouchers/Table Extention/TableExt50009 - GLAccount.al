tableextension 50620 AccountExt extends "G/L Account"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Expense Code"; Code[20])
        {
            Caption = 'Expense Code';
            //TableRelation = "Expense Code";
            DataClassification = ToBeClassified;
        }

        field(50001; "Budget Controlled"; Boolean)
        {

            Caption = 'Budget Controlled';
            //TableRelation = "Expense Code";
            DataClassification = ToBeClassified;
        }

        field(50002; Status; Option)
        {
            Description = 'Stores the status of the record in the database';
            OptionMembers = Open,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
            OptionCaption = 'Open,,,,Posted,Cancelled,,,"Pending Approval",Approved';
        }
        field(50003; "Change of Ownership"; Boolean)
        {

        }
        field(50004; "Payment Request No."; Code[20])
        {

        }
    }

    var
        myInt: Integer;
}

pageextension 50630 GlAccountExt extends "G/L Account Card"
{
    layout
    {
        addbefore(Blocked)
        {
            field("Budget Controlled"; Rec."Budget Controlled")
            {
                Caption = 'Budget Controlled';
                ApplicationArea = All;
            }
        }

    }

    actions
    {


        addafter("Apply Template")
        {
            group(Approvals)
            {
                Caption = 'Approvals';
                action(Approve2)
                {

                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    //

                    //

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ApproovedPost: Codeunit "Tax Calculation1";
                        ApproovedToPost: Boolean;


                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        ApproovedToPost := ApproovedPost.AutoSignature(Rec."No.");

                        CurrPage.Update;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId)
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId)
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or add comments.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(Action1000000047)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;


                    trigger OnAction()
                    var
                        Approvalentries: Page "Approval Entries";
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        doctype: Enum "Approval Document Type";
                    begin
                        doctype := doctype::Order;
                        //  WorkflowsEntriesBuffer.RunWorkflowEntriesPage(Rec.RecordId, DATABASE::"G/L Account", DocType.AsInteger(), Rec."No.");
                        Approvalentries.SetRecordFilters(15, Doctype, rec."No.");
                        Approvalentries.Run();
                    end;
                }
            }

            group("Request Approval")
            {
                Caption = 'Request Approval';
                action("Send Approval Request")
                {
                    ApplicationArea = Suite;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = NOT OpenApprovalEntriesExist;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
                        Txt0001: Label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
                        UpdateforActualNotspt: Codeunit "Posting Check FP1";
                    begin

                        if ApprovalMgt.CheckGLAccountApprovalsWorkflowEnable(Rec) then
                            ApprovalMgt.OnSendGLAccountForApproval(Rec);



                    end;


                }


                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = CanCancelApprovalForRecord;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
                    begin
                        ApprovalMgt.OnCancelGLAccountForApproval(Rec);
                    end;
                }
                action("Cancel Document")
                {
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        Text002: Label 'Are you sure you want to Cancel this Document?';
                        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender;
                    begin
                        //Post Committment Reversals
                        //TESTFIELD(Status,Status::Approved);
                        if Confirm(Text002, true) then begin
                            Doc_Type := Doc_Type::Imprest;

                            Rec.Status := Rec.Status::Cancelled;
                            Rec.Modify;
                        end;
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        //CurrPageUpdate;
        SetControlAppearance;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;


    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
    end;
}