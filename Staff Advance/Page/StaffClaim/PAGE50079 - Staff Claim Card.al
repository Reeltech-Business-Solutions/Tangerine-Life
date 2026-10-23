page 50676 "Staff Claim"
{
    Caption = 'Staff Claim Card';
    RefreshOnActivate = true;
    PageType = Document;

    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Staff Claims Header";
    // DelayedInsert = true;
    layout
    {
        area(content)
        {
            group(Control1)
            {
                //Editable = true;
                //Enabled = true;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    Editable = OthersEditable;
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Date; Rec.Date)
                {
                    Editable = OthersEditable;
                    ApplicationArea = All;

                }
                field("Account No."; Rec."Account No.")
                {

                    Editable = OthersEditable;
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    //  Caption = 'Account Name';
                    Editable = false;
                    ApplicationArea = All;
                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = DimEditable;

                    ApplicationArea = All;
                }
                field("Function Name"; Rec."Function Name")
                {
                    Caption = 'Cost Centre';
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = DimEditable;
                    ApplicationArea = All;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    Caption = 'Revenue Centre';
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Visible = true;
                    Editable = DimEditable;
                    ApplicationArea = All;
                }

                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Editable = DimEditable;
                }
                field("ECU Code Description"; Rec."ECU Code Description")
                {
                    Visible = false;
                    Editable = DimEditable;
                    ApplicationArea = All;
                }

                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = OthersEditable;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    Editable = PaymodeEditable;
                    Visible = PaymodeVisible;

                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec."Rebursehandler ID" := UserId;
                    end;
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    Editable = PaymodeEditable;
                    Visible = PaymodeVisible;
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Caption = 'Paying Bank Name';
                    Editable = false;
                    Visible = PaymodeVisible;
                    //Visible = true;
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    Caption = 'Reimbursement  Description';
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    Caption = 'Creator ID';
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    Caption = 'Total Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Net Amount LCY"; Rec."Total Net Amount LCY")
                {
                    Visible = true;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    //Caption = 'Payment  Date';
                    //Editable = "Payment Release DateEditable";

                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    Caption = 'Cheque/EFT No.';
                    Editable = PaymodeEditable;
                    Visible = PaymodeVisible;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Caption = 'Responsibility Center';
                    ApplicationArea = All;
                    Editable = DimEditable;
                }
                field("Group Head to Approve"; Rec."Group Head to Approve")
                {
                    ApplicationArea = All;
                    visible = false;
                }
                field("Rebursehandler ID"; Rec."Rebursehandler ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {

                    ApplicationArea = All;
                    Editable = false;
                }
                field("created Date"; Rec."created Date")
                {

                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(PVLines; "Staff Claim Lines")
            {
                SubPageLink = No = FIELD("No.");
                ApplicationArea = All;
                Editable = OthersEditable;
                //UpdatePropagation = Both;
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50634), "No." = FIELD("No.");
            }
        }
    }


    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Post Payment and Print")
                {
                    Caption = 'Post Payment and Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CheckImprestRequiredItems;
                        PostImprest;
                        CurrPage.Close();
                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        REPORT.Run(50024, true, true, Rec);
                        Rec.Reset;
                    end;
                }
                separator(Separator1102755021)
                {
                }
                action("Post Payment")
                {
                    Caption = 'Post Payment';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CheckImprestRequiredItems;
                        PostImprest;
                        CurrPage.Close();
                    end;
                }
                separator(Separator1102755026)
                {
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        DocumentType: Enum "Approval Document Type";
                        Approvalentries: Page "Approval Entries";
                    begin
                        DocumentType := DocumentType::"Staff Claim";
                        // WorkflowsEntriesBuffer.RunWorkflowEntriesPage(Rec.RecordId, DATABASE::"Staff Claims Header", DocumentType.AsInteger(), Rec."No.");
                        Approvalentries.SetRecordFilters(50634, DocumentType, rec."No.");
                        Approvalentries.Run();
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
                    //ApplicationArea = all;

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
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = NOT OpenApprovalEntriesExist;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
                        BudgetApproval: Codeunit "Budget Approval";
                        GeneSetUp: Record "General Ledger Setup";
                    begin
                        //TestField(Status, Status::Open);
                        //TestField(Attachment);
                        // CalcFields(Attachment);
                        GeneSetUp.Get();

                        if GeneSetUp.StaffClaimBudget then
                            BudgetApproval.ActualBudgetStaffClaims(Rec);
                        if Confirm('Are you sure you want to send the request for approval?', true) = false then
                            exit;

                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if not AllFieldsEntered then
                            Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        //Ensure No Items That should be committed that are not
                        // if LinesCommitmentStatus then ///blocked by Deji
                        ///   Error('There are some lines that have not been committed'); // Blocked by Deji

                        //Release the Imprest for Approval
                        //BudgetCheck.ActualBudgetClaimpayment(Rec);
                        IF ApprovalMgt.CheckStaffClaimApprovalsWorkflowEnable(Rec) THEN
                            ApprovalMgt.OnSendStaffClaimForApproval(Rec);

                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    //Visible = CanCancelApprovalForRecord;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
                    begin
                        ApprovalMgt.OnCancelStaffClaimForApproval(Rec);
                    end;
                }

                separator(Separator1102755009)
                {
                }

                separator(Separator1102755033)
                {
                }
                action("Print/Preview")
                {
                    Caption = 'Print/Preview';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        if Rec.Status <> Rec.Status::Approved then
                            Error('You can only print after the document is Approved');
                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        REPORT.Run(50607, true, true, Rec); //Staff Claims Voucher
                        Rec.Reset;
                    end;
                }
                separator(Separator1102756006)
                {
                }
                action("Cancel Document")
                {
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    Visible = false;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        Text000: Label 'Are you sure you want to Cancel this Document?';
                        Text001: Label 'You have selected not to Cancel this Document';
                        Doc_Type: Option "Imprest","staff Claim";
                        ApprovalsMgt: Codeunit "Approval Mgmt. ExtCal";
                    begin
                        // TESTFIELD(Status, Status::"Pending Approval");

                        // if (Status = Status::Approved) or (Status = Status::Open) then begin
                        //     if Confirm(Text000, true) then begin
                        //         //Post Committment Reversals
                        //         Doc_Type := Doc_Type::Imprest;
                        //         //BudgetControl.ReverseEntries(Doc_Type,"No.");
                        //         //Status := Status::Cancelled;
                        //         Modify;
                        //     end else
                        //         Error(Text001);

                        // end;
                        ApprovalsMgt.OnCancelStaffClaimForApproval(Rec);
                    end;
                }
                action("Create Payment Voucher")
                {
                    Promoted = true;
                    Visible = false;
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        PVHeadEr: Record "Voucher Header";
                        PaymentLines: Record "Voucher Line";
                        EntryNo: Integer;
                        STClaimLines: Record "Staff Claim Lines";
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                        GLSetup: Record "General Ledger Setup";
                    begin
                        CheckImprestRequiredItems;

                        PVHeadEr.Reset;
                        PVHeadEr.SetRange(PVHeadEr."External Document No.", Rec."No.");
                        if PVHeadEr.Find('-') = true then
                            Error('Payment Voucher has already been created for Staff claim %1', PVHeadEr."No.");


                        Rec.TestField(Status, Status::Approved);
                        //TestField("Pay Mode");

                        if not Confirm('Are you sure you want to create a Payment Voucher for %1', false, Rec."No.") then
                            Error('Creation of Payment Voucher Stopped') else begin
                            GLSetup.get();

                            PVHeadEr.Init;
                            PVHeadEr."Document Date" := Rec.Date;
                            //PVHeadEr.Narration := Payee;
                            //PVHeadEr."On Behalf Of" := "On Behalf Of";
                            //PVHeadEr.Cashier := Cashier;

                            if Rec."Pay Mode" = Rec."Pay Mode"::Cash then begin
                                PVHeadEr."Voucher Type" := PVHeadEr."Voucher Type"::CPV;
                                PVHeadEr.Validate("Voucher Type");
                                PVHeadEr."No." := NoSeriesMgt.GetNextNo(GLSetup."Cash Payment Voucher No", TODAY, TRUE);
                                PVHeadEr.Insert(true);
                            end else BEGIN
                                //"Pay Mode" = "Pay Mode"::Cheque then
                                PVHeadEr."Voucher Type" := PVHeadEr."Voucher Type"::BPV;
                                PVHeadEr.Validate("Voucher Type");
                                PVHeadEr."No." := NoSeriesMgt.GetNextNo(GLSetup."Bank Payment Voucher No", TODAY, TRUE);
                                PVHeadEr.Insert(true);
                            END;
                            PVHeadEr.Status := Rec.Status;
                            PVHeadEr."Account Type" := PVHeadEr."Account Type"::"Bank Account";
                            PVHeadEr."Account No." := Rec."Paying Bank Account";
                            PVHeadEr.Validate("Account No.");
                            PVHeadEr."Teller / Cheque No." := Rec."Cheque No.";
                            PVHeadEr."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                            PVHeadEr.Validate("Shortcut Dimension 1 Code");
                            PVHeadEr."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                            PVHeadEr.Validate("Shortcut Dimension 2 Code");
                            PVHeadEr."Responsibility Center" := Rec."Responsibility Center";
                            PVHeadEr."Document Date" := Rec."Payment Release Date";
                            PVHeadEr."Shortcut Dimension 3 Code" := Rec."Shortcut Dimension 3 Code";
                            PVHeadEr.Validate("Shortcut Dimension 3 Code");
                            PVHeadEr."Shortcut Dimension 4 Code" := Rec."Shortcut Dimension 4 Code";
                            PVHeadEr.Validate("Shortcut Dimension 4 Code");
                            PVHeadEr.Narration := Rec.Purpose;
                            PVHeadEr."External Document No." := Rec."No.";
                            PVHeadEr.Insert(true);

                            /*
                            //Removed for now since its inserting to a new document
                            PaymentLines.RESET;
                            IF PaymentLines.FIND('+') THEN BEGIN
                            EntryNo:=PaymentLines."Line No.";
                            END;
                            */
                            EntryNo := 1;
                            STClaimLines.Reset;
                            STClaimLines.SetRange(STClaimLines.No, Rec."No.");
                            if STClaimLines.Find('-') then
                                repeat
                                    PaymentLines.Init;
                                    PaymentLines."Line No." := 0;
                                    PaymentLines."Document No." := PVHeadEr."No.";
                                    PaymentLines.Account := PaymentLines.Account::Employee;
                                    PaymentLines.Validate("Account Type");
                                    PaymentLines."Account No." := STClaimLines."Account No:";
                                    PaymentLines."Account Name" := STClaimLines."Account Name";
                                    PaymentLines.Amount := STClaimLines.Amount;
                                    PaymentLines.Amount := STClaimLines.Amount;
                                    PaymentLines."Shortcut Dimension 1 Code" := STClaimLines."Global Dimension 1 Code";
                                    PaymentLines.Validate("Shortcut Dimension 1 Code");
                                    PaymentLines."Shortcut Dimension 2 Code" := STClaimLines."Shortcut Dimension 2 Code";
                                    PaymentLines.Validate("Shortcut Dimension 2 Code");
                                    PaymentLines."Shortcut Dimension 3 Code" := STClaimLines."Shortcut Dimension 3 Code";
                                    PaymentLines.Validate("Shortcut Dimension 3 Code");
                                    PaymentLines."Shortcut Dimension 4 Code" := STClaimLines."Shortcut Dimension 4 Code";
                                    PaymentLines.Validate("Shortcut Dimension 4 Code");
                                    PaymentLines.Insert(true);

                                until STClaimLines.Next = 0;
                        end;

                        Rec.Status := Rec.Status::Posted;
                        Rec.Modify;

                        Rec.Posted := true;
                        Rec."Date Posted" := Today;
                        Rec."Time Posted" := Time;
                        Rec.Modify;

                        if Rec."Pay Mode" = Rec."Pay Mode"::Cash then
                            PAGE.Run(50008, PVHeadEr)
                        else
                            PAGE.Run(50003, PVHeadEr);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
        // SetControlAppearance;
        // CurrPageUpdate; BOLU

    end;

    trigger OnInit()
    begin

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserMgt22: Codeunit "User Setup Management BR1";
    begin
        // // UpdateControls;
        // DimEditable := true;
        // //PaymodeEditable := false;
        // //PaymodeVisible := false;
        // OthersEditable := true;

        // "Payment Type" := "Payment Type"::Imprest;
        // "Account Type" := "Account Type"::Employee;
        // CurrPage.Update();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec.Status = Rec.Status::"Pending Approval" then
            Error('You can not delete pending approval documents');

        if Rec.Status = Rec.Status::Approved then
            Error('You can not delete approved documents');

    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        // UpdateControls; BOLU
    end;

    trigger OnOpenPage()
    var
        UserMgt36: Codeunit "User Setup Management BR1";


    begin
        begin
            //     rec.SetFilter("Created By", '%1', UserId);
        end;
        UpdateControls;
        if Rec.Status = Rec.Status::"Pending Approval" then
            CurrPage.Editable := false;



    end;

    var
        PayLine: Record "Staff Claim Lines";
        strFilter: Text[250];
        IntC: Integer;
        IntCount: Integer;
        Payments: Record "Voucher Header";
        RecPayTypes: Record "Receipts and Payment Types";
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record "Cash Office User Template";
        LineNo: Integer;
        Temp: Record "Cash Office User Template";
        JTemplate: Code[20];
        JBatch: Code[20];
        Post: Boolean;
        strText: Text[100];
        PVHead: Record "Voucher Header";
        BankAcc: Record "Bank Account";
        Commitments: Record Committment1;
        // UserMgt: Codeunit "User Setup Management BR1";
        //JournlPosted: Codeunit "Journal Post Successful1";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Payment Voucher","Petty Cash",Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Express Pv",Requisition,JV," ";
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash;
        TravReqHeader: Record "Staff Claims Header";
        //  AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        DateEditable: Boolean;
        // [InDataSet]
        PaymodeEditable: Boolean;
        bankeditabl: Boolean;
        PaymentLine: Record "Voucher Line";
        PVHeadNo: Code[20];
        //PaymodeVisible: Boolean;
        GLEntry: Record "G/L Entry";

        DimEditable: Boolean;
        PaymodeVisible: Boolean;
        OthersEditable: Boolean;
        DeletDoc: Boolean;


    local procedure LinesCommitmentStatus() Exists: Boolean
    begin
        // IF BCsetup.GET() THEN  BEGIN
        //    IF NOT BCsetup.Mandatory THEN BEGIN
        //       Exists:=FALSE;
        //       EXIT;
        //    END;
        // END ELSE BEGIN
        //       Exists:=FALSE;
        //       EXIT;
        // END;
        Exists := false;
        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Rec."No.");
        PayLine.SetRange(PayLine.Committed, false);
        PayLine.SetRange(PayLine."Budgetary Control A/C", true);
        if PayLine.Find('-') then
            Exists := true;
    end;

    procedure PostImprest()
    var
        JournlPosted: Codeunit "Journal Post Successful1";
        AdjustGenJnl35: Codeunit "Adjust Gen. Journal Balance";
    begin

        if Temp.Get(UserId) then begin
            GenJnlLine.Reset;
            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
            GenJnlLine.DeleteAll;
        end;

        //CREDIT BANK
        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec."Payment Release Date";
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine."External Document No." := Rec."Cheque No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine."Account No." := Rec."Paying Bank Account";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        GenJnlLine.Description := Rec.Purpose;
        Rec.CalcFields("Total Net Amount");
        GenJnlLine."Credit Amount" := Rec."Total Net Amount";
        GenJnlLine.Validate(GenJnlLine."Credit Amount");
        //Added for Currency Codes
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.Validate("Currency Code");
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.Validate("Currency Factor");
        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;



        //DEBIT RESPECTIVE G/L ACCOUNT(S)
        PayLine.Reset;
        PayLine.SetRange(PayLine.No, Rec."No.");

        if PayLine.Find('-') then begin
            repeat
                LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := JTemplate;
                GenJnlLine."Journal Batch Name" := JBatch;
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."Posting Date" := Rec."Payment Release Date";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                GenJnlLine."Document No." := Rec."No.";
                GenJnlLine."External Document No." := Rec."Cheque No.";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Account No." := PayLine."Account No:";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine.Description := PayLine.Purpose;
                GenJnlLine."Debit Amount" := PayLine.Amount;
                GenJnlLine.Validate(GenJnlLine."Debit Amount");
                //Added for Currency Codes
                GenJnlLine."Currency Code" := Rec."Currency Code";
                GenJnlLine.Validate("Currency Code");
                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                GenJnlLine.Validate("Currency Factor");
                GenJnlLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                GenJnlLine.ValidateShortcutDimCode(3, PayLine."Shortcut Dimension 3 Code");
                GenJnlLine.ValidateShortcutDimCode(4, PayLine."Shortcut Dimension 4 Code");

                if GenJnlLine.Amount <> 0 then
                    GenJnlLine.Insert;

            until PayLine.Next = 0
        end;


        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        //Adjust Gen Jnl Exchange Rate Rounding Balances
        AdjustGenJnl35.Run(GenJnlLine);
        //End Adjust Gen Jnl Exchange Rate Rounding Balances

        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
        // end;
        Post := FALSE;
        Post := JournlPosted.PostedSuccessfully();


        GLEntry.SetRange(GLEntry."Document No.", Rec."No.");
        if GLEntry.FindFirst() then begin
            //  if Post then begin
            Rec.Posted := true;
            Rec."Date Posted" := Today;
            Rec."Time Posted" := Time;
            Rec."Posted By" := UserId;
            Rec.Status := Rec.Status::Posted;
            Rec.Modify;
        end;
    end;

    procedure CheckImprestRequiredItems()
    begin

        Rec.TestField("Payment Release Date");
        Rec.TestField("Paying Bank Account");
        Rec.TestField("Account No.");
        //TestField("Account Type", "Account Type"::Employee);

        if Rec.Posted then begin
            Error('The Document has already been posted');
        end;

        Rec.TestField(Status, Status::Approved);

        /*Check if the user has selected all the relevant fields*/

        Temp.Get(UserId);
        JTemplate := Temp."Claim Template";
        JBatch := Temp."Claim  Batch";

        if JTemplate = '' then begin
            Error('Ensure the Imprest Template is set up in Cash Office Setup');
        end;

        if JBatch = '' then begin
            Error('Ensure the Imprest Batch is set up in the Cash Office Setup')
        end;

        if not LinesExists then
            Error('There are no Lines created for this Document');

    end;

    procedure UpdateControls()
    begin
        case Rec.Status of
            Rec.Status::Open:
                begin
                    DimEditable := true;
                    PaymodeEditable := false;
                    PaymodeVisible := false;
                    OthersEditable := true;
                end;
            Rec.Status::"Pending Approval":
                begin
                    DimEditable := false;
                    PaymodeEditable := false;
                    PaymodeVisible := false;
                    OthersEditable := false;
                end;
            Rec.Status::Approved:
                begin
                    DimEditable := false;
                    PaymodeEditable := true;
                    PaymodeVisible := true;
                    OthersEditable := false;
                end;
        end;

    end;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Staff Claim Lines";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines.No, Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    local procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Staff Claim Lines";
    begin
        AllKeyFieldsEntered := true;
        PayLines.Reset;
        PayLines.SetRange(PayLines.No, Rec."No.");
        if PayLines.Find('-') then begin
            repeat
                if (PayLines.Amount <= 0) then //IF (PayLines."Account No:"='') OR (PayLines.Amount<=0) THEN
                    AllKeyFieldsEntered := false;
            until PayLines.Next = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;

    local procedure OnAfterGetCurrrRecord()
    begin
        // xRec := Rec;
        UpdateControls();
    end;

    procedure CurrPageUpdate()
    begin
        // xRec := Rec;
        UpdateControls;
        CurrPage.Update;
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

