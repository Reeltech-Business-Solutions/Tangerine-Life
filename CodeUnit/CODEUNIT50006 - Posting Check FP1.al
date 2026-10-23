codeunit 50604 "Posting Check FP1"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        Post: Boolean;
        blnState: Boolean;
        blnJrnlState: Boolean;
        FromNo: Code[20];
        ToNo: Code[20];

    procedure SetCheck(var blnPost: Boolean)
    begin
        Post := blnPost;
    end;

    procedure GetCheck() blnPost: Boolean
    begin
        blnPost := Post;
    end;

    procedure ResetState()
    begin
        blnState := false;
        FromNo := '';
        ToNo := '';
    end;

    procedure SetState(Post: Boolean)
    begin
        blnState := Post;
    end;

    procedure GetState() ActState: Boolean
    begin
        ActState := blnState;
        exit(ActState);
    end;

    procedure FromEntryNo(var FromNoReg: Code[20])
    begin
        FromNo := FromNoReg;
    end;

    procedure ToEntryNo(var ToNoReg: Code[20])
    begin
        ToNo := ToNoReg;
    end;

    procedure GetFromRegNo() FromRegisterNo: Code[20]
    begin
        FromRegisterNo := FromNo;
    end;

    procedure GetToRegNo() ToRegisterNo: Code[20]
    begin
        ToRegisterNo := ToNo;
    end;

    procedure GetCustName(No: Code[20]) Name: Text[100]
    var
        Cust: Record Employee;
    begin
        Name := '';
        if Cust.Get(No) then
            Name := Cust."First Name" + ' ' + Cust."Middle Name" + ' ' + CUst."Last Name";
        exit(Name);
    end;


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

    procedure UpdateforNoActualSpent(var StaffAdvancSurrenderHeader: Record "Staff Advanc Surrender Header")
    var
        ImprestReq: Record "Staff Advance Header";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender;
    begin
        StaffAdvancSurrenderHeader.Posted := true;
        StaffAdvancSurrenderHeader.Status := StaffAdvancSurrenderHeader.Status::Posted;
        StaffAdvancSurrenderHeader."Date Posted" := Today;
        StaffAdvancSurrenderHeader."Time Posted" := Time;
        StaffAdvancSurrenderHeader."Posted By" := UserId;
        StaffAdvancSurrenderHeader.Modify;
        //Tag the Source Imprest Requisition as Surrendered
        ImprestReq.Reset;
        ImprestReq.SetRange(ImprestReq."No.", StaffAdvancSurrenderHeader."Imprest Issue Doc. No");
        if ImprestReq.Find('-') then begin
            ImprestReq."Surrender Status" := ImprestReq."Surrender Status"::Full;
            ImprestReq.Modify;
        end;
        //End Tag
        //Post Committment Reversals
        Doc_Type := Doc_Type::StaffSurrender;
    end;


    procedure InsertBank(StaffAdvancSurrenderHeaderBk: Record "Staff Advanc Surrender Header"; ImprestDetails: Record "Staff Advan Surrender Details"; SurrTemplate: Code[20]; SurrBatch: Code[20])
    var
        LineNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
    begin

        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := SurrTemplate;
        GenJnlLine."Journal Batch Name" := SurrBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        CheckBank(StaffAdvancSurrenderHeaderBk."Bank Code");
        GenJnlLine."Account No." := StaffAdvancSurrenderHeaderBk."Bank Code";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        //Set these fields to blanks
        GenJnlLine."Posting Date" := StaffAdvancSurrenderHeaderBk."Surrender Posting Date";
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
        GenJnlLine."Document No." := StaffAdvancSurrenderHeaderBk."No.";
        StaffAdvancSurrenderHeaderBk.CalcFields(StaffAdvancSurrenderHeaderBk.Difference);
        StaffAdvancSurrenderHeaderBk.CalcFields(StaffAdvancSurrenderHeaderBk."Actual Spent");
        if StaffAdvancSurrenderHeaderBk."Actual Spent" > StaffAdvancSurrenderHeaderBk.Amount then
            GenJnlLine.Amount := StaffAdvancSurrenderHeaderBk.Difference;
        if StaffAdvancSurrenderHeaderBk."Actual Spent" < StaffAdvancSurrenderHeaderBk.Amount then
            GenJnlLine.Amount := StaffAdvancSurrenderHeaderBk.Difference;
        if StaffAdvancSurrenderHeaderBk."Actual Spent" = 0 then
            GenJnlLine.Amount := StaffAdvancSurrenderHeaderBk.Amount;
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine.Description := 'Advance' + StaffAdvancSurrenderHeaderBk."No." + ' Retired by staff' + StaffAdvancSurrenderHeaderBk."Account No.";
        GenJnlLine."Currency Code" := StaffAdvancSurrenderHeaderBk."Currency Code";
        GenJnlLine.Validate("Currency Code");
        //Take care of Currency Factor
        GenJnlLine."Currency Factor" := StaffAdvancSurrenderHeaderBk."Currency Factor";
        GenJnlLine.Validate("Currency Factor");

        GenJnlLine."Shortcut Dimension 1 Code" := StaffAdvancSurrenderHeaderBk."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := StaffAdvancSurrenderHeaderBk."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, StaffAdvancSurrenderHeaderBk."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, StaffAdvancSurrenderHeaderBk."Shortcut Dimension 4 Code");
        GenJnlLine."External Document No." := ImprestDetails."Cash Receipt No";
        /*
        //Application of Surrender entries
        IF GenJnlLine."Bal. Account Type"=GenJnlLine."Bal. Account Type"::Customer THEN BEGIN
        GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
        GenJnlLine."Applies-to ID":="Apply to ID";
        END;
        */
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;

    end;

    procedure InsertBalancing(StaffAdvancSurrenderHeaderBk: Record "Staff Advanc Surrender Header"; AdvanceSurrLines: Record "Staff Advan Surrender Details"; SurrTemplate: Code[20]; SurrBatch: Code[20])
    var
        LineNo: integer;
        GenJnlLine: Record "Gen. Journal Line";
        TravAccHeader: Record "Staff Advanc Surrender Header";
    begin
        //insert customer balancing
        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := SurrTemplate;
        GenJnlLine."Journal Batch Name" := SurrBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Employee;
        GenJnlLine."Account No." := StaffAdvancSurrenderHeaderBk."Account No.";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        //Set these fields to blanks
        GenJnlLine."Posting Date" := StaffAdvancSurrenderHeaderBk."Surrender Posting Date";
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
        GenJnlLine."Document No." := StaffAdvancSurrenderHeaderBk."No.";
        GenJnlLine.Amount := -AdvanceSurrLines.Amount;//AdvanceSurrLines."Actual Spent";
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine.Description := CopyStr('Advance Retired for ' + AdvanceSurrLines."Account Name", 1, 50);
        GenJnlLine."Currency Code" := AdvanceSurrLines."Currency Code";
        GenJnlLine.Validate("Currency Code");
        //Take care of Currency Factor
        GenJnlLine."Currency Factor" := AdvanceSurrLines."Currency Factor";
        GenJnlLine.Validate("Currency Factor");

        GenJnlLine."Shortcut Dimension 1 Code" := StaffAdvancSurrenderHeaderBk."Global Dimension 1 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := StaffAdvancSurrenderHeaderBk."Shortcut Dimension 2 Code";
        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, StaffAdvancSurrenderHeaderBk."Shortcut Dimension 3 Code");
        GenJnlLine.ValidateShortcutDimCode(4, StaffAdvancSurrenderHeaderBk."Shortcut Dimension 4 Code");

        //Application of Surrender entries
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee then begin
            Evaluate(GenJnlLine."Applies-to Doc. Type", Format(GenJnlLine."Applies-to Doc. Type"::Payment));
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. Type");
            //GenJnlLine."Applies-to Doc. No.":="Imprest Issue Doc. No";
            TravAccHeader.Reset;
            TravAccHeader.SetRange(TravAccHeader."Imprest Issue Doc. No", StaffAdvancSurrenderHeaderBk."Imprest Issue Doc. No");
            if TravAccHeader.FindLast then
                GenJnlLine."Applies-to Doc. No." := TravAccHeader."Imprest Issue Doc. No";
            GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.");
            GenJnlLine."Applies-to ID" := StaffAdvancSurrenderHeaderBk."Apply to ID";
        end;

        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;
    end;

    local procedure CheckBank(BankCode: Code[20])
    begin
        if BankCode = '' then
            Error('Procedure TestField not implemented.');
    end;

    procedure LinesCommitmentStatusExist()
    begin
        Error('The field need to be fill');
    end;


    procedure ActualBudgetGenGL(var GenJournalLine: record "Gen. Journal Line")
    var

        GLSetupRead: Boolean;
        dimrec: Code[20];
        i: Integer;
        Dimension2: Record "Dimension Value";
        Dimension3: Record "Dimension Value";
        GenJournalLineRec: Record "Gen. Journal Line";
        GlEntry: Record "G/L Entry";
        "G/LBudgetEntry": Record "G/L Budget Entry";
        Daterec: Date;
        StartDate: Date;
        EndDate: Date;
        PayLineAmount: Decimal;
        GlEntryAmount: Decimal;
        "G/LBudgetEntryAmount": Decimal;
        Totalamountexceed: Decimal;
        StartYear: Date;
        EndYear: Date;
        t: Integer;
        StartDate2: Text;
        EndDate2: Text;
        Totalamount: Decimal;
        GenJournalLine3: Record "Gen. Journal Line";
        GlEntryAccountAmount: Decimal;
        PayLineAmountActual: Decimal;
        "G/LBudgetAccountAmount": Decimal;
        Totalamountglaccount: Decimal;
        GlaccBudgetAmountDiff: Decimal;
        GLAcc: Record "G/L Account";
        Dimension: Record "Dimension Value";
        FAPostingGroup: Record "FA Posting Group";
        FixedAsset: Record "Fixed Asset";
        fixsedassetcode: Code[20];
        Glaccount: Code[20];
        GenJournalLineNew: Record "Gen. Journal Line";
        GenJournalLineNewJ5: Record "Gen. Journal Line";
        BatchName: Code[20];
        TemplateBatch: Code[20];
        Text0055: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the Month you cannot proceed';
        Text0056: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the YEAR you cannot proceed';
    begin
        //i := 0;
        // to pick the number of cos center to itertate
        Daterec := GenJournalLine."Posting Date";
        //dimrec :='';
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);

        //MESSAGE(FORMAT(i));
        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;

        //GenJournalLineNew.RESET;
        //GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        // GenJournalLineNewJ5.SETFILTER("Journal Batch Name","Journal Batch Name");
        //GenJournalLineNewJ5.SETFILTER("Journal Template Name","Journal Template Name");
        //GenJournalLineRec.SETRANGE("Journal Template Name","Journal Template Name");
        //GenJournalLineRec.SETRANGE("Line No.","Line No.");
        //GenJournalLineNew.SETCURRENTKEY("Document No.");
        GenJournalLineNew.SETRANGE("Document No.", GenJournalLine."Document No.");
        IF GenJournalLineNew.FIND('-') THEN BEGIN
            BatchName := GenJournalLineNew."Journal Batch Name";
            TemplateBatch := GenJournalLineNew."Journal Template Name";
        END;

        GenJournalLineRec.RESET;
        GenJournalLineRec.SETCURRENTKEY("Journal Template Name", "Journal Batch Name");
        // GenJournalLineRec.SETCURRENTKEY("Document No.");
        GenJournalLineRec.SETRANGE("Journal Batch Name", BatchName);
        GenJournalLineRec.SETFILTER("Journal Template Name", TemplateBatch);
        //GenJournalLineRec.SETRANGE("Line No.","Line No.");
        //GenJournalLineRec.SETRANGE("Document No.",GenJournalLineNew."Document No.");
        IF GenJournalLineRec.FIND('-') THEN BEGIN
            REPEAT

                IF (GenJournalLineRec."Account Type" = GenJournalLineRec."Account Type"::"Fixed Asset") AND ((GenJournalLineRec."FA Posting Type" = GenJournalLineRec."FA Posting Type"::"Acquisition Cost") OR
                            (GenJournalLineRec."FA Posting Type" = GenJournalLineRec."FA Posting Type"::Appreciation)) THEN
                    ActualBudgetGenjMothYearFixedasset(GenJournalLineRec)
                ELSE BEGIN


                    GLAcc.RESET;
                    GLAcc.SETRANGE(GLAcc."No.", GenJournalLineRec."Account No.");
                    GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                    IF GLAcc.FINDFIRST THEN BEGIN

                        Dimension.SETFILTER(Dimension."Dimension Code", '%1', 'DEPARTMENT');
                        Dimension.SETRANGE(Dimension.Code, GenJournalLineRec."Shortcut Dimension 1 Code");
                        IF Dimension.FINDFIRST THEN
                            dimrec := GenJournalLineRec."Shortcut Dimension 1 Code";
                        // MESSAGE(FORMAT(dimrec[i]));
                        //  MESSAGE(dimrec);


                        //To take care of the monthly budget

                        //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
                        BEGIN
                            //Total sum of the the particular cost center on the payment line
                            GenJournalLine3.RESET;
                            GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code", "Journal Batch Name", "Journal Template Name");
                            GenJournalLine3.SETRANGE("Journal Batch Name", GenJournalLineRec."Journal Batch Name");
                            GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code", dimrec);
                            GenJournalLine3.SETRANGE("Journal Template Name", GenJournalLineRec."Journal Template Name");
                            //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
                            GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
                            PayLineAmount := GenJournalLine3.Amount;
                        END;

                        BEGIN
                            //total sum of a particular G/l account on the payment line
                            GenJournalLine3.RESET;
                            GenJournalLine3.SETCURRENTKEY("Journal Batch Name", "Journal Template Name", "Account No.");
                            GenJournalLine3.SETRANGE("Journal Batch Name", GenJournalLineRec."Journal Batch Name");
                            GenJournalLine3.SETFILTER("Journal Template Name", GenJournalLineRec."Journal Template Name");
                            GenJournalLine3.SETFILTER("Account No.", GenJournalLineRec."Account No.");
                            GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
                            PayLineAmountActual := GenJournalLine3.Amount;
                        END;

                        BEGIN
                            //Total sum of the particular cost center in the g/l entry
                            GlEntry.RESET;
                            GlEntry.SETFILTER("Global Dimension 1 Code", dimrec);
                            GlEntry.SETRANGE("Posting Date", StartDate, EndDate);
                            GlEntry.CALCSUMS(Amount);
                            GlEntryAmount := GlEntry.Amount;
                            //MESSAGE(FORMAT(GlEntryAmount));
                        END;

                        BEGIN
                            //Total sum of the particular g/l account  in the g/l entry
                            GlEntry.RESET;
                            GlEntry.SETRANGE("G/L Account No.", GenJournalLineRec."Account No.");
                            GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                            GlEntry.CALCSUMS(Amount);
                            GlEntryAccountAmount := GlEntry.Amount;
                        END;


                        BEGIN
                            //Total sum  value of a particular cost center in the budget entry
                            "G/LBudgetEntry".RESET;
                            "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                            "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                            "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        END;


                        BEGIN
                            //Total sum of of particular g/l account in the budget entry
                            "G/LBudgetEntry".RESET;
                            "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", GenJournalLineRec."Account No.");
                            "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                            "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        END;


                        //total sum for the G/L account in the g/l entry and payment line
                        Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                        //Difference btw the actual gl account and budgeted amount
                        GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                        //total sum for the costcenter in the g/l entry and payment line
                        Totalamountexceed := PayLineAmount + GlEntryAmount;

                        //Difference btw the actual cost center and budgeted amount
                        Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                        IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                        ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                        ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                            MESSAGE(Text0055, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", GenJournalLineRec."Account No.", Totalamountglaccount);

                        //END;

                        //to take care of the yearly budget

                        //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
                        BEGIN
                            //Total sum of the the particular cost center on the payment line
                            GenJournalLine3.RESET;
                            GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code", "Journal Batch Name", "Journal Template Name");
                            GenJournalLine3.SETRANGE("Journal Batch Name", GenJournalLineRec."Journal Batch Name");
                            GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code", dimrec);
                            GenJournalLine3.SETRANGE("Journal Template Name", GenJournalLineRec."Journal Template Name");
                            //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
                            GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
                            PayLineAmount := GenJournalLine3.Amount;
                        END;

                        BEGIN
                            //total sum of a particular G/l account on the payment line
                            GenJournalLine3.RESET;
                            GenJournalLine3.SETCURRENTKEY("Journal Batch Name", "Journal Template Name", "Account No.");
                            GenJournalLine3.SETRANGE("Journal Batch Name", GenJournalLineRec."Journal Batch Name");
                            GenJournalLine3.SETFILTER("Journal Template Name", GenJournalLineRec."Journal Template Name");
                            GenJournalLine3.SETFILTER("Account No.", GenJournalLineRec."Account No.");
                            GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
                            PayLineAmountActual := GenJournalLine3.Amount;
                        END;

                        BEGIN
                            //Total sum of the particular cost center in the g/l entry
                            GlEntry.RESET;
                            GlEntry.SETFILTER("Global Dimension 1 Code", dimrec);
                            GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                            GlEntry.CALCSUMS(Amount);
                            GlEntryAmount := GlEntry.Amount;
                            //MESSAGE(FORMAT(GlEntryAmount));
                        END;


                        BEGIN
                            //Total sum of the particular g/l account  in the g/l entry
                            GlEntry.RESET;
                            GlEntry.SETRANGE("G/L Account No.", GenJournalLineRec."Account No.");
                            GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                            GlEntry.CALCSUMS(Amount);
                            GlEntryAccountAmount := GlEntry.Amount;
                        END;
                        BEGIN
                            //Total sum  value of a particular cost center in the budget entry
                            "G/LBudgetEntry".RESET;
                            "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                            "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                            "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        END;

                        BEGIN
                            //Total sum  value of a particular cost center in the budget entry
                            "G/LBudgetEntry".RESET;
                            "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                            "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                            "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        END;

                        BEGIN
                            //Total sum of of particular g/l account in the budget entry
                            "G/LBudgetEntry".RESET;
                            "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", GenJournalLineRec."Account No.");
                            "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                            "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        END;

                        //total sum for the G/L account in the g/l entry and payment line
                        Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                        //Difference btw the actual gl account and budgeted amount
                        GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                        //total sum for the costcenter in the g/l entry and payment line
                        Totalamountexceed := PayLineAmount + GlEntryAmount;

                        //Difference btw the actual cost center and budgeted amount
                        Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                        //MESSAGE(Text005,"G/LBudgetEntryAmount",dimrec,Totalamountexceed,"G/LBudgetAccountAmount",PayLinebudget2."Account No.",Totalamountglaccount);
                        IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                        ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                        ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                            MESSAGE(Text0056, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", GenJournalLineRec."Account No.", Totalamountglaccount);
                        //END;
                    END;

                END;

            UNTIL GenJournalLineRec.NEXT = 0;
        END;
    end;

    procedure ActualBudgetGenjMothYearFixedasset(VAR GenjournaBudgetfixedasse: Record "Gen. Journal Line")
    var

        GLSetupRead: Boolean;
        dimrec: Code[20];
        i: Integer;
        Dimension2: Record "Dimension Value";
        Dimension3: Record "Dimension Value";
        GenJournalLineRec: Record "Gen. Journal Line";
        GlEntry: Record "G/L Entry";
        "G/LBudgetEntry": Record "G/L Budget Entry";
        Daterec: Date;
        StartDate: Date;
        EndDate: Date;
        PayLineAmount: Decimal;
        GlEntryAmount: Decimal;
        "G/LBudgetEntryAmount": Decimal;
        Totalamountexceed: Decimal;
        StartYear: Date;
        EndYear: Date;
        t: Integer;
        StartDate2: Text;
        EndDate2: Text;
        Totalamount: Decimal;
        GenJournalLine3: Record "Gen. Journal Line";
        GlEntryAccountAmount: Decimal;
        PayLineAmountActual: Decimal;
        "G/LBudgetAccountAmount": Decimal;
        Totalamountglaccount: Decimal;
        GlaccBudgetAmountDiff: Decimal;
        GLAcc: Record "G/L Account";
        Dimension: Record "Dimension Value";
        FAPostingGroup: Record "FA Posting Group";
        FixedAsset: Record "Fixed Asset";
        fixsedassetcode: Code[20];
        Glaccount: Code[20];
        GenJournalLineNew: Record "Gen. Journal Line";
        GenJournalLineNewJ5: Record "Gen. Journal Line";
        BatchName: Code[20];
        TemplateBatch: Code[20];
        Text0055: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the Month you cannot proceed';
        Text0056: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the YEAR you cannot proceed';
    begin
        IF FixedAsset.GET(GenjournaBudgetfixedasse."Account No.") THEN
            fixsedassetcode := FixedAsset."FA Posting Group";
        IF FAPostingGroup.GET(fixsedassetcode) THEN
            Glaccount := FAPostingGroup."Acquisition Cost Account";

        GLAcc.RESET;
        GLAcc.SETRANGE(GLAcc."No.", Glaccount);
        GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
        IF GLAcc.FINDFIRST THEN BEGIN

            Dimension.SETFILTER(Dimension."Dimension Code", '%1', 'DEPARTMENT');
            Dimension.SETRANGE(Dimension.Code, GenjournaBudgetfixedasse."Shortcut Dimension 1 Code");
            IF Dimension.FINDFIRST THEN
                dimrec := GenjournaBudgetfixedasse."Shortcut Dimension 1 Code";





            BEGIN
                //Total sum of the the particular cost center on the payment line
                GenJournalLine3.RESET;
                GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code", "Journal Batch Name", "Journal Template Name");
                GenJournalLine3.SETRANGE("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code", dimrec);
                GenJournalLine3.SETRANGE("Journal Template Name", GenjournaBudgetfixedasse."Journal Template Name");
                //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
                GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
                PayLineAmount := GenJournalLine3.Amount;
            END;

            BEGIN
                //total sum of a particular G/l account on the payment line for group of fixed asset
                GenJournalLine3.RESET;
                GenJournalLine3.SETCURRENTKEY("Journal Batch Name", "Journal Template Name", "Posting Group");
                GenJournalLine3.SETRANGE("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SETRANGE("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SETFILTER("Posting Group", GenjournaBudgetfixedasse."Posting Group");
                GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
                PayLineAmountActual := GenJournalLine3.Amount;
            END;

            BEGIN
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.RESET;
                GlEntry.SETRANGE("G/L Account No.", Glaccount);
                GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                GlEntry.CALCSUMS(Amount);
                GlEntryAccountAmount := GlEntry.Amount;
            END;


            BEGIN
                //Total sum of the particular cost center in the g/l entry
                GlEntry.RESET;
                GlEntry.SETFILTER("Global Dimension 1 Code", dimrec);
                GlEntry.SETRANGE("Posting Date", StartDate, EndDate);
                GlEntry.CALCSUMS(Amount);
                GlEntryAmount := GlEntry.Amount;
                //MESSAGE(FORMAT(GlEntryAmount));
            END;

            BEGIN
                //Total sum  value of a particular cost center in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            END;

            BEGIN
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", Glaccount);
                "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            END;


            //total sum for the G/L account in the g/l entry and payment line
            Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

            //Difference btw the actual gl account and budgeted amount
            GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

            //total sum for the costcenter in the g/l entry and payment line
            Totalamountexceed := PayLineAmount + GlEntryAmount;

            //Difference btw the actual cost center and budgeted amount
            Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

            IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
               ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
              ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                MESSAGE(Text0055, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", Glaccount, Totalamountglaccount);



            //END;


            BEGIN
                //Total sum of the the particular cost center on the journal line line
                GenJournalLine3.RESET;
                GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code", "Journal Batch Name", "Journal Template Name");
                GenJournalLine3.SETRANGE("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code", dimrec);
                GenJournalLine3.SETRANGE("Journal Template Name", GenjournaBudgetfixedasse."Journal Template Name");
                //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
                GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
                PayLineAmount := GenJournalLine3.Amount;
            END;

            BEGIN
                //total sum of a particular G/l account on the journal line line for group of fixed asset
                GenJournalLine3.RESET;
                GenJournalLine3.SETCURRENTKEY("Journal Batch Name", "Journal Template Name", "Posting Group");
                GenJournalLine3.SETRANGE("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SETRANGE("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SETFILTER("Posting Group", GenjournaBudgetfixedasse."Posting Group");
                GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
                PayLineAmountActual := GenJournalLine3.Amount;
            END;

            BEGIN
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.RESET;
                GlEntry.SETRANGE("G/L Account No.", Glaccount);
                GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                GlEntry.CALCSUMS(Amount);
                GlEntryAccountAmount := GlEntry.Amount;
            END;


            BEGIN
                //Total sum of the particular cost center in the g/l entry
                GlEntry.RESET;
                GlEntry.SETFILTER("Global Dimension 1 Code", dimrec);
                GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                GlEntry.CALCSUMS(Amount);
                GlEntryAmount := GlEntry.Amount;
                //MESSAGE(FORMAT(GlEntryAmount));
            END;

            BEGIN
                //Total sum  value of a particular cost center in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            END;

            BEGIN
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", Glaccount);
                "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            END;


            //total sum for the G/L account in the g/l entry and payment line
            Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

            //Difference btw the actual gl account and budgeted amount
            GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

            //total sum for the costcenter in the g/l entry and payment line
            Totalamountexceed := PayLineAmount + GlEntryAmount;

            //Difference btw the actual cost center and budgeted amount
            Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

            IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
               ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
              ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                MESSAGE(Text0056, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", Glaccount, Totalamountglaccount);

        END;

    end;



    procedure ActualBudgetPayment(Var PaymentHeader: record "Voucher Header")
    var
        dimrec: Code[20];
        i: Integer;
        Dimension2: Record "Dimension Value";
        Dimension3: Record "Dimension Value";
        Dimension: Record "Dimension Value";
        PayLinebudget: Record "Voucher Line";
        GlEntry: Record "G/L Entry";
        "G/LBudgetEntry": Record "G/L Budget Entry";
        Daterec: Date;
        StartDate: Date;
        EndDate: Date;
        PayLineAmount: Decimal;
        GlEntryAmount: Decimal;
        "G/LBudgetEntryAmount": Decimal;
        Totalamountexceed: Decimal;
        StartYear: Date;
        EndYear: Date;
        t: Integer;
        StartDate2: Text;
        EndDate2: Text;
        Totalamount: Decimal;
        PayLinebudget2: Record "Voucher Line";
        GlEntryAccountAmount: Decimal;
        PayLineAmountActual: Decimal;
        "G/LBudgetAccountAmount": Decimal;
        Totalamountglaccount: Decimal;
        GlaccBudgetAmountDiff: Decimal;
        GLAcc: Record "G/L Account";
        Text005: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the Month you cannot proceed';
        Text006: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the YEAR you cannot proceed';
    begin
        //i := 0;
        // to pick the number of cos center to itertate
        Daterec := PaymentHeader."Document Date";
        //dimrec :='';
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);

        //MESSAGE(FORMAT(i));
        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;



        PayLinebudget2.RESET;
        PayLinebudget2.SETCURRENTKEY("ShortCut Dimension 1 Code", "Document No.", "Account No.");
        PayLinebudget2.SETRANGE(PayLinebudget2."Document No.", PaymentHeader."No.");
        PayLinebudget2.SETRANGE("ShortCut Dimension 1 Code");
        PayLinebudget2.SETRANGE("Account No.");
        IF PayLinebudget2.FINDFIRST THEN BEGIN

            REPEAT


                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", PayLinebudget2."Account No.");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN

                    Dimension.SETFILTER(Dimension."Dimension Code", '%1', 'DEPARTMENT');
                    Dimension.SETRANGE(Dimension.Code, PayLinebudget2."ShortCut Dimension 1 Code");
                    IF Dimension.FINDFIRST THEN
                        dimrec := PayLinebudget2."ShortCut Dimension 1 Code";
                    // MESSAGE(FORMAT(dimrec[i]));


                    //  MESSAGE(dimrec);





                    //To take care of the monthly budget

                    //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
                    /*
                BEGIN
                    //Total sum of the the particular cost center on the payment line
                    PayLinebudget.RESET;
                    PayLinebudget.SETCURRENTKEY("Global Dimension 1 Code", "No.");
                    PayLinebudget.SETRANGE(PayLinebudget."No.", PaymentHeader."No.");
                    PayLinebudget.SETFILTER("Global Dimension 1 Code", dimrec);
                    //PayLinebudget.SETRANGE(Date,StartDate,EndDate);
                    PayLinebudget.CALCSUMS(PayLinebudget.Amount);
                    PayLineAmount := PayLinebudget.Amount;
                END;

*/
                    BEGIN
                        //Total sum of the the particular cost center on the payment line
                        PayLinebudget.RESET;
                        PayLinebudget.SETCURRENTKEY("Shortcut Dimension 1 Code", "Document No.");
                        PayLinebudget.SETRANGE(PayLinebudget."Document No.", PaymentHeader."No.");
                        PayLinebudget.SETFILTER("Shortcut Dimension 1 Code", dimrec);
                        //PayLinebudget.SETRANGE(Date,StartDate,EndDate);
                        PayLinebudget.CALCSUMS(PayLinebudget.Amount);
                        PayLineAmount := PayLinebudget.Amount;
                    END;


                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        PayLinebudget.RESET;
                        PayLinebudget.SETCURRENTKEY("Document No.", "Account No.");
                        PayLinebudget.SETRANGE(PayLinebudget."Document No.", PaymentHeader."No.");
                        PayLinebudget.SETFILTER("Account No.", PayLinebudget2."Account No.");
                        PayLinebudget.CALCSUMS(PayLinebudget.Amount);
                        PayLineAmountActual := PayLinebudget.Amount;
                    END;

                    BEGIN
                        //Total sum of the particular cost center in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETFILTER("Global Dimension 1 Code", dimrec);
                        GlEntry.SETRANGE("Posting Date", StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAmount := GlEntry.Amount;
                        //MESSAGE(FORMAT(GlEntryAmount));
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", PayLinebudget2."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;


                    BEGIN
                        //Total sum  value of a particular cost center in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", PayLinebudget2."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                    //total sum for the costcenter in the g/l entry and payment line
                    Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                       ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                      ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                        MESSAGE(Text005, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", PayLinebudget2."Account No.", Totalamountglaccount);

                    //END;

                    //to take care of the yearly budget

                    //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
                    BEGIN
                        //Total sum of the the particular cost center on the payment line
                        PayLinebudget.RESET;
                        PayLinebudget.SETCURRENTKEY("Shortcut Dimension 1 Code", "Document No.");
                        PayLinebudget.SETRANGE(PayLinebudget."Document No.", PaymentHeader."No.");
                        PayLinebudget.SETFILTER("Shortcut Dimension 1 Code", dimrec);
                        //PayLinebudget.SETRANGE(Date,StartYear,EndYear);
                        PayLinebudget.CALCSUMS(PayLinebudget.Amount);
                        PayLineAmount := PayLinebudget.Amount;
                    END;

                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        PayLinebudget.RESET;
                        PayLinebudget.SETCURRENTKEY("Document No.", "Account No.");
                        PayLinebudget.SETRANGE(PayLinebudget."Document No.", PaymentHeader."No.");
                        PayLinebudget.SETFILTER("Account No.", PayLinebudget2."Account No.");
                        PayLinebudget.CALCSUMS(PayLinebudget.Amount);
                        PayLineAmountActual := PayLinebudget.Amount;
                    END;

                    BEGIN
                        //Total sum of the particular cost center in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETFILTER("Global Dimension 1 Code", dimrec);
                        GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAmount := GlEntry.Amount;
                        //MESSAGE(FORMAT(GlEntryAmount));
                    END;


                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", PayLinebudget2."Account No.");
                        GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;
                    BEGIN
                        //Total sum  value of a particular cost center in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    BEGIN
                        //Total sum  value of a particular cost center in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", PayLinebudget2."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                    //total sum for the costcenter in the g/l entry and payment line
                    Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    //MESSAGE(Text005,"G/LBudgetEntryAmount",dimrec,Totalamountexceed,"G/LBudgetAccountAmount",PayLinebudget2."Account No.",Totalamountglaccount);
                    IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                       ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                      ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                        MESSAGE(Text006, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", PayLinebudget2."Account No.", Totalamountglaccount);
                    //END;
                END
            UNTIL PayLinebudget2.NEXT = 0;
        END;
    end;





    procedure ActualBudgetstaffAdvance(var StaffAdvanceHeader: record "Staff Advance Header")
    var
        dimrec: Code[20];
        i: Integer;
        Dimension2: Record "Dimension Value";
        Dimension3: Record "Dimension Value";
        StaffAdvanceLinesBudget: Record "Staff Advance Lines";
        GlEntry: Record "G/L Entry";
        "G/LBudgetEntry": Record "G/L Budget Entry";
        Daterec: Date;
        StartDate: Date;
        EndDate: Date;
        PayLineAmount: Decimal;
        GlEntryAmount: Decimal;
        "G/LBudgetEntryAmount": Decimal;
        Totalamountexceed: Decimal;
        StartYear: Date;
        EndYear: Date;
        t: Integer;
        StartDate2: Text;
        EndDate2: Text;
        Totalamount: Decimal;
        StaffAdvanceLinesBudget2: Record "Staff Advance Lines";
        GlEntryAccountAmount: Decimal;
        PayLineAmountActual: Decimal;
        "G/LBudgetAccountAmount": Decimal;
        Totalamountglaccount: Decimal;
        GlaccBudgetAmountDiff: Decimal;
        GLAcc: Record "G/L Account";
        Dimension: Record "Dimension Value";
        Text005: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the Month you cannot proceed';
        Text006: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the YEAR you cannot proceed';
    begin
        Daterec := StaffAdvanceHeader.Date;
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);


        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;

        // to pick the number of cos center to itertate

        Daterec := StaffAdvanceHeader.Date;
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);


        StaffAdvanceLinesBudget.SETCURRENTKEY("No.", "Global Dimension 1 Code", "Account No.");
        StaffAdvanceLinesBudget.SETRANGE(StaffAdvanceLinesBudget."No.", StaffAdvanceHeader."No.");
        StaffAdvanceLinesBudget.SETRANGE("Global Dimension 1 Code");
        StaffAdvanceLinesBudget.SETRANGE(StaffAdvanceLinesBudget."Account No.");
        IF StaffAdvanceLinesBudget.FINDFIRST THEN BEGIN
            REPEAT
                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", StaffAdvanceLinesBudget."Account No.");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN



                    Dimension.SETFILTER(Dimension."Dimension Code", '%1', 'DEPARTMENT');
                    Dimension.SETRANGE(Dimension.Code, StaffAdvanceLinesBudget."Global Dimension 1 Code");
                    IF Dimension.FINDFIRST THEN
                        dimrec := StaffAdvanceLinesBudget."Global Dimension 1 Code";

                    MESSAGE(dimrec);
                    //To take care of the monthly budget
                    //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
                    BEGIN
                        StaffAdvanceLinesBudget2.RESET;
                        StaffAdvanceLinesBudget2.SETCURRENTKEY("Global Dimension 1 Code", "No.");
                        StaffAdvanceLinesBudget2.SETRANGE(StaffAdvanceLinesBudget2."No.", StaffAdvanceHeader."No.");
                        StaffAdvanceLinesBudget2.SETFILTER("Global Dimension 1 Code", dimrec);
                        //PayLinebudget.SETRANGE(Date,StartDate,EndDate);
                        StaffAdvanceLinesBudget2.CALCSUMS(StaffAdvanceLinesBudget2.Amount);
                        PayLineAmount := StaffAdvanceLinesBudget2.Amount;
                    END;



                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        StaffAdvanceLinesBudget2.RESET;
                        StaffAdvanceLinesBudget2.SETCURRENTKEY("No.", "Account No.");
                        StaffAdvanceLinesBudget2.SETRANGE(StaffAdvanceLinesBudget2."No.", StaffAdvanceHeader."No.");
                        StaffAdvanceLinesBudget2.SETFILTER("Account No.", StaffAdvanceLinesBudget."Account No.");
                        StaffAdvanceLinesBudget2.CALCSUMS(StaffAdvanceLinesBudget2.Amount);
                        PayLineAmountActual := StaffAdvanceLinesBudget2.Amount;
                    END;


                    BEGIN
                        GlEntry.RESET;
                        GlEntry.SETFILTER("Global Dimension 2 Code", dimrec);
                        GlEntry.SETRANGE("Posting Date", StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAmount := GlEntry.Amount;
                        //MESSAGE(FORMAT(GlEntryAmount));
                    END;


                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", StaffAdvanceLinesBudget."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    BEGIN
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", StaffAdvanceLinesBudget."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                    //total sum for the costcenter in the g/l entry and payment line
                    Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                       ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                      ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                        MESSAGE(Text005, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", StaffAdvanceLinesBudget."Account No.", Totalamountglaccount);





                    //to take care of the yearly budget

                    //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
                    //F (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
                    BEGIN
                        StaffAdvanceLinesBudget2.RESET;
                        StaffAdvanceLinesBudget2.SETCURRENTKEY("Global Dimension 1 Code", "No.");
                        StaffAdvanceLinesBudget2.SETRANGE(StaffAdvanceLinesBudget2."No.", StaffAdvanceHeader."No.");
                        StaffAdvanceLinesBudget2.SETFILTER("Global Dimension 1 Code", dimrec);
                        //PayLinebudget.SETRANGE(Date,StartDate,EndDate);
                        StaffAdvanceLinesBudget2.CALCSUMS(StaffAdvanceLinesBudget2.Amount);
                        PayLineAmount := StaffAdvanceLinesBudget2.Amount;
                    END;



                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        StaffAdvanceLinesBudget2.RESET;
                        StaffAdvanceLinesBudget2.SETCURRENTKEY("No.", "Account No.");
                        StaffAdvanceLinesBudget2.SETRANGE(StaffAdvanceLinesBudget2."No.", StaffAdvanceHeader."No.");
                        StaffAdvanceLinesBudget2.SETFILTER("Account No.", StaffAdvanceLinesBudget."Account No.");
                        StaffAdvanceLinesBudget2.CALCSUMS(StaffAdvanceLinesBudget2.Amount);
                        PayLineAmountActual := StaffAdvanceLinesBudget2.Amount;
                    END;


                    BEGIN
                        GlEntry.RESET;
                        GlEntry.SETFILTER("Global Dimension 1 Code", dimrec);
                        GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAmount := GlEntry.Amount;
                        //MESSAGE(FORMAT(GlEntryAmount));
                    END;


                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", StaffAdvanceLinesBudget."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    BEGIN
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", StaffAdvanceLinesBudget."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                    //total sum for the costcenter in the g/l entry and payment line
                    Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                       ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                      ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                        MESSAGE(Text006, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", StaffAdvanceLinesBudget."Account No.", Totalamountglaccount);
                END;
            UNTIL StaffAdvanceLinesBudget.NEXT = 0;

        END;
    end;

    procedure ActualBudgetMothYearPurchase(var PurchaseHeader: record "Purchase Header")
    var

        Dimension: Record "Dimension Value";
        dimrec: Code[20];
        i: Integer;
        Dimension2: Record "Dimension Value";
        Dimension3: Record "Dimension Value";
        PurchaseLineBudget2: Record "Purchase Line";
        GlEntry: Record "G/L Entry";
        "G/LBudgetEntry": Record "G/L Budget Entry";
        Daterec: Date;
        StartDate: Date;
        EndDate: Date;
        PayLineAmount: Decimal;
        GlEntryAmount: Decimal;
        "G/LBudgetEntryAmount": Decimal;
        Totalamountexceed: Decimal;
        StartYear: Date;
        EndYear: Date;
        t: Integer;
        StartDate2: Text;
        EndDate2: Text;
        Totalamount: Decimal;
        PurchaseLineBudget: Record "Purchase Line";
        GlEntryAccountAmount: Decimal;
        PayLineAmountActual: Decimal;
        "G/LBudgetAccountAmount": Decimal;
        Totalamountglaccount: Decimal;
        GlaccBudgetAmountDiff: Decimal;
        FAPostingGroup: Record "FA Posting Group";
        FixedAsset: Record "Fixed Asset";
        fixsedassetcode: Code[20];
        Glaccount: Code[20];
        GLAcc: Record "G/L Account";
        Text0055: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the Month you cannot proceed';
        Text0056: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the YEAR you cannot proceed';
    begin
        Daterec := PurchaseHeader."Order Date";
        //dimrec :='';
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);

        //MESSAGE(FORMAT(i));
        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;



        PurchaseLineBudget.SETCURRENTKEY("Shortcut Dimension 1 Code", "Document No.", "No.");
        PurchaseLineBudget.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchaseLineBudget.SETRANGE("Shortcut Dimension 1 Code");
        PurchaseLineBudget.SETRANGE("No.");
        IF PurchaseLineBudget.FINDFIRST THEN BEGIN

            REPEAT

                IF PurchaseLineBudget.Type = PurchaseLineBudget.Type::"Fixed Asset" THEN
                    ActualBudgetMothYearFixedassPurchase(PurchaseHeader, PurchaseLineBudget)
                ELSE BEGIN

                    GLAcc.RESET;
                    GLAcc.SETRANGE(GLAcc."No.", PurchaseLineBudget."No.");
                    GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                    IF GLAcc.FINDFIRST THEN BEGIN

                        Dimension.SETFILTER(Dimension."Dimension Code", '%1', 'DEPARTMENT');
                        Dimension.SETRANGE(Dimension.Code, PurchaseLineBudget."Shortcut Dimension 1 Code");
                        IF Dimension.FINDFIRST THEN
                            dimrec := PurchaseLineBudget."Shortcut Dimension 1 Code";

                        MESSAGE(dimrec);


                        BEGIN
                            //Total sum of the the particular cost center on the payment line
                            PurchaseLineBudget2.RESET;
                            PurchaseLineBudget2.SETCURRENTKEY("Shortcut Dimension 1 Code", "Document No.");
                            PurchaseLineBudget2.SETRANGE("Document No.", PurchaseHeader."No.");
                            PurchaseLineBudget2.SETFILTER("Shortcut Dimension 2 Code", dimrec);
                            //PurchaseLineBudget2.SETRANGE(Date,StartDate,EndDate);
                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                            PayLineAmount := PurchaseLineBudget2."Amount Including VAT";
                        END;


                        BEGIN
                            //total sum of a particular G/l account on the payment line
                            PurchaseLineBudget2.RESET;
                            PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                            PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", PurchaseHeader."No.");
                            PurchaseLineBudget2.SETFILTER("No.", PurchaseLineBudget."No.");
                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                            PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                        END;

                        BEGIN
                            //Total sum of the particular g/l account  in the g/l entry
                            GlEntry.RESET;
                            GlEntry.SETRANGE("G/L Account No.", PurchaseLineBudget."No.");
                            GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                            GlEntry.CALCSUMS(Amount);
                            GlEntryAccountAmount := GlEntry.Amount;
                        END;


                        BEGIN
                            //Total sum of the particular cost center in the g/l entry
                            GlEntry.RESET;
                            GlEntry.SETFILTER("Global Dimension 1 Code", dimrec);
                            GlEntry.SETRANGE("Posting Date", StartDate, EndDate);
                            GlEntry.CALCSUMS(Amount);
                            GlEntryAmount := GlEntry.Amount;
                            //MESSAGE(FORMAT(GlEntryAmount));
                        END;

                        BEGIN
                            //Total sum  value of a particular cost center in the budget entry
                            "G/LBudgetEntry".RESET;
                            "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                            "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                            "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        END;

                        BEGIN
                            //Total sum of of particular g/l account in the budget entry
                            "G/LBudgetEntry".RESET;
                            "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", PurchaseLineBudget."No.");
                            "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                            "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        END;


                        //total sum for the G/L account in the g/l entry and payment line
                        Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                        //Difference btw the actual gl account and budgeted amount
                        GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                        //total sum for the costcenter in the g/l entry and payment line
                        Totalamountexceed := PayLineAmount + GlEntryAmount;

                        //Difference btw the actual cost center and budgeted amount
                        Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                        IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                           ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                          ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                            MESSAGE(Text0055, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", PurchaseLineBudget."No.", Totalamountglaccount);



                        //END;


                        BEGIN
                            //Total sum of the the particular cost center on the payment line
                            PurchaseLineBudget2.RESET;
                            PurchaseLineBudget2.SETCURRENTKEY("Shortcut Dimension 1 Code", "Document No.");
                            PurchaseLineBudget2.SETRANGE("Document No.", PurchaseHeader."No.");
                            PurchaseLineBudget2.SETFILTER("Shortcut Dimension 1 Code", dimrec);
                            //PurchaseLineBudget2.SETRANGE(Date,StartDate,EndDate);
                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                            PayLineAmount := PurchaseLineBudget2."Amount Including VAT";
                        END;


                        BEGIN
                            //total sum of a particular G/l account on the payment line
                            PurchaseLineBudget2.RESET;
                            PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                            PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", PurchaseHeader."No.");
                            PurchaseLineBudget2.SETFILTER("No.", PurchaseLineBudget."No.");
                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                            PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                        END;

                        BEGIN
                            //Total sum of the particular g/l account  in the g/l entry
                            GlEntry.RESET;
                            GlEntry.SETRANGE("G/L Account No.", PurchaseLineBudget."No.");
                            GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                            GlEntry.CALCSUMS(Amount);
                            GlEntryAccountAmount := GlEntry.Amount;
                        END;


                        BEGIN
                            //Total sum of the particular cost center in the g/l entry
                            GlEntry.RESET;
                            GlEntry.SETFILTER("Global Dimension 1 Code", dimrec);
                            GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                            GlEntry.CALCSUMS(Amount);
                            GlEntryAmount := GlEntry.Amount;
                            //MESSAGE(FORMAT(GlEntryAmount));
                        END;

                        BEGIN
                            //Total sum  value of a particular cost center in the budget entry
                            "G/LBudgetEntry".RESET;
                            "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                            "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                            "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        END;

                        BEGIN
                            //Total sum of of particular g/l account in the budget entry
                            "G/LBudgetEntry".RESET;
                            "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", PurchaseLineBudget."No.");
                            "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                            "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        END;


                        //total sum for the G/L account in the g/l entry and payment line
                        Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                        //Difference btw the actual gl account and budgeted amount
                        GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                        //total sum for the costcenter in the g/l entry and payment line
                        Totalamountexceed := PayLineAmount + GlEntryAmount;

                        //Difference btw the actual cost center and budgeted amount
                        Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                        IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                           ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                          ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                            MESSAGE(Text0056, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", PurchaseLineBudget."No.", Totalamountglaccount);
                    END
                END;
            UNTIL PurchaseLineBudget.NEXT = 0;
        END;

    end;

    procedure ActualBudgetMothYearFixedassPurchase(PurchaseHeader: record "Purchase Header"; VAR PurchaseLineBudgetfixedasse: Record "Purchase Line")
    var
        Dimension: Record "Dimension Value";
        dimrec: Code[20];
        i: Integer;
        Dimension2: Record "Dimension Value";
        Dimension3: Record "Dimension Value";
        PurchaseLineBudget2: Record "Purchase Line";
        GlEntry: Record "G/L Entry";
        "G/LBudgetEntry": Record "G/L Budget Entry";
        Daterec: Date;
        StartDate: Date;
        EndDate: Date;
        PayLineAmount: Decimal;
        GlEntryAmount: Decimal;
        "G/LBudgetEntryAmount": Decimal;
        Totalamountexceed: Decimal;
        StartYear: Date;
        EndYear: Date;
        t: Integer;
        StartDate2: Text;
        EndDate2: Text;
        Totalamount: Decimal;
        PurchaseLineBudget: Record "Purchase Line";
        GlEntryAccountAmount: Decimal;
        PayLineAmountActual: Decimal;
        "G/LBudgetAccountAmount": Decimal;
        Totalamountglaccount: Decimal;
        GlaccBudgetAmountDiff: Decimal;
        FAPostingGroup: Record "FA Posting Group";
        FixedAsset: Record "Fixed Asset";
        fixsedassetcode: Code[20];
        Glaccount: Code[20];
        GLAcc: Record "G/L Account";
        Text0055: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the Month you cannot proceed';
        Text0056: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the YEAR you cannot proceed';
    begin
        Daterec := PurchaseHeader."Order Date";
        //dimrec :='';
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);

        //MESSAGE(FORMAT(i));
        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;


        IF FixedAsset.GET(PurchaseLineBudgetfixedasse."No.") THEN
            fixsedassetcode := FixedAsset."FA Posting Group";
        IF FAPostingGroup.GET(fixsedassetcode) THEN
            Glaccount := FAPostingGroup."Acquisition Cost Account";

        GLAcc.RESET;
        GLAcc.SETRANGE(GLAcc."No.", Glaccount);
        GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
        IF GLAcc.FINDFIRST THEN BEGIN

            Dimension.SETFILTER(Dimension."Dimension Code", '%1', 'DEPARTMENT');
            Dimension.SETRANGE(Dimension.Code, PurchaseLineBudgetfixedasse."Shortcut Dimension 1 Code");
            IF Dimension.FINDFIRST THEN
                dimrec := PurchaseLineBudgetfixedasse."Shortcut Dimension 1 Code";





            BEGIN
                //Total sum of the the particular cost center on the payment line
                PurchaseLineBudget2.RESET;
                PurchaseLineBudget2.SETCURRENTKEY("Shortcut Dimension 1 Code", "Document No.");
                PurchaseLineBudget2.SETRANGE("Document No.", PurchaseHeader."No.");
                PurchaseLineBudget2.SETFILTER("Shortcut Dimension 1 Code", dimrec);
                //PurchaseLineBudget2.SETRANGE(Date,StartDate,EndDate);
                PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                PayLineAmount := PurchaseLineBudget2."Amount Including VAT";
            END;


            BEGIN
                //total sum of a particular G/l account on the payment line
                PurchaseLineBudget2.RESET;
                PurchaseLineBudget2.SETCURRENTKEY("Document No.", "Posting Group");
                PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", PurchaseHeader."No.");
                PurchaseLineBudget2.SETFILTER("Posting Group", PurchaseLineBudgetfixedasse."Posting Group");
                PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
            END;

            BEGIN
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.RESET;
                GlEntry.SETRANGE("G/L Account No.", Glaccount);
                GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                GlEntry.CALCSUMS(Amount);
                GlEntryAccountAmount := GlEntry.Amount;
            END;


            BEGIN
                //Total sum of the particular cost center in the g/l entry
                GlEntry.RESET;
                GlEntry.SETFILTER("Global Dimension 1 Code", dimrec);
                GlEntry.SETRANGE("Posting Date", StartDate, EndDate);
                GlEntry.CALCSUMS(Amount);
                GlEntryAmount := GlEntry.Amount;
                //MESSAGE(FORMAT(GlEntryAmount));
            END;

            BEGIN
                //Total sum  value of a particular cost center in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code", dimrec);
                "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            END;

            BEGIN
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", Glaccount);
                "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            END;


            //total sum for the G/L account in the g/l entry and payment line
            Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

            //Difference btw the actual gl account and budgeted amount
            GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

            //total sum for the costcenter in the g/l entry and payment line
            Totalamountexceed := PayLineAmount + GlEntryAmount;

            //Difference btw the actual cost center and budgeted amount
            Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

            IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
               ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
              ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                MESSAGE(Text0055, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", Glaccount, Totalamountglaccount);



            //END;


            BEGIN
                //Total sum of the the particular cost center on the payment line
                PurchaseLineBudget2.RESET;
                PurchaseLineBudget2.SETCURRENTKEY("Shortcut Dimension 1 Code", "Document No.");
                PurchaseLineBudget2.SETRANGE("Document No.", PurchaseHeader."No.");
                PurchaseLineBudget2.SETFILTER("Shortcut Dimension 1 Code", dimrec);
                //PurchaseLineBudget2.SETRANGE(Date,StartDate,EndDate);
                PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                PayLineAmount := PurchaseLineBudget2."Amount Including VAT";
            END;


            BEGIN
                //total sum of a particular G/l account on the payment line
                PurchaseLineBudget2.RESET;
                PurchaseLineBudget2.SETCURRENTKEY("Document No.", "Posting Group");
                PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", PurchaseHeader."No.");
                PurchaseLineBudget2.SETFILTER("Posting Group", PurchaseLineBudgetfixedasse."Posting Group");
                PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
            END;

            BEGIN
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.RESET;
                GlEntry.SETRANGE("G/L Account No.", Glaccount);
                GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                GlEntry.CALCSUMS(Amount);
                GlEntryAccountAmount := GlEntry.Amount;
            END;


            BEGIN
                //Total sum of the particular cost center in the g/l entry
                GlEntry.RESET;
                GlEntry.SETFILTER("Global Dimension 2 Code", dimrec);
                GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                GlEntry.CALCSUMS(Amount);
                GlEntryAmount := GlEntry.Amount;
                //MESSAGE(FORMAT(GlEntryAmount));
            END;

            BEGIN
                //Total sum  value of a particular cost center in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code", dimrec);
                "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            END;

            BEGIN
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", Glaccount);
                "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            END;


            //total sum for the G/L account in the g/l entry and payment line
            Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

            //Difference btw the actual gl account and budgeted amount
            GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

            //total sum for the costcenter in the g/l entry and payment line
            Totalamountexceed := PayLineAmount + GlEntryAmount;

            //Difference btw the actual cost center and budgeted amount
            Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

            IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
               ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
              ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                MESSAGE(Text0056, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", Glaccount, Totalamountglaccount);

        END;
    end;


    procedure ActualBudgetClaimpayment(Var StaffClaimsHeader: record "Staff Claims Header")
    var
        dimrec: Code[20];
        i: Integer;
        Dimension2: Record "Dimension Value";
        Dimension3: Record "Dimension Value";
        Dimension: Record "Dimension Value";
        PayLinebudget: Record "Staff Claim Lines";
        GlEntry: Record "G/L Entry";
        "G/LBudgetEntry": Record "G/L Budget Entry";
        Daterec: Date;
        StartDate: Date;
        EndDate: Date;
        PayLineAmount: Decimal;
        GlEntryAmount: Decimal;
        "G/LBudgetEntryAmount": Decimal;
        Totalamountexceed: Decimal;
        StartYear: Date;
        EndYear: Date;
        t: Integer;
        StartDate2: Text;
        EndDate2: Text;
        Totalamount: Decimal;
        PayLinebudget2: Record "Staff Claim Lines";
        GlEntryAccountAmount: Decimal;
        PayLineAmountActual: Decimal;
        "G/LBudgetAccountAmount": Decimal;
        Totalamountglaccount: Decimal;
        GlaccBudgetAmountDiff: Decimal;
        GLAcc: Record "G/L Account";
        Text005: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the Month you cannot proceed';
        Text006: Label 'The   Cost Center budgeted amount is  %1  for %2 and the cost center G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the YEAR you cannot proceed';
    begin
        //i := 0;
        // to pick the number of cos center to itertate
        Daterec := StaffClaimsHeader.Date;
        //dimrec :='';
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);

        //MESSAGE(FORMAT(i));
        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;



        PayLinebudget2.RESET;
        PayLinebudget2.SETCURRENTKEY("Global Dimension 1 Code", No, "Account No:");
        PayLinebudget2.SETRANGE(PayLinebudget2.No, StaffClaimsHeader."No.");
        PayLinebudget2.SETRANGE("Global Dimension 1 Code");
        PayLinebudget2.SETRANGE("Account No:");
        IF PayLinebudget2.FINDFIRST THEN BEGIN

            REPEAT


                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", PayLinebudget2."Account No:");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN

                    Dimension.SETFILTER(Dimension."Dimension Code", '%1', 'DEPARTMENT');
                    Dimension.SETRANGE(Dimension.Code, PayLinebudget2."Global Dimension 1 Code");
                    IF Dimension.FINDFIRST THEN
                        dimrec := PayLinebudget2."Global Dimension 1 Code";
                    // MESSAGE(FORMAT(dimrec[i]));


                    //  MESSAGE(dimrec);





                    //To take care of the monthly budget

                    //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
                    BEGIN
                        //Total sum of the the particular cost center on the payment line
                        PayLinebudget.RESET;
                        PayLinebudget.SETCURRENTKEY("Global Dimension 1 Code", No);
                        PayLinebudget.SETRANGE(PayLinebudget.No, StaffClaimsHeader."No.");
                        PayLinebudget.SETFILTER("Global Dimension 1 Code", dimrec);
                        //PayLinebudget.SETRANGE(Date,StartDate,EndDate);
                        PayLinebudget.CALCSUMS(PayLinebudget.Amount);
                        PayLineAmount := PayLinebudget.Amount;
                    END;


                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        PayLinebudget.RESET;
                        PayLinebudget.SETCURRENTKEY(No, "Account No:");
                        PayLinebudget.SETRANGE(PayLinebudget.No, StaffClaimsHeader."No.");
                        PayLinebudget.SETFILTER("Account No:", PayLinebudget2."Account No:");
                        PayLinebudget.CALCSUMS(PayLinebudget.Amount);
                        PayLineAmountActual := PayLinebudget.Amount;
                    END;

                    BEGIN
                        //Total sum of the particular cost center in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETFILTER("Global Dimension 2 Code", dimrec);
                        GlEntry.SETRANGE("Posting Date", StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAmount := GlEntry.Amount;
                        //MESSAGE(FORMAT(GlEntryAmount));
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", PayLinebudget2."Account No:");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;


                    BEGIN
                        //Total sum  value of a particular cost center in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code", dimrec);
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", PayLinebudget2."Account No:");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                    //total sum for the costcenter in the g/l entry and payment line
                    Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                       ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                      ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                        MESSAGE(Text005, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", PayLinebudget2."Account No:", Totalamountglaccount);

                    //END;

                    //to take care of the yearly budget

                    //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
                    BEGIN
                        //Total sum of the the particular cost center on the payment line
                        PayLinebudget.RESET;
                        PayLinebudget.SETCURRENTKEY("Global Dimension 1 Code", No);
                        PayLinebudget.SETRANGE(PayLinebudget.No, StaffClaimsHeader."No.");
                        PayLinebudget.SETFILTER("Global Dimension 1 Code", dimrec);
                        //PayLinebudget.SETRANGE(Date,StartYear,EndYear);
                        PayLinebudget.CALCSUMS(PayLinebudget.Amount);
                        PayLineAmount := PayLinebudget.Amount;
                    END;

                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        PayLinebudget.RESET;
                        PayLinebudget.SETCURRENTKEY(No, "Account No:");
                        PayLinebudget.SETRANGE(PayLinebudget.No, StaffClaimsHeader."No.");
                        PayLinebudget.SETFILTER("Account No:", PayLinebudget2."Account No:");
                        PayLinebudget.CALCSUMS(PayLinebudget.Amount);
                        PayLineAmountActual := PayLinebudget.Amount;
                    END;

                    BEGIN
                        //Total sum of the particular cost center in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETFILTER("Global Dimension 2 Code", dimrec);
                        GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAmount := GlEntry.Amount;
                        //MESSAGE(FORMAT(GlEntryAmount));
                    END;


                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", PayLinebudget2."Account No:");
                        GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;
                    BEGIN
                        //Total sum  value of a particular cost center in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code", dimrec);
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    BEGIN
                        //Total sum  value of a particular cost center in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code", dimrec);
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", PayLinebudget2."Account No:");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                    //total sum for the costcenter in the g/l entry and payment line
                    Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    //MESSAGE(Text005,"G/LBudgetEntryAmount",dimrec,Totalamountexceed,"G/LBudgetAccountAmount",PayLinebudget2."Account No.",Totalamountglaccount);
                    IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                       ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                      ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                        MESSAGE(Text006, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", PayLinebudget2."Account No:", Totalamountglaccount);
                    //END;
                END;

            UNTIL PayLinebudget2.NEXT = 0;
        END;
    end;

    var
        NextEntryNo: Integer;
        NextEntryNo2: Integer;
        NextTransactionNo: Integer;
        Customer: Record Customer;
}