codeunit 50614 "Budget Approval"
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
        GLSetupRead: Boolean;
        dimrec: Code[20];
        i: Integer;
        Dimension2: Record "Dimension Value";
        Dimension3: Record "Dimension Value";
        GenJournalLineRec: Record "Gen. Journal Line";
        GenJournalLineRecDim: Record "Gen. Journal Line";
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
        PurchaseLineBudget2: Record "Purchase Line";
        PurchaseLineBudget: Record "Purchase Line";
        dimrec2: Code[20];

        PurchHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseLineBudget3: Record "Purchase Line";
        PurchHeaderQty: Record "Purchase Header";
        PurchaseHeader: Record "Purchase Header";
        DocumentNo: Code[20];
        GLAccNo: Code[20];
        FixedAssetNo: Code[20];
        DimensionNo: Code[20];
        Text0057: Label 'The budget for Account  %1 and GL account amount budget is  %2  for  %3  %4 and Glaccount %5 and G/lentry Actual amount is  %6 which exceeds the available monthly limit';
        Text0058: Label 'The  budget for Account %1 and GL account amount budget is  %2  for  %3  %4 and Glaccount %5 and G/lentry Actual  amount is  %6 for the Year you cannot proceed';
        Text0059: Label 'The GL account amount budget is  %1  for   %2 and d GLaccount G/lentry Actual  amount is  %3 for the month you cannot proceed';
        Text0060: Label 'The GL account amount budget is  %1  for   %2 and d GLaccount G/lentry Actual  amount is  %3 for the Year you cannot proceed';
        GenJournalBatch: Record "Gen. Journal Batch";
        ApproveBatch: Code[20];
        DimName: Text;
        DimensionTemporary: Record "Dimension Temporary";
        AccountTemporary: Record "Account Temporary";
        StaffAdvanceLinesBudget2: Record "Staff Advance Lines";
        StaffAdvanceLinesBudget1: Record "Staff Advance Lines";
        StaffAdvanceHeader: Record "Staff Advance Lines";
        AccountRec: Decimal;
        PurchaseLineBudgetDim: Record "Purchase Line";
        PurchHeaderBudget: Record "Purchase Header";
        StaffAdvanceHeaderBudget: record "Staff Advance Header";
        StaffAdvanceLinesRec: Record "Staff Advance Lines";
        ApprovalCode: Code[20];
        BudgetCheck: Boolean;



    procedure ActualBudgetGeJournal(GenJournalLine: Record "Gen. Journal Line")
    begin

        // WITH GenJournalLine DO BEGIN
        Daterec := GenJournalLine."Posting Date";
        //dimrec :='';
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);

        GenJournalBatch.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
        //ApproveBatch :=GenJournalBatch."Approval Code"; gbenga
        //MESSAGE(ApproveBatch);
        //MESSAGE(FORMAT(i));
        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;
        AccountRec := 0;

        DimensionTemporary.DELETEALL;

        GenJournalLineNew.SETRANGE("Document No.", GenJournalLine."Document No.");
        IF GenJournalLineNew.FIND('-') THEN BEGIN
            BatchName := GenJournalLineNew."Journal Batch Name";
            TemplateBatch := GenJournalLineNew."Journal Template Name";
        END;

        GenJournalLineRec.RESET;
        GenJournalLineRec.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Line No.");
        GenJournalLineRec.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
        GenJournalLineRec.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
        IF GenJournalLineRec.FIND('-') THEN BEGIN
            REPEAT
                IF GenJournalLineRec."Shortcut Dimension 1 Code" <> '' THEN BEGIN
                    GenJournalLineRecDim.RESET;
                    GenJournalLineRecDim.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                    GenJournalLineRecDim.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                    GenJournalLineRecDim.SETRANGE("Shortcut Dimension 1 Code", GenJournalLineRec."Shortcut Dimension 1 Code");
                    GenJournalLineRecDim.CALCSUMS(GenJournalLineRecDim."Amount (LCY)");
                    AccountRec := GenJournalLineRecDim."Amount (LCY)";



                    Dimension.RESET;
                    Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                    Dimension.SETRANGE(Code, GenJournalLineRec."Shortcut Dimension 1 Code");
                    Dimension.SETRANGE("Global Dimension No.", 1);
                    IF Dimension.FINDFIRST THEN
                        DimensionTemporary.RESET;
                    DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                    DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                    IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                        DimensionTemporary.INIT;
                        DimensionTemporary."Dimension Code" := Dimension.Code;
                        DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                        DimensionTemporary."Account No." := GenJournalLineRec."Account No.";
                        DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                        DimensionTemporary.Amount := AccountRec;
                        DimensionTemporary.INSERT;
                    END;
                END;

                IF GenJournalLineRec."Shortcut Dimension 2 Code" <> '' THEN BEGIN
                    GenJournalLineRecDim.RESET;
                    GenJournalLineRecDim.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                    GenJournalLineRecDim.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                    GenJournalLineRecDim.SETRANGE("Shortcut Dimension 2 Code", GenJournalLineRec."Shortcut Dimension 2 Code");
                    GenJournalLineRecDim.CALCSUMS(GenJournalLineRecDim."Amount (LCY)");
                    AccountRec := GenJournalLineRecDim."Amount (LCY)";

                    Dimension.RESET;
                    Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                    Dimension.SETRANGE(Code, GenJournalLineRec."Shortcut Dimension 2 Code");
                    Dimension.SETRANGE("Global Dimension No.", 2);
                    IF Dimension.FINDFIRST THEN
                        DimensionTemporary.RESET;
                    DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                    DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                    IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                        DimensionTemporary.INIT;
                        DimensionTemporary."Dimension Code" := Dimension.Code;
                        DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                        DimensionTemporary."Account No." := GenJournalLineRec."Account No.";
                        DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                        DimensionTemporary.Amount := AccountRec;
                        DimensionTemporary.INSERT;
                    END;
                END;

                IF GenJournalLineRec."Shortcut Dimension 3 Code" <> '' THEN BEGIN
                    GenJournalLineRecDim.RESET;
                    GenJournalLineRecDim.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                    GenJournalLineRecDim.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                    GenJournalLineRecDim.SETRANGE("Shortcut Dimension 3 Code", GenJournalLineRec."Shortcut Dimension 3 Code");
                    GenJournalLineRecDim.CALCSUMS(GenJournalLineRecDim."Amount (LCY)");
                    AccountRec := GenJournalLineRecDim."Amount (LCY)";


                    Dimension.RESET;
                    Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                    Dimension.SETRANGE(Code, GenJournalLineRec."Shortcut Dimension 3 Code");
                    Dimension.SETRANGE("Global Dimension No.", 3);
                    IF Dimension.FINDFIRST THEN
                        DimensionTemporary.RESET;
                    DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                    DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                    IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                        DimensionTemporary.INIT;
                        DimensionTemporary."Dimension Code" := Dimension.Code;
                        DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                        DimensionTemporary."Account No." := GenJournalLineRec."Account No.";
                        DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                        DimensionTemporary.Amount := AccountRec;
                        DimensionTemporary.INSERT;
                    END;
                END;

                IF GenJournalLineRec."Shortcut Dimension 4 Code" <> '' THEN BEGIN
                    GenJournalLineRecDim.RESET;
                    GenJournalLineRecDim.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                    GenJournalLineRecDim.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                    GenJournalLineRecDim.SETRANGE("Shortcut Dimension 4 Code", GenJournalLineRec."Shortcut Dimension 4 Code");
                    GenJournalLineRecDim.CALCSUMS(GenJournalLineRecDim."Amount (LCY)");
                    AccountRec := GenJournalLineRecDim."Amount (LCY)";


                    Dimension.RESET;
                    Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                    Dimension.SETRANGE(Code, GenJournalLineRec."Shortcut Dimension 4 Code");
                    Dimension.SETRANGE("Global Dimension No.", 4);
                    IF Dimension.FINDFIRST THEN
                        DimensionTemporary.RESET;
                    DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                    DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                    IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                        DimensionTemporary.INIT;
                        DimensionTemporary."Dimension Code" := Dimension.Code;
                        DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                        DimensionTemporary."Account No." := GenJournalLineRec."Account No.";
                        DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                        DimensionTemporary.Amount := AccountRec;
                        DimensionTemporary.INSERT;
                    END;
                END;

                IF GenJournalLineRec."Shortcut Dimension 5 Code" <> '' THEN BEGIN
                    GenJournalLineRecDim.RESET;
                    GenJournalLineRecDim.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                    GenJournalLineRecDim.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                    GenJournalLineRecDim.SETRANGE("Shortcut Dimension 5 Code", GenJournalLineRec."Shortcut Dimension 5 Code");
                    GenJournalLineRecDim.CALCSUMS(GenJournalLineRecDim."Amount (LCY)");
                    AccountRec := GenJournalLineRecDim."Amount (LCY)";



                    Dimension.RESET;
                    Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                    Dimension.SETRANGE(Code, GenJournalLineRec."Shortcut Dimension 5 Code");
                    Dimension.SETRANGE("Global Dimension No.", 5);
                    IF Dimension.FINDFIRST THEN
                        DimensionTemporary.RESET;
                    DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                    DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                    IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                        DimensionTemporary.INIT;
                        DimensionTemporary."Dimension Code" := Dimension.Code;
                        DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                        DimensionTemporary."Account No." := GenJournalLineRec."Account No.";
                        DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                        DimensionTemporary.Amount := AccountRec;
                        DimensionTemporary.INSERT;
                    END;
                END;

                IF GenJournalLineRec."Shortcut Dimension 6 Code" <> '' THEN BEGIN
                    GenJournalLineRecDim.RESET;
                    GenJournalLineRecDim.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                    GenJournalLineRecDim.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                    GenJournalLineRecDim.SETRANGE("Shortcut Dimension 6 Code", GenJournalLineRec."Shortcut Dimension 6 Code");
                    GenJournalLineRecDim.CALCSUMS(GenJournalLineRecDim."Amount (LCY)");
                    AccountRec := GenJournalLineRecDim."Amount (LCY)";



                    Dimension.RESET;
                    Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                    Dimension.SETRANGE(Code, GenJournalLineRec."Shortcut Dimension 6 Code");
                    Dimension.SETRANGE("Global Dimension No.", 6);
                    IF Dimension.FINDFIRST THEN
                        DimensionTemporary.RESET;
                    DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                    DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                    IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                        DimensionTemporary.INIT;
                        DimensionTemporary."Dimension Code" := Dimension.Code;
                        DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                        DimensionTemporary."Account No." := GenJournalLineRec."Account No.";
                        DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                        DimensionTemporary.Amount := AccountRec;
                        DimensionTemporary.INSERT;
                    END;
                END;

                IF GenJournalLineRec."Shortcut Dimension 7 Code" <> '' THEN BEGIN
                    GenJournalLineRecDim.RESET;
                    GenJournalLineRecDim.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                    GenJournalLineRecDim.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                    GenJournalLineRecDim.SETRANGE("Shortcut Dimension 7 Code", GenJournalLineRec."Shortcut Dimension 7 Code");
                    GenJournalLineRecDim.CALCSUMS(GenJournalLineRecDim."Amount (LCY)");
                    AccountRec := GenJournalLineRecDim."Amount (LCY)";



                    Dimension.RESET;
                    Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                    Dimension.SETRANGE(Code, GenJournalLineRec."Shortcut Dimension 7 Code");
                    Dimension.SETRANGE("Global Dimension No.", 7);
                    IF Dimension.FINDFIRST THEN
                        DimensionTemporary.RESET;
                    DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                    DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                    IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                        DimensionTemporary.INIT;
                        DimensionTemporary."Dimension Code" := Dimension.Code;
                        DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                        DimensionTemporary."Account No." := GenJournalLineRec."Account No.";
                        DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                        DimensionTemporary.Amount := AccountRec;
                        DimensionTemporary.INSERT;
                    END;
                END;


                IF GenJournalLineRec."Shortcut Dimension 8 Code" <> '' THEN BEGIN
                    GenJournalLineRecDim.RESET;
                    GenJournalLineRecDim.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                    GenJournalLineRecDim.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                    GenJournalLineRecDim.SETRANGE("Shortcut Dimension 8 Code", GenJournalLineRec."Shortcut Dimension 8 Code");
                    GenJournalLineRecDim.CALCSUMS(GenJournalLineRecDim."Amount (LCY)");
                    AccountRec := GenJournalLineRecDim."Amount (LCY)";



                    Dimension.RESET;
                    Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                    Dimension.SETRANGE(Code, GenJournalLineRec."Shortcut Dimension 8 Code");
                    Dimension.SETRANGE("Global Dimension No.", 8);
                    IF Dimension.FINDFIRST THEN
                        DimensionTemporary.RESET;
                    DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                    DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                    IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                        DimensionTemporary.INIT;
                        DimensionTemporary."Dimension Code" := Dimension.Code;
                        DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                        DimensionTemporary."Account No." := GenJournalLineRec."Account No.";
                        DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                        DimensionTemporary.Amount := AccountRec;
                        DimensionTemporary.INSERT;
                    END;
                END;


                IF GenJournalLineRec."Account No." <> '' THEN BEGIN
                    GenJournalLineRecDim.RESET;
                    GenJournalLineRecDim.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                    GenJournalLineRecDim.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                    GenJournalLineRecDim.SETRANGE("Account No.", GenJournalLineRec."Account No.");
                    GenJournalLineRecDim.CALCSUMS(GenJournalLineRecDim."Amount (LCY)");
                    AccountRec := GenJournalLineRecDim."Amount (LCY)";


                    AccountTemporary.RESET;
                    AccountTemporary.SETRANGE("Account No.", GenJournalLineRec."Account No.");
                    IF NOT AccountTemporary.FINDFIRST THEN BEGIN
                        AccountTemporary.INIT;
                        AccountTemporary."Account No." := GenJournalLineRec."Account No.";
                        AccountTemporary.Amount := AccountRec;
                        AccountTemporary.INSERT;
                    END;
                END;

            UNTIL GenJournalLineRec.NEXT = 0;
        END;

        AccountTemporary.RESET;
        AccountTemporary.SETRANGE("Account No.");
        IF AccountTemporary.FINDFIRST THEN
            REPEAT
                //IF (GenJournalLineRec."Account Type" = GenJournalLineRec."Account Type"::"Fixed Asset") AND ((GenJournalLineRec."FA Posting Type" = GenJournalLineRec."FA Posting Type"::"Acquisition Cost") OR
                //           (GenJournalLineRec."FA Posting Type" = GenJournalLineRec."FA Posting Type"::Appreciation))   THEN
                //ActualBudgetMothYearFixedasset(GenJournalLineRec)
                //ELSE
                //BEGIN


                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", AccountTemporary."Account No.");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN


                    //To take care of the monthly budget



                    BEGIN
                        //total sum of a particular G/l account on the payment line

                        PayLineAmountActual := AccountTemporary.Amount;
                    END;



                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", AccountTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;




                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", AccountTemporary."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;


                    // IF  ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (ApproveBatch <>'') THEN
                    // MESSAGE(Text0059,"G/LBudgetAccountAmount",AccountTemporary."Account No.",Totalamountglaccount)
                    //ELSE
                    IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                        MESSAGE(Text0059, "G/LBudgetAccountAmount", AccountTemporary."Account No.", Totalamountglaccount);
                    //ELSE
                    //END;

                    //to take care of the yearly budget



                    BEGIN
                        //total sum of a particular G/l account on the payment line

                        PayLineAmountActual := AccountTemporary.Amount;
                    END;



                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", AccountTemporary."Account No.");
                        GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;



                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", AccountTemporary."Account No.");
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
                    //Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;


                    //    IF  ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (ApproveBatch <>'') THEN
                    //   MESSAGE(Text0059,"G/LBudgetAccountAmount",AccountTemporary."Account No.",Totalamountglaccount)
                    // ELSE
                    IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                        MESSAGE(Text0060, "G/LBudgetAccountAmount", AccountTemporary."Account No.", Totalamountglaccount);

                    //MESSAGE(Text0056,"G/LBudgetEntryAmount",dimrec2,Totalamountexceed,"G/LBudgetAccountAmount",GenJournalLineRec."Account No.",Totalamountglaccount);
                    //END;
                END;
            UNTIL AccountTemporary.NEXT = 0;

        AccountTemporary.DELETEALL;
        DimensionTemporaryLine(StartDate, EndDate, StartYear, EndYear, BudgetCheck);
        DimensionTemporary.DELETEALL;

    end;

    procedure ActualBudgetMothYearFixedasset(var GenjournaBudgetfixedasse: Record "Gen. Journal Line")
    begin
        if FixedAsset.Get(GenjournaBudgetfixedasse."Account No.") then
            fixsedassetcode := FixedAsset."FA Posting Group";
        if FAPostingGroup.Get(fixsedassetcode) then
            Glaccount := FAPostingGroup."Acquisition Cost Account";

        GLAcc.Reset;
        GLAcc.SetRange(GLAcc."No.", Glaccount);
        GLAcc.SetRange(GLAcc."Budget Controlled", true);
        if GLAcc.FindFirst then begin

            Dimension.SetFilter(Dimension."Dimension Code", '%1', 'COST CENTER');
            Dimension.SetRange(Dimension.Code, GenjournaBudgetfixedasse."Shortcut Dimension 2 Code");
            if Dimension.FindFirst then
                dimrec2 := GenjournaBudgetfixedasse."Shortcut Dimension 2 Code";





            begin
                //Total sum of the the particular cost center on the payment line
                GenJournalLine3.Reset;
                GenJournalLine3.SetCurrentKey("Shortcut Dimension 2 Code", "Journal Batch Name", "Journal Template Name");
                GenJournalLine3.SetRange("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SetFilter("Shortcut Dimension 2 Code", dimrec2);
                GenJournalLine3.SetRange("Journal Template Name", GenjournaBudgetfixedasse."Journal Template Name");
                //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
                GenJournalLine3.CalcSums(GenJournalLine3.Amount);
                PayLineAmount := GenJournalLine3.Amount;
            end;

            begin
                //total sum of a particular G/l account on the payment line for group of fixed asset
                GenJournalLine3.Reset;
                GenJournalLine3.SetCurrentKey("Journal Batch Name", "Journal Template Name", "Posting Group");
                GenJournalLine3.SetRange("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SetRange("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SetFilter("Posting Group", GenjournaBudgetfixedasse."Posting Group");
                GenJournalLine3.CalcSums(GenJournalLine3.Amount);
                PayLineAmountActual := GenJournalLine3.Amount;
            end;

            begin
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.Reset;
                GlEntry.SetRange("G/L Account No.", Glaccount);
                GlEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                GlEntry.CalcSums(Amount);
                GlEntryAccountAmount := GlEntry.Amount;
            end;


            begin
                //Total sum of the particular cost center in the g/l entry
                GlEntry.Reset;
                GlEntry.SetFilter("Global Dimension 2 Code", dimrec2);
                GlEntry.SetRange("Posting Date", StartDate, EndDate);
                GlEntry.CalcSums(Amount);
                GlEntryAmount := GlEntry.Amount;
                //MESSAGE(FORMAT(GlEntryAmount));
            end;

            begin
                //Total sum  value of a particular cost center in the budget entry
                "G/LBudgetEntry".Reset;
                "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 2 Code", dimrec2);
                "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
                "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            end;

            begin
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".Reset;
                "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", Glaccount);
                "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
                "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            end;


            //total sum for the G/L account in the g/l entry and payment line
            Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

            //Difference btw the actual gl account and budgeted amount
            GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

            //total sum for the costcenter in the g/l entry and payment line
            Totalamountexceed := PayLineAmount + GlEntryAmount;

            //Difference btw the actual cost center and budgeted amount
            Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

            if ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
               ((Totalamountexceed < "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
              ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) then
                Message(Text0055, "G/LBudgetEntryAmount", dimrec2, Totalamountexceed, "G/LBudgetAccountAmount", Glaccount, Totalamountglaccount);



            //END;


            begin
                //Total sum of the the particular cost center on the journal line line
                GenJournalLine3.Reset;
                GenJournalLine3.SetCurrentKey("Shortcut Dimension 2 Code", "Journal Batch Name", "Journal Template Name");
                GenJournalLine3.SetRange("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SetFilter("Shortcut Dimension 2 Code", dimrec2);
                GenJournalLine3.SetRange("Journal Template Name", GenjournaBudgetfixedasse."Journal Template Name");
                //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
                GenJournalLine3.CalcSums(GenJournalLine3.Amount);
                PayLineAmount := GenJournalLine3.Amount;
            end;

            begin
                //total sum of a particular G/l account on the journal line line for group of fixed asset
                GenJournalLine3.Reset;
                GenJournalLine3.SetCurrentKey("Journal Batch Name", "Journal Template Name", "Posting Group");
                GenJournalLine3.SetRange("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SetRange("Journal Batch Name", GenjournaBudgetfixedasse."Journal Batch Name");
                GenJournalLine3.SetFilter("Posting Group", GenjournaBudgetfixedasse."Posting Group");
                GenJournalLine3.CalcSums(GenJournalLine3.Amount);
                PayLineAmountActual := GenJournalLine3.Amount;
            end;

            begin
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.Reset;
                GlEntry.SetRange("G/L Account No.", Glaccount);
                GlEntry.SetFilter("Posting Date", '%1..%2', StartYear, EndYear);
                GlEntry.CalcSums(Amount);
                GlEntryAccountAmount := GlEntry.Amount;
            end;


            begin
                //Total sum of the particular cost center in the g/l entry
                GlEntry.Reset;
                GlEntry.SetFilter("Global Dimension 2 Code", dimrec2);
                GlEntry.SetRange("Posting Date", StartYear, EndYear);
                GlEntry.CalcSums(Amount);
                GlEntryAmount := GlEntry.Amount;
                //MESSAGE(FORMAT(GlEntryAmount));
            end;

            begin
                //Total sum  value of a particular cost center in the budget entry
                "G/LBudgetEntry".Reset;
                "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 2 Code", dimrec2);
                "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
                "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            end;

            begin
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".Reset;
                "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", Glaccount);
                "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
                "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            end;


            //total sum for the G/L account in the g/l entry and payment line
            Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

            //Difference btw the actual gl account and budgeted amount
            GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

            //total sum for the costcenter in the g/l entry and payment line
            Totalamountexceed := PayLineAmount + GlEntryAmount;

            //Difference btw the actual cost center and budgeted amount
            Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

            if ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
               ((Totalamountexceed < "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
              ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) then
                Message(Text0056, "G/LBudgetEntryAmount", dimrec2, Totalamountexceed, "G/LBudgetAccountAmount", Glaccount, Totalamountglaccount);

        end;

        //end;
    end;

    procedure ActualBudgetMothYear(PurchaseHeader: Record "Purchase Header")
    begin

        IF PurchaseHeader."Posting Date" <> 0D THEN
            Daterec := PurchaseHeader."Posting Date"
        ELSE
            Daterec := PurchaseHeader."Order Date";

        //PurchHeader.SETRANGE("No.",PurchaseHeader."No.");
        //IF PurchHeader.FINDFIRST THEN
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
        AccountRec := 0;
        ApprovalCode := PurchaseHeader.ApprovalCode;
        BudgetCheck:= PurchaseHeader."Budget Check";



        DimensionTemporary.DELETEALL;

        ////start
        PurchHeaderBudget.SetRange("No.", PurchHeader."No.");
        if PurchHeaderBudget.FindFirst() then begin


            PurchaseLineBudget.RESET;
            PurchaseLineBudget.SETCURRENTKEY("Shortcut Dimension 3 Code", "Document No.", "No.");
            PurchaseLineBudget.SETRANGE("Document No.", PurchHeaderBudget."No.");
            IF PurchaseLineBudget.FINDFIRST THEN BEGIN

                REPEAT
                    IF PurchaseLineBudget."Shortcut Dimension 3 Code" <> '' THEN BEGIN

                        PurchaseLineBudgetDim.RESET;
                        PurchaseLineBudgetDim.SETRANGE("Document No.", PurchaseLineBudget."Document No.");
                        PurchaseLineBudgetDim.SETRANGE("Shortcut Dimension 3 Code", PurchaseLineBudget."Shortcut Dimension 3 Code");
                        PurchaseLineBudgetDim.CALCSUMS(PurchaseLineBudgetDim."Amount Including VAT");
                        AccountRec := PurchaseLineBudgetDim."Amount Including VAT";



                        Dimension.RESET;
                        Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                        Dimension.SETRANGE(Code, PurchaseLineBudget."Shortcut Dimension 3 Code");
                        Dimension.SETRANGE("Global Dimension No.", 3);
                        IF Dimension.FINDFIRST THEN
                            DimensionTemporary.RESET;
                        DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                        DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                        IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                            DimensionTemporary.INIT;
                            DimensionTemporary."Dimension Code" := Dimension.Code;
                            DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                            DimensionTemporary."Account No." := PurchaseLineBudget."No.";
                            DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                            DimensionTemporary.Amount := AccountRec;
                            DimensionTemporary.INSERT;
                        END;
                    END;
                    //To IF PurchaseLineBudget."Shortcut Dimension 2 Code" <> '' THEN BEGIN

                    //     PurchaseLineBudgetDim.RESET;
                    //     PurchaseLineBudgetDim.SETRANGE("Document No.", PurchaseLineBudget."Document No.");
                    //     PurchaseLineBudgetDim.SETRANGE("Shortcut Dimension 2 Code", PurchaseLineBudget."Shortcut Dimension 2 Code");
                    //     PurchaseLineBudgetDim.CALCSUMS(PurchaseLineBudgetDim."Amount Including VAT");
                    //     AccountRec := PurchaseLineBudgetDim."Amount Including VAT";

                    //     Dimension.RESET;
                    //     Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                    //     Dimension.SETRANGE(Code, PurchaseLineBudget."Shortcut Dimension 2 Code");
                    //     Dimension.SETRANGE("Global Dimension No.", 2);
                    //     IF Dimension.FINDFIRST THEN
                    //         DimensionTemporary.RESET;
                    //     DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                    //     DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                    //     IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                    //         DimensionTemporary.INIT;
                    //         DimensionTemporary."Dimension Code" := Dimension.Code;
                    //         DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                    //         DimensionTemporary."Account No." := PurchaseLineBudget."No.";
                    //         DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                    //         DimensionTemporary.Amount := AccountRec;
                    //         DimensionTemporary.INSERT;
                    //     END;
                    //to END;


                    /*        IF PurchaseLineBudget."Shortcut Dimension 3 Code" <> '' THEN BEGIN

                        PurchaseLineBudgetDim.RESET;
                        PurchaseLineBudgetDim.SETRANGE("Document No.",PurchaseLineBudget."Document No.");
                        PurchaseLineBudgetDim.SETRANGE("Shortcut Dimension 3 Code",PurchaseLineBudget."Shortcut Dimension 3 Code");
                        PurchaseLineBudgetDim.CALCSUMS(PurchaseLineBudgetDim."Amount Including VAT");
                        AccountRec := PurchaseLineBudgetDim."Amount Including VAT";

                        Dimension.RESET;
                        Dimension.SETCURRENTKEY(Code,"Global Dimension No.");
                        Dimension.SETRANGE(Code,PurchaseLineBudget."Shortcut Dimension 3 Code");
                        Dimension.SETRANGE("Global Dimension No.",3);
                        IF Dimension.FINDFIRST THEN
                          DimensionTemporary.RESET;
                          DimensionTemporary.SETRANGE("Dimension Code",Dimension.Code);
                          DimensionTemporary.SETRANGE("Dimension name",Dimension."Dimension Code");
                          IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                              DimensionTemporary.INIT;
                              DimensionTemporary."Dimension Code" := Dimension.Code;
                              DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                              DimensionTemporary."Account No." := PurchaseLineBudget."No.";
                              DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                              DimensionTemporary.Amount :=   AccountRec;
                              DimensionTemporary.INSERT;
                           END;
                             END;

                               IF PurchaseLineBudget."Shortcut Dimension 4 Code" <> '' THEN BEGIN

                        PurchaseLineBudgetDim.RESET;
                        PurchaseLineBudgetDim.SETRANGE("Document No.",PurchaseLineBudget."Document No.");
                        PurchaseLineBudgetDim.SETRANGE("Shortcut Dimension 4 Code",PurchaseLineBudget."Shortcut Dimension 4 Code");
                        PurchaseLineBudgetDim.CALCSUMS(PurchaseLineBudgetDim."Amount Including VAT");
                        AccountRec := PurchaseLineBudgetDim."Amount Including VAT";

                        Dimension.RESET;
                        Dimension.SETCURRENTKEY(Code,"Global Dimension No.");
                        Dimension.SETRANGE(Code,PurchaseLineBudget."Shortcut Dimension 4 Code");
                        Dimension.SETRANGE("Global Dimension No.",4);
                        IF Dimension.FINDFIRST THEN
                          DimensionTemporary.RESET;
                          DimensionTemporary.SETRANGE("Dimension Code",Dimension.Code);
                          DimensionTemporary.SETRANGE("Dimension name",Dimension."Dimension Code");
                          IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                              DimensionTemporary.INIT;
                              DimensionTemporary."Dimension Code" := Dimension.Code;
                              DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                              DimensionTemporary."Account No." := PurchaseLineBudget."No.";
                              DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                              DimensionTemporary.Amount :=   AccountRec;
                              DimensionTemporary.INSERT;
                           END;
                             END;

                                  IF PurchaseLineBudget."Shortcut Dimension 5 Code" <> '' THEN BEGIN

                        PurchaseLineBudgetDim.RESET;
                        PurchaseLineBudgetDim.SETRANGE("Document No.",PurchaseLineBudget."Document No.");
                        PurchaseLineBudgetDim.SETRANGE("Shortcut Dimension 5 Code",PurchaseLineBudget."Shortcut Dimension 5 Code");
                        PurchaseLineBudgetDim.CALCSUMS(PurchaseLineBudgetDim."Amount Including VAT");
                        AccountRec := PurchaseLineBudgetDim."Amount Including VAT";

                        Dimension.RESET;
                        Dimension.SETCURRENTKEY(Code,"Global Dimension No.");
                        Dimension.SETRANGE(Code,PurchaseLineBudget."Shortcut Dimension 5 Code");
                        Dimension.SETRANGE("Global Dimension No.",5);
                        IF Dimension.FINDFIRST THEN
                          DimensionTemporary.RESET;
                          DimensionTemporary.SETRANGE("Dimension Code",Dimension.Code);
                          DimensionTemporary.SETRANGE("Dimension name",Dimension."Dimension Code");
                          IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                              DimensionTemporary.INIT;
                              DimensionTemporary."Dimension Code" := Dimension.Code;
                              DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                              DimensionTemporary."Account No." := PurchaseLineBudget."No.";
                              DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                              DimensionTemporary.Amount :=   AccountRec;
                              DimensionTemporary.INSERT;
                           END;
                             END;

                                    IF PurchaseLineBudget."Shortcut Dimension 6 Code" <> '' THEN BEGIN

                        PurchaseLineBudgetDim.RESET;
                        PurchaseLineBudgetDim.SETRANGE("Document No.",PurchaseLineBudget."Document No.");
                        PurchaseLineBudgetDim.SETRANGE("Shortcut Dimension 6 Code",PurchaseLineBudget."Shortcut Dimension 6 Code");
                        PurchaseLineBudgetDim.CALCSUMS(PurchaseLineBudgetDim."Amount Including VAT");
                        AccountRec := PurchaseLineBudgetDim."Amount Including VAT";

                        Dimension.RESET;
                        Dimension.SETCURRENTKEY(Code,"Global Dimension No.");
                        Dimension.SETRANGE(Code,PurchaseLineBudget."Shortcut Dimension 6 Code");
                        Dimension.SETRANGE("Global Dimension No.",6);
                        IF Dimension.FINDFIRST THEN
                          DimensionTemporary.RESET;
                          DimensionTemporary.SETRANGE("Dimension Code",Dimension.Code);
                          DimensionTemporary.SETRANGE("Dimension name",Dimension."Dimension Code");
                          IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                              DimensionTemporary.INIT;
                              DimensionTemporary."Dimension Code" := Dimension.Code;
                              DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                              DimensionTemporary."Account No." := PurchaseLineBudget."No.";
                              DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                              DimensionTemporary.Amount :=   AccountRec;
                              DimensionTemporary.INSERT;
                           END;
                             END;

                                          IF PurchaseLineBudget."Shortcut Dimension 7 Code" <> '' THEN BEGIN

                        PurchaseLineBudgetDim.RESET;
                        PurchaseLineBudgetDim.SETRANGE("Document No.",PurchaseLineBudget."Document No.");
                        PurchaseLineBudgetDim.SETRANGE("Shortcut Dimension 7 Code",PurchaseLineBudget."Shortcut Dimension 7 Code");
                        PurchaseLineBudgetDim.CALCSUMS(PurchaseLineBudgetDim."Amount Including VAT");
                        AccountRec := PurchaseLineBudgetDim."Amount Including VAT";

                        Dimension.RESET;
                        Dimension.SETCURRENTKEY(Code,"Global Dimension No.");
                        Dimension.SETRANGE(Code,PurchaseLineBudget."Shortcut Dimension 7 Code");
                        Dimension.SETRANGE("Global Dimension No.",7);
                        IF Dimension.FINDFIRST THEN
                          DimensionTemporary.RESET;
                          DimensionTemporary.SETRANGE("Dimension Code",Dimension.Code);
                          DimensionTemporary.SETRANGE("Dimension name",Dimension."Dimension Code");
                          IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                              DimensionTemporary.INIT;
                              DimensionTemporary."Dimension Code" := Dimension.Code;
                              DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                              DimensionTemporary."Account No." := PurchaseLineBudget."No.";
                              DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                              DimensionTemporary.Amount :=   AccountRec;
                              DimensionTemporary.INSERT;
                           END;
                             END;

                       IF PurchaseLineBudget."Shortcut Dimension 8 Code" <> '' THEN BEGIN

                        PurchaseLineBudgetDim.RESET;
                        PurchaseLineBudgetDim.SETRANGE("Document No.",PurchaseLineBudget."Document No.");
                        PurchaseLineBudgetDim.SETRANGE("Shortcut Dimension 8 Code",PurchaseLineBudget."Shortcut Dimension 8 Code");
                        PurchaseLineBudgetDim.CALCSUMS(PurchaseLineBudgetDim."Amount Including VAT");
                        AccountRec := PurchaseLineBudgetDim."Amount Including VAT";

                        Dimension.RESET;
                        Dimension.SETCURRENTKEY(Code,"Global Dimension No.");
                        Dimension.SETRANGE(Code,PurchaseLineBudget."Shortcut Dimension 8 Code");
                        Dimension.SETRANGE("Global Dimension No.",8);
                        IF Dimension.FINDFIRST THEN
                          DimensionTemporary.RESET;
                          DimensionTemporary.SETRANGE("Dimension Code",Dimension.Code);
                          DimensionTemporary.SETRANGE("Dimension name",Dimension."Dimension Code");
                          IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                              DimensionTemporary.INIT;
                              DimensionTemporary."Dimension Code" := Dimension.Code;
                              DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                              DimensionTemporary."Account No." := PurchaseLineBudget."No.";
                              DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                              DimensionTemporary.Amount :=   AccountRec;
                              DimensionTemporary.INSERT;
                           END;
                             END;

           */
                    IF PurchaseLineBudget."No." <> '' THEN BEGIN
                        PurchaseLineBudgetDim.RESET;
                        PurchaseLineBudgetDim.SETRANGE("No.", PurchaseLineBudget."No.");
                        PurchaseLineBudgetDim.SETRANGE("Document No.", PurchaseLineBudget."Document No.");
                        PurchaseLineBudgetDim.CALCSUMS("Amount Including VAT");
                        AccountRec := PurchaseLineBudgetDim."Amount Including VAT";



                        AccountTemporary.RESET;
                        AccountTemporary.SETRANGE("Account No.", PurchaseLineBudget."No.");
                        IF NOT AccountTemporary.FINDFIRST THEN BEGIN
                            AccountTemporary.INIT;
                            AccountTemporary."Account No." := PurchaseLineBudget."No.";
                            AccountTemporary.Amount := AccountRec;
                            AccountTemporary.INSERT;
                        END;
                    END;
                UNTIL PurchaseLineBudget.NEXT = 0;

            END;
        END;
        /////end

        // DimensionTemporaryLine(StartDate,EndDate,StartYear,EndYear);


        AccountTemporary.RESET;
        AccountTemporary.SETRANGE("Account No.");
        IF AccountTemporary.FINDFIRST THEN
            REPEAT







                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", AccountTemporary."Account No.");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN




                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        //                            PurchaseLineBudget2.RESET;
                        //                            PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                        //                            PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", PurchaseHeader."No.");
                        //                            //PurchaseLineBudget2.SETFILTER("Shortcut Dimension 1 Code", dimrec)
                        //                            PurchaseLineBudget2.SETFILTER("No.", AccountTemporary."Account No.");
                        //                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                        PayLineAmountActual := AccountTemporary.Amount;
                        //   MESSAGE(FORMAT(PayLineAmountActual));
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", AccountTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);

                        GlEntryAccountAmount := GlEntry.Amount;
                    END;



                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", AccountTemporary."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        // MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                    //total sum for the costcenter in the g/l entry and payment line
                    //     Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    //    Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    ////   IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    //     ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    //   ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                    //     MESSAGE(Text0055, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", PurchaseLineBudget."No.", Totalamountglaccount);

                    //  IF ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN
                    //     MESSAGE(Text0059, "G/LBudgetAccountAmount", AccountTemporary."Account No.", Totalamountglaccount);
                    //    ELSE
                    // IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                    // ERROR(Text0059,"G/LBudgetAccountAmount",AccountTemporary."Account No.",Totalamountglaccount);






                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        //                            PurchaseLineBudget2.RESET;
                        //                            PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                        //                            PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", PurchaseHeader."No.");
                        //                            PurchaseLineBudget2.SETFILTER("No.", AccountTemporary."Account No.");
                        //                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                        PayLineAmountActual := AccountTemporary.Amount;
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", AccountTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;



                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", AccountTemporary."Account No.");
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
                    //  Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    //   Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    //   IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    //      ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    //    ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                    //      MESSAGE(Text0056, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", PurchaseLineBudget."No.", Totalamountglaccount);
                    //    IF  ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN

                    //       MESSAGE(Text0060,"G/LBudgetAccountAmount",AccountTemporary."Account No.",Totalamountglaccount);
                    //                       ELSE
                    IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                        MESSAGE(Text0059, "G/LBudgetAccountAmount", AccountTemporary."Account No.", Totalamountglaccount);



                END
            //END;
            UNTIL AccountTemporary.NEXT = 0;

        //END
        //ELSE
        //AccountTemporary.DELETEALL;

        DimensionTemporaryLine(StartDate, EndDate, StartYear, EndYear, BudgetCheck);

        DimensionTemporary.DELETEALL;
        AccountTemporary.DELETEALL;



    END;
    //end;


    procedure ActualBudgetMothYearFixedassPurchase(PurchaseHeader: Record "Purchase Header"; var PurchaseLineBudgetfixedasse: Record "Purchase Line")
    begin


        IF PurchaseHeader."Posting Date" = 0D THEN
            Daterec := PurchaseHeader."Order Date"
        else
            Daterec := PurchaseHeader."Posting Date";
        //dimrec :='';
        StartDate := CalcDate('<-CM>', Daterec);
        EndDate := CalcDate('<CM>', Daterec);
        StartYear := CalcDate('<-CY>', Daterec);
        EndYear := CalcDate('<CY>', Daterec);

        // MESSAGE(FORMAT(Daterec));

        //MESSAGE(FORMAT(i));
        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;


        if FixedAsset.Get(PurchaseLineBudgetfixedasse."No.") then
            fixsedassetcode := FixedAsset."FA Posting Group";
        if FAPostingGroup.Get(fixsedassetcode) then
            Glaccount := FAPostingGroup."Acquisition Cost Account";

        GLAcc.Reset;
        GLAcc.SetRange(GLAcc."No.", Glaccount);
        GLAcc.SetRange(GLAcc."Budget Controlled", true);
        if GLAcc.FindFirst then begin

            //to  Dimension.SetFilter(Dimension."Dimension Code", '%1', 'COST CENTER');
            Dimension.SetRange(Dimension.Code, PurchaseLineBudgetfixedasse."Shortcut Dimension 3 Code");
            if Dimension.FindFirst then
                dimrec2 := PurchaseLineBudgetfixedasse."Shortcut Dimension 3 Code";





            begin
                //Total sum of the the particular cost center on the payment line
                PurchaseLineBudget3.Reset;
                PurchaseLineBudget3.SetCurrentKey("Shortcut Dimension 3 Code", "Document No.");
                PurchaseLineBudget3.SetRange("Document No.", PurchaseHeader."No.");
                PurchaseLineBudget3.SetFilter("Shortcut Dimension 3 Code", dimrec2);
                //PurchaseLineBudget2.SETRANGE(Date,StartDate,EndDate);
                PurchaseLineBudget3.CalcSums(PurchaseLineBudget3."Amount Including VAT");
                PayLineAmount := PurchaseLineBudget3."Amount Including VAT";
            end;


            begin
                //total sum of a particular G/l account on the payment line
                PurchaseLineBudget3.Reset;
                PurchaseLineBudget3.SetCurrentKey("Document No.", "Posting Group");
                PurchaseLineBudget3.SetRange(PurchaseLineBudget3."Document No.", PurchaseHeader."No.");
                PurchaseLineBudget3.SetFilter("Posting Group", PurchaseLineBudgetfixedasse."Posting Group");
                PurchaseLineBudget3.CalcSums(PurchaseLineBudget3."Amount Including VAT");
                PayLineAmountActual := PurchaseLineBudget3."Amount Including VAT";
            end;

            begin
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.Reset;
                GlEntry.SetRange("G/L Account No.", Glaccount);
                GlEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                GlEntry.CalcSums(Amount);
                GlEntryAccountAmount := GlEntry.Amount;
            end;


            begin
                //Total sum of the particular cost center in the g/l entry
                GlEntry.Reset;
                GlEntry.SetFilter("Shortcut Dimension 3 Code", dimrec2);
                GlEntry.SetRange("Posting Date", StartDate, EndDate);
                GlEntry.CalcSums(Amount);
                GlEntryAmount := GlEntry.Amount;
                //MESSAGE(FORMAT(GlEntryAmount));
            end;

            begin
                //Total sum  value of a particular cost center in the budget entry
                "G/LBudgetEntry".Reset;
                "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Budget Dimension 1 Code", dimrec2);
                "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
                "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            end;

            begin
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".Reset;
                "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", Glaccount);
                "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
                "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            end;


            //total sum for the G/L account in the g/l entry and payment line
            Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

            //Difference btw the actual gl account and budgeted amount
            GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

            //total sum for the costcenter in the g/l entry and payment line
            Totalamountexceed := PayLineAmount + GlEntryAmount;

            //Difference btw the actual cost center and budgeted amount
            Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

            if ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
               ((Totalamountexceed < "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
              ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) then
                Message(Text0055, "G/LBudgetEntryAmount", dimrec2, Totalamountexceed, "G/LBudgetAccountAmount", Glaccount, Totalamountglaccount);



            //END;


            begin
                //Total sum of the the particular cost center on the payment line
                PurchaseLineBudget3.Reset;
                PurchaseLineBudget3.SetCurrentKey("Shortcut Dimension 3 Code", "Document No.");
                PurchaseLineBudget3.SetRange("Document No.", PurchaseHeader."No.");
                PurchaseLineBudget3.SetFilter("Shortcut Dimension 3 Code", dimrec2);
                //PurchaseLineBudget2.SETRANGE(Date,StartDate,EndDate);
                PurchaseLineBudget3.CalcSums(PurchaseLineBudget3."Amount Including VAT");
                PayLineAmount := PurchaseLineBudget3."Amount Including VAT";
            end;


            begin
                //total sum of a particular G/l account on the payment line
                PurchaseLineBudget3.Reset;
                PurchaseLineBudget3.SetCurrentKey("Document No.", "Posting Group");
                PurchaseLineBudget3.SetRange(PurchaseLineBudget3."Document No.", PurchaseHeader."No.");
                PurchaseLineBudget3.SetFilter("Posting Group", PurchaseLineBudgetfixedasse."Posting Group");
                PurchaseLineBudget3.CalcSums(PurchaseLineBudget3."Amount Including VAT");
                PayLineAmountActual := PurchaseLineBudget3."Amount Including VAT";
            end;

            begin
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.Reset;
                GlEntry.SetRange("G/L Account No.", Glaccount);
                GlEntry.SetFilter("Posting Date", '%1..%2', StartYear, EndYear);
                GlEntry.CalcSums(Amount);
                GlEntryAccountAmount := GlEntry.Amount;
            end;


            begin
                //Total sum of the particular cost center in the g/l entry
                GlEntry.Reset;
                GlEntry.SetFilter("Shortcut Dimension 3 Code", dimrec2);
                GlEntry.SetRange("Posting Date", StartYear, EndYear);
                GlEntry.CalcSums(Amount);
                GlEntryAmount := GlEntry.Amount;
                //MESSAGE(FORMAT(GlEntryAmount));
            end;

            begin
                //Total sum  value of a particular cost center in the budget entry
                "G/LBudgetEntry".Reset;
                "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Budget Dimension 1 Code", dimrec2);
                "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
                "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            end;

            begin
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".Reset;
                "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", Glaccount);
                "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
                "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            end;


            //total sum for the G/L account in the g/l entry and payment line
            Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

            //Difference btw the actual gl account and budgeted amount
            GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

            //total sum for the costcenter in the g/l entry and payment line
            Totalamountexceed := PayLineAmount + GlEntryAmount;

            //Difference btw the actual cost center and budgeted amount
            Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

            if ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
               ((Totalamountexceed < "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
              ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) then
                Message(Text0056, "G/LBudgetEntryAmount", dimrec2, Totalamountexceed, "G/LBudgetAccountAmount", Glaccount, Totalamountglaccount);

        end;
        //end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Quantity', false, false)]
    procedure PurchaseLineValidateQty(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin

        IF (Rec."Shortcut Dimension 1 Code" <> '') OR (Rec."Shortcut Dimension 3 Code" <> '') THEN BEGIN
            PurchaseLineValidateDimension(Rec, xRec, 40);
            PurchaseLineValidateDimension2(Rec, xRec, 41);
        END;

        IF PurchHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
            DocumentNo := PurchHeader."No.";
            // MESSAGE(DocumentNo);
            // ActualBudgetMothYear(Rec);
            // Daterec := PurchHeader."Posting Date";
            if PurchHeader."Posting Date" = 0D then
                Daterec := PurchHeader."Order Date"
            else
                Daterec := PurchHeader."Posting Date";
            //MESSAGE(FORMAT(Daterec));
        END;
        //Rec := PurchaseLineBudget;
        //PurchHeader.SETRANGE("No.",PurchaseHeader."No.");
        //IF PurchHeader.FINDFIRST THEN
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






        GLAcc.RESET;
        GLAcc.SETRANGE(GLAcc."No.", Rec."No.");
        GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
        IF GLAcc.FINDFIRST THEN BEGIN


            BEGIN
                //total sum of a particular G/l account on the payment line
                //PurchaseLineBudget2.RESET;
                //PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                //PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", DocumentNo);
                //PurchaseLineBudget2.SETFILTER("No.", GLAccNo);
                // Rec.CALCSUMS(Rec."Amount Including VAT");
                PayLineAmountActual := Rec."Amount Including VAT";
                //MESSAGE(format(PayLineAmountActual));
            END;

            BEGIN
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.RESET;
                GlEntry.SETRANGE("G/L Account No.", GLAcc."No.");
                GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                GlEntry.CALCSUMS(Amount);

                GlEntryAccountAmount := GlEntry.Amount;
            END;



            BEGIN
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", GLAcc."No.");
                "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                //  MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            END;


            //total sum for the G/L account in the g/l entry and payment line
            Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

            //Difference btw the actual gl account and budgeted amount
            GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

            //total sum for the costcenter in the g/l entry and payment line
            // Totalamountexceed := PayLineAmount + GlEntryAmount;

            //Difference btw the actual cost center and budgeted amount
            // Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

            // IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
            //  ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
            // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
          //to  IF "G/LBudgetAccountAmount" < Totalamountglaccount THEN
            //to    MESSAGE(Text0059, "G/LBudgetAccountAmount", GLAcc."No.", Totalamountglaccount);




            BEGIN
                //total sum of a particular G/l account on the payment line
                //                            PurchaseLineBudget2.RESET;
                //                            PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                //                            PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", DocumentNo);
                //                            PurchaseLineBudget2.SETFILTER("No.", GLAccNo);
                //                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                //                            PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                PayLineAmountActual := Rec."Amount Including VAT";
            END;

            BEGIN
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.RESET;
                GlEntry.SETRANGE("G/L Account No.", GLAcc."No.");
                GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                GlEntry.CALCSUMS(Amount);
                GlEntryAccountAmount := GlEntry.Amount;
            END;
            BEGIN
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", GLAcc."No.");
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
            //Totalamountexceed := PayLineAmount + GlEntryAmount;

            //Difference btw the actual cost center and budgeted amount
            //  Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

            // IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
            //  ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
            // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
            IF "G/LBudgetAccountAmount" < Totalamountglaccount THEN
                MESSAGE(Text0059, "G/LBudgetAccountAmount", GLAcc."No.", Totalamountglaccount);
        END

    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Direct Unit Cost', false, false)]
    procedure PurchaseLineValidateAmt(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        IF (Rec."Shortcut Dimension 1 Code" <> '') OR (Rec."Shortcut Dimension 3 Code" <> '') THEN BEGIN
            PurchaseLineValidateDimension(Rec, xRec, 40);
            PurchaseLineValidateDimension2(Rec, xRec, 41);
        END;

        IF PurchHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
            DocumentNo := PurchHeader."No.";
            // MESSAGE(DocumentNo);
            // ActualBudgetMothYear(Rec);
            if PurchHeader."Posting Date" = 0D then
                Daterec := PurchHeader."Order Date"
            else
                Daterec := PurchHeader."Posting Date";

            //MESSAGE(FORMAT(Daterec));
        END;
        //Rec := PurchaseLineBudget;
        //PurchHeader.SETRANGE("No.",PurchaseHeader."No.");
        //IF PurchHeader.FINDFIRST THEN
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



        GLAcc.RESET;
        GLAcc.SETRANGE(GLAcc."No.", Rec."No.");
        GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
        IF GLAcc.FINDFIRST THEN BEGIN


            BEGIN
                //total sum of a particular G/l account on the payment line
                //PurchaseLineBudget2.RESET;
                //PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                //PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", DocumentNo);
                //PurchaseLineBudget2.SETFILTER("No.", GLAccNo);
                // Rec.CALCSUMS(Rec."Amount Including VAT");
                PayLineAmountActual := Rec."Amount Including VAT";
                //MESSAGE(format(PayLineAmountActual));
            END;

            BEGIN
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.RESET;
                GlEntry.SETRANGE("G/L Account No.", GLAcc."No.");
                GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                GlEntry.CALCSUMS(Amount);

                GlEntryAccountAmount := GlEntry.Amount;
            END;

            BEGIN
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", GLAcc."No.");
                "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            END;


            //total sum for the G/L account in the g/l entry and payment line
            Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

            //Difference btw the actual gl account and budgeted amount
            GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

           //to IF "G/LBudgetAccountAmount" < Totalamountglaccount THEN
             //to   MESSAGE(Text0059, "G/LBudgetAccountAmount", GLAcc."No.", Totalamountglaccount);

            BEGIN
                //total sum of a particular G/l account on the payment line
                //                            PurchaseLineBudget2.RESET;
                //                            PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                //                            PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", DocumentNo);
                //                            PurchaseLineBudget2.SETFILTER("No.", GLAccNo);
                //                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                //                            PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                PayLineAmountActual := Rec."Amount Including VAT";
            END;

            BEGIN
                //Total sum of the particular g/l account  in the g/l entry
                GlEntry.RESET;
                GlEntry.SETRANGE("G/L Account No.", GLAcc."No.");
                GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                GlEntry.CALCSUMS(Amount);
                GlEntryAccountAmount := GlEntry.Amount;
            END;


            BEGIN
                //Total sum of of particular g/l account in the budget entry
                "G/LBudgetEntry".RESET;
                "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", GLAcc."No.");
                "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
            END;


            //total sum for the G/L account in the g/l entry and payment line
            Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

            //Difference btw the actual gl account and budgeted amount
            GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

            IF "G/LBudgetAccountAmount" < Totalamountglaccount THEN
                MESSAGE(Text0060, "G/LBudgetAccountAmount", GLAcc."No.", Totalamountglaccount);
        END
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Shortcut Dimension 3 Code', false, false)]
    procedure PurchaseLineValidateDimension(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        IF Rec."Shortcut Dimension 3 Code" <> '' THEN BEGIN


            IF PurchHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
                DocumentNo := PurchHeader."No.";

                if PurchHeader."Posting Date" = 0D then
                    Daterec := PurchHeader."Order Date"
                else
                    Daterec := PurchHeader."Posting Date";

                //MESSAGE(FORMAT(Daterec));
            END;

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




            Dimension.RESET;
            Dimension.SETRANGE(Code, Rec."Shortcut Dimension 3 Code");
            Dimension.SETRANGE("Global Dimension No.", 3);
            IF Dimension.FINDFIRST THEN
                DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
            DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
            IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                DimensionTemporary.INIT;
                DimensionTemporary."Dimension Code" := Dimension.Code;
                DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                DimensionTemporary."Account No." := Rec."No.";
                DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                DimensionTemporary.Amount := Rec."Amount Including VAT";
                DimensionTemporary.INSERT;
            END;


        END;




        DimensionTemporary.RESET;
        DimensionTemporary.SETRANGE("Dimension Code");
        DimensionTemporary.SETRANGE("Dimension name");
        DimensionTemporary.SETRANGE("Global Dimension No", 3);
        IF DimensionTemporary.FINDFIRST THEN BEGIN





            GLAcc.RESET;
            GLAcc.SETRANGE(GLAcc."No.", DimensionTemporary."Account No.");
            GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
            IF GLAcc.FINDFIRST THEN BEGIN





                BEGIN
                    //total sum of a particular G/l account on the payment line
                    //                            PurchaseLineBudget2.RESET;
                    //                            PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                    //                            PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", DocumentNo);
                    //                            PurchaseLineBudget2.SETFILTER("No.", GLAccNo);
                    //                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                    //                            PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                    PayLineAmountActual := Rec."Amount Including VAT";
                    //MESSAGE(format(PayLineAmountActual));
                END;

                BEGIN
                    //Total sum of the particular g/l account  in the g/l entry
                    GlEntry.RESET;
                    GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                    GlEntry.SETFILTER("Global Dimension 1 Code", DimensionTemporary."Dimension Code");
                    GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                    GlEntry.CALCSUMS(Amount);

                    GlEntryAccountAmount := GlEntry.Amount;
                END;




                BEGIN
                    //Total sum of of particular g/l account in the budget entry
                    "G/LBudgetEntry".RESET;
                    "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                    "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 1 Code", DimensionTemporary."Dimension Code");
                    "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                    "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                    "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                    //       MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                END;


                //total sum for the G/L account in the g/l entry and payment line
                Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                //Difference btw the actual gl account and budgeted amount
                GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;


               // IF "G/LBudgetAccountAmount" < Totalamountglaccount THEN
                 //to   MESSAGE(Text0057, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", GLAccNo, Totalamountglaccount);





                BEGIN
                    //total sum of a particular G/l account on the payment line
                    //                           PurchaseLineBudget2.RESET;
                    //                           PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                    //                           PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", DocumentNo);
                    //                            PurchaseLineBudget2.SETFILTER("No.", GLAccNo);
                    //                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                    //                            PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                    PayLineAmountActual := Rec."Amount Including VAT";
                END;

                BEGIN
                    //Total sum of the particular g/l account  in the g/l entry
                    GlEntry.RESET;
                    GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                    GlEntry.SETFILTER("Shortcut Dimension 3 Code", DimensionTemporary."Dimension Code");
                    GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                    GlEntry.CALCSUMS(Amount);
                    GlEntryAccountAmount := GlEntry.Amount;
                END;



                BEGIN
                    //Total sum of of particular g/l account in the budget entry
                    "G/LBudgetEntry".RESET;
                    "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                    "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 1 Code", DimensionTemporary."Dimension Code");
                    "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                    "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                    "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                    //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                END;


                //total sum for the G/L account in the g/l entry and payment line
                Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                //Difference btw the actual gl account and budgeted amount
                GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                IF "G/LBudgetAccountAmount" < Totalamountglaccount THEN
                    MESSAGE(Text0058, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", DimensionTemporary."Account No.", Totalamountglaccount);

            END
        END;
        DimensionTemporary.DELETEALL;


    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Shortcut Dimension 2 Code', false, false)]
    procedure PurchaseLineValidateDimension2(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        IF Rec."Shortcut Dimension 2 Code" <> '' THEN BEGIN


            IF PurchHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
                DocumentNo := PurchHeader."No.";

                if PurchHeader."Posting Date" = 0D then
                    Daterec := PurchHeader."Order Date"
                else
                    Daterec := PurchHeader."Posting Date";
                //MESSAGE(FORMAT(Daterec));
            END;

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




            Dimension.RESET;
            Dimension.SETRANGE(Code, Rec."Shortcut Dimension 2 Code");
            Dimension.SETRANGE("Global Dimension No.", 2);
            IF Dimension.FINDFIRST THEN
                DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
            DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
            IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                DimensionTemporary.INIT;
                DimensionTemporary."Dimension Code" := Dimension.Code;
                DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                DimensionTemporary."Account No." := Rec."No.";
                DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                DimensionTemporary.Amount := Rec."Amount Including VAT";
                DimensionTemporary.INSERT;
            END;


        END;




        DimensionTemporary.RESET;
        DimensionTemporary.SETRANGE("Dimension Code");
        DimensionTemporary.SETRANGE("Dimension name");
        DimensionTemporary.SETRANGE("Global Dimension No", 2);
        IF DimensionTemporary.FINDFIRST THEN BEGIN





            GLAcc.RESET;
            GLAcc.SETRANGE(GLAcc."No.", DimensionTemporary."Account No.");
            GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
            IF GLAcc.FINDFIRST THEN BEGIN





                BEGIN
                    //total sum of a particular G/l account on the payment line
                    //                            PurchaseLineBudget2.RESET;
                    //                            PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                    //                            PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", DocumentNo);
                    //                            PurchaseLineBudget2.SETFILTER("No.", GLAccNo);
                    //                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                    //                            PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                    PayLineAmountActual := Rec."Amount Including VAT";
                    //MESSAGE(format(PayLineAmountActual));
                END;

                BEGIN
                    //Total sum of the particular g/l account  in the g/l entry
                    GlEntry.RESET;
                    GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                    GlEntry.SETFILTER("Global Dimension 2 Code", DimensionTemporary."Dimension Code");
                    GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                    GlEntry.CALCSUMS(Amount);

                    GlEntryAccountAmount := GlEntry.Amount;
                END;




                BEGIN
                    //Total sum of of particular g/l account in the budget entry
                    "G/LBudgetEntry".RESET;
                    "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                    "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code", DimensionTemporary."Dimension Code");
                    "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                    "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                    "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                    //       MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                END;


                //total sum for the G/L account in the g/l entry and payment line
                Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                //Difference btw the actual gl account and budgeted amount
                GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;


               // IF "G/LBudgetAccountAmount" < Totalamountglaccount THEN
               //     MESSAGE(Text0057, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", GLAccNo, Totalamountglaccount);





                BEGIN
                    //total sum of a particular G/l account on the payment line
                    //                           PurchaseLineBudget2.RESET;
                    //                           PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                    //                           PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", DocumentNo);
                    //                            PurchaseLineBudget2.SETFILTER("No.", GLAccNo);
                    //                            PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                    //                            PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                    PayLineAmountActual := Rec."Amount Including VAT";
                END;

                BEGIN
                    //Total sum of the particular g/l account  in the g/l entry
                    GlEntry.RESET;
                    GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                    GlEntry.SETFILTER("Global Dimension 2 Code", DimensionTemporary."Dimension Code");
                    GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                    GlEntry.CALCSUMS(Amount);
                    GlEntryAccountAmount := GlEntry.Amount;
                END;



                BEGIN
                    //Total sum of of particular g/l account in the budget entry
                    "G/LBudgetEntry".RESET;
                    "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                    "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code", DimensionTemporary."Dimension Code");
                    "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                    "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                    "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                    //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                END;


                //total sum for the G/L account in the g/l entry and payment line
                Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                //Difference btw the actual gl account and budgeted amount
                GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                IF "G/LBudgetAccountAmount" < Totalamountglaccount THEN
                    MESSAGE(Text0058, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", DimensionTemporary."Account No.", Totalamountglaccount);

            END
        END;
        DimensionTemporary.DELETEALL;


    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'Account No.', false, false)]
    procedure GenJourLineValidateNo(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin

        //     //WITH GenJournalLine DO BEGIN
        //     Daterec := Rec."Posting Date";
        //     //dimrec :='';
        //     StartDate := CalcDate('<-CM>', Daterec);
        //     EndDate := CalcDate('<CM>', Daterec);
        //     StartYear := CalcDate('<-CY>', Daterec);
        //     EndYear := CalcDate('<CY>', Daterec);

        //     DimName := 'COST CENTER';

        //     //MESSAGE(FORMAT(i));
        //     PayLineAmount := 0;
        //     GlEntryAmount := 0;
        //     "G/LBudgetEntryAmount" := 0;
        //     "G/LBudgetAccountAmount" := 0;
        //     PayLineAmountActual := 0;
        //     Totalamountglaccount := 0;
        //     GlaccBudgetAmountDiff := 0;
        //     Totalamount := 0;



        //     //GenJournalLineNew.RESET;
        //     //GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //     // GenJournalLineNewJ5.SETFILTER("Journal Batch Name","Journal Batch Name");
        //     //GenJournalLineNewJ5.SETFILTER("Journal Template Name","Journal Template Name");
        //     //GenJournalLineRec.SETRANGE("Journal Template Name","Journal Template Name");
        //     //GenJournalLineRec.SETRANGE("Line No.","Line No.");
        //     //GenJournalLineNew.SETCURRENTKEY("Document No.");
        //     GenJournalLineNew.SetRange("Document No.", Rec."Document No.");
        //     if GenJournalLineNew.Find('-') then begin
        //         BatchName := GenJournalLineNew."Journal Batch Name";
        //         TemplateBatch := GenJournalLineNew."Journal Template Name";
        //     end;

        //     //GenJournalLineRec.RESET;
        //     // GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //     // GenJournalLineRec.SETCURRENTKEY("Document No.");
        //     // GenJournalLineRec.SETRANGE("Journal Batch Name",GenJournalLine."Journal Batch Name");
        //     //GenJournalLineRec.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
        //     //  GenJournalLineRec.SETRANGE("Line No.",GenJournalLine."Line No.");
        //     //GenJournalLineRec.SETRANGE("Document No.",GenJournalLine."Document No.");
        //     //IF GenJournalLineRec.FIND('-') THEN BEGIN
        //     if (GLAcc.Get(Rec."Account No.")) or (Dimension.Get(Rec."Shortcut Dimension 1 Code", 'COST CENTER')) or (Rec."Amount (LCY)" <> 0) or
        //        FixedAsset.Get(Rec."Account No.") then begin
        //         //   IF PurchaseLineBudget.FINDLAST THEN BEGIN
        //         GLAccNo := GLAcc."No.";
        //         DimensionNo := Dimension.Code;
        //         FixedAssetNo := FixedAsset."No.";

        //         // REPEAT

        //         if (Rec."Account Type" = Rec."Account Type"::"Fixed Asset") and ((Rec."FA Posting Type" = Rec."FA Posting Type"::"Acquisition Cost") or
        //                      (Rec."FA Posting Type" = Rec."FA Posting Type"::Appreciation)) then
        //             ActualBudgetMothYearFixedasset(GenJournalLineRec)
        //         else begin


        //             GLAcc.Reset;
        //             GLAcc.SetRange(GLAcc."No.", GLAccNo);
        //             GLAcc.SetRange(GLAcc."Budget Controlled", true);
        //             if GLAcc.FindFirst then begin

        //                 Dimension.SetFilter(Dimension."Dimension Code", '%1', 'COST CENTER');
        //                 Dimension.SetRange(Dimension.Code, Rec."Shortcut Dimension 1 Code");
        //                 if Dimension.FindFirst then
        //                     DimensionNo := Rec."Shortcut Dimension 1 Code";
        //                 // MESSAGE(FORMAT(dimrec[i]));


        //                 //  MESSAGE(dimrec);





        //                 //To take care of the monthly budget

        //                 //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
        //                 begin
        //                     //Total sum of the the particular cost center on the Journal line
        //                     //GenJournalLine3.RESET;
        //                     // GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     //  GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                     //  GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                     //  GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     // PayLineAmount := Rec."Amount (LCY)";
        //                 end;


        //                 begin
        //                     //total sum of a particular G/l account on the payment line
        //                     // GenJournalLine3.RESET;
        //                     //  GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     //   GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                     // GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                     //  GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     PayLineAmountActual := Rec."Amount (LCY)";
        //                 end;

        //                 begin
        //                     //Total sum of the particular cost center in the g/l entry
        //                     // GlEntry.RESET;
        //                     // GlEntry.SETFILTER("Global Dimension 1 Code",DimensionNo);
        //                     // GlEntry.SETRANGE("Posting Date",StartDate,EndDate);
        //                     // GlEntry.CALCSUMS(Amount);
        //                     // GlEntryAmount := GlEntry.Amount;
        //                     //MESSAGE(FORMAT(GlEntryAmount));
        //                 end;

        //                 begin
        //                     //Total sum of the particular g/l account  in the g/l entry
        //                     GlEntry.Reset;
        //                     GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                     GlEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
        //                     GlEntry.CalcSums(Amount);
        //                     GlEntryAccountAmount := GlEntry.Amount;
        //                 end;


        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     //"G/LBudgetEntry".RESET;
        //                     //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                     //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartDate,EndDate);
        //                     //"G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                     //"G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;


        //                 begin
        //                     //Total sum of of particular g/l account in the budget entry
        //                     "G/LBudgetEntry".Reset;
        //                     "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                     "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
        //                     "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                     "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;


        //                 //total sum for the G/L account in the g/l entry and payment line
        //                 Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                 //Difference btw the actual gl account and budgeted amount
        //                 GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

        //                 //total sum for the costcenter in the g/l entry and payment line
        //                 //Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                 //Difference btw the actual cost center and budgeted amount
        //                 //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                 ///IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 //  ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN
        //                 if "G/LBudgetAccountAmount" < Totalamountglaccount then
        //                     Message(Text0059, "G/LBudgetAccountAmount", GLAccNo, Totalamountglaccount);

        //                 //END;

        //                 //to take care of the yearly budget

        //                 //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
        //                 begin
        //                     //Total sum of the the particular cost center on the payment line
        //                     //GenJournalLine3.RESET;
        //                     // GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     // GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                     //  GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                     //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     //  PayLineAmount := Rec."Amount (LCY)";
        //                 end;

        //                 begin
        //                     //total sum of a particular G/l account on the payment line
        //                     // GenJournalLine3.RESET;
        //                     //// GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     // GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                     // GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
        //                     PayLineAmountActual := Rec."Amount (LCY)";
        //                 end;

        //                 begin
        //                     //Total sum of the particular cost center in the g/l entry
        //                     //  GlEntry.RESET;
        //                     // GlEntry.SETFILTER("Global Dimension 1 Code",DimensionNo);
        //                     //GlEntry.SETRANGE("Posting Date",StartYear,EndYear);
        //                     //GlEntry.CALCSUMS(Amount);
        //                     //GlEntryAmount := GlEntry.Amount;
        //                     //MESSAGE(FORMAT(GlEntryAmount));
        //                 end;


        //                 begin
        //                     //Total sum of the particular g/l account  in the g/l entry
        //                     GlEntry.Reset;
        //                     GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                     GlEntry.SetRange("Posting Date", StartYear, EndYear);
        //                     GlEntry.CalcSums(Amount);
        //                     GlEntryAccountAmount := GlEntry.Amount;
        //                 end;
        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     //"G/LBudgetEntry".RESET;
        //                     //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                     //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
        //                     //"G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                     //"G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     //"G/LBudgetEntry".RESET;
        //                     // "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                     // "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
        //                     // "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                     // "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 begin
        //                     //Total sum of of particular g/l account in the budget entry
        //                     "G/LBudgetEntry".Reset;
        //                     "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                     "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
        //                     "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                     "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 //total sum for the G/L account in the g/l entry and payment line
        //                 Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                 //Difference btw the actual gl account and budgeted amount
        //                 GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

        //                 //total sum for the costcenter in the g/l entry and payment line
        //                 //Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                 //Difference btw the actual cost center and budgeted amount
        //                 //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                 //MESSAGE(Text005,"G/LBudgetEntryAmount",dimrec,Totalamountexceed,"G/LBudgetAccountAmount",PayLinebudget2."Account No.",Totalamountglaccount);
        //                 //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 //  ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 //((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN
        //                 if "G/LBudgetAccountAmount" < Totalamountglaccount then
        //                     Message(Text0060, "G/LBudgetAccountAmount", GLAccNo, Totalamountglaccount);
        //                 //END;
        //             end;








        //         end;

        //         //UNTIL GenJournalLineRec.NEXT = 0;
        //     end;
        //     //END;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'Debit Amount', false, false)]
    procedure GenJourLineValidateDebit(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        //     //WITH GenJournalLine DO BEGIN

        //     if (Rec."Shortcut Dimension 1 Code" <> '') or (Rec."Shortcut Dimension 2 Code" <> '') then begin
        //         GenJourLineValidateDimension(Rec, xRec, 24);
        //         GenJourLineValidateDimension2(Rec, xRec, 25);

        //     end;

        //     DimName := 'COST CENTER';

        //     Daterec := Rec."Posting Date";
        //     //dimrec :='';
        //     StartDate := CalcDate('<-CM>', Daterec);
        //     EndDate := CalcDate('<CM>', Daterec);
        //     StartYear := CalcDate('<-CY>', Daterec);
        //     EndYear := CalcDate('<CY>', Daterec);

        //     //MESSAGE(FORMAT(i));
        //     PayLineAmount := 0;
        //     GlEntryAmount := 0;
        //     "G/LBudgetEntryAmount" := 0;
        //     "G/LBudgetAccountAmount" := 0;
        //     PayLineAmountActual := 0;
        //     Totalamountglaccount := 0;
        //     GlaccBudgetAmountDiff := 0;
        //     Totalamount := 0;



        //     //GenJournalLineNew.RESET;
        //     //GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //     // GenJournalLineNewJ5.SETFILTER("Journal Batch Name","Journal Batch Name");
        //     //GenJournalLineNewJ5.SETFILTER("Journal Template Name","Journal Template Name");
        //     //GenJournalLineRec.SETRANGE("Journal Template Name","Journal Template Name");
        //     //GenJournalLineRec.SETRANGE("Line No.","Line No.");
        //     //GenJournalLineNew.SETCURRENTKEY("Document No.");
        //     GenJournalLineNew.SetRange("Document No.", Rec."Document No.");
        //     if GenJournalLineNew.Find('-') then begin
        //         BatchName := GenJournalLineNew."Journal Batch Name";
        //         TemplateBatch := GenJournalLineNew."Journal Template Name";
        //     end;

        //     //GenJournalLineRec.RESET;
        //     // GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //     // GenJournalLineRec.SETCURRENTKEY("Document No.");
        //     // GenJournalLineRec.SETRANGE("Journal Batch Name",GenJournalLine."Journal Batch Name");
        //     //GenJournalLineRec.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
        //     //  GenJournalLineRec.SETRANGE("Line No.",GenJournalLine."Line No.");
        //     //GenJournalLineRec.SETRANGE("Document No.",GenJournalLine."Document No.");
        //     //IF GenJournalLineRec.FIND('-') THEN BEGIN
        //     if (GLAcc.Get(Rec."Account No.")) or (Dimension.Get(Rec."Shortcut Dimension 1 Code", 'COST CENTER')) or (Rec."Amount (LCY)" <> 0) or
        //        FixedAsset.Get(Rec."Account No.") then begin
        //         //   IF PurchaseLineBudget.FINDLAST THEN BEGIN
        //         GLAccNo := GLAcc."No.";
        //         DimensionNo := Dimension.Code;
        //         FixedAssetNo := FixedAsset."No.";

        //         // REPEAT

        //         if (Rec."Account Type" = Rec."Account Type"::"Fixed Asset") and ((Rec."FA Posting Type" = Rec."FA Posting Type"::"Acquisition Cost") or
        //                      (Rec."FA Posting Type" = Rec."FA Posting Type"::Appreciation)) then
        //             ActualBudgetMothYearFixedasset(GenJournalLineRec)
        //         else begin


        //             GLAcc.Reset;
        //             GLAcc.SetRange(GLAcc."No.", GLAccNo);
        //             GLAcc.SetRange(GLAcc."Budget Controlled", true);
        //             if GLAcc.FindFirst then begin

        //                 Dimension.SetFilter(Dimension."Dimension Code", '%1', 'COST CENTER');
        //                 Dimension.SetRange(Dimension.Code, Rec."Shortcut Dimension 1 Code");
        //                 if Dimension.FindFirst then
        //                     DimensionNo := Rec."Shortcut Dimension 1 Code";
        //                 // MESSAGE(FORMAT(dimrec[i]));


        //                 //  MESSAGE(dimrec);





        //                 //To take care of the monthly budget

        //                 //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
        //                 begin
        //                     //Total sum of the the particular cost center on the Journal line
        //                     //GenJournalLine3.RESET;
        //                     // GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     //  GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                     //  GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                     //  GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     // PayLineAmount := Rec."Amount (LCY)";
        //                 end;


        //                 begin
        //                     //total sum of a particular G/l account on the payment line
        //                     // GenJournalLine3.RESET;
        //                     //  GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     //   GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                     // GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                     //  GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     PayLineAmountActual := Rec."Amount (LCY)";
        //                 end;

        //                 begin
        //                     //Total sum of the particular cost center in the g/l entry
        //                     // GlEntry.RESET;
        //                     // GlEntry.SETFILTER("Global Dimension 1 Code",DimensionNo);
        //                     // GlEntry.SETRANGE("Posting Date",StartDate,EndDate);
        //                     // GlEntry.CALCSUMS(Amount);
        //                     // GlEntryAmount := GlEntry.Amount;
        //                     //MESSAGE(FORMAT(GlEntryAmount));
        //                 end;

        //                 begin
        //                     //Total sum of the particular g/l account  in the g/l entry
        //                     GlEntry.Reset;
        //                     GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                     GlEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
        //                     GlEntry.CalcSums(Amount);
        //                     GlEntryAccountAmount := GlEntry.Amount;
        //                 end;


        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     //"G/LBudgetEntry".RESET;
        //                     //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                     //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartDate,EndDate);
        //                     //"G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                     //"G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;


        //                 begin
        //                     //Total sum of of particular g/l account in the budget entry
        //                     "G/LBudgetEntry".Reset;
        //                     "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                     "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
        //                     "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                     "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;


        //                 //total sum for the G/L account in the g/l entry and payment line
        //                 Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                 //Difference btw the actual gl account and budgeted amount
        //                 GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

        //                 //total sum for the costcenter in the g/l entry and payment line
        //                 //Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                 //Difference btw the actual cost center and budgeted amount
        //                 //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                 ///IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 //  ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN
        //                 if "G/LBudgetAccountAmount" < Totalamountglaccount then
        //                     Message(Text0059, "G/LBudgetAccountAmount", GLAccNo, Totalamountglaccount);

        //                 //END;

        //                 //to take care of the yearly budget

        //                 //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
        //                 begin
        //                     //Total sum of the the particular cost center on the payment line
        //                     //GenJournalLine3.RESET;
        //                     // GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     // GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                     //  GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                     //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     //  PayLineAmount := Rec."Amount (LCY)";
        //                 end;

        //                 begin
        //                     //total sum of a particular G/l account on the payment line
        //                     // GenJournalLine3.RESET;
        //                     //// GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     // GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                     // GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
        //                     PayLineAmountActual := Rec."Amount (LCY)";
        //                 end;

        //                 begin
        //                     //Total sum of the particular cost center in the g/l entry
        //                     //  GlEntry.RESET;
        //                     // GlEntry.SETFILTER("Global Dimension 1 Code",DimensionNo);
        //                     //GlEntry.SETRANGE("Posting Date",StartYear,EndYear);
        //                     //GlEntry.CALCSUMS(Amount);
        //                     //GlEntryAmount := GlEntry.Amount;
        //                     //MESSAGE(FORMAT(GlEntryAmount));
        //                 end;


        //                 begin
        //                     //Total sum of the particular g/l account  in the g/l entry
        //                     GlEntry.Reset;
        //                     GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                     GlEntry.SetRange("Posting Date", StartYear, EndYear);
        //                     GlEntry.CalcSums(Amount);
        //                     GlEntryAccountAmount := GlEntry.Amount;
        //                 end;
        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     //"G/LBudgetEntry".RESET;
        //                     //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                     //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
        //                     //"G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                     //"G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     //"G/LBudgetEntry".RESET;
        //                     // "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                     // "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
        //                     // "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                     // "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 begin
        //                     //Total sum of of particular g/l account in the budget entry
        //                     "G/LBudgetEntry".Reset;
        //                     "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                     "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
        //                     "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                     "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 //total sum for the G/L account in the g/l entry and payment line
        //                 Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                 //Difference btw the actual gl account and budgeted amount
        //                 GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

        //                 //total sum for the costcenter in the g/l entry and payment line
        //                 //Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                 //Difference btw the actual cost center and budgeted amount
        //                 //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                 //MESSAGE(Text005,"G/LBudgetEntryAmount",dimrec,Totalamountexceed,"G/LBudgetAccountAmount",PayLinebudget2."Account No.",Totalamountglaccount);
        //                 //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 //  ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 //((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN
        //                 if "G/LBudgetAccountAmount" < Totalamountglaccount then
        //                     Message(Text0060, "G/LBudgetAccountAmount", GLAccNo, Totalamountglaccount);
        //                 //END;
        //             end;








        //         end;

        //         //UNTIL GenJournalLineRec.NEXT = 0;
        //     end;
        //     //END;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'Shortcut Dimension 1 Code', false, false)]
    procedure GenJourLineValidateDimension(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        //     //WITH GenJournalLine DO BEGIN
        //     if Rec."Shortcut Dimension 1 Code" <> '' then begin

        //         Daterec := Rec."Posting Date";
        //         //dimrec :='';
        //         StartDate := CalcDate('<-CM>', Daterec);
        //         EndDate := CalcDate('<CM>', Daterec);
        //         StartYear := CalcDate('<-CY>', Daterec);
        //         EndYear := CalcDate('<CY>', Daterec);

        //         DimName := 'COST CENTER';




        //         //MESSAGE(FORMAT(i));
        //         PayLineAmount := 0;
        //         GlEntryAmount := 0;
        //         "G/LBudgetEntryAmount" := 0;
        //         "G/LBudgetAccountAmount" := 0;
        //         PayLineAmountActual := 0;
        //         Totalamountglaccount := 0;
        //         GlaccBudgetAmountDiff := 0;
        //         Totalamount := 0;



        //         //GenJournalLineNew.RESET;
        //         //GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //         // GenJournalLineNewJ5.SETFILTER("Journal Batch Name","Journal Batch Name");
        //         //GenJournalLineNewJ5.SETFILTER("Journal Template Name","Journal Template Name");
        //         //GenJournalLineRec.SETRANGE("Journal Template Name","Journal Template Name");
        //         //GenJournalLineRec.SETRANGE("Line No.","Line No.");
        //         //GenJournalLineNew.SETCURRENTKEY("Document No.");
        //         GenJournalLineNew.SetRange("Document No.", Rec."Document No.");
        //         if GenJournalLineNew.Find('-') then begin
        //             BatchName := GenJournalLineNew."Journal Batch Name";
        //             TemplateBatch := GenJournalLineNew."Journal Template Name";
        //         end;

        //         //GenJournalLineRec.RESET;
        //         //GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //         // GenJournalLineRec.SETCURRENTKEY("Document No.");
        //         // GenJournalLineRec.SETRANGE("Journal Batch Name",GenJournalLine."Journal Batch Name");
        //         //GenJournalLineRec.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
        //         //  GenJournalLineRec.SETRANGE("Line No.",GenJournalLine."Line No.");
        //         //GenJournalLineRec.SETRANGE("Document No.",GenJournalLine."Document No.");
        //         //IF GenJournalLineRec.FIND('-') THEN BEGIN
        //         if (GLAcc.Get(Rec."Account No.")) or (Dimension.Get(Rec."Shortcut Dimension 1 Code", 'COST CENTER')) or (Rec."Amount (LCY)" <> 0) or
        //            FixedAsset.Get(Rec."Account No.") then begin
        //             //   IF PurchaseLineBudget.FINDLAST THEN BEGIN
        //             GLAccNo := GLAcc."No.";
        //             DimensionNo := Dimension.Code;
        //             FixedAssetNo := FixedAsset."No.";

        //             // REPEAT

        //             if (Rec."Account Type" = Rec."Account Type"::"Fixed Asset") and ((Rec."FA Posting Type" = Rec."FA Posting Type"::"Acquisition Cost") or
        //                          (Rec."FA Posting Type" = Rec."FA Posting Type"::Appreciation)) then
        //                 ActualBudgetMothYearFixedasset(GenJournalLineRec)
        //             else begin


        //                 GLAcc.Reset;
        //                 GLAcc.SetRange(GLAcc."No.", GLAccNo);
        //                 GLAcc.SetRange(GLAcc."Budget Controlled", true);
        //                 if GLAcc.FindFirst then begin

        //                     Dimension.SetFilter(Dimension."Dimension Code", '%1', 'COST CENTER');
        //                     Dimension.SetRange(Dimension.Code, Rec."Shortcut Dimension 1 Code");
        //                     if Dimension.FindFirst then
        //                         DimensionNo := Dimension.Code;
        //                     // MESSAGE(FORMAT(dimrec[i]));


        //                     //  MESSAGE(dimrec);





        //                     //To take care of the monthly budget

        //                     //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
        //                     begin
        //                         //Total sum of the the particular cost center on the Journal line
        //                         //GenJournalLine3.RESET;
        //                         //GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                         //GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                         //GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                         //GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                         //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                         // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                         //PayLineAmount := Rec."Amount (LCY)";
        //                     end;


        //                     begin
        //                         //total sum of a particular G/l account on the payment line
        //                         // GenJournalLine3.RESET;
        //                         // GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.","Shortcut Dimension 1 Code");
        //                         // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                         // GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                         // GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                         // GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                         // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                         PayLineAmountActual := Rec."Amount (LCY)";
        //                     end;

        //                     begin
        //                         //Total sum of the particular cost center in the g/l entry
        //                         //GlEntry.RESET;
        //                         //GlEntry.SETFILTER("Global Dimension 1 Code",DimensionNo);
        //                         // GlEntry.SETRANGE("G/L Account No.",GLAccNo);
        //                         // GlEntry.SETRANGE("Posting Date",StartDate,EndDate);
        //                         // GlEntry.CALCSUMS(Amount);
        //                         // GlEntryAmount := GlEntry.Amount;
        //                         //MESSAGE(FORMAT(GlEntryAmount));
        //                     end;

        //                     begin
        //                         //Total sum of the particular g/l account  in the g/l entry
        //                         GlEntry.Reset;
        //                         GlEntry.SetFilter("Global Dimension 1 Code", DimensionNo);
        //                         GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                         GlEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
        //                         GlEntry.CalcSums(Amount);
        //                         GlEntryAccountAmount := GlEntry.Amount;
        //                     end;


        //                     begin
        //                         //Total sum  value of a particular cost center in the budget entry
        //                         "G/LBudgetEntry".Reset;
        //                         "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 1 Code", DimensionNo);
        //                         "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
        //                         "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                         "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                         "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                         //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                     end;


        //                     begin
        //                         //Total sum of of particular g/l account in the budget entry
        //                         //"G/LBudgetEntry".RESET;
        //                         // "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.",GLAccNo);
        //                         // "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                         // "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartDate,EndDate);
        //                         // "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                         // "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                         //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                     end;


        //                     //total sum for the G/L account in the g/l entry and payment line
        //                     Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                     //Difference btw the actual gl account and budgeted amount
        //                     GlaccBudgetAmountDiff := "G/LBudgetEntryAmount" - Totalamountglaccount;
        //                     //MESSAGE(FORMAT(PayLineAmountActual));


        //                     //total sum for the costcenter in the g/l entry and payment line
        //                     //Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                     //Difference btw the actual cost center and budgeted amount
        //                     //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                     //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                     // ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                     //((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN
        //                     if "G/LBudgetAccountAmount" < Totalamountglaccount then
        //                         Message(Text0057, DimName, "G/LBudgetEntryAmount", DimName, DimensionNo, GLAccNo, Totalamountglaccount);

        //                     //END;

        //                     //to take care of the yearly budget

        //                     //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
        //                     begin
        //                         //Total sum of the the particular cost center on the payment line
        //                         // GenJournalLine3.RESET;
        //                         // GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                         // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                         // GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                         //GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                         //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                         // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                         //  PayLineAmount := Rec."Amount (LCY)";
        //                     end;

        //                     begin
        //                         //total sum of a particular G/l account on the payment line
        //                         // GenJournalLine3.RESET;
        //                         //GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.");
        //                         //GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                         //GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                         //GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                         //GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
        //                         PayLineAmountActual := Rec."Amount (LCY)";
        //                     end;

        //                     begin
        //                         //Total sum of the particular cost center in the g/l entry
        //                         //GlEntry.RESET;
        //                         //GlEntry.SETFILTER("Global Dimension 1 Code",DimensionNo);
        //                         //GlEntry.SETRANGE("G/L Account No.",GLAccNo);
        //                         // GlEntry.SETRANGE("Posting Date",StartYear,EndYear);
        //                         //GlEntry.CALCSUMS(Amount);
        //                         //GlEntryAmount := GlEntry.Amount;
        //                         //MESSAGE(FORMAT(GlEntryAmount));
        //                     end;


        //                     begin
        //                         //Total sum of the particular g/l account  in the g/l entry
        //                         GlEntry.Reset;
        //                         GlEntry.SetFilter("Global Dimension 1 Code", DimensionNo);
        //                         GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                         GlEntry.SetRange("Posting Date", StartYear, EndYear);
        //                         GlEntry.CalcSums(Amount);
        //                         GlEntryAccountAmount := GlEntry.Amount;
        //                     end;
        //                     begin
        //                         //Total sum  value of a particular cost center in the budget entry
        //                         "G/LBudgetEntry".Reset;
        //                         "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 1 Code", DimensionNo);
        //                         "G/LBudgetEntry".SetRange("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                         "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
        //                         "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                         "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                         //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                     end;

        //                     begin
        //                         //Total sum  value of a particular cost center in the budget entry
        //                         //"G/LBudgetEntry".RESET;
        //                         //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                         //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
        //                         // "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                         //"G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                         //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                     end;

        //                     begin
        //                         //Total sum of of particular g/l account in the budget entry
        //                         // "G/LBudgetEntry".RESET;
        //                         //  "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.",GLAccNo);
        //                         //  "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
        //                         //  "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                         //  "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                         //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                     end;

        //                     //total sum for the G/L account in the g/l entry and payment line
        //                     Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                     //Difference btw the actual gl account and budgeted amount
        //                     GlaccBudgetAmountDiff := "G/LBudgetEntryAmount" - Totalamountglaccount;

        //                     if "G/LBudgetEntryAmount" < Totalamountglaccount then
        //                         Message(Text0058, DimName, "G/LBudgetEntryAmount", DimName, DimensionNo, GLAccNo, Totalamountglaccount);


        //                     //total sum for the costcenter in the g/l entry and payment line
        //                     //Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                     //Difference btw the actual cost center and budgeted amount
        //                     //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                     //MESSAGE(Text005,"G/LBudgetEntryAmount",dimrec,Totalamountexceed,"G/LBudgetAccountAmount",PayLinebudget2."Account No.",Totalamountglaccount);
        //                     //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                     // ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                     // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN

        //                     //MESSAGE(Text0056,"G/LBudgetEntryAmount",DimensionNo,Totalamountexceed,"G/LBudgetAccountAmount",GLAccNo,Totalamountglaccount);
        //                     //END;
        //                 end;








        //             end;

        //             //UNTIL GenJournalLineRec.NEXT = 0;
        //         end;
        //     end;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'Credit Amount', false, false)]
    procedure GenJourLineValidateCredit(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        //     //WITH GenJournalLine DO BEGIN

        //     if (Rec."Shortcut Dimension 1 Code" <> '') or (Rec."Shortcut Dimension 2 Code" <> '') then begin
        //         GenJourLineValidateDimension(Rec, xRec, 24);
        //         GenJourLineValidateDimension2(Rec, xRec, 25);

        //     end;

        //     DimName := 'COST CENTER';

        //     Daterec := Rec."Posting Date";
        //     //dimrec :='';
        //     StartDate := CalcDate('<-CM>', Daterec);
        //     EndDate := CalcDate('<CM>', Daterec);
        //     StartYear := CalcDate('<-CY>', Daterec);
        //     EndYear := CalcDate('<CY>', Daterec);

        //     //MESSAGE(FORMAT(i));
        //     PayLineAmount := 0;
        //     GlEntryAmount := 0;
        //     "G/LBudgetEntryAmount" := 0;
        //     "G/LBudgetAccountAmount" := 0;
        //     PayLineAmountActual := 0;
        //     Totalamountglaccount := 0;
        //     GlaccBudgetAmountDiff := 0;
        //     Totalamount := 0;



        //     //GenJournalLineNew.RESET;
        //     //GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //     // GenJournalLineNewJ5.SETFILTER("Journal Batch Name","Journal Batch Name");
        //     //GenJournalLineNewJ5.SETFILTER("Journal Template Name","Journal Template Name");
        //     //GenJournalLineRec.SETRANGE("Journal Template Name","Journal Template Name");
        //     //GenJournalLineRec.SETRANGE("Line No.","Line No.");
        //     //GenJournalLineNew.SETCURRENTKEY("Document No.");
        //     GenJournalLineNew.SetRange("Document No.", Rec."Document No.");
        //     if GenJournalLineNew.Find('-') then begin
        //         BatchName := GenJournalLineNew."Journal Batch Name";
        //         TemplateBatch := GenJournalLineNew."Journal Template Name";
        //     end;

        //     //GenJournalLineRec.RESET;
        //     // GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //     // GenJournalLineRec.SETCURRENTKEY("Document No.");
        //     // GenJournalLineRec.SETRANGE("Journal Batch Name",GenJournalLine."Journal Batch Name");
        //     //GenJournalLineRec.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
        //     //  GenJournalLineRec.SETRANGE("Line No.",GenJournalLine."Line No.");
        //     //GenJournalLineRec.SETRANGE("Document No.",GenJournalLine."Document No.");
        //     //IF GenJournalLineRec.FIND('-') THEN BEGIN
        //     if (GLAcc.Get(Rec."Account No.")) or (Dimension.Get(Rec."Shortcut Dimension 1 Code", 'COST CENTER')) or (Rec."Amount (LCY)" <> 0) or
        //        FixedAsset.Get(Rec."Account No.") then begin
        //         //   IF PurchaseLineBudget.FINDLAST THEN BEGIN
        //         GLAccNo := GLAcc."No.";
        //         DimensionNo := Dimension.Code;
        //         FixedAssetNo := FixedAsset."No.";

        //         // REPEAT

        //         if (Rec."Account Type" = Rec."Account Type"::"Fixed Asset") and ((Rec."FA Posting Type" = Rec."FA Posting Type"::"Acquisition Cost") or
        //                      (Rec."FA Posting Type" = Rec."FA Posting Type"::Appreciation)) then
        //             ActualBudgetMothYearFixedasset(GenJournalLineRec)
        //         else begin


        //             GLAcc.Reset;
        //             GLAcc.SetRange(GLAcc."No.", GLAccNo);
        //             GLAcc.SetRange(GLAcc."Budget Controlled", true);
        //             if GLAcc.FindFirst then begin

        //                 Dimension.SetFilter(Dimension."Dimension Code", '%1', 'COST CENTER');
        //                 Dimension.SetRange(Dimension.Code, Rec."Shortcut Dimension 1 Code");
        //                 if Dimension.FindFirst then
        //                     DimensionNo := Rec."Shortcut Dimension 1 Code";
        //                 // MESSAGE(FORMAT(dimrec[i]));


        //                 //  MESSAGE(dimrec);





        //                 //To take care of the monthly budget

        //                 //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
        //                 begin
        //                     //Total sum of the the particular cost center on the Journal line
        //                     //GenJournalLine3.RESET;
        //                     //GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                     //GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     //GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                     //GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                     //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     PayLineAmount := Rec."Amount (LCY)";
        //                 end;


        //                 begin
        //                     //total sum of a particular G/l account on the payment line
        //                     //GenJournalLine3.RESET;
        //                     //GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.");
        //                     //GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     //GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                     // GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     PayLineAmountActual := Rec."Amount (LCY)";
        //                 end;

        //                 begin
        //                     //Total sum of the particular cost center in the g/l entry
        //                     GlEntry.Reset;
        //                     GlEntry.SetFilter("Global Dimension 1 Code", DimensionNo);
        //                     GlEntry.SetRange("Posting Date", StartDate, EndDate);
        //                     GlEntry.CalcSums(Amount);
        //                     GlEntryAmount := GlEntry.Amount;
        //                     //MESSAGE(FORMAT(GlEntryAmount));
        //                 end;

        //                 begin
        //                     //Total sum of the particular g/l account  in the g/l entry
        //                     GlEntry.Reset;
        //                     GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                     GlEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
        //                     GlEntry.CalcSums(Amount);
        //                     GlEntryAccountAmount := GlEntry.Amount;
        //                 end;


        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     "G/LBudgetEntry".Reset;
        //                     "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 1 Code", DimensionNo);
        //                     "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
        //                     "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                     "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;


        //                 begin
        //                     //Total sum of of particular g/l account in the budget entry
        //                     "G/LBudgetEntry".Reset;
        //                     "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                     "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
        //                     "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                     "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;


        //                 //total sum for the G/L account in the g/l entry and payment line
        //                 Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                 //Difference btw the actual gl account and budgeted amount
        //                 GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

        //                 //total sum for the costcenter in the g/l entry and payment line
        //                 Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                 //Difference btw the actual cost center and budgeted amount
        //                 Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                 if ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
        //                    ((Totalamountexceed < "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
        //                   ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) then
        //                     Message(Text0055, "G/LBudgetEntryAmount", DimensionNo, Totalamountexceed, "G/LBudgetAccountAmount", GLAccNo, Totalamountglaccount);

        //                 //END;

        //                 //to take care of the yearly budget

        //                 //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
        //                 begin
        //                     //Total sum of the the particular cost center on the payment line
        //                     // GenJournalLine3.RESET;
        //                     // GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     // GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                     //GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                     //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     PayLineAmount := Rec."Amount (LCY)";
        //                 end;

        //                 begin
        //                     //total sum of a particular G/l account on the payment line
        //                     // GenJournalLine3.RESET;
        //                     //GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.");
        //                     //GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     //GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                     //GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                     //GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
        //                     PayLineAmountActual := Rec.Amount;
        //                 end;

        //                 begin
        //                     //Total sum of the particular cost center in the g/l entry
        //                     GlEntry.Reset;
        //                     GlEntry.SetFilter("Global Dimension 1 Code", DimensionNo);
        //                     GlEntry.SetRange("Posting Date", StartYear, EndYear);
        //                     GlEntry.CalcSums(Amount);
        //                     GlEntryAmount := GlEntry.Amount;
        //                     //MESSAGE(FORMAT(GlEntryAmount));
        //                 end;


        //                 begin
        //                     //Total sum of the particular g/l account  in the g/l entry
        //                     GlEntry.Reset;
        //                     GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                     GlEntry.SetRange("Posting Date", StartYear, EndYear);
        //                     GlEntry.CalcSums(Amount);
        //                     GlEntryAccountAmount := GlEntry.Amount;
        //                 end;
        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     "G/LBudgetEntry".Reset;
        //                     "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 1 Code", DimensionNo);
        //                     "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
        //                     "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                     "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     "G/LBudgetEntry".Reset;
        //                     "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 1 Code", DimensionNo);
        //                     "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
        //                     "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                     "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 begin
        //                     //Total sum of of particular g/l account in the budget entry
        //                     "G/LBudgetEntry".Reset;
        //                     "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                     "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
        //                     "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                     "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 //total sum for the G/L account in the g/l entry and payment line
        //                 Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                 //Difference btw the actual gl account and budgeted amount
        //                 GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

        //                 //total sum for the costcenter in the g/l entry and payment line
        //                 Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                 //Difference btw the actual cost center and budgeted amount
        //                 Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                 //MESSAGE(Text005,"G/LBudgetEntryAmount",dimrec,Totalamountexceed,"G/LBudgetAccountAmount",PayLinebudget2."Account No.",Totalamountglaccount);
        //                 if ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
        //                    ((Totalamountexceed < "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) or
        //                   ((Totalamountexceed > "G/LBudgetEntryAmount") and (Totalamountglaccount > "G/LBudgetAccountAmount")) then
        //                     Message(Text0056, "G/LBudgetEntryAmount", DimensionNo, Totalamountexceed, "G/LBudgetAccountAmount", GLAccNo, Totalamountglaccount);
        //                 //END;
        //             end;








        //         end;

        //         //UNTIL GenJournalLineRec.NEXT = 0;
        //     end;
        //     //END;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'Amount', false, false)]
    procedure GenJourLineValidateAmount(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        //     //WITH GenJournalLine DO BEGIN


        //     if (Rec."Shortcut Dimension 1 Code" <> '') or (Rec."Shortcut Dimension 2 Code" <> '') then begin
        //         GenJourLineValidateDimension(Rec, xRec, 24);
        //         GenJourLineValidateDimension2(Rec, xRec, 25);
        //     end;

        //     DimName := 'COST CENTER';
        //     if Rec."Posting Date" = 0D then begin
        //         Rec."Posting Date" := Today;
        //     end;
        //     //WITH GenJournalLine DO BEGIN
        //     Daterec := Rec."Posting Date";
        //     //dimrec :='';
        //     StartDate := CalcDate('<-CM>', Daterec);
        //     EndDate := CalcDate('<CM>', Daterec);
        //     StartYear := CalcDate('<-CY>', Daterec);
        //     EndYear := CalcDate('<CY>', Daterec);

        //     //MESSAGE(FORMAT(i));
        //     PayLineAmount := 0;
        //     GlEntryAmount := 0;
        //     "G/LBudgetEntryAmount" := 0;
        //     "G/LBudgetAccountAmount" := 0;
        //     PayLineAmountActual := 0;
        //     Totalamountglaccount := 0;
        //     GlaccBudgetAmountDiff := 0;
        //     Totalamount := 0;



        //     //GenJournalLineNew.RESET;
        //     //GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //     // GenJournalLineNewJ5.SETFILTER("Journal Batch Name","Journal Batch Name");
        //     //GenJournalLineNewJ5.SETFILTER("Journal Template Name","Journal Template Name");
        //     //GenJournalLineRec.SETRANGE("Journal Template Name","Journal Template Name");
        //     //GenJournalLineRec.SETRANGE("Line No.","Line No.");
        //     //GenJournalLineNew.SETCURRENTKEY("Document No.");
        //     GenJournalLineNew.SetRange("Document No.", Rec."Document No.");
        //     if GenJournalLineNew.Find('-') then begin
        //         BatchName := GenJournalLineNew."Journal Batch Name";
        //         TemplateBatch := GenJournalLineNew."Journal Template Name";
        //     end;

        //     //GenJournalLineRec.RESET;
        //     // GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //     // GenJournalLineRec.SETCURRENTKEY("Document No.");
        //     // GenJournalLineRec.SETRANGE("Journal Batch Name",GenJournalLine."Journal Batch Name");
        //     //GenJournalLineRec.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
        //     //  GenJournalLineRec.SETRANGE("Line No.",GenJournalLine."Line No.");
        //     //GenJournalLineRec.SETRANGE("Document No.",GenJournalLine."Document No.");
        //     //IF GenJournalLineRec.FIND('-') THEN BEGIN
        //     if (GLAcc.Get(Rec."Account No.")) or (Dimension.Get(Rec."Shortcut Dimension 1 Code", 'COST CENTER')) or (Rec."Amount (LCY)" <> 0) or
        //        FixedAsset.Get(Rec."Account No.") then begin
        //         //   IF PurchaseLineBudget.FINDLAST THEN BEGIN
        //         GLAccNo := GLAcc."No.";
        //         DimensionNo := Dimension.Code;
        //         FixedAssetNo := FixedAsset."No.";

        //         // REPEAT

        //         if (Rec."Account Type" = Rec."Account Type"::"Fixed Asset") and ((Rec."FA Posting Type" = Rec."FA Posting Type"::"Acquisition Cost") or
        //                      (Rec."FA Posting Type" = Rec."FA Posting Type"::Appreciation)) then
        //             ActualBudgetMothYearFixedasset(GenJournalLineRec)
        //         else begin


        //             GLAcc.Reset;
        //             GLAcc.SetRange(GLAcc."No.", GLAccNo);
        //             GLAcc.SetRange(GLAcc."Budget Controlled", true);
        //             if GLAcc.FindFirst then begin

        //                 Dimension.SetFilter(Dimension."Dimension Code", '%1', 'COST CENTER');
        //                 Dimension.SetRange(Dimension.Code, Rec."Shortcut Dimension 1 Code");
        //                 if Dimension.FindFirst then
        //                     DimensionNo := Rec."Shortcut Dimension 1 Code";
        //                 // MESSAGE(FORMAT(dimrec[i]));


        //                 //  MESSAGE(dimrec);





        //                 //To take care of the monthly budget

        //                 //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
        //                 begin
        //                     //Total sum of the the particular cost center on the Journal line
        //                     //GenJournalLine3.RESET;
        //                     // GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     //  GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                     //  GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                     //  GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     // PayLineAmount := Rec."Amount (LCY)";
        //                 end;


        //                 begin
        //                     //total sum of a particular G/l account on the payment line
        //                     // GenJournalLine3.RESET;
        //                     //  GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     //   GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                     // GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                     //  GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     PayLineAmountActual := Rec."Amount (LCY)";
        //                 end;

        //                 begin
        //                     //Total sum of the particular cost center in the g/l entry
        //                     // GlEntry.RESET;
        //                     // GlEntry.SETFILTER("Global Dimension 1 Code",DimensionNo);
        //                     // GlEntry.SETRANGE("Posting Date",StartDate,EndDate);
        //                     // GlEntry.CALCSUMS(Amount);
        //                     // GlEntryAmount := GlEntry.Amount;
        //                     //MESSAGE(FORMAT(GlEntryAmount));
        //                 end;

        //                 begin
        //                     //Total sum of the particular g/l account  in the g/l entry
        //                     GlEntry.Reset;
        //                     GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                     GlEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
        //                     GlEntry.CalcSums(Amount);
        //                     GlEntryAccountAmount := GlEntry.Amount;
        //                 end;


        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     //"G/LBudgetEntry".RESET;
        //                     //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                     //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartDate,EndDate);
        //                     //"G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                     //"G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;


        //                 begin
        //                     //Total sum of of particular g/l account in the budget entry
        //                     "G/LBudgetEntry".Reset;
        //                     "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                     "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
        //                     "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                     "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;


        //                 //total sum for the G/L account in the g/l entry and payment line
        //                 Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                 //Difference btw the actual gl account and budgeted amount
        //                 GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

        //                 //total sum for the costcenter in the g/l entry and payment line
        //                 //Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                 //Difference btw the actual cost center and budgeted amount
        //                 //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                 ///IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 //  ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN
        //                 if "G/LBudgetAccountAmount" < Totalamountglaccount then
        //                     Message(Text0059, "G/LBudgetAccountAmount", GLAccNo, Totalamountglaccount);

        //                 //END;

        //                 //to take care of the yearly budget

        //                 //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
        //                 begin
        //                     //Total sum of the the particular cost center on the payment line
        //                     //GenJournalLine3.RESET;
        //                     // GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     // GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                     //  GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                     //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                     //  PayLineAmount := Rec."Amount (LCY)";
        //                 end;

        //                 begin
        //                     //total sum of a particular G/l account on the payment line
        //                     // GenJournalLine3.RESET;
        //                     //// GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.");
        //                     // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                     // GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                     // GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                     // GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
        //                     PayLineAmountActual := Rec."Amount (LCY)";
        //                 end;

        //                 begin
        //                     //Total sum of the particular cost center in the g/l entry
        //                     //  GlEntry.RESET;
        //                     // GlEntry.SETFILTER("Global Dimension 1 Code",DimensionNo);
        //                     //GlEntry.SETRANGE("Posting Date",StartYear,EndYear);
        //                     //GlEntry.CALCSUMS(Amount);
        //                     //GlEntryAmount := GlEntry.Amount;
        //                     //MESSAGE(FORMAT(GlEntryAmount));
        //                 end;


        //                 begin
        //                     //Total sum of the particular g/l account  in the g/l entry
        //                     GlEntry.Reset;
        //                     GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                     GlEntry.SetRange("Posting Date", StartYear, EndYear);
        //                     GlEntry.CalcSums(Amount);
        //                     GlEntryAccountAmount := GlEntry.Amount;
        //                 end;
        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     //"G/LBudgetEntry".RESET;
        //                     //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                     //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
        //                     //"G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                     //"G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 begin
        //                     //Total sum  value of a particular cost center in the budget entry
        //                     //"G/LBudgetEntry".RESET;
        //                     // "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                     // "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
        //                     // "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                     // "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 begin
        //                     //Total sum of of particular g/l account in the budget entry
        //                     "G/LBudgetEntry".Reset;
        //                     "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                     "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
        //                     "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                     "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                     //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                 end;

        //                 //total sum for the G/L account in the g/l entry and payment line
        //                 Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                 //Difference btw the actual gl account and budgeted amount
        //                 GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

        //                 //total sum for the costcenter in the g/l entry and payment line
        //                 //Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                 //Difference btw the actual cost center and budgeted amount
        //                 //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                 //MESSAGE(Text005,"G/LBudgetEntryAmount",dimrec,Totalamountexceed,"G/LBudgetAccountAmount",PayLinebudget2."Account No.",Totalamountglaccount);
        //                 //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 //  ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                 //((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN
        //                 if "G/LBudgetAccountAmount" < Totalamountglaccount then
        //                     Message(Text0060, "G/LBudgetAccountAmount", GLAccNo, Totalamountglaccount);
        //                 //END;
        //             end;








        //         end;

        //         //UNTIL GenJournalLineRec.NEXT = 0;
        //     end;
        //     //END;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'Shortcut Dimension 2 Code', false, false)]
    procedure GenJourLineValidateDimension2(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        //     //WITH GenJournalLine DO BEGIN
        //     if Rec."Shortcut Dimension 2 Code" <> '' then begin
        //         Daterec := Rec."Posting Date";
        //         //dimrec :='';
        //         StartDate := CalcDate('<-CM>', Daterec);
        //         EndDate := CalcDate('<CM>', Daterec);
        //         StartYear := CalcDate('<-CY>', Daterec);
        //         EndYear := CalcDate('<CY>', Daterec);

        //         DimName := 'PROFIT CENTER';






        //         //MESSAGE(FORMAT(i));
        //         PayLineAmount := 0;
        //         GlEntryAmount := 0;
        //         "G/LBudgetEntryAmount" := 0;
        //         "G/LBudgetAccountAmount" := 0;
        //         PayLineAmountActual := 0;
        //         Totalamountglaccount := 0;
        //         GlaccBudgetAmountDiff := 0;
        //         Totalamount := 0;



        //         //GenJournalLineNew.RESET;
        //         //GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //         // GenJournalLineNewJ5.SETFILTER("Journal Batch Name","Journal Batch Name");
        //         //GenJournalLineNewJ5.SETFILTER("Journal Template Name","Journal Template Name");
        //         //GenJournalLineRec.SETRANGE("Journal Template Name","Journal Template Name");
        //         //GenJournalLineRec.SETRANGE("Line No.","Line No.");
        //         //GenJournalLineNew.SETCURRENTKEY("Document No.");
        //         GenJournalLineNew.SetRange("Document No.", Rec."Document No.");
        //         if GenJournalLineNew.Find('-') then begin
        //             BatchName := GenJournalLineNew."Journal Batch Name";
        //             TemplateBatch := GenJournalLineNew."Journal Template Name";
        //         end;

        //         //GenJournalLineRec.RESET;
        //         // GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        //         // GenJournalLineRec.SETCURRENTKEY("Document No.");
        //         // GenJournalLineRec.SETRANGE("Journal Batch Name",GenJournalLine."Journal Batch Name");
        //         //GenJournalLineRec.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
        //         //  GenJournalLineRec.SETRANGE("Line No.",GenJournalLine."Line No.");
        //         //GenJournalLineRec.SETRANGE("Document No.",GenJournalLine."Document No.");
        //         //IF GenJournalLineRec.FIND('-') THEN BEGIN
        //         if (GLAcc.Get(Rec."Account No.")) or (Dimension.Get(Rec."Shortcut Dimension 2 Code", 'PROFIT CENTER')) or (Rec."Amount (LCY)" <> 0) or
        //            FixedAsset.Get(Rec."Account No.") then begin
        //             //   IF PurchaseLineBudget.FINDLAST THEN BEGIN
        //             GLAccNo := GLAcc."No.";
        //             DimensionNo := Dimension.Code;
        //             FixedAssetNo := FixedAsset."No.";

        //             // REPEAT

        //             if (Rec."Account Type" = Rec."Account Type"::"Fixed Asset") and ((Rec."FA Posting Type" = Rec."FA Posting Type"::"Acquisition Cost") or
        //                          (Rec."FA Posting Type" = Rec."FA Posting Type"::Appreciation)) then
        //                 ActualBudgetMothYearFixedasset(GenJournalLineRec)
        //             else begin


        //                 GLAcc.Reset;
        //                 GLAcc.SetRange(GLAcc."No.", GLAccNo);
        //                 GLAcc.SetRange(GLAcc."Budget Controlled", true);
        //                 if GLAcc.FindFirst then begin

        //                     Dimension.SetFilter(Dimension."Dimension Code", '%1', 'PROFIT CENTER');
        //                     Dimension.SetRange(Dimension.Code, Rec."Shortcut Dimension 2 Code");
        //                     if Dimension.FindFirst then
        //                         DimensionNo := Dimension.Code;
        //                     // MESSAGE(FORMAT(dimrec[i]));


        //                     //  MESSAGE(dimrec);





        //                     //To take care of the monthly budget

        //                     //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
        //                     begin
        //                         //Total sum of the the particular cost center on the Journal line
        //                         //GenJournalLine3.RESET;
        //                         //GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                         //GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                         //GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                         //GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                         //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                         // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                         //PayLineAmount := Rec."Amount (LCY)";
        //                     end;


        //                     begin
        //                         //total sum of a particular G/l account on the payment line
        //                         // GenJournalLine3.RESET;
        //                         // GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.","Shortcut Dimension 1 Code");
        //                         // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                         // GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                         // GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                         // GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                         // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                         PayLineAmountActual := Rec."Amount (LCY)";
        //                     end;

        //                     begin
        //                         //Total sum of the particular cost center in the g/l entry
        //                         //GlEntry.RESET;
        //                         //GlEntry.SETFILTER("Global Dimension 1 Code",DimensionNo);
        //                         // GlEntry.SETRANGE("G/L Account No.",GLAccNo);
        //                         // GlEntry.SETRANGE("Posting Date",StartDate,EndDate);
        //                         // GlEntry.CALCSUMS(Amount);
        //                         // GlEntryAmount := GlEntry.Amount;
        //                         //MESSAGE(FORMAT(GlEntryAmount));
        //                     end;

        //                     begin
        //                         //Total sum of the particular g/l account  in the g/l entry
        //                         GlEntry.Reset;
        //                         GlEntry.SetFilter("Global Dimension 2 Code", DimensionNo);
        //                         GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                         GlEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
        //                         GlEntry.CalcSums(Amount);
        //                         GlEntryAccountAmount := GlEntry.Amount;
        //                     end;


        //                     begin
        //                         //Total sum  value of a particular cost center in the budget entry
        //                         "G/LBudgetEntry".Reset;
        //                         "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 2 Code", DimensionNo);
        //                         "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
        //                         "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                         "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                         "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                         //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                     end;


        //                     begin
        //                         //Total sum of of particular g/l account in the budget entry
        //                         //"G/LBudgetEntry".RESET;
        //                         // "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.",GLAccNo);
        //                         // "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                         // "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartDate,EndDate);
        //                         // "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                         // "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                         //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                     end;


        //                     //total sum for the G/L account in the g/l entry and payment line
        //                     Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                     //Difference btw the actual gl account and budgeted amount
        //                     GlaccBudgetAmountDiff := "G/LBudgetEntryAmount" - Totalamountglaccount;
        //                     //MESSAGE(FORMAT(PayLineAmountActual));


        //                     //total sum for the costcenter in the g/l entry and payment line
        //                     //Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                     //Difference btw the actual cost center and budgeted amount
        //                     //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                     //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                     // ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                     //((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN
        //                     if ("G/LBudgetEntryAmount" < Totalamountglaccount) then
        //                         Message(Text0057, DimName, "G/LBudgetEntryAmount", DimName, DimensionNo, GLAccNo, Totalamountglaccount);

        //                     //END;

        //                     //to take care of the yearly budget

        //                     //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
        //                     begin
        //                         //Total sum of the the particular cost center on the payment line
        //                         // GenJournalLine3.RESET;
        //                         // GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 1 Code","Journal Batch Name","Journal Template Name");
        //                         // GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                         // GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionNo);
        //                         //GenJournalLine3.SETRANGE("Journal Template Name",TemplateBatch);
        //                         //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
        //                         // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
        //                         //  PayLineAmount := Rec."Amount (LCY)";
        //                     end;

        //                     begin
        //                         //total sum of a particular G/l account on the payment line
        //                         // GenJournalLine3.RESET;
        //                         //GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.");
        //                         //GenJournalLine3.SETRANGE("Journal Batch Name",BatchName);
        //                         //GenJournalLine3.SETFILTER("Journal Template Name",TemplateBatch);
        //                         //GenJournalLine3.SETFILTER("Account No.",GLAccNo);
        //                         //GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
        //                         PayLineAmountActual := Rec."Amount (LCY)";
        //                     end;

        //                     begin
        //                         //Total sum of the particular cost center in the g/l entry
        //                         //GlEntry.RESET;
        //                         //GlEntry.SETFILTER("Global Dimension 1 Code",DimensionNo);
        //                         //GlEntry.SETRANGE("G/L Account No.",GLAccNo);
        //                         // GlEntry.SETRANGE("Posting Date",StartYear,EndYear);
        //                         //GlEntry.CALCSUMS(Amount);
        //                         //GlEntryAmount := GlEntry.Amount;
        //                         //MESSAGE(FORMAT(GlEntryAmount));
        //                     end;


        //                     begin
        //                         //Total sum of the particular g/l account  in the g/l entry
        //                         GlEntry.Reset;
        //                         GlEntry.SetFilter("Global Dimension 2 Code", DimensionNo);
        //                         GlEntry.SetRange("G/L Account No.", GLAccNo);
        //                         GlEntry.SetRange("Posting Date", StartYear, EndYear);
        //                         GlEntry.CalcSums(Amount);
        //                         GlEntryAccountAmount := GlEntry.Amount;
        //                     end;
        //                     begin
        //                         //Total sum  value of a particular cost center in the budget entry
        //                         "G/LBudgetEntry".Reset;
        //                         "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 2 Code", DimensionNo);
        //                         "G/LBudgetEntry".SetRange("G/LBudgetEntry"."G/L Account No.", GLAccNo);
        //                         "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
        //                         "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
        //                         "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                         //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                     end;

        //                     begin
        //                         //Total sum  value of a particular cost center in the budget entry
        //                         //"G/LBudgetEntry".RESET;
        //                         //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code",DimensionNo);
        //                         //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
        //                         // "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                         //"G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
        //                         //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                     end;

        //                     begin
        //                         //Total sum of of particular g/l account in the budget entry
        //                         // "G/LBudgetEntry".RESET;
        //                         //  "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.",GLAccNo);
        //                         //  "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
        //                         //  "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
        //                         //  "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
        //                         //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
        //                     end;

        //                     //total sum for the G/L account in the g/l entry and payment line
        //                     Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

        //                     //Difference btw the actual gl account and budgeted amount
        //                     GlaccBudgetAmountDiff := "G/LBudgetEntryAmount" - Totalamountglaccount;

        //                     if ("G/LBudgetEntryAmount" < Totalamountglaccount) then
        //                         Message(Text0058, DimName, "G/LBudgetEntryAmount", DimName, DimensionNo, GLAccNo, Totalamountglaccount);

        //                     //total sum for the costcenter in the g/l entry and payment line
        //                     //Totalamountexceed := PayLineAmount + GlEntryAmount;

        //                     //Difference btw the actual cost center and budgeted amount
        //                     //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

        //                     //MESSAGE(Text005,"G/LBudgetEntryAmount",dimrec,Totalamountexceed,"G/LBudgetAccountAmount",PayLinebudget2."Account No.",Totalamountglaccount);
        //                     //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                     // ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
        //                     // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN

        //                     //MESSAGE(Text0056,"G/LBudgetEntryAmount",DimensionNo,Totalamountexceed,"G/LBudgetAccountAmount",GLAccNo,Totalamountglaccount);
        //                     //END;
        //                 end;








        //             end;

        //             //UNTIL GenJournalLineRec.NEXT = 0;
        //         end;
        //     end;
    end;

    procedure PurchaseLineDime1(PurchaseHeader: Record "Purchase Header")
    begin
        if PurchaseHeader."Posting Date" = 0D then
            Daterec := PurchaseHeader."Order Date"
        else
            Daterec := PurchaseHeader."Posting Date";

        //DimName := 'DEPARTMENT';

        //PurchHeader.SETRANGE("No.",PurchaseHeader."No.");
        //IF PurchHeader.FINDFIRST THEN
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

        //PurchaseLineDime1(PurchaseHeader);


        DimensionTemporary.RESET;
        DimensionTemporary.SETRANGE("Dimension Code");
        DimensionTemporary.SETRANGE("Dimension name");
        DimensionTemporary.SETRANGE("Global Dimension No", 3);
        IF DimensionTemporary.FINDFIRST THEN
            REPEAT

                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", DimensionTemporary."Account No.");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN





                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        PurchaseLineBudget2.RESET;
                        PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                        PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", PurchaseHeader."No.");
                        PurchaseLineBudget2.SETFILTER("No.", DimensionTemporary."Account No.");
                        PurchaseLineBudget2.SETFILTER("Shortcut Dimension 3 Code", DimensionTemporary."Dimension Code");
                        PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                        PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                        // MESSAGE(FORMAT(PayLineAmountActual));
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 3 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);

                        GlEntryAccountAmount := GlEntry.Amount;
                    END;





                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 1 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //  MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;



                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        PurchaseLineBudget2.RESET;
                        PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                        PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", PurchaseHeader."No.");
                        PurchaseLineBudget2.SETFILTER("Shortcut Dimension 3 Code", DimensionTemporary."Dimension Code");
                        PurchaseLineBudget2.SETFILTER("No.", DimensionTemporary."Account No.");
                        PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                        PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETFILTER("Shortcut Dimension 3 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;



                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 1 Code", DimensionTemporary."Dimension Code");
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
                    //Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    ///IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    //  ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                    // IF ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN
                    //     MESSAGE(Text0058, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", PurchaseLineBudget."No.", Totalamountglaccount)
                    // ELSE
                    //     IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                    //         ERROR(Text0058, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", DimensionTemporary."Account No.", Totalamountglaccount); //Gbenga



                    //  END
                END;
            UNTIL DimensionTemporary.NEXT = 0;
        //END;

        //end;

    end;

    procedure PurchaseLineDime2(PurchaseHeader: Record "Purchase Header")
    begin

        if PurchaseHeader."Posting Date" = 0D then
            Daterec := PurchaseHeader."Order Date"
        else
            Daterec := PurchaseHeader."Posting Date";


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

        //PurchaseLineDime1(PurchaseHeader);


        DimensionTemporary.RESET;
        DimensionTemporary.SETRANGE("Dimension Code");
        DimensionTemporary.SETRANGE("Dimension name");
        DimensionTemporary.SETRANGE("Global Dimension No", 2);
        IF DimensionTemporary.FINDFIRST THEN
            REPEAT





                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", DimensionTemporary."Account No.");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN






                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        PurchaseLineBudget2.RESET;
                        PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                        PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", PurchaseHeader."No.");
                        PurchaseLineBudget2.SETFILTER("No.", DimensionTemporary."Account No.");
                        PurchaseLineBudget2.SETFILTER("Shortcut Dimension 2 Code", DimensionTemporary."Dimension Code");
                        PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                        PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                        //MESSAGE(FORMAT(PayLineAmountActual));
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Global Dimension 2 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);

                        GlEntryAccountAmount := GlEntry.Amount;
                    END;






                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        // MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                    //total sum for the costcenter in the g/l entry and payment line
                    //Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    //  ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                    //  MESSAGE(Text0055, "G/LBudgetEntryAmount", dimrec, Totalamountexceed, "G/LBudgetAccountAmount", PurchaseLineBudget."No.", Totalamountglaccount);
                    //  IF ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN
                    //      MESSAGE(Text0057, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", DimensionTemporary."Account No.", Totalamountglaccount)

                    //   ELSE
                    //to  IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                    //to    ERROR(Text0057, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", DimensionTemporary."Account No.", Totalamountglaccount);
                    //IF "G/LBudgetAccountAmount" < Totalamountglaccount THEN
                    // MESSAGE(Text0057, "G/LBudgetAccountAmount", dimrec,PurchaseLineBudget."No.", Totalamountglaccount);



                    //END;





                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        PurchaseLineBudget2.RESET;
                        PurchaseLineBudget2.SETCURRENTKEY("Document No.", "No.");
                        PurchaseLineBudget2.SETRANGE(PurchaseLineBudget2."Document No.", PurchaseHeader."No.");
                        PurchaseLineBudget2.SETFILTER("Shortcut Dimension 2 Code", DimensionTemporary."Dimension Code");
                        PurchaseLineBudget2.SETFILTER("No.", DimensionTemporary."Account No.");
                        PurchaseLineBudget2.CALCSUMS(PurchaseLineBudget2."Amount Including VAT");
                        PayLineAmountActual := PurchaseLineBudget2."Amount Including VAT";
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETFILTER("Global Dimension 2 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;




                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code", DimensionTemporary."Dimension Code");
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
                    //Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    ///IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    //  ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                    //IF "G/LBudgetAccountAmount" < Totalamountglaccount THEN
                    // MESSAGE(Text0058, "G/LBudgetAccountAmount", dimrec,PurchaseLineBudget."No.", Totalamountglaccount);
                    // IF ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN
                    //to   MESSAGE(Text0058, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", PurchaseLineBudget."No.", Totalamountglaccount)
                    //  ELSE
                    //    IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                    //       ERROR(Text0058, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", PurchaseLineBudget."No.", Totalamountglaccount);
                    //  END
                END;
            UNTIL DimensionTemporary.NEXT = 0;

        DimensionTemporary.DELETEALL;


    end;

    procedure GenJourLineCheckDimension2(GenJournalLine: Record "Gen. Journal Line")
    begin
        //  with GenJournalLine do begin
        Daterec := GenJournalLine."Posting Date";
        //dimrec :='';
        StartDate := CalcDate('<-CM>', Daterec);
        EndDate := CalcDate('<CM>', Daterec);
        StartYear := CalcDate('<-CY>', Daterec);
        EndYear := CalcDate('<CY>', Daterec);

        //MESSAGE(FORMAT(i));
        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;

        //  GenJourLineCheckDimension1(GenJournalLine);


        //GenJournalLineNew.RESET;
        //GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        // GenJournalLineNewJ5.SETFILTER("Journal Batch Name","Journal Batch Name");
        //GenJournalLineNewJ5.SETFILTER("Journal Template Name","Journal Template Name");
        //GenJournalLineRec.SETRANGE("Journal Template Name","Journal Template Name");
        //GenJournalLineRec.SETRANGE("Line No.","Line No.");
        //GenJournalLineNew.SETCURRENTKEY("Document No.");
        GenJournalLineNew.SetRange("Document No.", GenJournalLine."Document No.");
        if GenJournalLineNew.Find('-') then begin
            BatchName := GenJournalLineNew."Journal Batch Name";
            TemplateBatch := GenJournalLineNew."Journal Template Name";
        end;

        GenJournalLineRec.Reset;
        GenJournalLineRec.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        // GenJournalLineRec.SETCURRENTKEY("Document No.");
        GenJournalLineRec.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJournalLineRec.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        //  GenJournalLineRec.SETRANGE("Line No.",GenJournalLine."Line No.");
        //GenJournalLineRec.SETRANGE("Document No.",GenJournalLine."Document No.");
        if GenJournalLineRec.Find('-') then begin
            repeat




                if (GenJournalLineRec."Account Type" = GenJournalLineRec."Account Type"::"Fixed Asset") and ((GenJournalLineRec."FA Posting Type" = GenJournalLineRec."FA Posting Type"::"Acquisition Cost") or
                             (GenJournalLineRec."FA Posting Type" = GenJournalLineRec."FA Posting Type"::Appreciation)) then
                    ActualBudgetMothYearFixedasset(GenJournalLineRec)
                else begin


                    GLAcc.Reset;
                    GLAcc.SetRange(GLAcc."No.", GenJournalLineRec."Account No.");
                    GLAcc.SetRange(GLAcc."Budget Controlled", true);
                    if GLAcc.FindFirst then begin

                        Dimension.SetFilter(Dimension."Dimension Code", '%1', 'PROFIT CENTER');
                        Dimension.SetRange(Dimension.Code, GenJournalLineRec."Shortcut Dimension 2 Code");
                        if Dimension.FindFirst then
                            dimrec2 := GenJournalLineRec."Shortcut Dimension 2 Code";
                        // MESSAGE(FORMAT(dimrec[i]));


                        //  MESSAGE(dimrec);


                        DimName := 'PROFIT CENTER';


                        //To take care of the monthly budget

                        //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
                        begin
                            //Total sum of the the particular cost center on the payment line
                            //GenJournalLine3.RESET;
                            //// GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 2 Code","Journal Batch Name","Journal Template Name");
                            // GenJournalLine3.SETRANGE("Journal Batch Name",GenJournalLineRec."Journal Batch Name");
                            // GenJournalLine3.SETFILTER("Shortcut Dimension 2 Code",dimrec2);
                            // GenJournalLine3.SETRANGE("Journal Template Name",GenJournalLineRec."Journal Template Name");
                            //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
                            // GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
                            //  PayLineAmount := GenJournalLine3.Amount;
                        end;


                        begin
                            //total sum of a particular G/l account on the payment line
                            GenJournalLine3.Reset;
                            GenJournalLine3.SetCurrentKey("Journal Batch Name", "Journal Template Name", "Account No.", "Shortcut Dimension 2 Code");
                            GenJournalLine3.SetRange("Journal Batch Name", GenJournalLineRec."Journal Batch Name");
                            GenJournalLine3.SetFilter("Shortcut Dimension 2 Code", dimrec2);
                            GenJournalLine3.SetFilter("Journal Template Name", GenJournalLineRec."Journal Template Name");
                            GenJournalLine3.SetFilter("Account No.", GenJournalLineRec."Account No.");
                            GenJournalLine3.CalcSums(GenJournalLine3.Amount);
                            PayLineAmountActual := GenJournalLine3.Amount;
                        end;

                        begin
                            //Total sum of the particular cost center in the g/l entry
                            //  GlEntry.RESET;
                            //   GlEntry.SETFILTER("Global Dimension 2 Code",dimrec2);
                            //  GlEntry.SETRANGE("Posting Date",StartDate,EndDate);
                            //  GlEntry.CALCSUMS(Amount);
                            //   GlEntryAmount := GlEntry.Amount;
                            //MESSAGE(FORMAT(GlEntryAmount));
                        end;

                        begin
                            //Total sum of the particular g/l account  in the g/l entry
                            GlEntry.Reset;
                            GlEntry.SetRange("G/L Account No.", GenJournalLineRec."Account No.");
                            GlEntry.SetFilter("Global Dimension 2 Code", dimrec2);
                            GlEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                            GlEntry.CalcSums(Amount);
                            GlEntryAccountAmount := GlEntry.Amount;
                        end;


                        begin
                            //Total sum  value of a particular cost center in the budget entry
                            // "G/LBudgetEntry".RESET;
                            // "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code",dimrec2);
                            // "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartDate,EndDate);
                            // "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            // "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        end;


                        begin
                            //Total sum of of particular g/l account in the budget entry
                            "G/LBudgetEntry".Reset;
                            "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GenJournalLineRec."Account No.");
                            "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 2 Code", dimrec2);
                            "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
                            "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                            "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        end;


                        //total sum for the G/L account in the g/l entry and payment line
                        Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                        //Difference btw the actual gl account and budgeted amount
                        GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                        //total sum for the costcenter in the g/l entry and payment line
                        //Totalamountexceed := PayLineAmount + GlEntryAmount;

                        //Difference btw the actual cost center and budgeted amount
                        //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                        //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
                        //  ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
                        // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN
                        if ("G/LBudgetAccountAmount" < Totalamountglaccount) and (ApproveBatch <> '') then
                            Message(Text0057, DimName, "G/LBudgetAccountAmount", DimName, dimrec2, GenJournalLineRec."Account No.", Totalamountglaccount)

                        else
                            if "G/LBudgetAccountAmount" > Totalamountglaccount then
                                Error(Text0057, DimName, "G/LBudgetAccountAmount", DimName, dimrec2, GenJournalLineRec."Account No.", Totalamountglaccount);

                        //MESSAGE(Text0055,"G/LBudgetEntryAmount",dimrec2,Totalamountexceed,"G/LBudgetAccountAmount",GenJournalLineRec."Account No.",Totalamountglaccount);

                        //END;

                        //to take care of the yearly budget

                        //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
                        begin
                            //Total sum of the the particular cost center on the payment line
                            // GenJournalLine3.RESET;
                            // GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 2 Code","Journal Batch Name","Journal Template Name","Account No.");
                            // GenJournalLine3.SETRANGE("Journal Batch Name",GenJournalLineRec."Journal Batch Name");
                            // GenJournalLine3.SETFILTER("Shortcut Dimension 2 Code",dimrec2);
                            // GenJournalLine3.SETRANGE("Account No.",GenJournalLineRec."Account No.");
                            // GenJournalLine3.SETRANGE("Journal Template Name",GenJournalLineRec."Journal Template Name");
                            //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
                            // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
                            // PayLineAmount := GenJournalLine3."Amount (LCY)";
                        end;

                        begin
                            //total sum of a particular G/l account on the payment line
                            GenJournalLine3.Reset;
                            GenJournalLine3.SetCurrentKey("Shortcut Dimension 2 Code", "Journal Batch Name", "Journal Template Name", "Account No.");
                            GenJournalLine3.SetRange("Journal Batch Name", GenJournalLineRec."Journal Batch Name");
                            GenJournalLine3.SetFilter("Shortcut Dimension 2 Code", dimrec2);
                            GenJournalLine3.SetFilter("Journal Template Name", GenJournalLineRec."Journal Template Name");
                            GenJournalLine3.SetFilter("Account No.", GenJournalLineRec."Account No.");
                            GenJournalLine3.CalcSums(GenJournalLine3."Amount (LCY)");
                            PayLineAmountActual := GenJournalLine3."Amount (LCY)";
                        end;

                        begin
                            //Total sum of the particular cost center in the g/l entry
                            //  GlEntry.RESET;
                            // GlEntry.SETFILTER("Global Dimension 2 Code",dimrec2);
                            // GlEntry.SETRANGE("Posting Date",StartYear,EndYear);
                            // GlEntry.CALCSUMS(Amount);
                            // GlEntryAmount := GlEntry.Amount;
                            //MESSAGE(FORMAT(GlEntryAmount));
                        end;


                        begin
                            //Total sum of the particular g/l account  in the g/l entry
                            GlEntry.Reset;
                            GlEntry.SetRange("G/L Account No.", GenJournalLineRec."Account No.");
                            GlEntry.SetFilter("Global Dimension 2 Code", dimrec2);
                            GlEntry.SetRange("Posting Date", StartYear, EndYear);
                            GlEntry.CalcSums(Amount);
                            GlEntryAccountAmount := GlEntry.Amount;
                        end;
                        begin
                            //Total sum  value of a particular cost center in the budget entry
                            //"G/LBudgetEntry".RESET;
                            //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code",dimrec2);
                            //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
                            //"G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            //"G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        end;

                        begin
                            //Total sum  value of a particular cost center in the budget entry
                            //  "G/LBudgetEntry".RESET;
                            //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code",dimrec2);
                            //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
                            // "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            // "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        end;

                        begin
                            //Total sum of of particular g/l account in the budget entry
                            "G/LBudgetEntry".Reset;
                            "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GenJournalLineRec."Account No.");
                            "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 2 Code", dimrec2);
                            "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
                            "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                            "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        end;

                        //total sum for the G/L account in the g/l entry and payment line
                        Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                        //Difference btw the actual gl account and budgeted amount
                        GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                        //total sum for the costcenter in the g/l entry and payment line
                        //Totalamountexceed := PayLineAmount + GlEntryAmount;

                        //Difference btw the actual cost center and budgeted amount
                        //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                        //MESSAGE(Text005,"G/LBudgetEntryAmount",dimrec,Totalamountexceed,"G/LBudgetAccountAmount",PayLinebudget2."Account No.",Totalamountglaccount);
                        //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
                        // ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
                        //((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN




                        if ("G/LBudgetAccountAmount" < Totalamountglaccount) and (ApproveBatch <> '') then
                            Message(Text0058, DimName, "G/LBudgetAccountAmount", DimName, dimrec2, GenJournalLineRec."Account No.", Totalamountglaccount)
                        else
                            if "G/LBudgetAccountAmount" > Totalamountglaccount then
                                Error(Text0058, DimName, "G/LBudgetAccountAmount", DimName, dimrec2, GenJournalLineRec."Account No.", Totalamountglaccount);



                    end;








                end;

            until GenJournalLineRec.Next = 0;
        end;
    end;


    procedure GenJourLineCheckDimension1(GenJournalLine: Record "Gen. Journal Line")
    begin
        // with GenJournalLine do begin
        Daterec := GenJournalLine."Posting Date";
        //dimrec :='';
        StartDate := CalcDate('<-CM>', Daterec);
        EndDate := CalcDate('<CM>', Daterec);
        StartYear := CalcDate('<-CY>', Daterec);
        EndYear := CalcDate('<CY>', Daterec);

        DimName := 'COST CENTER';

        //MESSAGE(FORMAT(i));
        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;

        //  GenJourLineCheckDimension1(GenJournalLine);


        //GenJournalLineNew.RESET;
        //GenJournalLineRec.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        // GenJournalLineNewJ5.SETFILTER("Journal Batch Name","Journal Batch Name");
        //GenJournalLineNewJ5.SETFILTER("Journal Template Name","Journal Template Name");
        //GenJournalLineRec.SETRANGE("Journal Template Name","Journal Template Name");
        //GenJournalLineRec.SETRANGE("Line No.","Line No.");
        //GenJournalLineNew.SETCURRENTKEY("Document No.");
        GenJournalLineNew.SetRange("Document No.", GenJournalLine."Document No.");
        if GenJournalLineNew.Find('-') then begin
            BatchName := GenJournalLineNew."Journal Batch Name";
            TemplateBatch := GenJournalLineNew."Journal Template Name";
        end;

        GenJournalLineRec.Reset;
        GenJournalLineRec.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        // GenJournalLineRec.SETCURRENTKEY("Document No.");
        GenJournalLineRec.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJournalLineRec.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        //  GenJournalLineRec.SETRANGE("Line No.",GenJournalLine."Line No.");
        //GenJournalLineRec.SETRANGE("Document No.",GenJournalLine."Document No.");
        if GenJournalLineRec.Find('-') then begin
            repeat




                if (GenJournalLineRec."Account Type" = GenJournalLineRec."Account Type"::"Fixed Asset") and ((GenJournalLineRec."FA Posting Type" = GenJournalLineRec."FA Posting Type"::"Acquisition Cost") or
                             (GenJournalLineRec."FA Posting Type" = GenJournalLineRec."FA Posting Type"::Appreciation)) then
                    ActualBudgetMothYearFixedasset(GenJournalLineRec)
                else begin


                    GLAcc.Reset;
                    GLAcc.SetRange(GLAcc."No.", GenJournalLineRec."Account No.");
                    GLAcc.SetRange(GLAcc."Budget Controlled", true);
                    if GLAcc.FindFirst then begin

                        Dimension.SetFilter(Dimension."Dimension Code", '%1', 'COST CENTER');
                        Dimension.SetRange(Dimension.Code, GenJournalLineRec."Shortcut Dimension 1 Code");
                        if Dimension.FindFirst then
                            dimrec := Dimension.Code;
                        // MESSAGE(FORMAT(dimrec[i]));


                        //  MESSAGE(dimrec);





                        //To take care of the monthly budget

                        //IF (Daterec > StartDate) AND (Daterec < EndDate) THEN BEGIN
                        begin
                            //Total sum of the the particular cost center on the payment line
                            //GenJournalLine3.RESET;
                            //// GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 2 Code","Journal Batch Name","Journal Template Name");
                            // GenJournalLine3.SETRANGE("Journal Batch Name",GenJournalLineRec."Journal Batch Name");
                            // GenJournalLine3.SETFILTER("Shortcut Dimension 2 Code",dimrec2);
                            // GenJournalLine3.SETRANGE("Journal Template Name",GenJournalLineRec."Journal Template Name");
                            //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
                            // GenJournalLine3.CALCSUMS(GenJournalLine3.Amount);
                            //  PayLineAmount := GenJournalLine3.Amount;
                        end;


                        begin
                            //total sum of a particular G/l account on the payment line
                            GenJournalLine3.Reset;
                            GenJournalLine3.SetCurrentKey("Journal Batch Name", "Journal Template Name", "Account No.", "Shortcut Dimension 1 Code");
                            GenJournalLine3.SetRange("Journal Batch Name", GenJournalLineRec."Journal Batch Name");
                            GenJournalLine3.SetFilter("Shortcut Dimension 1 Code", dimrec);
                            GenJournalLine3.SetFilter("Journal Template Name", GenJournalLineRec."Journal Template Name");
                            GenJournalLine3.SetFilter("Account No.", GenJournalLineRec."Account No.");
                            GenJournalLine3.CalcSums(GenJournalLine3."Amount (LCY)");
                            PayLineAmountActual := GenJournalLine3."Amount (LCY)";
                        end;

                        begin
                            //Total sum of the particular cost center in the g/l entry
                            //  GlEntry.RESET;
                            //   GlEntry.SETFILTER("Global Dimension 2 Code",dimrec2);
                            //  GlEntry.SETRANGE("Posting Date",StartDate,EndDate);
                            //  GlEntry.CALCSUMS(Amount);
                            //   GlEntryAmount := GlEntry.Amount;
                            //MESSAGE(FORMAT(GlEntryAmount));
                        end;

                        begin
                            //Total sum of the particular g/l account  in the g/l entry
                            GlEntry.Reset;
                            GlEntry.SetRange("G/L Account No.", GenJournalLineRec."Account No.");
                            GlEntry.SetFilter("Global Dimension 1 Code", dimrec);
                            GlEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                            GlEntry.CalcSums(Amount);
                            GlEntryAccountAmount := GlEntry.Amount;
                        end;


                        begin
                            //Total sum  value of a particular cost center in the budget entry
                            // "G/LBudgetEntry".RESET;
                            // "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code",dimrec2);
                            // "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartDate,EndDate);
                            // "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            // "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        end;


                        begin
                            //Total sum of of particular g/l account in the budget entry
                            "G/LBudgetEntry".Reset;
                            "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GenJournalLine."Account No.");
                            "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                            "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartDate, EndDate);
                            "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                            "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        end;


                        //total sum for the G/L account in the g/l entry and payment line
                        Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                        //Difference btw the actual gl account and budgeted amount
                        GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                        //total sum for the costcenter in the g/l entry and payment line
                        //Totalamountexceed := PayLineAmount + GlEntryAmount;

                        //Difference btw the actual cost center and budgeted amount
                        //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                        //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
                        //  ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
                        // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN
                        if ("G/LBudgetAccountAmount" < Totalamountglaccount) and (ApproveBatch <> '') then
                            Message(Text0057, DimName, "G/LBudgetAccountAmount", DimName, dimrec, GenJournalLineRec."Account No.", Totalamountglaccount)
                        else

                            if ("G/LBudgetAccountAmount" < Totalamountglaccount) then
                                Error(Text0057, DimName, "G/LBudgetAccountAmount", DimName, dimrec, GenJournalLineRec."Account No.", Totalamountglaccount);

                        //MESSAGE(Text0055,"G/LBudgetEntryAmount",dimrec2,Totalamountexceed,"G/LBudgetAccountAmount",GenJournalLineRec."Account No.",Totalamountglaccount);

                        //END;

                        //to take care of the yearly budget

                        //IF (Daterec > StartYear) AND (Daterec < EndYear) THEN BEGIN
                        begin
                            //Total sum of the the particular cost center on the payment line
                            // GenJournalLine3.RESET;
                            // GenJournalLine3.SETCURRENTKEY("Shortcut Dimension 2 Code","Journal Batch Name","Journal Template Name","Account No.");
                            // GenJournalLine3.SETRANGE("Journal Batch Name",GenJournalLineRec."Journal Batch Name");
                            // GenJournalLine3.SETFILTER("Shortcut Dimension 2 Code",dimrec2);
                            // GenJournalLine3.SETRANGE("Account No.",GenJournalLineRec."Account No.");
                            // GenJournalLine3.SETRANGE("Journal Template Name",GenJournalLineRec."Journal Template Name");
                            //GenJournalLine3.SETRANGE("Posting Date",StartDate,EndDate);
                            // GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
                            // PayLineAmount := GenJournalLine3."Amount (LCY)";
                        end;

                        begin
                            //total sum of a particular G/l account on the payment line
                            GenJournalLine3.Reset;
                            GenJournalLine3.SetCurrentKey("Shortcut Dimension 1 Code", "Journal Batch Name", "Journal Template Name", "Account No.");
                            GenJournalLine3.SetRange("Journal Batch Name", GenJournalLineRec."Journal Batch Name");
                            GenJournalLine3.SetFilter("Shortcut Dimension 1 Code", dimrec);
                            GenJournalLine3.SetFilter("Journal Template Name", GenJournalLineRec."Journal Template Name");
                            GenJournalLine3.SetFilter("Account No.", GenJournalLineRec."Account No.");
                            GenJournalLine3.CalcSums(GenJournalLine3."Amount (LCY)");
                            PayLineAmountActual := GenJournalLine3."Amount (LCY)";
                        end;

                        begin
                            //Total sum of the particular cost center in the g/l entry
                            //  GlEntry.RESET;
                            // GlEntry.SETFILTER("Global Dimension 2 Code",dimrec2);
                            // GlEntry.SETRANGE("Posting Date",StartYear,EndYear);
                            // GlEntry.CALCSUMS(Amount);
                            // GlEntryAmount := GlEntry.Amount;
                            //MESSAGE(FORMAT(GlEntryAmount));
                        end;


                        begin
                            //Total sum of the particular g/l account  in the g/l entry
                            GlEntry.Reset;
                            GlEntry.SetRange("G/L Account No.", GenJournalLineRec."Account No.");
                            GlEntry.SetFilter("Global Dimension 1 Code", dimrec);
                            GlEntry.SetRange("Posting Date", StartYear, EndYear);
                            GlEntry.CalcSums(Amount);
                            GlEntryAccountAmount := GlEntry.Amount;
                        end;
                        begin
                            //Total sum  value of a particular cost center in the budget entry
                            //"G/LBudgetEntry".RESET;
                            //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code",dimrec2);
                            //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
                            //"G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            //"G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        end;

                        begin
                            //Total sum  value of a particular cost center in the budget entry
                            //  "G/LBudgetEntry".RESET;
                            //"G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code",dimrec2);
                            //"G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartYear,EndYear);
                            // "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                            // "G/LBudgetEntryAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        end;

                        begin
                            //Total sum of of particular g/l account in the budget entry
                            "G/LBudgetEntry".Reset;
                            "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."G/L Account No.", GenJournalLineRec."Account No.");
                            "G/LBudgetEntry".SetFilter("G/LBudgetEntry"."Global Dimension 1 Code", dimrec);
                            "G/LBudgetEntry".SetRange("G/LBudgetEntry".Date, StartYear, EndYear);
                            "G/LBudgetEntry".CalcSums("G/LBudgetEntry".Amount);
                            "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                            //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                        end;

                        //total sum for the G/L account in the g/l entry and payment line
                        Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                        //Difference btw the actual gl account and budgeted amount
                        GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                        //total sum for the costcenter in the g/l entry and payment line
                        //Totalamountexceed := PayLineAmount + GlEntryAmount;

                        //Difference btw the actual cost center and budgeted amount
                        //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                        //MESSAGE(Text005,"G/LBudgetEntryAmount",dimrec,Totalamountexceed,"G/LBudgetAccountAmount",PayLinebudget2."Account No.",Totalamountglaccount);
                        //IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
                        // ( (Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" )) OR
                        //((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount >"G/LBudgetAccountAmount" ))  THEN
                        if ("G/LBudgetAccountAmount" < Totalamountglaccount) and (ApproveBatch <> '') then
                            Message(Text0058, DimName, "G/LBudgetAccountAmount", DimName, dimrec, GenJournalLineRec."Account No.", Totalamountglaccount)
                        else
                            if ("G/LBudgetAccountAmount" < Totalamountglaccount) then
                                Error(Text0058, DimName, "G/LBudgetAccountAmount", DimName, dimrec, GenJournalLineRec."Account No.", Totalamountglaccount);
                        //END;
                    end;








                end;

            until GenJournalLineRec.Next = 0;
        end;
    end;



    procedure ActualBudgetstaffAdvance(var StaffAdvanceHeader: record "Staff Advance Header")
    var
        dimrec: Code[20];
        i: Integer;
        Dimension2: Record "Dimension Value";
        Dimension3: Record "Dimension Value";
        // StaffAdvanceLinesBudget: Record "Staff Advance Lines";
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
        //  StaffAdvanceLinesBudget2: Record "Staff Advance Lines";
        GlEntryAccountAmount: Decimal;
        PayLineAmountActual: Decimal;
        "G/LBudgetAccountAmount": Decimal;
        Totalamountglaccount: Decimal;
        GlaccBudgetAmountDiff: Decimal;
        ApprovalCode: Code[20];
        GLAcc: Record "G/L Account";
        Dimension: Record "Dimension Value";
        Text005: Label 'The budgeted amount is  %1  for %2 and the G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the Month you cannot proceed';
        Text006: Label 'The budgeted amount is  %1  for %2 and the G/l entry  amount is  %3 the G/L account   Amount budgeted  is %4 for the G/L account %5  and the G/L entry amount is  %6 for the YEAR you cannot proceed';
    begin
        Daterec := StaffAdvanceHeader.Date;
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);
        ApprovalCode := StaffAdvanceHeader."Group Head";
        BudgetCheck := StaffAdvanceHeader."Budget Check";


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

        DimensionTemporary.DELETEALL;



        StaffAdvanceHeaderBudget.Reset();
        StaffAdvanceHeaderBudget.SetRange("No.", StaffAdvanceHeader."No.");
        if StaffAdvanceHeaderBudget.FindFirst() then begin

            StaffAdvanceLinesBudget1.RESET;
            StaffAdvanceLinesBudget1.SETCURRENTKEY("Shortcut Dimension 3 Code", "No.");
            StaffAdvanceLinesBudget1.SETRANGE("No.", StaffAdvanceHeaderBudget."No.");
            IF StaffAdvanceLinesBudget1.FINDFIRST THEN BEGIN

                REPEAT
                    IF StaffAdvanceLinesBudget1."Shortcut Dimension 3 Code" <> '' THEN BEGIN

                        AccountRec := 0;
                        StaffAdvanceLinesRec.RESET;
                        StaffAdvanceLinesRec.SETRANGE("No.", StaffAdvanceLinesBudget1."No.");
                        StaffAdvanceLinesRec.SETRANGE("Shortcut Dimension 3 Code", StaffAdvanceLinesBudget1."Shortcut Dimension 3 Code");
                        StaffAdvanceLinesRec.CALCSUMS(StaffAdvanceLinesRec.Amount);
                        AccountRec := StaffAdvanceLinesRec.Amount;

                        Dimension.RESET;
                        Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                        Dimension.SETRANGE(Code, StaffAdvanceLinesBudget1."Shortcut Dimension 3 Code");
                        Dimension.SETRANGE("Global Dimension No.", 3);
                        IF Dimension.FINDFIRST THEN
                            DimensionTemporary.Reset();
                        DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                        DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                        IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                            DimensionTemporary.INIT;
                            DimensionTemporary."Dimension Code" := Dimension.Code;
                            DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                            DimensionTemporary."Account No." := StaffAdvanceLinesBudget1."Account No.";
                            DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                            DimensionTemporary.Amount := AccountRec;
                            DimensionTemporary.INSERT;
                        END;
                    END;
                    //to IF StaffAdvanceLinesBudget1."Shortcut Dimension 2 Code" <> '' THEN BEGIN
                    //     AccountRec := 0;
                    //     StaffAdvanceLinesRec.RESET;
                    //     StaffAdvanceLinesRec.SETRANGE("No.", StaffAdvanceLinesBudget1."No.");
                    //     StaffAdvanceLinesRec.SETRANGE("Shortcut Dimension 2 Code", StaffAdvanceLinesBudget1."Shortcut Dimension 2 Code");
                    //     StaffAdvanceLinesRec.CALCSUMS(StaffAdvanceLinesRec.Amount);
                    //     AccountRec := StaffAdvanceLinesRec.Amount;


                    //     Dimension.RESET;
                    //     Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                    //     Dimension.SETRANGE(Code, StaffAdvanceLinesBudget1."Shortcut Dimension 2 Code");
                    //     Dimension.SETRANGE("Global Dimension No.", 2);
                    //     IF Dimension.FINDFIRST THEN
                    //         DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                    //     DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                    //     IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                    //         DimensionTemporary.INIT;
                    //         DimensionTemporary."Dimension Code" := Dimension.Code;
                    //         DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                    //         DimensionTemporary."Account No." := StaffAdvanceLinesBudget1."Account No.";
                    //         DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                    //         DimensionTemporary.Amount := AccountRec;
                    //         DimensionTemporary.INSERT;
                    //     END;
                    //to END;

                    IF StaffAdvanceLinesBudget1."Account No." <> '' THEN BEGIN
                        StaffAdvanceLinesRec.RESET;
                        StaffAdvanceLinesRec.SETRANGE("No.", StaffAdvanceLinesBudget1."No.");
                        StaffAdvanceLinesRec.SETRANGE("Account No.", StaffAdvanceLinesBudget1."Account No.");
                        StaffAdvanceLinesRec.CALCSUMS(Amount);
                        AccountRec := StaffAdvanceLinesRec.Amount;



                        AccountTemporary.RESET;
                        AccountTemporary.SETRANGE("Account No.", StaffAdvanceLinesBudget1."Account No.");
                        IF NOT AccountTemporary.FINDFIRST THEN BEGIN
                            AccountTemporary.INIT;
                            AccountTemporary."Account No." := StaffAdvanceLinesBudget1."Account No.";
                            AccountTemporary.Amount := AccountRec;
                            AccountTemporary.INSERT;
                        END;
                    END;
                UNTIL StaffAdvanceLinesBudget1.NEXT = 0;

            END;
        END;
        /////end


        // StaffAdvanceLinesBudget.SETCURRENTKEY("No.", "Global Dimension 1 Code", "Account No.");
        // StaffAdvanceLinesBudget.SETRANGE(StaffAdvanceLinesBudget."No.", StaffAdvanceHeader."No.");
        // StaffAdvanceLinesBudget.SETRANGE("Global Dimension 1 Code");
        // StaffAdvanceLinesBudget.SETRANGE(StaffAdvanceLinesBudget."Account No.");
        // IF StaffAdvanceLinesBudget.FINDFIRST THEN BEGIN
        //  PurchaseLineDime1(PurchaseHeader);
        //  PurchaseLineDime2(PurchaseHeader);

        //   PurchaseLineDime1(PurchaseHeader);
        //  PurchaseLineDime2(PurchaseHeader);

        AccountTemporary.RESET;
        AccountTemporary.SETRANGE("Account No.");
        IF AccountTemporary.FINDFIRST THEN BEGIN
            REPEAT




                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", AccountTemporary."Account No.");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN


                    BEGIN

                        PayLineAmountActual := AccountTemporary.Amount;
                        //   MESSAGE(FORMAT(PayLineAmountActual));
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", AccountTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);

                        GlEntryAccountAmount := GlEntry.Amount;
                    END;



                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", AccountTemporary."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        // MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;



                    // IF  ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN

                    //         MESSAGE(Text0059,"G/LBudgetAccountAmount",AccountTemporary."Account No.",Totalamountglaccount)
                    //   ELSE
                    IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                        Message(Text0059, "G/LBudgetAccountAmount", AccountTemporary."Account No.", Totalamountglaccount);






                    BEGIN
                        //total sum of a particular G/l account on the payment line

                        PayLineAmountActual := AccountTemporary.Amount;
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", AccountTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;



                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", AccountTemporary."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;


                    //   IF  ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN

                    //     MESSAGE(Text0060,"G/LBudgetAccountAmount",AccountTemporary."Account No.",Totalamountglaccount)
                    // ELSE
                    IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                        Message(Text0060, "G/LBudgetAccountAmount", AccountTemporary."Account No.", Totalamountglaccount);



                END
            //END;
            UNTIL AccountTemporary.NEXT = 0;
        END;
        // AccountTemporary.DELETEALL;

        DimensionTemporaryLine(StartDate, EndDate, StartYear, EndYear, BudgetCheck);

        DimensionTemporary.DELETEALL;
        AccountTemporary.DELETEALL;
    END;

    procedure StaffAdvanceLineDime1(StaffAdvanceHeader: Record "Staff Advance Header")
    begin
        //  if PurchaseHeader."Posting Date" = 0D then
        //    Daterec := PurchaseHeader."Order Date"
        //else
        Daterec := StaffAdvanceHeader.Date;

        //DimName := 'DEPARTMENT';

        //PurchHeader.SETRANGE("No.",PurchaseHeader."No.");
        //IF PurchHeader.FINDFIRST THEN
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

        //PurchaseLineDime1(PurchaseHeader);


        DimensionTemporary.RESET;
        DimensionTemporary.SETRANGE("Dimension Code");
        DimensionTemporary.SETRANGE("Dimension name");
        DimensionTemporary.SETRANGE("Global Dimension No", 1);
        IF DimensionTemporary.FINDFIRST THEN
            REPEAT

                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", DimensionTemporary."Account No.");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN





                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        StaffAdvanceLinesBudget1.RESET;
                        StaffAdvanceLinesBudget1.SETCURRENTKEY(StaffAdvanceLinesBudget1."Account No.", "No.");
                        StaffAdvanceLinesBudget1.SETRANGE(StaffAdvanceLinesBudget1."No.", StaffAdvanceHeader."No.");
                        StaffAdvanceLinesBudget1.SETFILTER("No.", DimensionTemporary."Account No.");
                        StaffAdvanceLinesBudget1.SETFILTER("Shortcut Dimension 3 Code", DimensionTemporary."Dimension Code");
                        StaffAdvanceLinesBudget1.CALCSUMS(StaffAdvanceLinesBudget1."Amount LCY");
                        PayLineAmountActual := StaffAdvanceLinesBudget1."Amount LCY";
                        // MESSAGE(FORMAT(PayLineAmountActual));
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 3 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);

                        GlEntryAccountAmount := GlEntry.Amount;
                    END;





                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 1 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //  MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;



                    BEGIN
                        //total sum of a particular G/l account on the payment line
                        StaffAdvanceLinesBudget1.RESET;
                        StaffAdvanceLinesBudget1.SETCURRENTKEY("Account No.", "No.");
                        StaffAdvanceLinesBudget1.SETRANGE(StaffAdvanceLinesBudget1."Account No.", PurchaseHeader."No.");
                        StaffAdvanceLinesBudget1.SETFILTER("Account No.", DimensionTemporary."Dimension Code");
                        StaffAdvanceLinesBudget1.SETFILTER("No.", DimensionTemporary."Account No.");
                        StaffAdvanceLinesBudget1.CALCSUMS(StaffAdvanceLinesBudget1."Amount LCY");
                        PayLineAmountActual := StaffAdvanceLinesBudget1."Amount LCY";
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETFILTER("Global Dimension 1 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;



                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 1 Code", DimensionTemporary."Dimension Code");
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
                    //Totalamountexceed := PayLineAmount + GlEntryAmount;

                    //Difference btw the actual cost center and budgeted amount
                    //Totalamount := "G/LBudgetEntryAmount" - Totalamountexceed;

                    ///IF ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    //  ((Totalamountexceed < "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) OR
                    // ((Totalamountexceed > "G/LBudgetEntryAmount") AND (Totalamountglaccount > "G/LBudgetAccountAmount")) THEN
                    // IF ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN
                    MESSAGE(Text0058, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", PurchaseLineBudget."No.", Totalamountglaccount)
                    //  ELSE
                    //   IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                    //      ERROR(Text0058, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", DimensionTemporary."Account No.", Totalamountglaccount); //Gbenga


                    //  END
                END;
            UNTIL DimensionTemporary.NEXT = 0;
        //END;

        //end;

    end;

    procedure DimensionTemporaryLine(StartMonth: Date; EndMonth: Date; StartYear: Date; EndYear: Date; BudgetCheck: Boolean)
    begin
        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;

        //  GenJourLineCheckDimension1(GenJournalLine);



        DimensionTemporary.RESET;
        DimensionTemporary.SETRANGE("Dimension Code");
        DimensionTemporary.SETRANGE("Dimension name");
        DimensionTemporary.SETRANGE("Global Dimension No", 3);
        IF DimensionTemporary.FINDFIRST THEN
            REPEAT


                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", DimensionTemporary."Account No.");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN



                    BEGIN
                        //          //total sum of a particular G/l account on the payment line
                        //        GenJournalLine3.RESET;
                        //        GenJournalLine3.SETCURRENTKEY("Journal Batch Name","Journal Template Name","Account No.","Shortcut Dimension 1 Code");
                        //        GenJournalLine3.SETRANGE("Journal Batch Name",GenJournalBatch.Name);
                        //        GenJournalLine3.SETFILTER("Shortcut Dimension 1 Code",DimensionTemporary."Dimension Code");
                        //        GenJournalLine3.SETFILTER("Journal Template Name",GenJournalBatch."Journal Template Name");
                        //        GenJournalLine3.SETFILTER("Account No.",DimensionTemporary."Account No.");
                        //        GenJournalLine3.CALCSUMS(GenJournalLine3."Amount (LCY)");
                        PayLineAmountActual := DimensionTemporary.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 1 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Global Dimension 1 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;


                    IF DimensionTemporary."Global Dimension No" = 2 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Global Dimension 2 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 3 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 3 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 4 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 4 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 5 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 5 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 6 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 6 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 7 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 7 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 8 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 8 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 1 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SetCurrentKey("G/L Account No.", "Global Dimension 1 Code", Date);
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry".Date, '%1..%2', StartMonth, EndMonth);
                        "G/LBudgetEntry".CALCSUMS(Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;


                    END;

                    IF DimensionTemporary."Global Dimension No" = 2 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SetCurrentKey("G/L Account No.", "Global Dimension 1 Code", Date);
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry".Date, '%1..%2', StartMonth, EndMonth);
                        "G/LBudgetEntry".CALCSUMS(Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;

                    END;

                    IF DimensionTemporary."Global Dimension No" = 3 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 3 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartMonth, EndMonth);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    IF DimensionTemporary."Global Dimension No" = 4 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 4 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartMonth, EndMonth);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    IF DimensionTemporary."Global Dimension No" = 5 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 3 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartMonth, EndMonth);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    IF DimensionTemporary."Global Dimension No" = 6 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 4 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartMonth, EndMonth);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    // IF DimensionTemporary."Global Dimension No" = 7  THEN
                    // 
                    //   BEGIN
                    //   //Total sum of of particular g/l account in the budget entry
                    //        "G/LBudgetEntry".RESET;
                    //        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.",DimensionTemporary."Account No.");
                    //        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 6 Code",DimensionTemporary."Dimension Code");
                    //        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartMonth,EndMonth);
                    //        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                    //        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                    //    //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    //    END;

                    // IF DimensionTemporary."Global Dimension No" = 8  THEN
                    // 
                    //   BEGIN
                    //   //Total sum of of particular g/l account in the budget entry
                    //        "G/LBudgetEntry".RESET;
                    //        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.",DimensionTemporary."Account No.");
                    //        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 8 Code",DimensionTemporary."Dimension Code");
                    //        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartMonth,EndMonth);
                    //        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                    //        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                    //    //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    //    END;

                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;

                    //to IF ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (ApproveBatch <> '') THEN
                     //to   MESSAGE(Text0057, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", DimensionTemporary."Account No.", Totalamountglaccount)
                  //to  ELSE

                      //to  IF (("G/LBudgetAccountAmount" < Totalamountglaccount) AND (BudgetCheck = false)) THEN
                          //to  ERROR(Text0057, AccountTemporary."Account No.", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", DimensionTemporary."Account No.", Totalamountglaccount);

                    //MESSAGE(Text0055,"G/LBudgetEntryAmount",dimrec2,Totalamountexceed,"G/LBudgetAccountAmount",GenJournalLineRec."Account No.",Totalamountglaccount);


                    BEGIN

                        PayLineAmountActual := DimensionTemporary.Amount;
                    END;


                    IF DimensionTemporary."Global Dimension No" = 1 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Global Dimension 1 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 2 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Global Dimension 2 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETRANGE("Posting Date", StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 3 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 3 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 4 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 4 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 5 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 5 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 6 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 6 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 7 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 7 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;

                    IF DimensionTemporary."Global Dimension No" = 8 THEN BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", DimensionTemporary."Account No.");
                        GlEntry.SETFILTER("Shortcut Dimension 8 Code", DimensionTemporary."Dimension Code");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartMonth, EndMonth);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;





                    IF DimensionTemporary."Global Dimension No" = 1 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 1 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    IF DimensionTemporary."Global Dimension No" = 2 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 2 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    IF DimensionTemporary."Global Dimension No" = 3 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 1 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartMonth, EndMonth);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    IF DimensionTemporary."Global Dimension No" = 4 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 2 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartMonth, EndMonth);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    IF DimensionTemporary."Global Dimension No" = 5 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 3 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartMonth, EndMonth);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    IF DimensionTemporary."Global Dimension No" = 6 THEN BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", DimensionTemporary."Account No.");
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Budget Dimension 4 Code", DimensionTemporary."Dimension Code");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartMonth, EndMonth);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;

                    // IF DimensionTemporary."Global Dimension No" = 7  THEN
                    // 
                    //   BEGIN
                    //   //Total sum of of particular g/l account in the budget entry
                    //        "G/LBudgetEntry".RESET;
                    //        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.",DimensionTemporary."Account No.");
                    //        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 6 Code",DimensionTemporary."Dimension Code");
                    //        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartMonth,EndMonth);
                    //        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                    //        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                    //    //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    //    END;

                    // IF DimensionTemporary."Global Dimension No" = 8  THEN
                    // 
                    //   BEGIN
                    //   //Total sum of of particular g/l account in the budget entry
                    //        "G/LBudgetEntry".RESET;
                    //        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.",DimensionTemporary."Account No.");
                    //        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."Global Dimension 8 Code",DimensionTemporary."Dimension Code");
                    //        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date,StartMonth,EndMonth);
                    //        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                    //        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                    //    //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    //    END;

                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;


                    IF ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (ApproveBatch <> '') THEN
                        MESSAGE(Text0058, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", DimensionTemporary."Account No.", Totalamountglaccount)
                    ELSE
                        IF (("G/LBudgetAccountAmount" < Totalamountglaccount) AND (BudgetCheck = false)) THEN
                            ERROR(Text0058, DimensionTemporary."Dimension name", "G/LBudgetAccountAmount", DimensionTemporary."Dimension name", DimensionTemporary."Dimension Code", DimensionTemporary."Account No.", Totalamountglaccount);
                    //END;
                END;








            //END;

            UNTIL DimensionTemporary.NEXT = 0;
        //END;
        //END;
        DimensionTemporary.DELETEALL;
    END;

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
        PaymentVoucher: Record "Voucher Header";
        VoucherLine: Record "Voucher Line";
        VoucherLineRec: Record "Voucher Line";
    begin
        Daterec := PaymentHeader."Posting Date";
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

        Daterec := PaymentHeader."Posting Date";
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);

        DimensionTemporary.DELETEALL;

        PaymentVoucher.Reset();
        PaymentVoucher.SetRange("No.", PaymentHeader."No.");
        if PaymentVoucher.FindFirst() then begin

            VoucherLine.RESET;
            VoucherLine.SETCURRENTKEY("Document No.");
            VoucherLine.SETRANGE("Document No.", PaymentVoucher."No.");
            IF VoucherLine.FINDFIRST THEN BEGIN

                REPEAT
                    IF VoucherLine."Shortcut Dimension 1 Code" <> '' THEN BEGIN

                        AccountRec := 0;
                        VoucherLineRec.RESET;
                        VoucherLineRec.SETRANGE("Document No.", VoucherLine."Document No.");
                        VoucherLineRec.SETRANGE("Shortcut Dimension 1 Code", VoucherLine."Shortcut Dimension 1 Code");
                        VoucherLineRec.CALCSUMS(VoucherLineRec.Amount);
                        AccountRec := VoucherLineRec.Amount;

                        Dimension.RESET;
                        Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                        Dimension.SETRANGE(Code, VoucherLine."Shortcut Dimension 1 Code");
                        Dimension.SETRANGE("Global Dimension No.", 1);
                        IF Dimension.FINDFIRST THEN
                            DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                        DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                        IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                            DimensionTemporary.INIT;
                            DimensionTemporary."Dimension Code" := Dimension.Code;
                            DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                            DimensionTemporary."Account No." := VoucherLine."Account No.";
                            DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                            DimensionTemporary.Amount := AccountRec;
                            DimensionTemporary.INSERT;
                        END;
                    END;
                    IF VoucherLine."Shortcut Dimension 2 Code" <> '' THEN BEGIN
                        AccountRec := 0;
                        VoucherLineRec.RESET;
                        VoucherLineRec.SETRANGE("Document No.", VoucherLine."Document No.");
                        VoucherLineRec.SETRANGE("Shortcut Dimension 2 Code", VoucherLine."Shortcut Dimension 2 Code");
                        VoucherLineRec.CALCSUMS(VoucherLineRec.Amount);
                        AccountRec := VoucherLineRec.Amount;


                        Dimension.RESET;
                        Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                        Dimension.SETRANGE(Code, VoucherLine."Shortcut Dimension 2 Code");
                        Dimension.SETRANGE("Global Dimension No.", 2);
                        IF Dimension.FINDFIRST THEN
                            DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                        DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                        IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                            DimensionTemporary.INIT;
                            DimensionTemporary."Dimension Code" := Dimension.Code;
                            DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                            DimensionTemporary."Account No." := VoucherLine."Account No.";
                            DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                            DimensionTemporary.Amount := AccountRec;
                            DimensionTemporary.INSERT;
                        END;
                    END;

                    IF VoucherLine."Account No." <> '' THEN BEGIN
                        VoucherLineRec.RESET;
                        VoucherLineRec.SETRANGE("Document No.", VoucherLine."Document No.");
                        VoucherLineRec.SETRANGE("Account No.", VoucherLine."Account No.");
                        VoucherLineRec.CALCSUMS(Amount);
                        AccountRec := VoucherLineRec.Amount;



                        AccountTemporary.RESET;
                        AccountTemporary.SETRANGE("Account No.", VoucherLine."Account No.");
                        IF NOT AccountTemporary.FINDFIRST THEN BEGIN
                            AccountTemporary.INIT;
                            AccountTemporary."Account No." := VoucherLine."Account No.";
                            AccountTemporary.Amount := VoucherLine."Amount (LCY)";
                            AccountTemporary.INSERT;
                        END;
                    END;
                UNTIL VoucherLine.NEXT = 0;

            END;
        END;
        /////end


        // StaffAdvanceLinesBudget.SETCURRENTKEY("No.", "Global Dimension 1 Code", "Account No.");
        // StaffAdvanceLinesBudget.SETRANGE(StaffAdvanceLinesBudget."No.", StaffAdvanceHeader."No.");
        // StaffAdvanceLinesBudget.SETRANGE("Global Dimension 1 Code");
        // StaffAdvanceLinesBudget.SETRANGE(StaffAdvanceLinesBudget."Account No.");
        // IF StaffAdvanceLinesBudget.FINDFIRST THEN BEGIN
        //  PurchaseLineDime1(PurchaseHeader);
        //  PurchaseLineDime2(PurchaseHeader);

        //   PurchaseLineDime1(PurchaseHeader);
        //  PurchaseLineDime2(PurchaseHeader);

        AccountTemporary.RESET;
        AccountTemporary.SETRANGE("Account No.");
        IF AccountTemporary.FINDFIRST THEN BEGIN
            REPEAT







                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", AccountTemporary."Account No.");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN




                    BEGIN

                        PayLineAmountActual := AccountTemporary.Amount;
                        //   MESSAGE(FORMAT(PayLineAmountActual));
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", AccountTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);

                        GlEntryAccountAmount := GlEntry.Amount;
                    END;



                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", AccountTemporary."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        // MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;



                    // IF  ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN

                    //         MESSAGE(Text0059,"G/LBudgetAccountAmount",AccountTemporary."Account No.",Totalamountglaccount)
                    //   ELSE
                    IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                        MESSAGE(Text0059, "G/LBudgetAccountAmount", AccountTemporary."Account No.", Totalamountglaccount);






                    BEGIN
                        //total sum of a particular G/l account on the payment line

                        PayLineAmountActual := AccountTemporary.Amount;
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", AccountTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;



                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", AccountTemporary."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;


                    //   IF  ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN

                    //     MESSAGE(Text0060,"G/LBudgetAccountAmount",AccountTemporary."Account No.",Totalamountglaccount)
                    // ELSE
                    IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                        MESSAGE(Text0060, "G/LBudgetAccountAmount", AccountTemporary."Account No.", Totalamountglaccount);




                END
            //END;
            UNTIL AccountTemporary.NEXT = 0;
            AccountTemporary.DELETEALL;

            DimensionTemporaryLine(StartDate, EndDate, StartYear, EndYear, BudgetCheck);
            DimensionTemporary.DELETEALL;
        END;

    end;


    procedure ActualBudgetStaffClaims(var StaffClaimsHeader: record "Staff Claims Header")
    var
        dimrec: Code[20];
        i: Integer;
        Dimension2: Record "Dimension Value";
        Dimension3: Record "Dimension Value";
        // StaffAdvanceLinesBudget: Record "Staff Advance Lines";
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
        //  StaffAdvanceLinesBudget2: Record "Staff Advance Lines";
        GlEntryAccountAmount: Decimal;
        PayLineAmountActual: Decimal;
        "G/LBudgetAccountAmount": Decimal;
        Totalamountglaccount: Decimal;
        GlaccBudgetAmountDiff: Decimal;
        GLAcc: Record "G/L Account";
        Dimension: Record "Dimension Value";
        Text005: Label 'The budgeted amount is  %1  for %2 and the G/l entry  amount is  %3 the G/L account Amount budgeted is %4 for the G/L account %5  and the G/L entry amount is  %6 for the Month you cannot proceed';
        Text006: Label 'The budgeted amount is  %1  for %2 and the G/l entry  amount is  %3 the G/L account Amount budgeted is %4 for the G/L account %5  and the G/L entry amount is  %6 for the YEAR you cannot proceed';
        StaffClaimsHeaderBudget: Record "Staff Claims Header";
        StaffClaimsLinesBudget1: Record "Staff Claim Lines";
        StaffClaimsLinesRec: Record "Staff Claim Lines";
        ApprovalCode: Code[20];
        
    begin
        Daterec := StaffClaimsHeader.Date;
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);
        ApprovalCode := StaffClaimsHeader."Group Head to Approve";
        BudgetCheck := StaffClaimsHeader."Budget Check";


        PayLineAmount := 0;
        GlEntryAmount := 0;
        "G/LBudgetEntryAmount" := 0;
        "G/LBudgetAccountAmount" := 0;
        PayLineAmountActual := 0;
        Totalamountglaccount := 0;
        GlaccBudgetAmountDiff := 0;
        Totalamount := 0;

        // to pick the number of cos center to itertate

        Daterec := StaffClaimsHeader.Date;
        StartDate := CALCDATE('<-CM>', Daterec);
        EndDate := CALCDATE('<CM>', Daterec);
        StartYear := CALCDATE('<-CY>', Daterec);
        EndYear := CALCDATE('<CY>', Daterec);

        DimensionTemporary.DELETEALL;

        StaffClaimsHeaderBudget.Reset();
        StaffClaimsHeaderBudget.SetRange("No.", StaffClaimsHeader."No.");
        if StaffClaimsHeaderBudget.FindFirst() then begin

            StaffClaimsLinesBudget1.RESET;
            StaffClaimsLinesBudget1.SETCURRENTKEY(No);
            StaffClaimsLinesBudget1.SETRANGE(No, StaffClaimsHeaderBudget."No.");
            IF StaffClaimsLinesBudget1.FINDFIRST THEN BEGIN

                REPEAT
                    IF StaffClaimsLinesBudget1."Shortcut Dimension 3 Code" <> '' THEN BEGIN

                        AccountRec := 0;
                        StaffClaimsLinesRec.RESET;
                        StaffClaimsLinesRec.SETRANGE(No, StaffClaimsLinesBudget1.No);
                        StaffClaimsLinesRec.SETRANGE("Shortcut Dimension 3 Code", StaffClaimsLinesBudget1."Shortcut Dimension 3 Code");
                        StaffClaimsLinesRec.CALCSUMS(Amount);
                        AccountRec := StaffClaimsLinesRec.Amount;

                        Dimension.RESET;
                        Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                        Dimension.SETRANGE(Code, StaffClaimsLinesBudget1."Shortcut Dimension 3 Code");
                        Dimension.SETRANGE("Global Dimension No.", 1);
                        IF Dimension.FINDFIRST THEN
                            DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                        DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                        IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                            DimensionTemporary.INIT;
                            DimensionTemporary."Dimension Code" := Dimension.Code;
                            DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                            DimensionTemporary."Account No." := StaffClaimsLinesBudget1."Account No:";
                            DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                            DimensionTemporary.Amount := AccountRec;
                            DimensionTemporary.INSERT;

                        END;

                    END;
                    //to IF StaffClaimsLinesBudget1."Shortcut Dimension 2 Code" <> '' THEN BEGIN
                    //     AccountRec := 0;
                    //     StaffClaimsLinesRec.RESET;
                    //     StaffClaimsLinesRec.SETRANGE(No, StaffClaimsLinesBudget1.No);
                    //     StaffClaimsLinesRec.SETRANGE("Shortcut Dimension 2 Code", StaffClaimsLinesBudget1."Shortcut Dimension 2 Code");
                    //     StaffClaimsLinesRec.CALCSUMS(Amount);
                    //     AccountRec := StaffClaimsLinesRec.Amount;


                    //     Dimension.RESET;
                    //     Dimension.SETCURRENTKEY(Code, "Global Dimension No.");
                    //     Dimension.SETRANGE(Code, StaffClaimsLinesBudget1."Shortcut Dimension 2 Code");
                    //     Dimension.SETRANGE("Global Dimension No.", 2);
                    //     IF Dimension.FINDFIRST THEN
                    //         DimensionTemporary.SETRANGE("Dimension Code", Dimension.Code);
                    //     DimensionTemporary.SETRANGE("Dimension name", Dimension."Dimension Code");
                    //     IF NOT DimensionTemporary.FINDFIRST THEN BEGIN
                    //         DimensionTemporary.INIT;
                    //         DimensionTemporary."Dimension Code" := Dimension.Code;
                    //         DimensionTemporary."Dimension name" := Dimension."Dimension Code";
                    //         DimensionTemporary."Account No." := StaffClaimsLinesBudget1."Account No:";
                    //         DimensionTemporary."Global Dimension No" := Dimension."Global Dimension No.";
                    //         DimensionTemporary.Amount := AccountRec;
                    //         DimensionTemporary.INSERT;
                    //     END;

                    //to END;

                    IF StaffClaimsLinesBudget1."Account No:" <> '' THEN BEGIN
                        StaffClaimsLinesRec.RESET;
                        StaffClaimsLinesRec.SETRANGE(No, StaffClaimsLinesBudget1.No);
                        StaffClaimsLinesRec.SETRANGE("Account No:", StaffClaimsLinesBudget1."Account No:");
                        StaffClaimsLinesRec.CALCSUMS(Amount);
                        AccountRec := StaffClaimsLinesRec.Amount;



                        AccountTemporary.RESET;
                        AccountTemporary.SETRANGE("Account No.", StaffClaimsLinesBudget1.No);
                        IF NOT AccountTemporary.FINDFIRST THEN BEGIN
                            AccountTemporary.INIT;
                            AccountTemporary."Account No." := StaffClaimsLinesBudget1."Account No:";
                            AccountTemporary.Amount := StaffClaimsLinesBudget1."Amount LCY";
                            AccountTemporary.INSERT;
                        END;
                    END;
                UNTIL StaffClaimsLinesBudget1.NEXT = 0;

            END;
        END;
        /////end


        // StaffAdvanceLinesBudget.SETCURRENTKEY("No.", "Global Dimension 1 Code", "Account No.");
        // StaffAdvanceLinesBudget.SETRANGE(StaffAdvanceLinesBudget."No.", StaffClaimsHeader."No.");
        // StaffAdvanceLinesBudget.SETRANGE("Global Dimension 1 Code");
        // StaffAdvanceLinesBudget.SETRANGE(StaffAdvanceLinesBudget."Account No.");
        // IF StaffAdvanceLinesBudget.FINDFIRST THEN BEGIN
        //  PurchaseLineDime1(PurchaseHeader);
        //  PurchaseLineDime2(PurchaseHeader);

        //   PurchaseLineDime1(PurchaseHeader);
        //  PurchaseLineDime2(PurchaseHeader);

        AccountTemporary.RESET;
        AccountTemporary.SETRANGE("Account No.");
        IF AccountTemporary.FINDFIRST THEN BEGIN
            REPEAT







                GLAcc.RESET;
                GLAcc.SETRANGE(GLAcc."No.", AccountTemporary."Account No.");
                GLAcc.SETRANGE(GLAcc."Budget Controlled", TRUE);
                IF GLAcc.FINDFIRST THEN BEGIN




                    BEGIN

                        PayLineAmountActual := AccountTemporary.Amount;
                        //   MESSAGE(FORMAT(PayLineAmountActual));
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", AccountTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        GlEntry.CALCSUMS(Amount);

                        GlEntryAccountAmount := GlEntry.Amount;
                    END;



                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", AccountTemporary."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartDate, EndDate);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        // MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;



                    // IF  ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN

                    //         MESSAGE(Text0059,"G/LBudgetAccountAmount",AccountTemporary."Account No.",Totalamountglaccount)
                    //   ELSE
                  //  IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                     //   MESSAGE(Text0059, "G/LBudgetAccountAmount", AccountTemporary."Account No.", Totalamountglaccount);






                    BEGIN
                        //total sum of a particular G/l account on the payment line

                        PayLineAmountActual := AccountTemporary.Amount;
                    END;

                    BEGIN
                        //Total sum of the particular g/l account  in the g/l entry
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", AccountTemporary."Account No.");
                        GlEntry.SETFILTER("Posting Date", '%1..%2', StartYear, EndYear);
                        GlEntry.CALCSUMS(Amount);
                        GlEntryAccountAmount := GlEntry.Amount;
                    END;



                    BEGIN
                        //Total sum of of particular g/l account in the budget entry
                        "G/LBudgetEntry".RESET;
                        "G/LBudgetEntry".SETFILTER("G/LBudgetEntry"."G/L Account No.", AccountTemporary."Account No.");
                        "G/LBudgetEntry".SETRANGE("G/LBudgetEntry".Date, StartYear, EndYear);
                        "G/LBudgetEntry".CALCSUMS("G/LBudgetEntry".Amount);
                        "G/LBudgetAccountAmount" := "G/LBudgetEntry".Amount;
                        //MESSAGE(FORMAT("G/LBudgetEntryAmount"));
                    END;


                    //total sum for the G/L account in the g/l entry and payment line
                    Totalamountglaccount := PayLineAmountActual + GlEntryAccountAmount;

                    //Difference btw the actual gl account and budgeted amount
                    GlaccBudgetAmountDiff := "G/LBudgetAccountAmount" - Totalamountglaccount;


                    //   IF  ("G/LBudgetAccountAmount" < Totalamountglaccount) AND (PurchaseHeader."Approval Code" <> '') THEN

                    //     MESSAGE(Text0060,"G/LBudgetAccountAmount",AccountTemporary."Account No.",Totalamountglaccount)
                    // ELSE
                    IF ("G/LBudgetAccountAmount" < Totalamountglaccount) THEN
                        MESSAGE(Text0060, "G/LBudgetAccountAmount", AccountTemporary."Account No.", Totalamountglaccount);
                END
            //END;
            UNTIL AccountTemporary.NEXT = 0;
        END;
        AccountTemporary.DELETEALL;

        DimensionTemporaryLine(StartDate, EndDate, StartYear, EndYear, BudgetCheck);
        DimensionTemporary.DELETEALL;
    END;

    //end;

}

