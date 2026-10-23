page 50680 "Posted Staff Claims"
{
    DeleteAllowed = false;
    caption = 'Posted Staff Claim Card';
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Staff Claims Header";
    SourceTableView = WHERE(Posted = CONST(true));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Editable = DateEditable;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    Caption = 'Staff No/Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                    Caption = 'Requester ID';
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Editable = "Currency CodeEditable";
                    Visible = true;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    Editable = "Pay ModeEditable";
                    ApplicationArea = All;
                    Visible = payingbankvisible;
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    ApplicationArea = All;
                    Editable = "Paying Bank AccountEditable";
                    Visible = payingbankvisible;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    Caption = 'Claim Description';
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                    Caption = 'Creator ID';
                    Editable = false;
                    Visible = payingbankvisible;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Net Amount LCY"; Rec."Total Net Amount LCY")
                {
                    ApplicationArea = All;
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    Editable = "Payment Release DateEditable";
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                    Caption = 'Cheque/EFT No.';
                    Editable = "Cheque No.Editable";
                    Visible = payingbankvisible;
                }
            }
            part(PVLines; "Staff Claim Lines")
            {
                ApplicationArea = All;
                SubPageLink = No = FIELD("No.");
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
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CheckImprestRequiredItems;
                        PostImprest;

                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        REPORT.Run(50024, true, true, Rec); //Staff Claims Voucher report
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
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CheckImprestRequiredItems;
                        PostImprest;
                    end;
                }
                separator(Separator1102755026)
                {
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        DocumentType: Enum "Approval Document Type";
                        Approvalentries: Page "Approval Entries";
                    begin
                        DocumentType := DocumentType::"Staff Claim";
                        // WorkflowsEntriesBuffer.RunWorkflowEntriesPage(Rec.RecordId, DATABASE::"Staff Claims Header", DocumentType.AsInteger(), Rec."No.");
                        Approvalentries.SetRecordFilters(Database::"Staff Claims Header", DocumentType, rec."No.");
                        Approvalentries.Run();
                    end;
                }
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    ApplicationArea = All;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if not AllFieldsEntered then
                            Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        //Ensure No Items That should be committed that are not
                        if LinesCommitmentStatus then
                            Error('There are some lines that have not been committed');

                        //Release the Imprest for Approval
                        // IF ApprovalMgt.CheckStaffClaimsApprovalsWorkflowEnabled(Rec) THEN
                        // ApprovalMgt.OnSendStaffClaimsForApproval(Rec);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        //ApprovalMgt.OnCancelStaffClaimsApprovalRequest(Rec);
                    end;
                }
                separator(Separator1102755009)
                {
                }
                action("Check Budgetary Availability")
                {
                    Caption = 'Check Budgetary Availability';
                    Image = Balance;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin

                        // BCSetup.GET;
                        // IF NOT BCSetup.Mandatory THEN
                        //   EXIT;

                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if not AllFieldsEntered then
                            Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        //First Check whether other lines are already committed.
                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::StaffClaim);
                        Commitments.SetRange(Commitments."Document No.", Rec."No.");
                        if Commitments.Find('-') then begin
                            if Confirm('Lines in this Document appear to be committed do you want to re-commit?', false) = false then begin exit end;
                            Commitments.Reset;
                            Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::StaffClaim);
                            Commitments.SetRange(Commitments."Document No.", Rec."No.");
                            Commitments.DeleteAll;
                        end;

                        // CheckBudgetAvail.CheckStaffClaim(Rec);
                    end;
                }
                action("Cancel Budget Commitment")
                {
                    Caption = 'Cancel Budget Commitment';
                    Image = CancelAllLines;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        if Confirm('Do you Wish to Cancel the Commitment entries for this document', false) = false then begin exit end;

                        Commitments.Reset;
                        Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::StaffClaim);
                        Commitments.SetRange(Commitments."Document No.", Rec."No.");
                        Commitments.DeleteAll;

                        PayLine.Reset;
                        PayLine.SetRange(PayLine.No, Rec."No.");
                        if PayLine.Find('-') then begin
                            repeat
                                PayLine.Committed := false;
                                PayLine.Modify;
                            until PayLine.Next = 0;
                        end;
                    end;
                }
                separator(Separator1102755033)
                {
                }
                action("Print/Preview")
                {
                    Caption = 'Print/Preview';
                    Image = Print;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Rec.Status <> Rec.Status::Approved then
                            Error('You can only print after the document is Approved');
                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        REPORT.Run(50024, true, true, Rec);
                        Rec.Reset;
                    end;
                }
                action("Reverse Entries")
                {
                    Caption = 'Reverse Entries';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    //  Visible = PageActionsVisible;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        Userset: Record "User Setup";
                    begin

                        begin
                            if Userset.Get(UserId) then begin
                                if Userset."Released Status" = true then begin
                                    rec.Posted := false;
                                    rec.Status := rec.Status::Approved;
                                    Message('Document has been Reopened');
                                end;
                            end;
                        end;
                    end;
                }
                separator(Separator1102756006)
                {
                }
                action("Cancel Document")
                {
                    Caption = 'Cancel Document';
                    ApplicationArea = All;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        Text000: Label 'Are you sure you want to Cancel this Document?';
                        Text001: Label 'You have selected not to Cancel this Document';
                    begin


                        //TESTFIELD(Status,Status::Approved);
                        if (Rec.Status = Rec.Status::Approved) or (Rec.Status = Rec.Status::Open) then begin
                            if Confirm(Text000, true) then begin
                                //Post Committment Reversals
                                Doc_Type := Doc_Type::Imprest;
                                //BudgetControl.ReverseEntries(Doc_Type,"No.");
                                Rec.Status := Rec.Status::Cancelled;
                                Rec.Modify;
                            end else
                                Error(Text001);

                        end;
                    end;
                }

                action("Create Payment Voucher")
                {
                    Promoted = true;
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    var
                        PVHeadEr: Record "Voucher Header";
                        PaymentLines: Record "Voucher Line";
                        EntryNo: Integer;
                        STClaimLines: Record "Staff Claim Lines";
                    begin
                        //CheckImprestRequiredItems;

                        PVHeadEr.Reset;
                        PVHeadEr.SetRange(PVHeadEr."External Document No.", Rec."No.");
                        if PVHeadEr.Find('-') = true then
                            Error('Payment Voucher has already been created for Staff claim %1', PVHeadEr."No.");


                        Rec.TestField(Status, Status::Approved);
                        Rec.TestField("Pay Mode");

                        if not Confirm('Are you sure you want to create a Payment Voucher for %1', false, Rec."No.") then
                            Error('Creation of Payment Voucher Stopped') else begin
                            /*
                                                        PVHeadEr.Init;
                                                        PVHeadEr.Date := Date;
                                                        //PVHeadEr.Payee := Payee;
                                                        //PVHeadEr."On Behalf Of" := "On Behalf Of";
                                                        //PVHeadEr.Cashier := Cashier;
                                                        PVHeadEr.Status := Status;
                                                        if "Pay Mode" = "Pay Mode"::Cash then
                                                            PVHeadEr."Payment Type" := PVHeadEr."Payment Type"::"Petty Cash"
                                                        else
                                                            if "Pay Mode" = "Pay Mode"::Cheque then
                                                                PVHeadEr."Payment Type" := PVHeadEr."Payment Type"::Normal;
                                                        PVHeadEr."Pay Mode" := "Pay Mode";
                                                        PVHeadEr."Paying Bank Account" := "Paying Bank Account";
                                                        PVHeadEr.Validate("Paying Bank Account");
                                                        PVHeadEr."Cheque No." := "Cheque No.";
                                                        PVHeadEr."Global Dimension 1 Code" := "Global Dimension 1 Code";
                                                        PVHeadEr.Validate("Global Dimension 1 Code");
                                                        PVHeadEr."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                                        PVHeadEr.Validate("Shortcut Dimension 2 Code");
                                                        PVHeadEr."Responsibility Center" := "Responsibility Center";
                                                        PVHeadEr."Payment Release Date" := "Payment Release Date";
                                                        PVHeadEr."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
                                                        PVHeadEr.Validate("Shortcut Dimension 3 Code");
                                                        PVHeadEr."Shortcut Dimension 4 Code" := "Shortcut Dimension 4 Code";
                                                        PVHeadEr.Validate("Shortcut Dimension 4 Code");
                                                        PVHeadEr."Payment Narration" := Purpose;
                                                        PVHeadEr."External Doc No." := "No.";
                                                        PVHeadEr.Insert(true);

                              */                          /*
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
                                    PaymentLines."Account No." := STClaimLines."Account No:";
                                    PaymentLines."Account Name" := STClaimLines."Account Name";
                                    PaymentLines.Amount := STClaimLines.Amount;
                                    PaymentLines."Amount" := STClaimLines.Amount;
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
                            PAGE.Run(39005902, PVHeadEr)
                        else
                            PAGE.Run(39005905, PVHeadEr);

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
        CurrPageUpdate;
    end;

    trigger OnInit()
    begin
        "Currency CodeEditable" := true;
        DateEditable := true;
        ShortcutDimension2CodeEditable := true;
        GlobalDimension1CodeEditable := true;
        "Cheque No.Editable" := true;
        "Pay ModeEditable" := true;
        "Paying Bank AccountEditable" := true;
        "Payment Release DateEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        //check if the documenent has been added while another one is still pending
        TravReqHeader.Reset;
        //TravAccHeader.SETRANGE(SaleHeader."Document Type",SaleHeader."Document Type"::"Cash Sale");
        TravReqHeader.SetRange(TravReqHeader.Cashier, UserId);
        TravReqHeader.SetRange(TravReqHeader.Status, Status::Open);

        if TravReqHeader.Count > 0 then begin
            Error('There are still some pending document(s) on your account. Please list & select the pending document to use.  ');
        end;
        //*********************************END ****************************************//


        Rec."Payment Type" := Rec."Payment Type"::Imprest;
        Rec."Account Type" := Rec."Account Type"::Employee;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //Add dimensions if set by default here
        Rec."Global Dimension 1 Code" := UserMgt.GetSetDimensions(UserId, 1);
        Rec.Validate("Global Dimension 1 Code");
        Rec."Shortcut Dimension 2 Code" := UserMgt.GetSetDimensions(UserId, 2);
        Rec.Validate("Shortcut Dimension 2 Code");
        Rec."Shortcut Dimension 3 Code" := UserMgt.GetSetDimensions(UserId, 3);
        Rec.Validate("Shortcut Dimension 3 Code");
        Rec."Shortcut Dimension 4 Code" := UserMgt.GetSetDimensions(UserId, 4);
        Rec.Validate("Shortcut Dimension 4 Code");
        UpdateControls;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin
        /*
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
        UpdateControls;
        */
        if Rec.Status = Rec.Status::Open then begin
            payingbankvisible := false;
        end else begin
            payingbankvisible := true;
        end;

    end;

    var
        PayLine: Record "Staff Claim Lines";
        strFilter: Text[250];
        IntC: Integer;
        IntCount: Integer;
        Payments: Record "Voucher Header";
        RecPayTypes: Record "Receipts and Payment Types";
        TarriffCodes: Record "Tariff Codes2";
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
        UserMgt: Codeunit "User Setup Management BR1";
        JournlPosted: Codeunit "Journal Post Successful1";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Payment Voucher","Petty Cash",Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Express Pv",Requisition,JV," ";
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash;
        TravReqHeader: Record "Staff Claims Header";
        //  AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        // [InDataSet]
        "Payment Release DateEditable": Boolean;
        // [InDataSet]
        "Paying Bank AccountEditable": Boolean;
        // [InDataSet]
        "Pay ModeEditable": Boolean;
        // [InDataSet]
        "Cheque No.Editable": Boolean;
        // [InDataSet]
        GlobalDimension1CodeEditable: Boolean;
        // [InDataSet]
        ShortcutDimension2CodeEditable: Boolean;
        // [InDataSet]
        ShortcutDimension3CodeEditable: Boolean;
        // [InDataSet]
        ShortcutDimension4CodeEditable: Boolean;
        // [InDataSet]
        DateEditable: Boolean;
        // [InDataSet]
        "Currency CodeEditable": Boolean;
        StatusEditable: Boolean;
        PaymentLine: Record "Voucher Line";
        PVHeadNo: Code[20];
        payingbankvisible: Boolean;

    procedure LinesCommitmentStatus() Exists: Boolean
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

    local procedure PostImprest()
    var
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
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
                GenJnlLine.Description := Rec.Purpose;
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
        AdjustGenJnl.Run(GenJnlLine);
        //End Adjust Gen Jnl Exchange Rate Rounding Balances

        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);

        Post := false;
        Post := JournlPosted.PostedSuccessfully();
        if Post then begin
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
        Rec.TestField("Account Type", "Account Type"::Employee);

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
        if Rec.Status = Rec.Status::Approved then begin
            "Payment Release DateEditable" := true;
            "Paying Bank AccountEditable" := true;
            "Pay ModeEditable" := true;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            "Cheque No.Editable" := true;
            // payingbankvisible :=TRUE;
            //CurrPage.UpdateControls();
        end else begin
            "Payment Release DateEditable" := false;
            "Paying Bank AccountEditable" := false;
            "Pay ModeEditable" := false;
            "Cheque No.Editable" := false;
            // payingbankvisible :=FALSE;
            //CurrForm."Currency Code".EDITABLE:=TRUE;
            //CurrPage.UpdateControls();
        end;

        if Rec.Status = Rec.Status::Open then begin
            GlobalDimension1CodeEditable := true;
            ShortcutDimension2CodeEditable := true;
            //CurrForm.Payee.EDITABLE:=TRUE;
            ShortcutDimension3CodeEditable := true;
            ShortcutDimension4CodeEditable := true;
            DateEditable := true;
            //  payingbankvisible :=FALSE;
            //CurrForm."Account No.".EDITABLE:=TRUE;
            "Currency CodeEditable" := true;
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            //CurrPage.UpdateControls();
        end else begin
            GlobalDimension1CodeEditable := false;
            ShortcutDimension2CodeEditable := false;
            //CurrForm.Payee.EDITABLE:=FALSE;
            ShortcutDimension3CodeEditable := false;
            ShortcutDimension4CodeEditable := false;
            DateEditable := false;
            payingbankvisible := true;
            //CurrForm."Account No.".EDITABLE:=FALSE;
            "Currency CodeEditable" := false;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            //CurrPage.UpdateControls();
        end;

        if Rec.Status = Rec.Status::"Pending Approval" then begin
            payingbankvisible := false;
            "Paying Bank AccountEditable" := true;
        end else begin
            payingbankvisible := true;
            GlobalDimension1CodeEditable := false;
            ShortcutDimension2CodeEditable := false;
            //CurrForm.Payee.EDITABLE:=FALSE;
            ShortcutDimension3CodeEditable := false;
            ShortcutDimension4CodeEditable := false;
            DateEditable := false;
            payingbankvisible := true;
            //CurrForm."Account No.".EDITABLE:=FALSE;
            "Currency CodeEditable" := false;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            //CurrPage.UpdateControls();
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
                if (PayLines."Account No:" = '') or (PayLines.Amount <= 0) then
                    AllKeyFieldsEntered := false;
            until PayLines.Next = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;

    local procedure OnAfterGetCurrrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;

    procedure CurrPageUpdate()
    begin
        xRec := Rec;
        UpdateControls;
        CurrPage.Update;
    end;
}

