table 50632 "Staff Advan Surrender Details"
{

    fields
    {
        field(1; "Surrender Doc No."; Code[20])
        {
            Editable = false;
            NotBlank = true;

            trigger OnValidate()
            begin
                // IF Pay.GET(No) THEN
                // "Imprest Holder":=Pay."Account No.";
            end;
        }
        field(2; "Account No:"; Code[20])
        {
            TableRelation = IF ("Account Type" = FILTER("G/L Account")) "G/L Account"."No." WHERE("Direct Posting" = CONST(true))
            ELSE
            IF ("Account Type" = FILTER(Vendor)) Vendor."No."
            ELSE
            IF ("Account Type" = FILTER(Customer)) Customer."No."
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee."No.";// WHERE("Employee Posting Group" = CONST('GROUP'));

            trigger OnValidate()
            begin


                if GLAcc.Get("Account No:") then begin
                    "Account Name" := GLAcc.Name;
                    GLAcc.TestField("Direct Posting", true);
                    // "Budgetary Control A/C":=GLAcc."Budget Controlled";
                end;

                Pay.SetRange(Pay."No.", "Surrender Doc No.");
                if Pay.FindFirst then begin
                    if Pay."Account No." <> '' then begin
                        "Advance Holder" := Pay."Account No.";
                        "Shortcut Dimension 1 Code" := Pay."Global Dimension 1 Code";
                        "Shortcut Dimension 2 Code" := Pay."Shortcut Dimension 2 Code";
                        "Currency Factor" := Pay."Currency Factor";
                        "Currency Code" := Pay."Currency Code";
                    end //else
                        //Error('Please Enter the Customer/Account Number'); blocked by Deji
                end;
            end;
        }
        field(3; "Account Name"; Text[50])
        {
        }
        field(4; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                //Difference := Amount - "Actual Spent";
            end;
        }
        field(5; "Due Date"; Date)
        {
            Editable = false;
        }
        field(6; "Advance Holder"; Code[20])
        {
            Editable = true;
            TableRelation = Employee."No.";
        }
        field(7; "Actual Spent"; Decimal)
        {

            trigger OnValidate()
            begin
                //Allow actual spent to be more than amount if open for overexpenditure and from original document
                if not ("Allow Overexpenditure") and ("Line on Original Document") then begin
                    if "Actual Spent" > Amount then
                        Error('The Actual Spent Cannot be more than the Issued Amount');
                end;

                if "Line No." = 0 then
                    "Line No." := GetLastLineNo + 1;


                if "Currency Factor" <> 0 then
                    "Amount LCY" := "Actual Spent" / "Currency Factor"
                else
                    "Amount LCY" := "Actual Spent";

                Difference := Amount - "Actual Spent";
            end;
        }
        field(8; "Apply to"; Code[20])
        {
            Editable = false;
        }
        field(9; "Apply to ID"; Code[20])
        {
            Editable = false;
        }
        field(10; "Surrender Date"; Date)
        {
            Editable = false;
        }
        field(11; Surrendered; Boolean)
        {
            Editable = false;
        }
        field(12; "Cash Receipt No"; Code[20])
        {
            //TableRelation = "Receipts Line" WHERE("Account No." = FIELD("Advance Holder"));
        }
        field(13; "Date Issued"; Date)
        {
            Editable = false;
        }
        field(14; "Type of Surrender"; Option)
        {
            OptionMembers = " ",Cash,Receipt;
        }
        field(15; "Dept. Vch. No."; Code[20])
        {
        }
        field(16; "Cash Surrender Amt"; Decimal)
        {
        }
        field(17; "Bank/Petty Cash"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(18; "Doc No."; Code[20])
        {
            Editable = false;
        }
        field(19; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(20; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(21; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Posting Location';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(22; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Vehicle code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('VEHICLE'));
        }
        field(23; "Shortcut Dimension 5 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = Dimension;
        }
        field(24; "Shortcut Dimension 6 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = Dimension;
        }
        field(25; "Shortcut Dimension 7 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = Dimension;
        }
        field(26; "Shortcut Dimension 8 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = Dimension;
        }
        field(27; "VAT Prod. Posting Group"; Code[20])
        {
            Editable = false;
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(28; "Imprest Type"; Code[20])
        {

            TableRelation = "Receipts and Payment Types".Code WHERE(Type = CONST(Advance));

            trigger OnValidate()
            begin
                ImprestHeader.Reset;
                ImprestHeader.SetRange(ImprestHeader."No.", "Surrender Doc No.");
                if ImprestHeader.FindFirst then begin
                    if //(ImprestHeader.Status=ImprestHeader.Status::Approved) OR
                    (ImprestHeader.Status = ImprestHeader.Status::Posted) or
                    (ImprestHeader.Status = ImprestHeader.Status::"Pending Approval") then
                        Error('You Cannot Insert a new record when the status of the document is not Pending');
                end;

                RecPay.Reset;
                RecPay.SetRange(RecPay.Code, "Imprest Type");
                RecPay.SetRange(RecPay.Type, RecPay.Type::Advance);
                if RecPay.Find('-') then begin
                    Grouping := RecPay."Default Grouping";
                    "Account No:" := RecPay."Account No.";
                    "Account Name" := RecPay."Transation Remarks";
                    "Account Type" := RecPay."Account Type";
                    Validate("Account No:");
                end;

            end;
        }
        field(85; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(86; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            Editable = true;
            TableRelation = Currency;
        }
        field(87; "Amount LCY"; Decimal)
        {
        }
        field(88; "Cash Surrender Amt LCY"; Decimal)
        {
        }
        field(89; "Imprest Req Amt LCY"; Decimal)
        {
        }
        field(90; "Cash Receipt Amount"; Decimal)
        {
        }
        field(91; "Line No."; Integer)
        {
        }
        field(92; Committed; Boolean)
        {
        }
        field(93; "Budgetary Control A/C"; Boolean)
        {
        }
        field(94; "Line on Original Document"; Boolean)
        {
        }
        field(95; "Allow Overexpenditure"; Boolean)
        {
        }
        field(96; "Open for Overexpenditure by"; Code[50])
        {
        }
        field(97; "Date opened for OvExpenditure"; Date)
        {
        }
        field(98; Difference; Decimal)
        {
        }
        field(99; Grouping; Code[20])
        {
            Description = 'Stores Expense Code';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions
            end;
        }
        field(50000; "Account Type"; Enum "Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,None';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,"None";
        }
        field(50001; "Staff Advance Doc No"; Code[20])
        {
        }
        field(50002; "Staff Advance Doc Line No"; Integer)
        {
        }
        field(50003; Posted; Boolean)
        {
            CalcFormula = Lookup("Staff Advanc Surrender Header".Posted WHERE("No." = FIELD("Surrender Doc No.")));
            FieldClass = FlowField;
        }
        field(50004; "Applies-to Doc. Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-to Doc. Type';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            // OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;

            trigger OnLookup()
            begin
                /*PHead.RESET;
                PHead.SETRANGE(PHead."No.",No);
                 IF PHead.FINDFIRST THEN BEGIN
                    IF (PHead.Status=PHead.Status::Approved) OR (PHead.Status=PHead.Status::Posted) OR
                     (PHead.Status=PHead.Status::"Pending Approval")OR (PHead.Status=PHead.Status::Cancelled) THEN
                       ERROR('You Cannot modify documents that are approved/posted/Send for Approval');
                 END;*/

            end;

            trigger OnValidate()
            begin
                /*PHead.RESET;
                PHead.SETRANGE(PHead."No.",No);
                 IF PHead.FINDFIRST THEN BEGIN
                    IF (PHead.Status=PHead.Status::Approved) OR (PHead.Status=PHead.Status::Posted) OR
                     (PHead.Status=PHead.Status::"Pending Approval")OR (PHead.Status=PHead.Status::Cancelled) THEN
                       ERROR('You Cannot modify documents that are approved/posted/Send for Approval');
                 END;*/

            end;
        }
        field(50005; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
                PayToVendorNo: Code[20];
                OK: Boolean;
                Text000: Label 'You must specify %1 or %2.';
                CustLedgEntry: Record "Cust. Ledger Entry";
                PayToCustomerNo: Code[20];
            begin
                if (Rec."Account Type" <> Rec."Account Type"::Employee) then
                    Error('You cannot apply to %1', "Account Type");
                if "Account Type" = "Account Type"::Employee then begin
                    //  with Rec do begin
                    //Amount:=0;
                    //VALIDATE(Amount);
                    PayToVendorNo := "Account No:";
                    EmployeeLedgerEntry.SetCurrentKey("Employee No.", Open);
                    EmployeeLedgerEntry.SetRange("Employee No.", PayToVendorNo);
                    EmployeeLedgerEntry.SetRange(Open, true);
                    if "Applies-to ID" = '' then
                        "Applies-to ID" := "Surrender Doc No.";
                    if "Applies-to ID" = '' then
                        Error(
                          Text000,
                          FieldCaption("Surrender Doc No."), FieldCaption("Applies-to ID"));
                    //ApplyVendEntries."SetPVLine-Delete"(PVLine,PVLine.FIELDNO("Applies-to ID"));
                    ApplyEmployeeEntries.SetPVLine(Rec, EmployeeLedgerEntry, Rec.FieldNo("Applies-to ID"));
                    ApplyEmployeeEntries.SetRecord(EmployeeLedgerEntry);
                    ApplyEmployeeEntries.SetTableView(EmployeeLedgerEntry);
                    ApplyEmployeeEntries.LookupMode(true);
                    OK := ApplyEmployeeEntries.RunModal = ACTION::LookupOK;
                    Clear(ApplyEmployeeEntries);
                    if not OK then
                        exit;
                    EmployeeLedgerEntry.Reset;
                    EmployeeLedgerEntry.SetCurrentKey("Employee No.", Open);
                    EmployeeLedgerEntry.SetRange("Employee No.", PayToVendorNo);
                    EmployeeLedgerEntry.SetRange(Open, true);
                    EmployeeLedgerEntry.SetRange(EmployeeLedgerEntry."Applies-to ID", "Applies-to ID");
                    if EmployeeLedgerEntry.Find('-') then begin
                        "Applies-to Doc. Type" := EmployeeLedgerEntry."Document Type";
                        "Applies-to Doc. No." := EmployeeLedgerEntry."Document No.";

                    end else
                        "Applies-to ID" := '';
                end;
                //Calculate  Total To Apply
                EmployeeLedgerEntry.Reset;
                EmployeeLedgerEntry.SetCurrentKey("Employee No.", Open, "Applies-to ID");
                EmployeeLedgerEntry.SetRange("Employee No.", PayToVendorNo);
                EmployeeLedgerEntry.SetRange(Open, true);
                EmployeeLedgerEntry.SetRange("Applies-to ID", "Applies-to ID");
                if EmployeeLedgerEntry.Find('-') then begin
                    EmployeeLedgerEntry.CalcSums("Amount to Apply");
                    Amount := Abs(EmployeeLedgerEntry."Amount to Apply");
                    Validate(Amount);
                    //Total Invoice Amount
                    Amount := Abs(EmployeeLedgerEntry."Amount to Apply");
                    //Total Invoice Amount
                end;
            end;


            trigger OnValidate()
            begin
                if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." <> '') and
                   ("Applies-to Doc. No." <> '')
                then begin
                    SetAmountToApply("Applies-to Doc. No.", "Account No:");
                    SetAmountToApply(xRec."Applies-to Doc. No.", "Account No:");
                end else
                    if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." = '') then
                        SetAmountToApply("Applies-to Doc. No.", "Account No:")
                    else
                        if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and ("Applies-to Doc. No." = '') then
                            SetAmountToApply(xRec."Applies-to Doc. No.", "Account No:");
            end;
        }
        field(50006; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                SaffSurr.Reset;
                SaffSurr.SetRange(SaffSurr."No.", "Staff Advance Doc No");
                if SaffSurr.FindFirst then begin
                    if (SaffSurr.Status = SaffSurr.Status::Approved) or (SaffSurr.Status = SaffSurr.Status::Posted) or
                     (SaffSurr.Status = SaffSurr.Status::"Pending Approval") or (SaffSurr.Status = SaffSurr.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
            end;

            trigger OnValidate()
            var
                TempVendLedgEntry: Record "Vendor Ledger Entry";
                TempCustLedgEntry: Record "Cust. Ledger Entry";
                CustLedgEntry: Record "Cust. Ledger Entry";
            begin
                //IF "Applies-to ID" <> '' THEN
                //  TESTFIELD("Bal. Account No.",'');
                /*PHead.RESET;
                PHead.SETRANGE(PHead."No.",No);
                 IF PHead.FINDFIRST THEN BEGIN
                    IF (PHead.Status=PHead.Status::Approved) OR (PHead.Status=PHead.Status::Posted) OR
                     (PHead.Status=PHead.Status::"Pending Approval")OR (PHead.Status=PHead.Status::Cancelled) THEN
                       ERROR('You Cannot modify documents that are approved/posted/Send for Approval');
                 END;*/

                if "Account Type" = "Account Type"::Employee then begin
                    if ("Applies-to ID" <> xRec."Applies-to ID") and (xRec."Applies-to ID" <> '') then begin
                        EmployeeLedgerEntry.SetCurrentKey("Employee No.", Open);
                        EmployeeLedgerEntry.SetRange("Employee No.", "Account No:");
                        EmployeeLedgerEntry.SetRange(Open, true);
                        EmployeeLedgerEntry.SetRange("Applies-to ID", xRec."Applies-to ID");
                        if EmployeeLedgerEntry.FindFirst then
                            "EmplEntry-SetApplID".SetApplId(EmployeeLedgerEntry, TempEmployeeLedgerEntry, '');
                        EmployeeLedgerEntry.Reset;
                    end;
                end;

            end;
        }


    }

    keys
    {
        key(Key1; "Surrender Doc No.", "Line No.")
        {
            SumIndexFields = "Amount LCY", "Imprest Req Amt LCY", "Actual Spent", "Cash Receipt Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //Don't Allow deleting of lines on original document
        if ("Line on Original Document") and (Amount <> 0) then
            Error('You are not allowed to delete lines that were on the original issuing document');

        Pay.Reset;
        Pay.SetRange(Pay."No.", "Surrender Doc No.");
        if Pay.Find('-') then
            if (Pay.Status = Pay.Status::Posted) or (Pay.Status = Pay.Status::"Pending Approval") then
                //     OR (Pay.Status=Pay.Status::Approved)THEN
                Error('This Document is already Send for Approval or Posted');

        TestField(Committed, false);
    end;

    trigger OnInsert()
    begin
        //Do not allow insertion of lines until the document is open for over expenditure
        Pay.Reset;
        Pay.SetRange(Pay."No.", "Surrender Doc No.");
        if Pay.Find('-') then begin
            if not Pay."Allow Overexpenditure" then
                Error('You must first open the document to allow over expenditure and addition of lines');
        end;
    end;

    trigger OnModify()
    begin
        Pay.Reset;
        Pay.SetRange(Pay."No.", "Surrender Doc No.");
        if Pay.Find('-') then
            if (Pay.Status = Pay.Status::Posted) then //OR (Pay.Status=Pay.Status::"Pending Approval") THEN
                                                      //OR (Pay.Status=Pay.Status::Approved)THEN
                Error('This Document is already Send for Approval or Posted');
        Pay.TestField("Commitment Status", false);
    end;

    var
        GLAcc: Record "G/L Account";
        Pay: Record "Staff Advanc Surrender Header";
        Dim: Record Dimension;
        CustLedger: Record "Cust. Ledger Entry";
        Text000: Label 'Receipt No %1 Is already Used in Another Document';
        ImprestHeader: Record "Staff Advance Lines";
        RecPay: Record "Receipts and Payment Types";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        ApplyEmployeeEntries: Page "Apply Employee Entries2";
        TempEmployeeLedgerEntry: Record "Employee Ledger Entry";
        "EmplEntry-SetApplID": Codeunit "Empl. Entry-SetAppl.ID";
        SaffSurr: Record "Staff Advanc Surrender Header";

    procedure GetLastLineNo(): Integer
    var
        StaffAdvanceSurrLines: Record "Staff Advan Surrender Details";
    begin
        StaffAdvanceSurrLines.Reset;
        StaffAdvanceSurrLines.SetRange(StaffAdvanceSurrLines."Surrender Doc No.", "Surrender Doc No.");
        StaffAdvanceSurrLines.FindLast;
        exit(StaffAdvanceSurrLines."Line No.");
    end;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Advance Surrender', "Line No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure SetAmountToApply(AppliesToDocNo: Code[20]; EmployNo: Code[20])
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin

        EmployeeLedgerEntry.SetCurrentKey("Document No.");
        EmployeeLedgerEntry.SetRange("Document No.", AppliesToDocNo);
        EmployeeLedgerEntry.SetRange("Employee No.", EmployNo);
        EmployeeLedgerEntry.SetRange(Open, true);
        if EmployeeLedgerEntry.FindFirst then begin
            if EmployeeLedgerEntry."Amount to Apply" = 0 then begin
                EmployeeLedgerEntry.CalcFields("Remaining Amount");
                EmployeeLedgerEntry."Amount to Apply" := EmployeeLedgerEntry."Remaining Amount";
            end else
                EmployeeLedgerEntry."Amount to Apply" := 0;
            //EmployeeLedgerEntry."Accepted Payment Tolerance" := 0;
            // EmployeeLedgerEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
            CODEUNIT.Run(CODEUNIT::"Empl. Entry-Edit", EmployeeLedgerEntry);
        end;
    end;

    procedure PayLinesExist(): Boolean
    var
        StaffAdvancSurrenderDetails: Record "Staff Advan Surrender Details";
    begin
        StaffAdvancSurrenderDetails.Reset;
        StaffAdvancSurrenderDetails.SetRange("Surrender Doc No.", "Surrender Doc No.");
        exit(StaffAdvancSurrenderDetails.FindFirst);
    end;
}

