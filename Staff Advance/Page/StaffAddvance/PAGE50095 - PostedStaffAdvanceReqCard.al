page 50674 "Posted Staff Advance Req. Card"
{

    Caption = 'Posted Staff Advance Req. Card';
    DeleteAllowed = false;
    PageType = Document;
    ShowFilter = false;
    Editable = false;
    SourceTable = "Staff Advance Header";

    SourceTableView = WHERE(Posted = CONST(true), "Type of Advance" = filter("Staff Advance"));

    layout
    {
        area(content)
        {
            group("General Information")
            {
                Editable = true;
                //ShowCaption = false;
                Visible = true;
                field("No."; Rec."No.")
                {

                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Editable = DateEditable;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = GlobalDimension1CodeEditable;
                    ApplicationArea = All;
                    NotBlank = true;
                    //Visible = false;
                }
                field("Function Name"; Rec."Function Name")
                {
                    Caption = 'Description';
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Caption = 'ECU';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("ECU Code Description"; Rec."ECU Code Description")
                {
                    Caption = 'Description';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
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
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {

                    visible = false;
                    ApplicationArea = All;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    Caption = 'Description';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = true; //jj121021
                    Visible = false;  //jj121021
                    ApplicationArea = All;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    //Editable = "Pay ModeEditable";
                    ValuesAllowed = " ", Cash, Cheque, EFT;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    // Editable = "Paying Bank AccountEditable";
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Caption = 'Paying Bank Name';
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    Editable = true; //jj121021
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
                    Editable = false; //jj131021
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        UpdateControls;

                    end;

                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    Caption = 'Total Amount';
                    ApplicationArea = All;
                }
                field("Total Net Amount LCY"; Rec."Total Net Amount LCY")
                {
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    Caption = 'Posting Date';
                    Editable = "Payment Release DateEditable";
                    Visible = PostingDateVisible;
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    Caption = 'Cheque/EFT No.';
                    Editable = "Cheque No.Editable";
                    Visible = ChequeNoVisible;
                    ApplicationArea = All;
                }
                field(Control5; Rec.Attachment)
                {
                    ShowCaption = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    //Caption = 'ECU to Approve';
                    Caption = 'Responsibility Center';
                    //Editable = editno;
                    visible = false;
                    ApplicationArea = All;
                }
                field("Group Head"; Rec."Group Head")
                {
                    Caption = 'Group Head to Approve';
                    Visible = false;
                    ApplicationArea = All;
                }
            }
            part(Control1000000004; "Staff Advance Lines")
            {
                Editable = editno;
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        ApproovedToPost := ApproovedPost.AutoSignature(Rec."No.");
                        if ApproovedToPost then
                            Rec.Status := Rec.Status::Approved;
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
                separator(Separator1102755026)
                {
                    Caption = 'Approvals';
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        DocumentType: Enum "Approval Document Type";
                        Approvalentries: Page "Approval Entries";
                    begin
                        DocumentType := DocumentType::"Staff Advance";
                        //    WorkflowsEntriesBuffer.RunWorkflowEntriesPage(Rec.RecordId, DATABASE::"Staff Advance Header", DocumentType.AsInteger(), Rec."No.");
                        Approvalentries.SetRecordFilters(50063, DocumentType, rec."No.");
                        Approvalentries.Run();
                    end;
                }
                action(SendApproval)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    //  Visible = NOT OpenApprovalEntriesExist;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
                        BudgetCheck: Codeunit "Posting Check FP1";
                    begin
                        Rec.TESTFIELD(Status, Status::Open);

                        IF EmployeeRec.GET(Rec."Account No.") THEN
                            EmployeeRec.CALCFIELDS(Balance);
                        IF EmployeeRec.Balance > 100 THEN
                            ERROR('Please check, you are still having outstanding to retire');

                        IF CONFIRM('Are you sure you want to send the request for approval?', TRUE) = FALSE THEN
                            EXIT;
                        IF NOT LinesExists THEN
                            ERROR('There are no Lines created for this Document');

                        IF NOT AllFieldsEntered THEN
                            ERROR('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        //Ensure No Items That should be committed that are not
                        IF LinesCommitmentStatus THEN
                            ERROR('There are some lines that have not been committed');

                        //Release the Imprest for Approval
                        BudgetCheck.ActualBudgetstaffAdvance(Rec);
                        if ApprovalMgt.CheckStaffAdvanceApprovalsWorkflowEnable(Rec) then
                            ApprovalMgt.OnSendStaffAdvanceForApproval(Rec);
                        //EditNo
                        Rec.Validate(Status);

                    end;
                }
                action(CancelApproval)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = CanCancelApprovalForRecord;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
                    begin
                        ApprovalMgt.OnCancelStaffAdvanceForApproval(Rec);
                    end;
                }
                separator(Separator1102755009)
                {
                }
                separator(Separator1102755033)
                {
                }
                action(PrintPreview)
                {
                    Caption = 'Print/Preview';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = PageActionsVisible;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Status::Posted);
                        if Rec."Pay Mode" = Rec."Pay Mode"::" " then Error('Please Select A Pay Mode');
                        if (Rec.Status = Rec.Status::Open) or (Rec.Status = Rec.Status::Cancelled) or (Rec.Status = Rec.Status::"Pending Approval") then
                            Error('You can not print a document that is %1', Rec.Status);
                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        REPORT.Run(50023, true, true, Rec);
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
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        Userset: Record "User Setup";
                    begin

                        begin
                            if Userset.Get(UserId) then begin
                                if Userset."Released Status" = true then begin

                                    // rec.Status := rec.Status::Approved;
                                    // Message('Document has been Reopened');
                                end;
                            end;
                        end;
                    end;
                }
                separator(Separator1102756006)
                {
                }
                action(UploadDoc)
                {
                    Caption = 'Upload Document';
                    Image = Import;
                    // Visible = PageActionsVisible;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        vartest: Variant;
                    begin
                        // Upload('Upload file', 'C:\', 'Text file(*.txt)|*.txt|PDF file(*.pdf)|*.pdf|ALL file(*)|*', 'Doc.txt', vartest)
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
                        StaffAdvLines: Record "Staff Advance Lines";
                        PaymentLines: Record "Voucher Line";
                        EntryNo: Integer;
                        ApprovalEntry: Record "Approval Entry";
                        AppEntry: Record "Approval Entry";
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                    begin
                        CheckImprestRequiredItems(Rec);

                        PVHeadEr.Reset;
                        PVHeadEr.SetRange(PVHeadEr."External Document No.", Rec."No.");
                        if PVHeadEr.Find('-') = true then
                            Error('Payment Voucher has already been created for Staff Adavance %1', PVHeadEr."No.");

                        Rec.TestField(Status, Status::Approved);
                        Rec.TestField("Pay Mode");
                        Rec.TestField("Paying Bank Account");

                        if not Confirm('Are you sure you want to create a Payment Voucher for %1', false, Rec."No.") then
                            Error('Creation of Payment Voucher Stopped') else begin

                            PVHeadEr.Init;
                            PVHeadEr."Document Date" := Rec.Date;

                            if Rec."Pay Mode" = Rec."Pay Mode"::Cash then begin
                                PVHeadEr."Voucher Type" := PVHeadEr."Voucher Type"::CPV;
                                PVHeadEr.Validate("Voucher Type");
                                PVHeadEr."No." := NoSeriesMgt.GetNextNo('CPV', TODAY, TRUE);
                                PVHeadEr.Insert(true);
                            end else BEGIN
                                //"Pay Mode" = "Pay Mode"::Cheque then
                                PVHeadEr."Voucher Type" := PVHeadEr."Voucher Type"::BPV;
                                PVHeadEr.Validate("Voucher Type");
                                PVHeadEr."No." := NoSeriesMgt.GetNextNo('BPV', TODAY, TRUE);
                                PVHeadEr.Insert(true);
                            END;

                            PVHeadEr.Status := PVHeadEr.Status::Open;
                            PVHeadEr."Account Type" := PVHeadEr."Account Type"::"Bank Account";
                            PVHeadEr."Account No." := Rec."Paying Bank Account";
                            PVHeadEr.VALIDATE("Account No.");
                            PVHeadEr."Teller / Cheque No." := Rec."Cheque No.";
                            PVHeadEr."Currency Code" := Rec."Currency Code";
                            PVHeadEr.Validate("Currency Code");
                            PVHeadEr."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                            PVHeadEr.Validate("Shortcut Dimension 1 Code");
                            PVHeadEr."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                            PVHeadEr.Validate("Shortcut Dimension 2 Code");
                            //PVHeadEr."Responsibility Center" := "Responsibility Center";
                            //PVHeadEr."Payment Release Date" := "Payment Release Date";

                            PVHeadEr."Shortcut Dimension 3 Code" := Rec."Shortcut Dimension 3 Code";
                            PVHeadEr.Validate("Shortcut Dimension 3 Code");
                            PVHeadEr."Shortcut Dimension 4 Code" := Rec."Shortcut Dimension 4 Code";
                            PVHeadEr.Validate("Shortcut Dimension 4 Code");

                            PVHeadEr."Narration" := Rec.Purpose;
                            PVHeadEr."External Document No." := Rec."No.";
                            PVHeadEr.Validate("External Document No.");
                            PVHeadEr.Modify(true);

                            StaffAdvLines.Reset;
                            StaffAdvLines.SetRange(StaffAdvLines."No.", Rec."No.");
                            if StaffAdvLines.Find('-') then begin

                                EntryNo := 1;

                                repeat
                                    PaymentLines.Init;
                                    PaymentLines."Voucher Type" := PVHeadEr."Voucher Type";
                                    PaymentLines."Line No." := 0;//EntryNo+1;
                                                                 //MESSAGE('%1',EntryNo);
                                    PaymentLines."Document No." := PVHeadEr."No.";
                                    PaymentLines."Account Type" := PaymentLines."Account Type"::Employee;
                                    PaymentLines.Validate("Account Type");
                                    PaymentLines."Account No." := Rec."Account No.";

                                    PaymentLines.Validate("Account No.");
                                    PaymentLines."Account Name" := Rec.Payee;
                                    PaymentLines.Account := PaymentLines.Account::Employee;
                                    PaymentLines."Currency Code" := Rec."Currency Code";
                                    PaymentLines."Currency Factor" := Rec."Currency Factor";
                                    //PaymentLines."NetAmount LCY":=StaffAdvLines."Amount LCY";
                                    PaymentLines.Amount := StaffAdvLines.Amount;
                                    PaymentLines.Validate(Amount);
                                    //PaymentLines."Net Amount":=StaffAdvLines.Amount;
                                    if EmployeeRec.get(Rec."Account No.") then
                                        PaymentLines."Posting Group" := EmployeeRec."Employee Posting Group";
                                    PaymentLines."Shortcut Dimension 1 Code" := StaffAdvLines."Global Dimension 1 Code";
                                    PaymentLines.Validate("Shortcut Dimension 1 Code");
                                    PaymentLines."Shortcut Dimension 2 Code" := StaffAdvLines."Shortcut Dimension 2 Code";
                                    PaymentLines.Validate("Shortcut Dimension 2 Code");
                                    PaymentLines."Shortcut Dimension 3 Code" := StaffAdvLines."Shortcut Dimension 3 Code";
                                    PaymentLines.Validate("Shortcut Dimension 3 Code");
                                    PaymentLines."Shortcut Dimension 4 Code" := StaffAdvLines."Shortcut Dimension 4 Code";
                                    PaymentLines.Validate("Shortcut Dimension 4 Code");
                                    PaymentLines.Insert(true);
                                until StaffAdvLines.Next = 0;
                            end;
                        end;


                        Rec.Posted := true;
                        Rec."Date Posted" := Today;
                        Rec."Time Posted" := Time;
                        Rec.Modify;

                        if Rec."Pay Mode" = Rec."Pay Mode"::Cash then
                            PAGE.Run(50008, PVHeadEr)
                        else
                            PAGE.Run(50003, PVHeadEr);
                        CurrPage.Close();
                    end;
                }
                /*    action(Attachment)
                    {
                        Image = Attach;
                        Promoted = true;
                        //PromotedCategory = Attachment;
                        PromotedIsBig = true;
                        PromotedOnly = true;
                        //RunObject = Page Page39005911;
                        //RunPageLink = Field50002=FIELD("No.");

                        trigger OnAction()
                        var
                            vartest: Variant;
                        begin

                            UPLOAD('Upload file', 'C:\', 'Text file(*.txt)|*.txt|PDF file(*.pdf)|*.pdf|ALL file(*)|*', 'Doc.txt', vartest)
                        end;
                    }*/
                action(PostAdvance)
                {
                    Caption = 'Post Advance';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PostImprest(Rec);
                        CurrPage.Close();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;

        UpdateControls;
        CurrPageUpdate;
        SetControlAppearance;
        if Rec.Status = rec.Status::Approved then
            CreateVouch := false
        else
            CreateVouch := true;
    end;

    trigger OnInit()
    begin
        UpdateControls;

        /*
                IF Status = Status::"Pending Approval" THEN
                    CurrPage.EDITABLE := FALSE;

                EditNo := true;
                if Status <> Status::Open
                then
                    EditNo := false;

                if "Pay Mode" = "Pay Mode"::EFT then
                    ChequeNoVisible := false;

                if Status = Status::Open then begin
                    PayingBankVisible := false;
                    PostingDateVisible := false;
                    PaymodeVisible := false;
                    ChequeNoVisible := false;
                    PageActionsVisible := false;
                    PayingBankNameVisible := false
                end else
                    if Status <> Status::Open then begin
                        PayingBankVisible := true;
                        PayingBankNameVisible := true;
                        PostingDateVisible := true;
                        PaymodeVisible := true;
                        ChequeNoVisible := true;
                        PageActionsVisible := true;
                    end;


                if Status = Status::Approved then begin
                    CreateVouch := true;
                    EditNo := true;
                end
                else
                    CreateVouch := false;

        */
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //check if the documenent has been added while another one is still pending
        TravReqHeader.Reset;
        //TravReqHeader.SetRange(TravReqHeader.Cashier, UserId);
        TravReqHeader.SetRange(TravReqHeader.Status, Status::Open);
        //if TravReqHeader.Count > 0 then begin
        //  Error(Text001);
        //end;

        Rec."Payment Type" := Rec."Payment Type"::Imprest;
        Rec."Account Type" := Rec."Account Type"::Employee;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /*
        //yusuf"Responsibility Center" := UserMgt.GetPurchasesFilter();
        //Add dimensions if set by default here
        "Global Dimension 1 Code" := UserMgt.GetSetDimensions(UserId, 1);
        Validate("Global Dimension 1 Code");
        "Shortcut Dimension 2 Code" := UserMgt.GetSetDimensions(UserId, 2);
        Validate("Shortcut Dimension 2 Code");
        "Shortcut Dimension 3 Code" := UserMgt.GetSetDimensions(UserId, 3);
        Validate("Shortcut Dimension 3 Code");
        "Shortcut Dimension 4 Code" := UserMgt.GetSetDimensions(UserId, 4);
        Validate("Shortcut Dimension 4 Code");
*/
        UpdateControls;

        //CurrPageUpdate;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin

        IF Rec.Status = Rec.Status::"Pending Approval" THEN
            CurrPage.EDITABLE := FALSE;

        EditNo := true;
        if Rec.Status <> Rec.Status::Open
        then
            EditNo := false;

        if Rec."Pay Mode" = Rec."Pay Mode"::EFT then
            ChequeNoVisible := false;

        if Rec.Status = Rec.Status::Open then begin
            PayingBankVisible := false;
            PostingDateVisible := false;
            PaymodeVisible := false;
            ChequeNoVisible := false;
            PageActionsVisible := false;
            PayingBankNameVisible := false
        end else
            if Rec.Status <> Rec.Status::Open then begin
                PayingBankVisible := true;
                PayingBankNameVisible := true;
                PostingDateVisible := true;
                PaymodeVisible := true;
                ChequeNoVisible := true;
                PageActionsVisible := true;
            end;

        //UpdateControls;

        if Rec.Status = Rec.Status::Approved then
            CreateVouch := true
        else
            CreateVouch := false;

    end;

    var
        PayLine: Record "Staff Advance Lines";
        strFilter: Text[250];
        IntC: Integer;
        IntCount: Integer;
        RecPayTypes: Record "Receipts and Payment Types";
        TarriffCodes: Record "Tariff Codes2";
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";

        LineNo: Integer;
        Temp: Record "Cash Office User Template";
        JTemplate: Code[20];
        JBatch: Code[20];
        Post: Boolean;
        strText: Text[100];
        //PVHead: Record "Cash Office Setup";
        BankAcc: Record "Bank Account";
        Commitments: Record Committment1;
        UserMgt: Codeunit "User Setup Management BR1";
        JournlPosted: Codeunit "Journal Post Successful1";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash;
        TravReqHeader: Record "Staff Advance Header";
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
        RespEditable: Boolean;
        AccountEditable: Boolean;
        PurposeEditable: Boolean;
        PayingBankVisible: Boolean;
        PayingBankNameVisible: Boolean;
        PostingDateVisible: Boolean;
        PaymodeVisible: Boolean;
        ChequeNoVisible: Boolean;
        PageActionsVisible: Boolean;
        CreateVouch: Boolean;
        EditNo: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        AttachmentRec: Record Attachment;
        Text001: Label 'There are still some pending document(s) on your account or you have not retired an existing staff advance.Please list & select the pending document to use.';
        EmployeeRec: Record Employee;
        GLentry: Record "G/L Entry";
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ApproovedPost: Codeunit "Tax Calculation1";
        ApproovedToPost: Boolean;

    procedure LinesCommitmentStatus() Exists: Boolean
    begin
    end;

    procedure PostImprest(rec: Record "Staff Advance Header")
    begin
        LineNo := 1000;
        //if Temp.Get(UserId) then begin
        JTemplate := 'BPV';//Temp."Advance Template";
        JBatch := 'BPV';// Temp."Advance  Batch";
        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        GenJnlLine.DeleteAll;
        //end;

        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Rec.Date;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := Rec."No.";
        GenJnlLine."External Document No." := Rec."Cheque No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Employee;
        GenJnlLine."Account No." := Rec."Account No.";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        GenJnlLine.Description := 'Advance: ' + Rec."Account No." + ':' + Rec.Payee;
        Rec.CalcFields("Total Net Amount");
        GenJnlLine.Amount := Rec."Total Net Amount";
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := Rec."Paying Bank Account";
        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
        //Added for Currency Codes
        GenJnlLine."Currency Code" := Rec."Currency Code";
        GenJnlLine.Validate("Currency Code");
        GenJnlLine."Currency Factor" := Rec."Currency Factor";
        GenJnlLine.Validate("Currency Factor");
        /*
        GenJnlLine."Currency Factor":=Payments."Currency Factor";
        GenJnlLine.VALIDATE("Currency Factor");
        */
        GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;


        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
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

        GLentry.SetFilter(GLentry."Document No.", Rec."No.");
        if GLentry.FindFirst then begin
            Rec.Posted := true;
            Rec.Modify;
        end;

    end;

    procedure CheckImprestRequiredItems(rec: Record "Staff Advance Header")
    begin
        //TESTFIELD("Payment Release Date");
        Rec.TestField("Paying Bank Account");
        Rec.TestField("Account No.");
        Rec.TestField("Account Type", "Account Type"::Employee);

        if Rec.Posted then begin
            Error('The Document has already been posted');
        end;

        Rec.TestField(Status, Status::Approved);

        /*Check if the user has selected all the relevant fields*/

        // Temp.Get(UserId);
        JTemplate := Temp."Advance Template";
        JBatch := Temp."Advance  Batch";
        /*
                if JTemplate = '' then begin
                    Error('Ensure the Staff Advance Template is set up in Cash Office Setup');
                end;

                if JBatch = '' then begin
                    Error('Ensure the Staff Advance Batch is set up in the Cash Office Setup')
                end;

                if not LinesExists then
                    Error('There are no Lines created for this Document');
        */
    end;

    procedure UpdateControls()
    Begin

        IF Rec.Status <> Rec.Status::Approved THEN BEGIN
            "Payment Release DateEditable" := FALSE;
            "Paying Bank AccountEditable" := FALSE;
            "Pay ModeEditable" := FALSE;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            "Cheque No.Editable" := FALSE;
            //CurrPage.UpdateControls();
        END ELSE BEGIN
            "Payment Release DateEditable" := TRUE;
            "Paying Bank AccountEditable" := TRUE;
            "Pay ModeEditable" := TRUE;
            "Cheque No.Editable" := TRUE;
            //CurrForm."Currency Code".EDITABLE:=TRUE;
            //CurrPage.UpdateControls();
        END;

        IF Rec.Status = Rec.Status::Open THEN BEGIN
            GlobalDimension1CodeEditable := TRUE;
            ShortcutDimension2CodeEditable := TRUE;
            //CurrForm.Payee.EDITABLE:=TRUE;
            ShortcutDimension3CodeEditable := TRUE;
            ShortcutDimension4CodeEditable := TRUE;
            DateEditable := TRUE;
            //CurrForm."Account No.".EDITABLE:=TRUE;
            "Currency CodeEditable" := TRUE;
            //CurrForm."Paying Bank Account".EDITABLE:=FALSE;
            //CurrPage.UpdateControls();
        END ELSE BEGIN
            GlobalDimension1CodeEditable := FALSE;
            ShortcutDimension2CodeEditable := FALSE;
            //CurrForm.Payee.EDITABLE:=FALSE;
            ShortcutDimension3CodeEditable := FALSE;
            ShortcutDimension4CodeEditable := FALSE;
            DateEditable := FALSE;
            //CurrForm."Account No.".EDITABLE:=FALSE;
            "Currency CodeEditable" := FALSE;
            //CurrForm."Paying Bank Account".EDITABLE:=TRUE;
            //CurrPage.UpdateControls();
        END;

        IF (Rec.Status = Rec.Status::Posted) OR (Rec.Status = Rec.Status::Cancelled) THEN BEGIN
            "Payment Release DateEditable" := FALSE;
            "Paying Bank AccountEditable" := FALSE;
            "Pay ModeEditable" := FALSE;
            //CurrForm."Currency Code".EDITABLE:=FALSE;
            "Cheque No.Editable" := FALSE;
            "Payment Release DateEditable" := FALSE;
            "Paying Bank AccountEditable" := FALSE;
            "Pay ModeEditable" := FALSE;
            "Cheque No.Editable" := FALSE;
            RespEditable := FALSE;
            AccountEditable := FALSE;
            PurposeEditable := FALSE;
            //CurrForm."Currency Code".EDITABLE:=TRUE;
            //CurrPage.UpdateControls();
        END;
    end;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Staff Advance Lines";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines."No.", Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            exit(HasLines);
        end;
    end;

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Staff Advance Lines";
    begin
        AllKeyFieldsEntered := true;
        PayLines.Reset;
        PayLines.SetRange(PayLines."No.", Rec."No.");
        if PayLines.Find('-') then begin
            repeat
                if (PayLines.Amount <= 0) then   //Modify by Gbenga 4/23/2018
                    AllKeyFieldsEntered := false;
            until PayLines.Next = 0;
            exit(AllKeyFieldsEntered);
        end;


    end;

    local procedure OnAfterGetCurrrRecord()
    begin
        //xRec := Rec;
        //UpdateControls();
    end;

    procedure CurrPageUpdate()
    begin
        xRec := Rec;
        UpdateControls;
        CurrPage.Update;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
    end;
}


