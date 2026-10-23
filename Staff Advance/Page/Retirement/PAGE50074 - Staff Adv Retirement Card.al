page 50663 "Staff Advance Retirement"
{
    Caption = 'Staff Advance Retirement';
    PageType = Document;
    ApplicationArea = All;
    SourceTable = "Staff Advanc Surrender Header";
    SourceTableView = WHERE("Retirement Type" = filter("Advance Retirement"));
    PromotedActionCategories = 'New,Process,Report,Approvals,Attachments';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Surrender Date"; Rec."Surrender Date")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Editable = DimEditable;
                    NotBlank = true;
                    trigger OnValidate()
                    var
                        CustomerNmae: Codeunit "Posting Check FP1";
                        EmplyAccountName: Text[100];
                        "Account No.Editable": Boolean;
                    begin
                        EmplyAccountName := CustomerNmae.GetCustName(Rec."Account No.");
                    end;
                }
                field(AccountName; Rec."Account Name")
                {
                    Caption = 'Staff Name';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Imprest Issue Doc. No"; Rec."Imprest Issue Doc. No")
                {
                    Caption = 'Advance Issue Doc. No.';
                    ApplicationArea = All;
                    Editable = DimEditable;
                }
                field(ImprestPurposeEditable; 'Imprest PurposeEditable')
                {
                    Caption = 'Advance Description';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Spent"; Rec."Actual Spent")
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Difference; Rec.Difference)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Amount (LCY)"; Rec."Actual Amount (LCY)")
                {
                    Caption = 'Actual Spent (LCY)';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Imprest Issue Date"; Rec."Imprest Issue Date")
                {
                    Caption = 'Advance Issue Date';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Advance Narration"; Rec."Advance Narration")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    //Caption = 'Scheme Code';
                    Editable = DimEditable;
                    ApplicationArea = All;
                    //Visible = false;

                    trigger OnValidate()
                    var
                        DimensName: Codeunit "Posting Check FP1";
                        DimName1: Code[20];
                    begin
                        DimName1 := DimensName.GetDimensionName(Rec."Global Dimension 1 Code", 1);
                    end;
                }
                field(DimName1; 'DimName1')
                {
                    Editable = false;
                    //ShowCaption = false;
                    Caption = 'Cost Centre';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    //Caption = 'Department Code';
                    Editable = DimEditable;
                    //Visible = true;
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        DimensName: Codeunit "Posting Check FP1";
                        DimName2: Code[100];
                    begin
                        DimName2 := DimensName.GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
                        Rec."Global Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    end;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Editable = DimEditable;
                }

                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    //Caption = 'Department Code';
                    Editable = DimEditable;
                    //Visible = true;
                    ApplicationArea = All;


                }
                field(DimName2; DimName2)
                {
                    Caption = 'Revenue Centre';
                    Editable = DimEditable;
                    //Visible = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Narration; Rec.Narration)
                {
                    ApplicationArea = All;
                }
                field(Description2; Rec.Description2)
                {
                    Caption = 'Remarks';
                    ApplicationArea = All;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    //Editable = true;
                    //Visible = False;
                    ApplicationArea = All;
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                field(Cashier; Rec.Cashier)
                {
                    Caption = 'User';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Surrender Posting Date"; Rec."Surrender Posting Date")
                {
                    Caption = 'Retire Posting date';
                    ApplicationArea = All;
                }
                field("Allow Overexpenditure"; Rec."Allow Overexpenditure")
                {
                    ApplicationArea = All;
                }
                field("Open for Overexpenditure by"; Rec."Open for Overexpenditure by")
                {
                    ApplicationArea = All;
                }
                field("Date opened for OvExpenditure"; Rec."Date opened for OvExpenditure")
                {
                    ApplicationArea = All;
                }

                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    //Caption = 'ECU to Approve';
                    Editable = OthersEditable;
                    //Visible = true;
                    ApplicationArea = All;
                }
                field("Group Head"; Rec."Group Head")
                {
                    Caption = 'Group Head to Approve';
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
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
            part(ImprestLines; "Staff Advan Surrender Details5")
            {
                Caption = 'Line';
                Editable = true;
                SubPageLink = "Surrender Doc No." = FIELD("No.");
                ApplicationArea = All;
            }
        }

        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50631),
                              "No." = FIELD("No.");
            }
            part(Control23; "Pending Approval FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "Table ID" = CONST(50631), "Document No." = FIELD("No.");
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
        area(processing)
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
                    Visible = false;
                    ToolTip = 'Approve the requested changes.';
                    // Visible = OpenApprovalEntriesExistForCurrUser2;
                    // Visible = OpenApprovalEntriesExistForCurrUser2;

                    // OpenApprovalEntriesExistForCurrUser2 = true ;
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
                        if ApproovedToPost then
                            Rec.Status := Status::Approved;
                        Rec.Modify(true);
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
                    //Visible = OpenApprovalEntriesExistForCurrUser2;
                    Visible = false;

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
                    // Visible = OpenApprovalEntriesExistForCurrUser;
                    Visible = false;

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
                    //  Visible = OpenApprovalEntriesExistForCurrUser;

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
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        doctype: Enum "Approval Document Type";
                        Approvalentries: Page "Approval Entries";
                    begin
                        doctype := Rec."Retirement Type";
                        //  WorkflowsEntriesBuffer.RunWorkflowEntriesPage(Rec.RecordId, DATABASE::"Staff Advanc Surrender Header", DocType.AsInteger(), Rec."No.");
                        Approvalentries.SetRecordFilters(Database::"Staff Advanc Surrender Header", doctype::"Advance Retirement", rec."No.");
                        Approvalentries.Run();
                    end;
                }
                separator(Separator1000000046)
                {
                }
                action(Post)
                {
                    Caption = 'Post';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    Enabled = Visibilty;

                    trigger OnAction()
                    var
                        Txt0001: Label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
                        AdvanceSurrLines: Record "Staff Advanc Surrender Header";
                        Temp: Record "Cash Office User Template";
                        SurrBatch: Code[20];
                        SurrTemplate: Code[20];
                        Text000: Label 'You have not specified the Actual Amount Spent. This document will only reverse the committment and you will have to receipt the total amount returned.';
                        Text001: Label 'Document Not Posted';
                        GenledSetup: Record "Cash Office Setup";
                        GenJnlLine: Record "Gen. Journal Line";
                        DefaultBatch: Record "Gen. Journal Batch";
                        LineNo: Integer;
                        ImprestDetails: Record "Staff Advan Surrender Details";
                        Payline: Record "Staff Advan Surrender Details";
                        AdjustGenJnl34: Codeunit "Adjust Gen. Journal Balance";
                        GLEntry: Record "G/L Entry";
                        ImprestReq: Record "Staff Advance Header";
                        UpdateforActualNotspt: Codeunit "Posting Check FP1";

                    begin
                        Rec.TestField(Status, Status::Approved);
                        Rec.TestField("Surrender Posting Date");

                        if Rec.Posted then
                            Error('The transaction has already been posted.');

                        //Ensure actual spent does not exceed the amount on original document
                        Rec.CALCFIELDS("Actual Spent", "Cash Receipt Amount");
                        IF (Rec."Actual Spent" + Rec."Cash Receipt Amount") < Rec.Amount THEN
                            Message('Cash officer to confirm that deposit receipt is attached');

                        Rec.CALCFIELDS("Actual Spent");

                        //Get the Cash office user template
                        Temp.Get(UserId);
                        SurrTemplate := Temp."Advance Surr Template";
                        SurrBatch := Temp."Advance Surr Batch";

                        //HOW ABOUT WHERE ONE RETURNS ALL THE AMOUNT??
                        //THERE SHOULD BE NO GENJNL ENTRIES BUT REVERSE THE COMMITTMENTS
                        Rec.CalcFields("Actual Spent");
                        if Rec."Actual Spent" = 0 then
                            if Confirm(Text000, true) then
                                //UpdateforActualNotspt.
                                UpdateforNoActualSpent//(Rec)
                            else
                                Error(Text001);

                        // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                        if GenledSetup.Get then begin
                            GenJnlLine.Reset;
                            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", SurrTemplate);
                            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", SurrBatch);
                            GenJnlLine.DeleteAll;
                        end;

                        if DefaultBatch.Get(SurrTemplate, SurrBatch) then begin
                            DefaultBatch.Delete;
                        end;

                        DefaultBatch.Reset;
                        DefaultBatch."Journal Template Name" := SurrTemplate;
                        DefaultBatch.Name := SurrBatch;
                        DefaultBatch.Insert;
                        LineNo := 0;

                        ImprestDetails.Reset;
                        ImprestDetails.SetRange("Surrender Doc No.", Rec."No.");
                        if ImprestDetails.Find('-') then begin
                            repeat
                                LineNo := LineNo + 1000;
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := SurrTemplate;
                                GenJnlLine."Journal Batch Name" := SurrBatch;
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Source Code" := 'PAYMENTJNL';
                                //RecPayTypes.GET(ImprestDetails."Imprest Type");
                                GenJnlLine."Account Type" := RecPayTypes."Account Type";
                                GenJnlLine."Account No." := ImprestDetails."Account No:";
                                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                                //Set these fields to blanks
                                GenJnlLine."Posting Date" := Rec."Surrender Posting Date";
                                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                                GenJnlLine.VALIDATE("Gen. Posting Type");
                                GenJnlLine."Gen. Bus. Posting Group" := '';
                                GenJnlLine.VALIDATE("Gen. Bus. Posting Group");
                                GenJnlLine."Gen. Prod. Posting Group" := '';
                                GenJnlLine.VALIDATE("Gen. Prod. Posting Group");
                                GenJnlLine."VAT Bus. Posting Group" := '';
                                GenJnlLine.VALIDATE("VAT Bus. Posting Group");
                                GenJnlLine."VAT Prod. Posting Group" := '';
                                GenJnlLine.VALIDATE("VAT Prod. Posting Group");
                                GenJnlLine."Document No." := Rec."No.";
                                GenJnlLine.Amount := ImprestDetails."Actual Spent";
                                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                                //GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::Employee;
                                //GenJnlLine."Bal. Account No.":=ImprestDetails."Advance Holder";
                                GenJnlLine.Description := COPYSTR('Advance Surrendered ' + ImprestDetails."Account Name", 1, 50);
                                //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                                GenJnlLine."Currency Code" := Rec."Currency Code";
                                GenJnlLine.VALIDATE("Currency Code");
                                //Take care of Currency Factor
                                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                                GenJnlLine.VALIDATE("Currency Factor");

                                GenJnlLine."Shortcut Dimension 1 Code" := ImprestDetails."Shortcut Dimension 1 Code";
                                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := ImprestDetails."Shortcut Dimension 2 Code";
                                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                                GenJnlLine.ValidateShortcutDimCode(3, ImprestDetails."Shortcut Dimension 3 Code");
                                GenJnlLine.ValidateShortcutDimCode(4, ImprestDetails."Shortcut Dimension 4 Code");

                                //Application of Surrender entries
                                IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Employee THEN BEGIN
                                    //GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                                    //GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
                                    PVHeader.RESET;
                                    PVHeader.SETRANGE(PVHeader."External Document No.", Rec."Imprest Issue Doc. No");
                                    PVHeader.SETRANGE(PVHeader.Status, PVHeader.Status::Released);
                                    PVHeader.FINDFIRST;
                                    GenJnlLine."Applies-to Doc. No." := PVHeader."No.";
                                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                                    GenJnlLine."Applies-to ID" := Rec."Apply to ID";
                                END;

                                IF GenJnlLine.Amount <> 0 THEN
                                    GenJnlLine.INSERT;

                                //Insert balancing Employee Entries
                                LineNo := LineNo + 1000;
                                GenJnlLine.INIT;
                                GenJnlLine."Journal Template Name" := SurrTemplate;
                                GenJnlLine."Journal Batch Name" := SurrBatch;
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Source Code" := 'PAYMENTJNL';
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Employee;
                                GenJnlLine."Account No." := ImprestDetails."Advance Holder";

                                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                                //Set these fields to blanks
                                GenJnlLine."Posting Date" := Rec."Surrender Posting Date";
                                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                                GenJnlLine.VALIDATE("Gen. Posting Type");
                                GenJnlLine."Gen. Bus. Posting Group" := '';
                                GenJnlLine.VALIDATE("Gen. Bus. Posting Group");
                                GenJnlLine."Gen. Prod. Posting Group" := '';
                                GenJnlLine.VALIDATE("Gen. Prod. Posting Group");
                                GenJnlLine."VAT Bus. Posting Group" := '';
                                GenJnlLine.VALIDATE("VAT Bus. Posting Group");
                                GenJnlLine."VAT Prod. Posting Group" := '';
                                GenJnlLine.VALIDATE("VAT Prod. Posting Group");
                                GenJnlLine."Document No." := Rec."No.";
                                Rec.CALCFIELDS(Difference);
                                IF Rec.Difference < 0 THEN
                                    GenJnlLine.Amount := -ImprestDetails.Amount
                                ELSE
                                    GenJnlLine.Amount := -ImprestDetails."Actual Spent";
                                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                                //GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::Employee;
                                //GenJnlLine."Bal. Account No.":=ImprestDetails."Advance Holder";
                                GenJnlLine.Description := COPYSTR('Advance Surrendered ' + ImprestDetails."Account Name", 1, 50);
                                //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                                GenJnlLine."Currency Code" := Rec."Currency Code";
                                GenJnlLine.VALIDATE("Currency Code");
                                //Take care of Currency Factor
                                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                                GenJnlLine.VALIDATE("Currency Factor");

                                GenJnlLine."Shortcut Dimension 1 Code" := ImprestDetails."Shortcut Dimension 1 Code";
                                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := ImprestDetails."Shortcut Dimension 2 Code";
                                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                                GenJnlLine.ValidateShortcutDimCode(3, ImprestDetails."Shortcut Dimension 3 Code");
                                GenJnlLine.ValidateShortcutDimCode(4, ImprestDetails."Shortcut Dimension 4 Code");

                                //Application of Surrender entries
                                IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee THEN BEGIN
                                    GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Payment; //Dennis
                                    //GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
                                    PVHeader.RESET;
                                    PVHeader.SETRANGE(PVHeader."External Document No.", Rec."Imprest Issue Doc. No");
                                    IF PVHeader.FINDLAST THEN
                                        GenJnlLine."Applies-to Doc. No." := PVHeader."No.";
                                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                                    GenJnlLine."Applies-to ID" := Rec."Apply to ID";
                                END;

                                IF GenJnlLine.Amount <> 0 THEN
                                    GenJnlLine.INSERT;

                                //Insert Refunded Amount
                                IF Rec.Difference > 0 then begin
                                    LineNo := LineNo + 1000;
                                    GenJnlLine.INIT;
                                    GenJnlLine."Journal Template Name" := SurrTemplate;
                                    GenJnlLine."Journal Batch Name" := SurrBatch;
                                    GenJnlLine."Line No." := LineNo;
                                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Employee;
                                    GenJnlLine."Account No." := ImprestDetails."Advance Holder";

                                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                                    //Set these fields to blanks
                                    GenJnlLine."Posting Date" := Rec."Surrender Posting Date";
                                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                                    GenJnlLine.VALIDATE("Gen. Posting Type");
                                    GenJnlLine."Gen. Bus. Posting Group" := '';
                                    GenJnlLine.VALIDATE("Gen. Bus. Posting Group");
                                    GenJnlLine."Gen. Prod. Posting Group" := '';
                                    GenJnlLine.VALIDATE("Gen. Prod. Posting Group");
                                    GenJnlLine."VAT Bus. Posting Group" := '';
                                    GenJnlLine.VALIDATE("VAT Bus. Posting Group");
                                    GenJnlLine."VAT Prod. Posting Group" := '';
                                    GenJnlLine.VALIDATE("VAT Prod. Posting Group");
                                    GenJnlLine."Document No." := Rec."No.";
                                    Rec.CALCFIELDS(Difference);
                                    //IF Difference < 0 THEN
                                    //  GenJnlLine.Amount := -ImprestDetails.Amount
                                    //ELSE
                                    GenJnlLine.Amount := -ImprestDetails.Difference;
                                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                                    //GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::Employee;
                                    //GenJnlLine."Bal. Account No.":=ImprestDetails."Advance Holder";
                                    GenJnlLine.Description := COPYSTR('Advance Surrendered ' + ImprestDetails."Account Name", 1, 50);
                                    //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                                    GenJnlLine."Currency Code" := Rec."Currency Code";
                                    GenJnlLine.VALIDATE("Currency Code");
                                    //Take care of Currency Factor
                                    GenJnlLine."Currency Factor" := Rec."Currency Factor";
                                    GenJnlLine.VALIDATE("Currency Factor");

                                    GenJnlLine."Shortcut Dimension 1 Code" := ImprestDetails."Shortcut Dimension 1 Code";
                                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                                    GenJnlLine."Shortcut Dimension 2 Code" := ImprestDetails."Shortcut Dimension 2 Code";
                                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                                    GenJnlLine.ValidateShortcutDimCode(3, ImprestDetails."Shortcut Dimension 3 Code");
                                    GenJnlLine.ValidateShortcutDimCode(4, ImprestDetails."Shortcut Dimension 4 Code");

                                    //Application of Surrender entries
                                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee THEN BEGIN
                                        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Payment; //Dennis
                                                                                                                         //GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
                                        PVHeader.RESET;
                                        PVHeader.SETRANGE(PVHeader."External Document No.", Rec."Imprest Issue Doc. No");
                                        IF PVHeader.FINDLAST THEN
                                            GenJnlLine."Applies-to Doc. No." := PVHeader."No.";
                                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                                        GenJnlLine."Applies-to ID" := Rec."Apply to ID";
                                    END;

                                    IF GenJnlLine.Amount <> 0 THEN
                                        GenJnlLine.INSERT;
                                end;
                            UNTIL ImprestDetails.NEXT = 0;

                            //Insert Employee 

                            //

                            //insert balancing bank Entries
                            Rec.CALCFIELDS(Difference);
                            IF Rec.Difference <> 0 THEN begin                               //InsertBank;
                                                                                            //Bank Side
                                LineNo := LineNo + 1000;
                                GenJnlLine.Init;
                                GenJnlLine."Journal Template Name" := SurrTemplate;
                                GenJnlLine."Journal Batch Name" := SurrBatch;
                                GenJnlLine."Line No." := LineNo;
                                GenJnlLine."Source Code" := 'PAYMENTJNL';
                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                                Rec.TestField("Bank Code");
                                GenJnlLine."Account No." := Rec."Bank Code";
                                GenJnlLine.Validate(GenJnlLine."Account No.");
                                //Set these fields to blanks
                                GenJnlLine."Posting Date" := Rec."Surrender Posting Date";
                                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                                GenJnlLine.Validate("Gen. Posting Type");
                                GenJnlLine."Gen. Bus. Posting Group" := '';
                                GenJnlLine.Validate("Gen. Bus. Posting Group");
                                GenJnlLine."Gen. Prod. Posting Group" := '';
                                GenJnlLine.Validate("Gen. Prod. Posting Group");
                                GenJnlLine."VAT Bus. Posting Group" := '';
                                GenJnlLine.Validate("VAT Bus. Posting Group");
                                GenJnlLine."VAT Prod. Posting Group" := '';
                                GenJnlLine.Validate("VAT Prod. Posting Group");
                                GenJnlLine."Document No." := Rec."No.";
                                Rec.CalcFields(Difference);
                                Rec.CalcFields("Actual Spent");
                                if Rec."Actual Spent" > Rec.Amount then
                                    GenJnlLine.Amount := Rec.Difference;
                                if Rec."Actual Spent" < Rec.Amount then
                                    GenJnlLine.Amount := Rec.Difference;
                                if Rec."Actual Spent" = 0 then
                                    GenJnlLine.Amount := Rec.Amount;
                                GenJnlLine.Validate(GenJnlLine.Amount);
                                GenJnlLine.Description := 'Advance' + Rec."No." + ' Retired by staff' + Rec."Account No.";
                                GenJnlLine."Currency Code" := Rec."Currency Code";
                                GenJnlLine.Validate("Currency Code");
                                //Take care of Currency Factor
                                GenJnlLine."Currency Factor" := Rec."Currency Factor";
                                GenJnlLine.Validate("Currency Factor");

                                GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                                GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                                GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                                GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");
                                GenJnlLine."External Document No." := ImprestDetails."Cash Receipt No";

                                // if GenJnlLine.Amount <> 0 then
                                GenJnlLine.Insert;
                            end;
                            //................

                            //Post Entries
                            GenJnlLine.RESET;
                            GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", SurrTemplate);
                            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", SurrBatch);
                            //Adjust Gen Jnl Exchange Rate Rounding Balances
                            //AdjustGenJnl.RUN(GenJnlLine);
                            //End Adjust Gen Jnl Exchange Rate Rounding Balances

                            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine); //Dennis
                        END;
                        /*
                        IF JournalPostSuccessful.PostedSuccessfully THEN BEGIN
                                    Posted:=TRUE;
                                    Status:=Status::Posted;
                                    "Date Posted":=TODAY;
                                    "Time Posted":=TIME;
                                    "Posted By":=USERID;
                                    MODIFY;
                                    */
                        GLEntry.SetRange(GLEntry."Document No.", Rec."No.");
                        if GLEntry.FindFirst then begin
                            Rec.Posted := true;
                            Rec.Status := Status::Approved;
                            Rec."Date Posted" := Today;
                            Rec."Time Posted" := Time;
                            Rec."Posted By" := UserId;
                            Rec.Modify;
                            //Tag the Source Imprest Requisition as Surrendered
                            ImprestReq.RESET;
                            ImprestReq.SETRANGE(ImprestReq."No.", Rec."Imprest Issue Doc. No");
                            IF ImprestReq.FIND('-') THEN BEGIN
                                ImprestReq."Surrender Status" := ImprestReq."Surrender Status"::Full;
                                ImprestReq.MODIFY;
                            END;

                            //End Tag
                            //Post Committment Reversals
                            Doc_Type := Doc_Type::StaffSurrender;
                            //BudgetControl.ReverseEntries(Doc_Type,No);
                            if StaffAdv.Get(Rec."Imprest Issue Doc. No") then begin
                                StaffAdv.Retired := true;
                                StaffAdv.Modify(true);
                            end;
                        END;
                        CurrPage.Close;
                    end;
                }
                separator(Separator1000000044)
                {
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action("Send Approval Request")
                {
                    ApplicationArea = All;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Enabled = Visibilty;
                    // Visible = NOT OpenApprovalEntriesExist;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
                        Txt0001: Label 'Actual Spent and the Cash Receipt Amount should be equal to the amount Issued';
                        UpdateforActualNotspt: Codeunit "Posting Check FP1";
                        BudgetCheck: Codeunit "Posting Check FP1";
                    begin
                        //TESTFIELD (Attachment);
                        //CALCFIELDS (Attachment);
                        /*Payline.RESET;
                        Payline.SETRANGE(Payline."Surrender Doc No.",No);
                        IF Payline.FINDFIRST THEN BEGIN
                          REPEAT
                          IF Payline."Actual Spent" = 0 THEN
                          ERROR ('You must enter the actual amount spent for Line No. %1',Payline."Line No.");
                          UNTIL Payline.NEXT = 0;
                        END;*/
                        //TESTFIELD ("Actual Spent");

                        if Confirm('Are you sure you want to send the request for approval?', true) = false then
                            exit;
                        //Ensure actual spent does not exceed the amount on original document
                        Rec.CalcFields("Actual Spent", Rec."Cash Receipt Amount", Difference);

                        Rec."Amount on Original Document" := Rec."Actual Spent";
                        Rec.Modify;

                        if Rec.Difference <> 0 then//"Actual Spent"+"Cash Receipt Amount" > Amount THEN
                            if not Confirm('The actual Amount spent differs with the amount issued by %1 ,do you want to continue ', false, Rec.Difference) then exit;
                        /*
                              IF "Actual Spent"+"Cash Receipt Amount" > Amount THEN
                              ERROR('The actual Amount spent should not exceed the amount issued ');
                        */
                        /*
                        //First Check whether all amount entered tally
                        ImprestDetails.RESET;
                        ImprestDetails.SETRANGE(ImprestDetails."Surrender Doc No.",No);
                        IF ImprestDetails.FIND('-') THEN BEGIN
                        REPEAT
                          IF (ImprestDetails."Cash Receipt Amount"+ImprestDetails."Actual Spent")<>ImprestDetails.Amount THEN
                              ERROR(Txt0001);
                        
                        UNTIL ImprestDetails.NEXT = 0;
                        END;
                        */
                        //Ensure No Items That should be committed that are not
                        //UpdateforActualNotspt.LinesCommitmentStatusExist;
                        Rec.TestField("Account No.");
                        // send approval request
                        //BudgetCheck.ActualBudgetstaffAdvance(Rec);
                        if ApprovalMgt.CheckAdvanceSurrenderApprovalsWorkflowEnable(Rec) then
                            ApprovalMgt.OnSendAdvanceSurrenderForApproval(Rec);



                    end;


                }


                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    Enabled = Visibilty;
                    // Visible = CanCancelApprovalForRecord;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
                    begin
                        ApprovalMgt.OnCancelAdvanceSurrenderForApproval(Rec);
                    end;
                }
                separator(Separator5)
                {
                }
                group("Upload Attachment")
                {
                    Caption = 'Upload Attachment';
                    action(Attachment)
                    {
                        Caption = 'Attachment';
                        Image = Attach;
                        Promoted = true;
                        PromotedCategory = Category5;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        ApplicationArea = All;
                        //RunObject = Page Page39005911;
                        //RunPageLink = Field50002=FIELD(No);

                        trigger OnAction()
                        begin
                            // AttachmentRec.Reset;
                            // //AttachmentRec.SETRANGE(AttachmentRec."Document No.",No);
                            // if AttachmentRec.FindFirst then
                            //     PAGE.Run(39005911, AttachmentRec)
                            // else begin
                            //     AttachmentRec.Init;
                            //     // AttachmentRec."Document No.":=No;
                            //     AttachmentRec.Insert(true);
                            //     PAGE.Run(39005911, AttachmentRec);
                            //end;
                        end;
                    }
                    action("Cancel Document")
                    {
                        Caption = 'Cancel Document';
                        Image = Cancel;
                        Promoted = true;
                        PromotedCategory = Category6;
                        PromotedIsBig = true;
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            Text002: Label 'Are you sure you want to Cancel this Document?';
                            Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender;
                        begin
                            //Post Committment Reversals
                            //TESTFIELD(Status,Status::Approved);
                            if Confirm(Text002, true) then begin
                                Doc_Type := Doc_Type::Imprest;

                                Rec.Status := Status::Cancelled;
                                Rec.Modify;
                            end;
                        end;
                    }

                }
            }
            separator(Separator1000000036)
            {
            }
            action("Open OverExpenditure")
            {
                Caption = 'Open OverExpenditure';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Payline: Record "Staff Advan Surrender Details";
                begin
                    //Opening should only be for Pending Documents
                    //TESTFIELD(Status,Status::Open);
                    //Open for Overexpenditure
                    Rec."Allow Overexpenditure" := true;
                    Rec."Open for Overexpenditure by" := UserId;
                    Rec."Date opened for OvExpenditure" := Today;
                    Rec.Modify;
                    //Open lines
                    Payline.Reset;
                    Payline.SetRange(Payline."Surrender Doc No.", Rec."No.");
                    if Payline.Find('-') then begin
                        repeat
                            Payline."Allow Overexpenditure" := true;
                            Payline."Open for Overexpenditure by" := UserId;
                            Payline."Date opened for OvExpenditure" := Today;
                            Payline.Modify;
                        until Payline.Next = 0;
                    end;
                    //End open for Overexpenditure
                end;
            }
            action("Close OverExpenditure")
            {
                Caption = 'Close OverExpenditure';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Payline: Record "Staff Advan Surrender Details";
                begin
                    //Opening should only be for Pending Documents
                    //TESTFIELD(Status,Status::Open);
                    //Open for Overexpenditure
                    Rec."Allow Overexpenditure" := false;
                    Rec."Open for Overexpenditure by" := '';
                    Rec."Date opened for OvExpenditure" := 0D;
                    Rec.Modify;
                    //Open lines
                    Payline.Reset;
                    Payline.SetRange(Payline."Surrender Doc No.", Rec."No.");
                    if Payline.Find('-') then begin
                        repeat
                            Rec."Allow Overexpenditure" := false;
                            Rec."Open for Overexpenditure by" := '';
                            Rec."Date opened for OvExpenditure" := 0D;
                            Payline.Modify;
                        until Payline.Next = 0;
                    end;
                    //End open for Overexpenditure
                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(50605, true, true, Rec);
                    Rec.Reset;
                end;
            }

            action(Upload)
            {
                Image = TransmitElectronicDoc;
                ApplicationArea = All;

                trigger OnAction()
                var
                    vartest: Variant;
                    TestFile: File;
                    FilePath: Text;
                    FileName: Text;
                    DocNo: Code[20];
                    varLink: Text;
                    DocRecRef: RecordRef;
                    MyFieldRef: FieldRef;
                    LinkId: Integer;
                    CopyFrom: Text;
                    CopyTo: Text;
                begin
                    // if Upload('Upload file','C:\','Text file(*.txt)|*.txt|PDF file(*.pdf)|*.pdf|EXCEL File(*.xlsx)|*.xlsx|WORD File(*.docx)|*.docx|ALL Files(*.*)|*.*','Upload.txt',vartest) then begin
                    Message('File successfully uploaded to the server', vartest);
                    //TestFile.OPEN(vartest);
                    //FileName:=TestFile.NAME;
                    //MESSAGE('%1',FileName);

                    DocNo := Rec."No.";
                    //DocRecRef.Open(DATABASE::Table39005940);
                    MyFieldRef := DocRecRef.Field(1);
                    MyFieldRef.Value := DocNo;
                    if DocRecRef.Find('=') then begin
                        LinkId := DocRecRef.AddLink(vartest);
                        // RecordLinks.Get(LinkId);
                        //RecordLinks.Validate(Type);
                        //  MESSAGE('link %1 added successfully',LinkId);
                        /*
                        //taken to record links table for server side processing
                        RecordLinks.GET(LinkId);
                        CopyFrom:=RecordLinks.URL1;
                        FileName:=GetFileName(RecordLinks.URL1);
                        CopyTo:='C:\NavAttachments\'+FileName;
                        FILE.COPY(CopyFrom,CopyTo);
                        RecordLinks.URL1:=CopyTo;
                        RecordLinks.Description:=FileName;
                        RecordLinks.MODIFY;
                        */
                    end;
                    //else
                    //  Message('Link not added');

                end;

                //  Message('File not Successfully uploaded')

                // end
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;

        CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RecordId);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);
        //StatusStyleTxt := GetStatusStyleText();
    end;

    trigger OnAfterGetRecord()
    begin
        //CurrPageUpdate;Rec.
        SetControlAppearance;
    end;

    trigger OnInit()
    begin
        Rec."Account Type" := "Account Type"::Employee;
        Rec."Retirement Type" := "Retirement Type"::"Advance Retirement";

        ImprestLinesEditable := true;
        "Surrender Posting DateEditable" := true;
        "Responsibility CenterEditable" := true;
        "Imprest Issue Doc. NoEditable" := true;
        "Surrender DateEditable" := true;
        "Account NameNoEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserMgt: Codeunit "User Setup Management BR1";
    begin
        // "Responsibility Center" := UserMgt.GetPurchasesFilter();
        //OnAfterGetCurrRecord;

        Rec."Account Type" := "Account Type"::Employee;
        Rec."Retirement Type" := "Retirement Type"::"Advance Retirement";

        UpdateControls;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin
        begin
            //  rec.SetFilter("Created By", '%1', UserId);
        end;
        if Rec.Status = Rec.Status::"Pending Approval" then
            CurrPage.Editable := false;

        EditNo := true;
        if Rec.Status <> Status::Open
        then
            EditNo := false;

        if rec.Posted = true then
            CurrPage.Editable := false;

        Visibilty := rec.Posted = false;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec.Status = Rec.Status::"Pending Approval" then
            Error('You can not delete pending approval documents');

        if Rec.Status = Rec.Status::Approved then
            Error('You can not delete approved documents');

    end;

    procedure LinesCommitmentStatus() Exists: Boolean
    begin
    end;

    var
        RecPayTypes: Record "Receipts and Payment Types";
        TarriffCodes: Record "Tariff Codes2";
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record "Cash Office User Template";
        LineNo: Integer;
        NextEntryNo: Integer;
        CommitNo: Integer;
        ImprestDetails: Record "Staff Advan Surrender Details";
        EntryNo: Integer;
        GLAccount: Record "G/L Account";
        IsImprest: Boolean;
        GenledSetup: Record "Cash Office Setup";
        ImprestAmt: Decimal;
        DimName1: Text[60];
        DimName2: Text[60];
        PaymentLine: Record "Staff Advance Lines";
        CurrSurrDocNo: Code[20];
        // JournalPostSuccessful: Codeunit "Journal Post Successful1";
        Commitments: Record Committment1;
        Visibilty: Boolean;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender;
        ImprestReq: Record "Staff Advance Header";
        // UserMgt: Codeunit "User Setup Management BR1";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AccountName: Text[100];
        //  AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        TravAccHeader: Record "Staff Advanc Surrender Header";
        Payline: Record "Staff Advan Surrender Details";
        Temp: Record "Cash Office User Template";
        SurrBatch: Code[20];
        SurrTemplate: Code[20];
        // [InDataSet]
        "Surrender DateEditable": Boolean;
        //[InDataSet]
        "Account No.Editable": Boolean;
        ImprestPurposeEditable: Boolean;
        //[InDataSet]
        "Imprest Issue Doc. NoEditable": Boolean;
        //[InDataSet]
        "Responsibility CenterEditable": Boolean;
        // [InDataSet]
        "Surrender Posting DateEditable": Boolean;
        // [InDataSet]
        ImprestLinesEditable: Boolean;
        StatusEditable: Boolean;
        DimEditable: Boolean;
        PaymodeEditable: Boolean;
        PaymodeVisible: Boolean;
        OthersEditable: Boolean;
        RecRef: RecordRef;
        RecordLinks: Record "Record Link";
        FileName: Text;
        PVHeader: Record "Voucher Header";
        Text000: Label 'You have not specified the Actual Amount Spent. This document will only reverse the committment and you will have to receipt the total amount returned.';
        Text001: Label 'Document Not Posted';
        Text002: Label 'Are you sure you want to Cancel this Document?';
        Text19053222: Label 'Enter Advance Accounting Details below';
        GLEntry: Record "G/L Entry";
        EditNo: Boolean;
        "Account NameNoEditable": Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        AttachmentRec: Record Attachment;
        //ApproovedPost: Codeunit "Tax Calculation1";
        ShowWorkflowStatus: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        ApproovedToPost: Boolean;
        StaffAdv: Record "Staff Advance Header";

    procedure GetDimensionName(var "Code": Code[20]; DimNo: Integer) Name: Text[60]
    var
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
    begin
        /*Get the global dimension 1 and 2 from the database*/
        Name := '';

        GLSetup.Reset;
        GLSetup.Get();

        DimVal.Reset;
        DimVal.SetRange(DimVal.Code, Code);

        if DimNo = 1 then begin
            DimVal.SetRange(DimVal."Dimension Code", GLSetup."Global Dimension 1 Code");
        end
        else
            if DimNo = 2 then begin
                DimVal.SetRange(DimVal."Dimension Code", GLSetup."Global Dimension 2 Code");
            end;
        if DimVal.Find('-') then begin
            Name := DimVal.Name;
        end;

    end;


    procedure UpdateControls()
    begin
        case Rec.Status of
            Status::Open:
                begin
                    DimEditable := true;
                    PaymodeEditable := false;
                    PaymodeVisible := false;
                    OthersEditable := true;
                end;
            Status::"Pending Approval":
                begin
                    DimEditable := false;
                    PaymodeEditable := false;
                    PaymodeVisible := false;
                    OthersEditable := false;
                end;
            Status::Approved:
                begin
                    DimEditable := false;
                    PaymodeEditable := true;
                    PaymodeVisible := true;
                    OthersEditable := false;
                end;
        end;

    end;

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

    procedure GetCustName(No: Code[20]) Name: Text[100]
    var
        Employ: Record Employee;
    begin
        Name := '';
        if Employ.Get(No) then
            Name := Employ.FullName;
        exit(Name);
    end;

    procedure UpdateforNoActualSpent()
    begin
        Rec.Posted := true;
        Rec.Status := Status::Posted;
        Rec."Date Posted" := Today;
        Rec."Time Posted" := Time;
        Rec."Posted By" := UserId;
        Rec.Modify;
        //Tag the Source Imprest Requisition as Surrendered
        ImprestReq.Reset;
        ImprestReq.SetRange(ImprestReq."No.", Rec."Imprest Issue Doc. No");
        if ImprestReq.Find('-') then begin
            ImprestReq."Surrender Status" := ImprestReq."Surrender Status"::Full;
            ImprestReq.Modify;
        end;
        //End Tag
        //Post Committment Reversals
        Doc_Type := Doc_Type::StaffSurrender;
    end;

    procedure CompareAllAmounts()
    begin
    end;

    procedure CurrPageUpdate()
    begin
        xRec := Rec;
        UpdateControls;
        AccountName := GetCustName(Rec."Account No.");
        DimName1 := GetDimensionName(Rec."Global Dimension 1 Code", 1);
        DimName2 := GetDimensionName(Rec."Shortcut Dimension 2 Code", 2);
        CurrPage.Update;
    end;

    procedure InsertBalancing(AdvanceSurrLines: Record "Staff Advan Surrender Details")
    begin
        //insert Employee balancing
        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := SurrTemplate;
        GenJnlLine."Journal Batch Name" := SurrBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Employee;
        GenJnlLine."Account No." := Rec."Account No.";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        //Set these fields to blanks
        GenJnlLine."Posting Date" := Rec."Surrender Posting Date";
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine.Validate("Gen. Posting Type");
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine.Validate("Gen. Bus. Posting Group");
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine.Validate("Gen. Prod. Posting Group");
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine.Validate("VAT Bus. Posting Group");
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlLine.Validate("VAT Prod. Posting Group");
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine.Amount := -AdvanceSurrLines.Amount;//AdvanceSurrLines."Actual Spent";
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine.Description := CopyStr('Advance Retired for ' + AdvanceSurrLines."Account Name", 1, 50);
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.Validate("Currency Code");
        //Take care of Currency Factor
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.Validate("Currency Factor");

        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        //Application of Surrender entries
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee then begin
            Evaluate(GenJnlLine."Applies-to Doc. Type", Format(GenJnlLine."Applies-to Doc. Type"::Payment));
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. Type");
            //GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
            TravAccHeader.Reset;
            TravAccHeader.SetRange(TravAccHeader."Imprest Issue Doc. No", Rec."Imprest Issue Doc. No");
            if TravAccHeader.FindLast then
                GenJnlLine."Applies-to Doc. No." := TravAccHeader."Imprest Issue Doc. No";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID" := Rec."Apply to ID";
        end;

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;
    end;

    procedure InsertBank()
    begin

        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := SurrTemplate;
        GenJnlLine."Journal Batch Name" := SurrBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        Rec.TestField("Bank Code");
        GenJnlLine."Account No." := Rec."Bank Code";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        //Set these fields to blanks
        GenJnlLine."Posting Date" := Rec."Surrender Posting Date";
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine.Validate("Gen. Posting Type");
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine.Validate("Gen. Bus. Posting Group");
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine.Validate("Gen. Prod. Posting Group");
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine.Validate("VAT Bus. Posting Group");
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlLine.Validate("VAT Prod. Posting Group");
        GenJnlLine."Document No." := Rec."No.";
        Rec.CalcFields(Difference);
        Rec.CalcFields("Actual Spent");
        if Rec."Actual Spent" > Rec.Amount then
            GenJnlLine.Amount := Rec.Difference;
        if Rec."Actual Spent" < Rec.Amount then
            GenJnlLine.Amount := Rec.Difference;
        if Rec."Actual Spent" = 0 then
            GenJnlLine.Amount := Rec.Amount;
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine.Description := 'Advance' + Rec."No." + ' Retired by staff' + Rec."Account No.";
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.Validate("Currency Code");
        //Take care of Currency Factor
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.Validate("Currency Factor");

        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");
        GenJnlLine."External Document No." := ImprestDetails."Cash Receipt No";
        /*
        //Application of Surrender entries
        IF GenJnlLine."Bal. Account Type"=GenJnlLine."Bal. Account Type"::Employee THEN BEGIN
        GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
        GenJnlLine."Applies-to ID":="Apply to ID";
        END;
        */
        // if GenJnlLine.Amount <> 0 then
        GenJnlLine.Insert;
    end;

}