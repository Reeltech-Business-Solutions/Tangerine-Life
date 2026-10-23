page 50699 "Bank Payment Voucher"
{
    Caption = 'Bank Payment Voucher';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Voucher Header";
    SourceTableView = WHERE("Voucher Type" = CONST(BPV));
    //SORTING("Voucher Type", "No.")


    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin

                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field("Account No."; Rec."Account No.")
                {
                    Caption = 'Account Code';
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                    //StyleExpr = StatusStyleTxt;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, or released to the next stage of processing.';

                }
                field(Narration; Rec.Narration)
                {
                    Caption = 'Narration';
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Caption = 'Voucher No.';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Budget; Rec.Budget)
                {
                    ApplicationArea = All;
                }
                field("Expended Value"; Rec."Expended Value")
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "Bank Payment Voucher Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            group(Usertrail)
            {
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created By Name"; Rec."Created By Name")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; Rec."Created Time")
                {
                    ApplicationArea = All;
                }
                field("Modified By"; Rec."Modified By")
                {
                    ApplicationArea = All;
                }
                field("Modified By Name"; Rec."Modified By Name")
                {
                    ApplicationArea = All;
                }
                field("Modified Date"; Rec."Modified Date")
                {
                    ApplicationArea = All;
                }
                field("Modified Time"; Rec."Modified Time")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50000), "No." = FIELD("No.");

                // "Document Type" = field("Voucher Type");
            }
            part(Control23; "Pending Approval FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "Table ID" = CONST(50000),
                              "Document Type" = FIELD("Voucher Type"),
                              "Document No." = FIELD("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(ApprovalFactBox; "Approval FactBox")
            {
                ApplicationArea = Suite;
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Voucher")
            {
                Caption = '&Voucher';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
                }
                action("A&pprovals")
                {
                    Caption = 'A&pprovals';
                    ApplicationArea = All;


                    trigger OnAction()
                    var
                        Approvalentries: Page "Approval Entries";
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        doctype: Enum "Approval Document Type";
                    begin
                        doctype := Rec."Voucher Type";
                        //  WorkflowsEntriesBuffer.RunWorkflowEntriesPage(Rec.RecordId, DATABASE::"Voucher Header", DocType.AsInteger(), Rec."No.");
                        Approvalentries.SetRecordFilters(50000, Doctype, rec."No.");
                        Approvalentries.Run();

                    end;
                }
            }
        }
        area(processing)
        {
            group(Release1)
            {
                Caption = 'Release';
                action(Release)
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //ReleaseVoucher.PerformManualRelease(Rec);
                        Rec.VALIDATE(Status, Rec.Status::Released);
                    end;
                }
                action(Reopen)
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //ReleaseVoucher.PerformManualReopen(Rec);
                        Rec.VALIDATE(Status, Status::Open);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
                        Status1: Option Approved;
                        PayLine: record "Voucher Line";
                    begin
                        //Validate(Status, Status1::Approved);
                        /*if ApprovalMgt.CheckPaymentHeaderApprovalsWorkflowEnable(Rec) then
                            ApprovalMgt.OnSendPaymentHeaderForApproval(Rec);

                        //IF ApprovalMgt.SendVoucherApprovalRequest(Rec) THEN;
                        VALIDATE(Status, Status::"Pending Approval");*/

                        Rec.TestField(Status, Status::Open);

                        if not LinesExists then
                            Error('There are no Lines created for this Document');
                        //Ensure No Items That should be committed that are not
                        //if LinesCommitmentStatus then
                        //  Error('There are some lines that have not been committed');

                        //PayLine.RESET;
                        PayLine.SetRange(PayLine."Document No.", Rec."No.");
                        if PayLine.Find('-') then begin
                            repeat
                            // PayLine.TESTFIELD("Applies-to Doc. No."); HABA
                            until PayLine.Next = 0;
                        end;

                        //Release the PV for Approval
                        if ApprovalMgt.CheckPaymentHeaderApprovalsWorkflowEnable(Rec) then
                            ApprovalMgt.OnSendPaymentHeaderForApproval(Rec);

                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";

                    begin
                        //IF ApprovalMgt.CancelVoucherApprovalRequest(Rec,TRUE,TRUE) THEN;
                        ApprovalMgt.OnCancelPaymentHeaderForApproval(Rec);
                        Rec.VALIDATE(Status, Status::Open);


                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ApplicationArea = All;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Ellipsis = false;
                    Image = Post;
                    Promoted = false;
                    ApplicationArea = All;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin

                        /*Usersetup.GET(USERID);
                        IF NOT Usersetup."Post Voucher" THEN
                          ERROR('You do not have permision to post the Voucher....!');*/


                        IF NOT CONFIRM('Are you sure you want to post the voucher') THEN
                            EXIT;
                        VoucherPost.RUN(Rec);

                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnAction()
                    begin
                        VoucherHeader.SETRANGE("Voucher Type", Rec."Voucher Type");
                        VoucherHeader.SETRANGE("No.", Rec."No.");
                        IF VoucherHeader.FINDFIRST THEN
                            REPORT.RUN(50052, TRUE, FALSE, VoucherHeader);
                        VoucherPost.RUN(Rec);
                    end;
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                action("Print Voucher")
                {
                    Caption = 'Print Voucher';
                    Promoted = false;
                    ApplicationArea = All;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        VoucherHeader.SETRANGE("Voucher Type", Rec."Voucher Type");
                        VoucherHeader.SETRANGE("No.", Rec."No.");
                        IF VoucherHeader.FINDFIRST THEN
                            REPORT.RUN(50052, TRUE, FALSE, VoucherHeader);
                    end;
                }
            }
        }
    }
    procedure LinesExists(): Boolean
    var
        VoucherLines: Record "Voucher Line";
        HasLines: Boolean;
    begin
        HasLines := false;
        VoucherLines.Reset;
        VoucherLines.SetRange(VoucherLines."Document No.", Rec."No.");
        if VoucherLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Account Type" := Rec."Account Type"::"Bank Account";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;

        CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RecordId);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);
        //StatusStyleTxt := GetStatusStyleText();
    end;

    var
        StatusStyleTxt: Text;
        VoucherPost: Codeunit "Voucher Post";
        ApprovalEntries: Page "Approval Entries";
        ReleaseVoucher: Codeunit "Voucher Release";
        VoucherHeader: Record "Voucher Header";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;
}

