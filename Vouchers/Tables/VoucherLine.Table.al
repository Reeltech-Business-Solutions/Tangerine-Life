table 50605 "Voucher Line"
{
    fields
    {
        field(1; "Voucher Type"; Enum VoucherType)
        {
            //OptionCaption = 'JV,CPV,CRV,BPV,BRV,Contra,PettyCash';
            //OptionMembers = JV,CPV,CRV,BPV,BRV,Contra,PettyCash;

            trigger OnValidate()
            begin
                IF VoucherHeader.GET("Voucher Type", "Document No.") THEN
                    VALIDATE("Responsibility Center", VoucherHeader."Responsibility Center");
            end;
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","",Employee;
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF (Account = CONST("G/L Account")) "G/L Account"."No." WHERE(Blocked = FILTER(false))
            ELSE
            IF (Account = CONST(Customer), "Responsibility Center" = FILTER(<> '')) Customer."No." WHERE(Blocked = FILTER(' '), "Responsibility Center" = FIELD("Responsibility Center"), "Customer Type" = filter(<> Employee))
            ELSE
            IF (Account = CONST(Customer), "Responsibility Center" = FILTER('')) Customer."No." WHERE(Blocked = FILTER(' '), "Customer Type" = filter(<> Employee))
            ELSE
            IF (Account = CONST("Local Vendor")) Vendor."No." WHERE(Blocked = FILTER(' '), "Vendor Type" = FILTER(Local))
            ELSE
            IF (Account = FILTER("Foreign Vendor")) Vendor."No." WHERE(Blocked = FILTER(' '), "Vendor Type" = FILTER(Foreign | Import))
            ELSE
            if (Account = Const("Local Staff")) vendor."No." where(Blocked = FIlter(' '), "Vendor Type" = filter(Cash))
            else
            IF (Account = FILTER(Cash)) "Bank Account"."No." WHERE(Blocked = CONST(false), "Bank Type" = Filter(Cash))
            ELSE
            IF (Account = FILTER(Bank)) "Bank Account"."No." WHERE(Blocked = CONST(false))
            ELSE
            IF (Account = FILTER("Fixed Asset")) "Fixed Asset"."No." WHERE(Blocked = FILTER(false))
            else
            if (Account = filter(Employee)) Employee."No." Where(Status = filter(Active))
            else
            if (Account = FILTER("Import File")) Vendor."No." WHERE(Blocked = FILTER(' '), "Vendor Type" = FILTER("Import File"));

            trigger OnValidate()
            begin
                TestStatusOpen;
                //UNL >>
                IF VoucherHeader.GET("Voucher Type", "Document No.") THEN BEGIN
                    VALIDATE("Shortcut Dimension 1 Code", VoucherHeader."Shortcut Dimension 1 Code");
                    VALIDATE("Shortcut Dimension 2 Code", VoucherHeader."Shortcut Dimension 2 Code");
                    VALIDATE("Shortcut Dimension 3 Code", VoucherHeader."Shortcut Dimension 3 Code");
                    VALIDATE("Shortcut Dimension 4 Code", VoucherHeader."Shortcut Dimension 4 Code");
                    VALIDATE("Shortcut Dimension 5 Code", VoucherHeader."Shortcut Dimension 5 Code");
                    VALIDATE("Shortcut Dimension 6 Code", VoucherHeader."Shortcut Dimension 6 Code");
                    VALIDATE("Shortcut Dimension 7 Code", VoucherHeader."Shortcut Dimension 7 Code");
                    VALIDATE("Shortcut Dimension 8 Code", VoucherHeader."Shortcut Dimension 8 Code");
                    VALIDATE("Posting Date", VoucherHeader."Posting Date");
                    VALIDATE("Currency Code", VoucherHeader."Currency Code");
                    VALIDATE("Currency Factor", VoucherHeader."Currency Factor");
                    VALIDATE("Responsibility Center", VoucherHeader."Responsibility Center");
                END;
                //UNL <<

                CASE "Account Type" OF
                    "Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Account No.");
                            CheckGLAcc;
                            "Account Name" := GLAcc.Name;
                        END;
                    "Account Type"::Customer:
                        BEGIN
                            Cust.GET("Account No.");
                            "Account Name" := Cust.Name;
                            //
                            VALIDATE("Shortcut Dimension 1 Code", Cust."Global Dimension 1 Code");
                            VALIDATE("Shortcut Dimension 2 Code", Cust."Global Dimension 2 Code");
                            VALIDATE("Shortcut Dimension 3 Code", Cust."Shortcut Dimension 3 Code");
                            VALIDATE("Shortcut Dimension 4 Code", Cust."Shortcut Dimension 4 Code");
                            VALIDATE("Shortcut Dimension 5 Code", Cust."Shortcut Dimension 5 Code");
                            VALIDATE("Shortcut Dimension 6 Code", Cust."Shortcut Dimension 6 Code");
                            VALIDATE("Shortcut Dimension 7 Code", Cust."Shortcut Dimension 7 Code");
                            VALIDATE("Shortcut Dimension 8 Code", Cust."Shortcut Dimension 8 Code");

                            "Currency Code" := Cust."Currency Code";
                            "Responsibility Center" := Cust."Responsibility Center";
                            VALIDATE("Currency Code");
                            //

                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            Vend.GET("Account No.");
                            "Account Name" := Vend.Name;
                            "Shortcut Dimension 1 Code" := Vend."Global Dimension 1 Code";
                            "Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                            "Currency Code" := Vend."Currency Code";
                            VALIDATE("Currency Code");
                        END;
                    "Account Type"::Employee:
                        BEGIN
                            Emp.GET("Account No.");
                            "Account Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + emp."Last Name";
                            "Shortcut Dimension 1 Code" := Vend."Global Dimension 1 Code";
                            "Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                            //VALIDATE("Currency Code");
                        END;
                    "Account Type"::"Bank Account":
                        BEGIN
                            BankAcc.GET("Account No.");
                            BankAcc.TESTFIELD(Blocked, FALSE);
                            "Account Name" := BankAcc.Name;
                            "Currency Code" := BankAcc."Currency Code";
                            VALIDATE("Currency Code");
                        END;
                    "Account Type"::"Fixed Asset":
                        BEGIN
                            FA.GET("Account No.");
                            "Account Name" := FA.Description;
                        END;
                END;

                CreateDim(
                  DimMgt.TypeToTableID1("Account Type"), "Account No.",
                  DimMgt.TypeToTableID1("Bal. Account Type"), "Bal. Account No.",
                  DATABASE::Job, "Job No.",
                  DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code",
                  DATABASE::Campaign, "Campaign No.");
            end;
        }
        field(5; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(6; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                TestStatusOpen;

                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date", "Currency Code",
                        Amount, "Currency Factor"));

                Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                UpdateLineBalance;
            end;
        }
        field(7; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                TestStatusOpen;

                //DELI FROST REQUEST TO ENTER AMOUNT LCY MANUALLY
                IF "Currency Code" <> '' THEN BEGIN
                    TESTFIELD("Currency Factor");
                    Amount := ROUND("Amount (LCY)" * "Currency Factor", Currency."Amount Rounding Precision");
                END;
                //
                IF "Currency Code" = '' THEN BEGIN
                    Amount := "Amount (LCY)";
                    VALIDATE(Amount);
                END ELSE BEGIN
                    IF CheckFixedCurrency THEN BEGIN
                        GetCurrency;
                        Amount := ROUND(
                          CurrExchRate.ExchangeAmtLCYToFCY(
                            "Posting Date", "Currency Code",
                            "Amount (LCY)", "Currency Factor"),
                            Currency."Amount Rounding Precision")
                    END ELSE BEGIN
                        TESTFIELD("Amount (LCY)");
                        TESTFIELD(Amount);
                        "Currency Factor" := Amount / "Amount (LCY)";
                    END;
                END;

                UpdateLineBalance;
            end;
        }
        field(8; "Debit Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                TestStatusOpen;

                GetCurrency;
                "Debit Amount" := ROUND("Debit Amount", Currency."Amount Rounding Precision");
                Amount := "Debit Amount";
                VALIDATE(Amount);
            end;
        }
        field(9; "Credit Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                TestStatusOpen;

                GetCurrency;
                "Credit Amount" := ROUND("Credit Amount", Currency."Amount Rounding Precision");
                Amount := -"Credit Amount";
                VALIDATE(Amount);
            end;
        }
        field(10; "Line No."; Integer)
        {
        }
        field(15; "Currency Code"; Code[20])
        {
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TestStatusOpen;

                GetCurrency;
                IF "Currency Code" <> '' THEN BEGIN
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       ("Posting Date" <> xRec."Posting Date") OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
                END ELSE
                    "Currency Factor" := 0;
                VALIDATE("Currency Factor");
                IF "Currency Factor" <> 0 THEN
                    VALIDATE("Exchange Rate", (1 / "Currency Factor"));
                IF "Currency Code" = '' THEN
                    "Exchange Rate" := 0;
            end;
        }
        field(16; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE(Amount);
            end;
        }
        field(17; Narration; Text[150])
        {

            trigger OnValidate()
            begin
                TestStatusOpen
            end;
        }
        field(19; "Document Date"; Date)
        {
        }
        field(20; "Posting Date"; Date)
        {

            trigger OnValidate()
            begin
                TestStatusOpen
            end;
        }
        field(21; Status; Option)
        {
            OptionCaption = 'Open,Released,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";
        }
        field(23; "Exchange Rate"; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TESTFIELD("Currency Code");
                IF "Exchange Rate" <> 0 THEN
                    VALIDATE("Currency Factor", (1 / "Exchange Rate"));
            end;
        }
        field(24; "Posting Group"; Code[20])
        {
        }
        field(25; Account; Option)
        {
            OptionCaption = 'G/L Account,Customer,Local Vendor,Foreign Vendor,Local Staff,Import File,Cash,Bank,Fixed Asset,Employee';
            OptionMembers = "G/L Account",Customer,"Local Vendor","Foreign Vendor","Local Staff","Import File",Cash,Bank,"Fixed Asset",Employee;

            trigger OnValidate()
            begin
                TestStatusOpen;

                CASE Account OF
                    Account::"G/L Account":
                        VALIDATE("Account Type", Account::"G/L Account");
                    Account::Customer:
                        VALIDATE("Account Type", Account::Customer);
                    Account::"Local Vendor":
                        VALIDATE("Account Type", "Account Type"::"Vendor");
                    Account::"Foreign Vendor":
                        VALIDATE("Account Type", "Account Type"::"Vendor");
                    /*Account::Intercomany:
                        VALIDATE("Account Type", "Account Type"::Vendor);
                    Account::"Expat Staff":
                        VALIDATE("Account Type", "Account Type"::Vendor);
                        */
                    Account::"Local Staff":
                        VALIDATE("Account Type", "Account Type"::Vendor);
                    Account::"Import File":
                        VALIDATE("Account Type", "Account Type"::Vendor);

                    Account::Cash:
                        VALIDATE("Account Type", "Account Type"::"Bank Account");
                    Account::Bank:
                        VALIDATE("Account Type", "Account Type"::"Bank Account");
                    /*
                Account::"Other Bank":
                    VALIDATE("Account Type", "Account Type"::"Bank Account");
                    */
                    Account::"Fixed Asset":
                        VALIDATE("Account Type", "Account Type"::"Fixed Asset");
                    Account::Employee:
                        VALIDATE("Account Type", "Account Type"::Employee);
                END;
            end;
        }
        field(30; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset",,Employee;
        }
        field(31; "Bal. Account No."; Code[20])
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE(Blocked = FILTER(false))
            ELSE
            IF ("Bal. Account Type" = CONST(Customer), "Responsibility Center" = FILTER(<> '')) Customer."No." WHERE(Blocked = FILTER(' '), "Responsibility Center" = FIELD("Responsibility Center"))
            ELSE
            IF ("Bal. Account Type" = CONST(Customer), "Responsibility Center" = FILTER('')) Customer."No." WHERE(Blocked = FILTER(' '))
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor."No." WHERE(Blocked = FILTER(' '),
           "Vendor Type" = FILTER(Local))
            ELSE
            IF ("Bal. Account Type" = FILTER("Bank Account")) "Bank Account"."No." WHERE(Blocked = CONST(false))
            ELSE

            IF ("Bal. Account Type" = FILTER("Fixed Asset")) "Fixed Asset"."No." WHERE(Blocked = FILTER(false))
            else
            if ("Bal. Account Type" = filter(Employee)) Employee."No." Where(Status = filter(Active));

            trigger OnValidate()
            begin
                TestStatusOpen;
                //UNL >>
                IF VoucherHeader.GET("Voucher Type", "Document No.") THEN BEGIN
                    VALIDATE("Shortcut Dimension 1 Code", VoucherHeader."Shortcut Dimension 1 Code");
                    VALIDATE("Shortcut Dimension 2 Code", VoucherHeader."Shortcut Dimension 2 Code");
                    VALIDATE("Shortcut Dimension 3 Code", VoucherHeader."Shortcut Dimension 3 Code");
                    VALIDATE("Shortcut Dimension 4 Code", VoucherHeader."Shortcut Dimension 4 Code");
                    VALIDATE("Shortcut Dimension 5 Code", VoucherHeader."Shortcut Dimension 5 Code");
                    VALIDATE("Shortcut Dimension 6 Code", VoucherHeader."Shortcut Dimension 6 Code");
                    VALIDATE("Shortcut Dimension 7 Code", VoucherHeader."Shortcut Dimension 7 Code");
                    VALIDATE("Shortcut Dimension 8 Code", VoucherHeader."Shortcut Dimension 8 Code");
                    VALIDATE("Posting Date", VoucherHeader."Posting Date");
                    VALIDATE("Currency Code", VoucherHeader."Currency Code");
                    VALIDATE("Currency Factor", VoucherHeader."Currency Factor");
                    VALIDATE("Responsibility Center", VoucherHeader."Responsibility Center");
                END;
                //UNL <<

                CASE "Bal. Account Type" OF
                    "Bal. Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Bal. Account No.");
                            CheckGLAcc;
                            "Bal. Account Name" := GLAcc.Name;
                        END;
                    "Bal. Account Type"::Customer:
                        BEGIN
                            Cust.GET("Bal. Account No.");
                            "Bal. Account Name" := Cust.Name;
                            //
                            VALIDATE("Shortcut Dimension 1 Code", Cust."Global Dimension 1 Code");
                            VALIDATE("Shortcut Dimension 2 Code", Cust."Global Dimension 2 Code");
                            VALIDATE("Shortcut Dimension 3 Code", Cust."Shortcut Dimension 3 Code");
                            VALIDATE("Shortcut Dimension 4 Code", Cust."Shortcut Dimension 4 Code");
                            VALIDATE("Shortcut Dimension 5 Code", Cust."Shortcut Dimension 5 Code");
                            VALIDATE("Shortcut Dimension 6 Code", Cust."Shortcut Dimension 6 Code");
                            VALIDATE("Shortcut Dimension 7 Code", Cust."Shortcut Dimension 7 Code");
                            VALIDATE("Shortcut Dimension 8 Code", Cust."Shortcut Dimension 8 Code");

                            "Currency Code" := Cust."Currency Code";
                            "Responsibility Center" := Cust."Responsibility Center";
                            VALIDATE("Currency Code");
                            //

                        END;
                    "Bal. Account Type"::Vendor:
                        BEGIN
                            Vend.GET("Bal. Account No.");
                            "Bal. Account Name" := Vend.Name;
                            "Shortcut Dimension 1 Code" := Vend."Global Dimension 1 Code";
                            "Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                            "Currency Code" := Vend."Currency Code";
                            VALIDATE("Currency Code");
                        END;
                    "Bal. Account Type"::Employee:
                        BEGIN
                            Emp.GET("Bal. Account No.");
                            "Bal. Account Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + emp."Last Name";
                            "Shortcut Dimension 1 Code" := Vend."Global Dimension 1 Code";
                            "Shortcut Dimension 2 Code" := Vend."Global Dimension 2 Code";
                            //VALIDATE("Currency Code");
                        END;
                    "Bal. Account Type"::"Bank Account":
                        BEGIN
                            BankAcc.GET("Bal. Account No.");
                            BankAcc.TESTFIELD(Blocked, FALSE);
                            "Bal. Account Name" := BankAcc.Name;

                            "Currency Code" := BankAcc."Currency Code";
                            VALIDATE("Currency Code");
                        END;
                    "Bal. Account Type"::"Fixed Asset":
                        BEGIN
                            FA.GET("Bal. Account No.");
                            "Bal. Account Name" := FA.Description;
                        END;
                END;

                CreateDim(
                  DimMgt.TypeToTableID1("Bal. Account Type"), "Bal. Account No.",
                  DimMgt.TypeToTableID1("Bal. Account Type"), "Bal. Account No.",
                  DATABASE::Job, "Job No.",
                  DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code",
                  DATABASE::Campaign, "Campaign No.");
            end;
        }
        field(34; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(35; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
                PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
                OldAppliesToDocNo: Code[20];
                EmpLedgEntry: record "Employee Ledger Entry";
            begin

                TESTFIELD("Account No.");

                CASE Account OF
                    Account::Customer:
                        BEGIN
                            CustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date");
                            CustLedgEntry.SETRANGE("Customer No.", "Account No.");
                            IF PAGE.RUNMODAL(PAGE::"Customer Ledger Entries", CustLedgEntry) = ACTION::LookupOK THEN BEGIN
                                VALIDATE("Applies-to Doc. No.", CustLedgEntry."Document No.");
                                VALIDATE("Applies-to Doc. Type", CustLedgEntry."Document Type");
                            END;
                        END;
                    Account::"Local Vendor", Account::"Foreign Vendor":
                        BEGIN
                            VendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                            VendLedgEntry.SETRANGE("Vendor No.", "Account No.");
                            IF PAGE.RUNMODAL(PAGE::"Vendor Ledger Entries", VendLedgEntry) = ACTION::LookupOK THEN BEGIN
                                VALIDATE("Applies-to Doc. No.", VendLedgEntry."Document No.");
                                VALIDATE("Applies-to Doc. Type", VendLedgEntry."Document Type");
                            END;
                        END;
                    Account::Employee:
                        BEGIN
                            EmpLedgEntry.SETCURRENTKEY("Employee No.", "Posting Date");
                            EmpLedgEntry.SETRANGE("Employee No.", "Account No.");
                            IF PAGE.RUNMODAL(PAGE::"Employee Ledger Entries", EmpLedgEntry) = ACTION::LookupOK THEN BEGIN
                                VALIDATE("Applies-to Doc. No.", EmpLedgEntry."Document No.");
                                VALIDATE("Applies-to Doc. Type", EmpLedgEntry."Document Type");
                            END;
                        END;
                END;
            end;

            trigger OnValidate()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                VendLedgEntry: Record "Vendor Ledger Entry";
                TempVoucherLine: Record "Voucher Line" temporary;
                EmpLedgEntry: record "Employee Ledger Entry";
            begin

                TempVoucherLine := Rec;

                IF TempVoucherLine.Account = TempVoucherLine.Account::Customer THEN BEGIN
                    CustLedgEntry.SETCURRENTKEY("Document No.");
                    CustLedgEntry.SETRANGE("Document No.", xRec."Applies-to Doc. No.");
                    IF NOT (xRec."Applies-to Doc. Type" = "Applies-to Doc. Type"::" ") THEN
                        CustLedgEntry.SETRANGE("Document Type", xRec."Applies-to Doc. Type");
                    CustLedgEntry.SETRANGE("Customer No.", TempVoucherLine."Account No.");
                    CustLedgEntry.SETRANGE(Open, TRUE);
                    IF CustLedgEntry.FIND('-') THEN BEGIN
                        IF CustLedgEntry."Amount to Apply" <> 0 THEN BEGIN
                            CustLedgEntry."Amount to Apply" := 0;
                            CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", CustLedgEntry);
                        END;
                    END;
                END ELSE
                    IF TempVoucherLine."Account Type" = TempVoucherLine."Account Type"::Employee THEN BEGIN
                        EmpLedgEntry.SETCURRENTKEY("Document No.");
                        EmpLedgEntry.SETRANGE("Document No.", xRec."Applies-to Doc. No.");
                        IF NOT (xRec."Applies-to Doc. Type" = "Applies-to Doc. Type"::" ") THEN
                            EmpLedgEntry.SETRANGE("Document Type", xRec."Applies-to Doc. Type");
                        EmpLedgEntry.SETRANGE("Employee No.", TempVoucherLine."Account No.");
                        EmpLedgEntry.SETRANGE(Open, TRUE);
                        IF EmpLedgEntry.FIND('-') THEN BEGIN
                            IF EmpLedgEntry."Amount to Apply" <> 0 THEN BEGIN
                                EmpLedgEntry."Amount to Apply" := 0;
                                CODEUNIT.RUN(CODEUNIT::"Empl. Entry-Edit", EmpLedgEntry);
                            END;
                        END;
                        //SetApplyAmount;
                        //END;
                    END ELSE
                        IF TempVoucherLine."Account Type" = TempVoucherLine."Account Type"::Vendor THEN BEGIN
                            VendLedgEntry.SETCURRENTKEY("Document No.");
                            VendLedgEntry.SETRANGE("Document No.", xRec."Applies-to Doc. No.");
                            IF NOT (xRec."Applies-to Doc. Type" = "Applies-to Doc. Type"::" ") THEN
                                VendLedgEntry.SETRANGE("Document Type", xRec."Applies-to Doc. Type");
                            VendLedgEntry.SETRANGE("Vendor No.", TempVoucherLine."Account No.");
                            VendLedgEntry.SETRANGE(Open, TRUE);
                            IF VendLedgEntry.FIND('-') THEN BEGIN
                                IF VendLedgEntry."Amount to Apply" <> 0 THEN BEGIN
                                    VendLedgEntry."Amount to Apply" := 0;
                                    CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                                END;
                            END;
                            SetApplyAmount;
                        END;

                ValidateApplyRequirements(Rec);
            end;
        }
        field(36; "Applies to File No."; Code[20])
        {
            Editable = false;
        }
        field(37; "Bal. Account Name"; Text[100])
        {

        }
        field(50; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(51; "Posting No. Series"; Code[20])
        {
        }
        field(70; "Bank Payment Type"; Option)
        {
            Caption = 'Bank Payment Type';
            OptionCaption = ' ,Computer Check,Manual Check';
            OptionMembers = " ","Computer Check","Manual Check";

            trigger OnValidate()
            begin
                IF ("Bank Payment Type" <> "Bank Payment Type"::" ") AND
                   ("Account Type" <> "Account Type"::"Bank Account")
                THEN
                    ERROR(Text007, FIELDCAPTION("Account Type"));
                IF ("Account Type" = "Account Type"::"Fixed Asset") THEN
                    FIELDERROR("Account Type");
            end;
        }
        field(75; "Check Printed"; Boolean)
        {
            Caption = 'Check Printed';
            Editable = false;
        }
        field(76; "Source Code"; Code[20])
        {
        }
        field(100; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(101; "Created By Name"; Text[50])
        {
            Editable = false;
        }
        field(102; "Created Date"; Date)
        {
            Editable = false;
        }
        field(103; "Created Time"; Time)
        {
            Editable = false;
        }
        field(104; "Modified By"; Code[50])
        {
            Editable = false;
        }
        field(105; "Modified By Name"; Text[50])
        {
            Editable = false;
        }
        field(106; "Modified Date"; Date)
        {
            Editable = false;
        }
        field(107; "Modified Time"; Time)
        {
            Editable = false;
        }
        field(50001; "Dimension Set ID"; Integer)
        {
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(50002; "Bank Receipt Type"; Option)
        {
            OptionMembers = " ","Advance Payment";
        }
        field(50003; "FA Posting Date"; Date)
        {
            Caption = 'FA Posting Date';
        }
        field(50004; "FA Posting Type"; Option)
        {
            Caption = 'FA Posting Type';
            OptionCaption = ' ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance';
            OptionMembers = " ","Acquisition Cost",Depreciation,"Write-Down",Appreciation,"Custom 1","Custom 2",Disposal,Maintenance;

            trigger OnValidate()
            begin
                IF NOT (("Account Type" = "Account Type"::"Fixed Asset") OR
                         ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset")) AND
                   ("FA Posting Type" = "FA Posting Type"::" ")
                THEN BEGIN
                    "FA Posting Date" := 0D;
                    //"Salvage Value" := 0;
                    "No. of Depreciation Days" := 0;
                    "Depr. until FA Posting Date" := FALSE;
                    "Depr. Acquisition Cost" := FALSE;
                    "Maintenance Code" := '';
                    "Insurance No." := '';
                    "Budgeted FA No." := '';
                    "Duplicate in Depreciation Book" := '';
                    "Use Duplication List" := FALSE;
                    "FA Reclassification Entry" := FALSE;
                    "FA Error Entry No." := 0;
                END;

                "FA Posting Date" := "Posting Date";

                IF "FA Posting Type" <> "FA Posting Type"::"Acquisition Cost" THEN
                    TESTFIELD("Insurance No.", '');
                IF "FA Posting Type" <> "FA Posting Type"::Maintenance THEN
                    TESTFIELD("Maintenance Code", '');

                /*GetFAVATSetup;
                GetFAAddCurrExchRate;
                */

            end;
        }
        field(50006; "Teller / Cheque No."; Code[30])
        {

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(50007; "External Document No."; Code[30])
        {

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(50008; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(50009; "Job No."; Code[20])
        {
        }
        field(50010; "Salespers./Purch. Code"; Code[20])
        {

            trigger OnValidate()
            begin
                CreateDim(
                  DATABASE::Campaign, "Campaign No.",
                  DimMgt.TypeToTableID1("Account Type"), "Account No.",
                  DimMgt.TypeToTableID1("Bal. Account Type"), "Bal. Account No.",
                  DATABASE::Job, "Job No.",
                  DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code");
            end;
        }
        field(50011; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;

            trigger OnValidate()
            begin
                CreateDim(
                  DATABASE::Campaign, "Campaign No.",
                  DimMgt.TypeToTableID1("Account Type"), "Account No.",
                  DimMgt.TypeToTableID1("Bal. Account Type"), "Bal. Account No.",
                  DATABASE::Job, "Job No.",
                  DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code");
            end;
        }
        field(50012; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            begin
                IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN
                    ClearCustVendApplnEntry;
                SetJournalLineFieldsFromApplication;
            end;
        }
        field(50013; "Applies-to Ext. Doc. No."; Code[35])
        {
            Caption = 'Applies-to Ext. Doc. No.';
        }
        field(50014; "No. of Depreciation Days"; Integer)
        {
            BlankZero = true;
            Caption = 'No. of Depreciation Days';
        }
        field(50015; "Depr. until FA Posting Date"; Boolean)
        {
            Caption = 'Depr. until FA Posting Date';
        }
        field(50016; "Depr. Acquisition Cost"; Boolean)
        {
            Caption = 'Depr. Acquisition Cost';
        }
        field(50017; "Maintenance Code"; Code[20])
        {
            Caption = 'Maintenance Code';
            TableRelation = Maintenance;

            trigger OnValidate()
            begin
                IF "Maintenance Code" <> '' THEN
                    TESTFIELD("FA Posting Type", "FA Posting Type"::Maintenance);
            end;
        }
        field(50018; "Insurance No."; Code[20])
        {
            Caption = 'Insurance No.';
            TableRelation = Insurance;

            trigger OnValidate()
            begin
                IF "Insurance No." <> '' THEN
                    TESTFIELD("FA Posting Type", "FA Posting Type"::"Acquisition Cost");
            end;
        }
        field(50019; "Budgeted FA No."; Code[20])
        {
            Caption = 'Budgeted FA No.';
            TableRelation = "Fixed Asset";

            trigger OnValidate()
            begin
                IF "Budgeted FA No." <> '' THEN BEGIN
                    FA.GET("Budgeted FA No.");
                    FA.TESTFIELD("Budgeted Asset", TRUE);
                END;
            end;
        }
        field(50020; "Duplicate in Depreciation Book"; Code[20])
        {
            Caption = 'Duplicate in Depreciation Book';
            TableRelation = "Depreciation Book";

            trigger OnValidate()
            begin
                "Use Duplication List" := FALSE;
            end;
        }
        field(50021; "Use Duplication List"; Boolean)
        {
            Caption = 'Use Duplication List';

            trigger OnValidate()
            begin
                "Duplicate in Depreciation Book" := '';
            end;
        }
        field(50022; "FA Reclassification Entry"; Boolean)
        {
            Caption = 'FA Reclassification Entry';
        }
        field(50023; "FA Error Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'FA Error Entry No.';
            TableRelation = "FA Ledger Entry";
        }
        field(50024; "Depreciation Book Code"; code[20])
        {
            //BlankZero = true;
            Caption = 'FA Error Entry No.';
            TableRelation = "Depreciation Book";
        }

        field(60000; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(60001; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(60002; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(60003; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(60004; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(60005; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(60006; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(60007; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(60008; "Expat Name"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE("Dimension Code" = FILTER('EXPATS'),
                                                               Code = FIELD("Shortcut Dimension 7 Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60009; GLAccountType; enum "G/L Account Type")
        {
            CalcFormula = Lookup("G/L Account"."Account Type" WHERE("No." = FIELD("Account No.")));
            FieldClass = FlowField;
            // OptionCaption = 'Posting,Heading,Total,Begin-Total,End-Total';
            // OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";
        }
        field(60010; "Customer No."; Code[20])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                IF Cust.GET("Customer No.") THEN
                    "Customer Name" := Cust.Name
                ELSE
                    "Customer Name" := '';
            end;
        }
        field(60011; "Customer Name"; Text[50])
        {
            Editable = false;
        }
        field(60012; "VAT Rate"; Decimal)
        {

        }
        field(60013; "W/Tax Rate"; Decimal)
        {

        }
        field(60014; "Payment Request No."; Code[20])
        {

        }

    }

    keys
    {
        key(Key1; "Voucher Type", "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Debit Amount", "Credit Amount", Amount, "Amount (LCY)";
        }
        key(Key2; "Posting Date")
        {
        }
        key(Key3; "Voucher Type", "Posting Date", "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Responsibility Center" := UserMgt.GetRespCenter(3, "Responsibility Center");
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        Emp: Record Employee;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        DimMgt: Codeunit DimensionManagement;
        CurrencyCode: Code[20];
        SourceCodeSetup: Record "Source Code Setup";
        VoucherHeader: Record "Voucher Header";
        DimValue: Record "Dimension Value";
        VLERec: Record "Vendor Ledger Entry";
        DocDimensions: Page "IC Document Dimensions";
        JobRec: Record Job;
        JobTaskRec: Record "Job Task";
        CustLedgEntry: Record "Cust. Ledger Entry";
        EmpLedgEntry: record "Employee Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        ApplyCustEntries: Page "Apply Customer Entries";
        ApplyVendEntries: Page "Apply Vendor Entries";
        UserMgt: Codeunit "User Setup Management";
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        EmpEntrySetApplID: Codeunit "Empl. Entry-SetAppl.ID";
        Text002: Label 'cannot be specified without %1';
        Text004: Label 'Account Type should not be %1, in %2.';
        Text007: Label '%1 or %2 must be a Bank Account.';
        Text008: Label 'You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post %1 %2 and then apply it to %3 %4.';
        Text009: Label 'The %1 in the %2 will be changed from %3 to %4.\';
        Text010: Label 'Do you wish to continue?';
        Text011: Label 'The update has been interrupted to respect the warning.';


    [Scope('Cloud')]
    procedure InitRecord()
    begin
        CASE "Voucher Type" OF
            "Voucher Type"::JV:
                BEGIN
                    SourceCodeSetup.GET;
                    "Source Code" := SourceCodeSetup."Cash Receipt Voucher";
                END;
            "Voucher Type"::CPV:
                BEGIN
                    SourceCodeSetup.GET;
                    "Source Code" := SourceCodeSetup."Cash Payment Voucher";
                END;
            "Voucher Type"::CRV:
                BEGIN
                    SourceCodeSetup.GET;
                    "Source Code" := SourceCodeSetup."Bank Payment Voucher";
                END;
            "Voucher Type"::BPV:
                BEGIN
                    SourceCodeSetup.GET;
                    "Source Code" := SourceCodeSetup."Bank Receipt Voucher";
                END;
            "Voucher Type"::BRV:
                BEGIN
                    SourceCodeSetup.GET;
                    "Source Code" := SourceCodeSetup."Journal Voucher";
                END;
        END;
    end;

    local procedure GetCurrency()
    begin
        CurrencyCode := "Currency Code";

        IF CurrencyCode = '' THEN BEGIN
            CLEAR(Currency);
            Currency.InitRoundingPrecision
        END ELSE
            IF CurrencyCode <> Currency.Code THEN BEGIN
                Currency.GET(CurrencyCode);
                Currency.TESTFIELD("Amount Rounding Precision");
            END;
    end;

    [Scope('Cloud')]
    procedure CheckFixedCurrency(): Boolean
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        CurrExchRate.SETRANGE("Currency Code", "Currency Code");
        CurrExchRate.SETRANGE("Starting Date", 0D, "Posting Date");

        IF NOT CurrExchRate.FIND('+') THEN
            EXIT(FALSE);

        IF CurrExchRate."Relational Currency Code" = '' THEN
            EXIT(
              CurrExchRate."Fix Exchange Rate Amount" =
              CurrExchRate."Fix Exchange Rate Amount"::Both);

        IF CurrExchRate."Fix Exchange Rate Amount" <>
          CurrExchRate."Fix Exchange Rate Amount"::Both
        THEN
            EXIT(FALSE);

        CurrExchRate.SETRANGE("Currency Code", CurrExchRate."Relational Currency Code");
        IF CurrExchRate.FIND('+') THEN
            EXIT(
              CurrExchRate."Fix Exchange Rate Amount" =
              CurrExchRate."Fix Exchange Rate Amount"::Both);

        EXIT(FALSE);
    end;

    [Scope('Cloud')]
    procedure ShowDimensions()
    var
        DocDim: Record "IC Document Dimension";
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Voucher Type", "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    [Scope('Cloud')]
    procedure ShowShortcutDimCode(var ShortcutDimCode: array[15] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    [Scope('Cloud')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    [Scope('Cloud')]
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    [Scope('Cloud')]
    procedure TestStatusOpen()
    begin
        IF VoucherHeader.GET("Voucher Type", "Document No.") THEN
            VoucherHeader.TESTFIELD(Status, VoucherHeader.Status::Open);
    end;

    [Scope('Cloud')]
    procedure SetApplyAmount()
    begin

        IF Account = Account::Customer THEN BEGIN
            CustLedgEntry.SETCURRENTKEY("Document No.");
            CustLedgEntry.SETRANGE("Document No.", Rec."Applies-to Doc. No.");
            CustLedgEntry.SETRANGE("Customer No.", "Account No.");
            CustLedgEntry.SETRANGE(Open, TRUE);
            IF CustLedgEntry.FIND('-') THEN
                IF CustLedgEntry."Amount to Apply" = 0 THEN BEGIN
                    CustLedgEntry.CALCFIELDS("Remaining Amount");
                    CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
                    CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", CustLedgEntry);
                END;
        END ELSE
            IF Account = Account::Employee THEN BEGIN
                EmpLedgEntry.SETCURRENTKEY("Document No.");
                EmpLedgEntry.SETRANGE("Document No.", Rec."Applies-to Doc. No.");
                EmpLedgEntry.SETRANGE("Employee No.", "Account No.");
                EmpLedgEntry.SETRANGE(Open, TRUE);
                IF EmpLedgEntry.FIND('-') THEN
                    IF EmpLedgEntry."Amount to Apply" = 0 THEN BEGIN
                        EmpLedgEntry.CALCFIELDS("Remaining Amount");
                        EmpLedgEntry."Amount to Apply" := EmpLedgEntry."Remaining Amount";
                        CODEUNIT.RUN(CODEUNIT::"Empl. Entry-Edit", EmpLedgEntry);
                    END;
            END ELSE
                IF (Account = Account::"Local Vendor") OR ((Account = Account::"Foreign Vendor")) THEN BEGIN
                    VendLedgEntry.SETCURRENTKEY("Document No.");
                    VendLedgEntry.SETRANGE("Document No.", Rec."Applies-to Doc. No.");
                    VendLedgEntry.SETRANGE("Vendor No.", "Account No.");
                    VendLedgEntry.SETRANGE(Open, TRUE);
                    IF VendLedgEntry.FIND('-') THEN
                        IF VendLedgEntry."Amount to Apply" = 0 THEN BEGIN
                            VendLedgEntry.CALCFIELDS("Remaining Amount");
                            VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                            CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                        END;
                END;
    end;

    [Scope('Cloud')]
    procedure ValidateApplyRequirements(TempVoucherLine: Record "Voucher Line" temporary)
    begin

        IF TempVoucherLine."Account Type" = TempVoucherLine."Account Type"::Customer THEN BEGIN
            IF TempVoucherLine."Applies-to Doc. No." <> '' THEN BEGIN
                CustLedgEntry.SETCURRENTKEY("Document No.");
                CustLedgEntry.SETRANGE("Document No.", TempVoucherLine."Applies-to Doc. No.");
                IF TempVoucherLine."Applies-to Doc. Type" <> TempVoucherLine."Applies-to Doc. Type"::" " THEN
                    CustLedgEntry.SETRANGE("Document Type", TempVoucherLine."Applies-to Doc. Type");
                CustLedgEntry.SETRANGE("Customer No.", TempVoucherLine."Account No.");
                CustLedgEntry.SETRANGE(Open, TRUE);
                IF CustLedgEntry.FIND('-') THEN
                    IF (TempVoucherLine."Posting Date" < CustLedgEntry."Posting Date") THEN
                        ERROR(
                          Text008, TempVoucherLine."Voucher Type", TempVoucherLine."Document No.",
                          CustLedgEntry."Document Type", CustLedgEntry."Document No.");
            END;
            IF TempVoucherLine."Account Type" = TempVoucherLine."Account Type"::Vendor THEN BEGIN
            END ELSE
                IF TempVoucherLine."Applies-to Doc. No." <> '' THEN BEGIN
                    VendLedgEntry.SETCURRENTKEY("Document No.");
                    VendLedgEntry.SETRANGE("Document No.", TempVoucherLine."Applies-to Doc. No.");
                    IF TempVoucherLine."Applies-to Doc. Type" <> TempVoucherLine."Applies-to Doc. Type"::" " THEN
                        VendLedgEntry.SETRANGE("Document Type", TempVoucherLine."Applies-to Doc. Type");
                    VendLedgEntry.SETRANGE("Vendor No.", TempVoucherLine."Account No.");
                    VendLedgEntry.SETRANGE(Open, TRUE);
                    IF VendLedgEntry.FIND('-') THEN
                        IF (TempVoucherLine."Posting Date" < VendLedgEntry."Posting Date") THEN
                            ERROR(
                              Text008, TempVoucherLine."Voucher Type", TempVoucherLine."Document No.",
                              VendLedgEntry."Document Type", VendLedgEntry."Document No.");
                END;
            IF TempVoucherLine."Account Type" = TempVoucherLine."Account Type"::Employee THEN BEGIN
            END ELSE
                IF TempVoucherLine."Applies-to Doc. No." <> '' THEN BEGIN
                    EmpLedgEntry.SETCURRENTKEY("Document No.");
                    EmpLedgEntry.SETRANGE("Document No.", TempVoucherLine."Applies-to Doc. No.");
                    IF TempVoucherLine."Applies-to Doc. Type" <> TempVoucherLine."Applies-to Doc. Type"::" " THEN
                        EmpLedgEntry.SETRANGE("Document Type", TempVoucherLine."Applies-to Doc. Type");
                    EmpLedgEntry.SETRANGE("Employee No.", TempVoucherLine."Account No.");
                    EmpLedgEntry.SETRANGE(Open, TRUE);
                    IF EmpLedgEntry.FIND('-') THEN
                        IF (TempVoucherLine."Posting Date" < EmpLedgEntry."Posting Date") THEN
                            ERROR(
                              Text008, TempVoucherLine."Voucher Type", TempVoucherLine."Document No.",
                              EmpLedgEntry."Document Type", EmpLedgEntry."Document No.");
                END;

        END;
    end;

    [Scope('Cloud')]
    procedure UpdateLineBalance()
    begin
        IF (Amount > 0)
        THEN BEGIN
            "Debit Amount" := Amount;
            "Credit Amount" := 0
        END ELSE BEGIN
            "Debit Amount" := 0;
            "Credit Amount" := -Amount;
        END;
        IF "Currency Code" = '' THEN
            "Amount (LCY)" := Amount;
    end;

    [Scope('Cloud')]
    procedure "...............TL..................."()
    begin
    end;

    [Scope('Cloud')]
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20])
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        // "Dimension Set ID" :=
        //   DimMgt.GetDefaultDimID(
        //     TableID, No, "Source Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);



    end;

    [Scope('Cloud')]
    procedure CheckGLAcc()
    begin

        GLAcc.CheckGLAcc;
        IF GLAcc."Direct Posting" THEN
            EXIT;
        IF "Posting Date" <> 0D THEN
            IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
                EXIT;
        GLAcc.TESTFIELD("Direct Posting", TRUE);
    end;

    [Scope('Cloud')]
    procedure ClearCustVendApplnEntry()
    var
        TempCustLedgEntry: Record "Cust. Ledger Entry";
        TempVendLedgEntry: Record "Vendor Ledger Entry";
        CustEntryEdit: Codeunit "Cust. Entry-Edit";
        VendEntryEdit: Codeunit "Vend. Entry-Edit";
        EmpEntryEdit: Codeunit "Empl. Entry-Edit";

        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset",Employee;
        AccNo: Code[20];
    begin
        GetAccTypeAndNo(AccType, AccNo);
        CASE AccType OF
            AccType::Customer:
                IF "Applies-to ID" <> '' THEN BEGIN
                    IF FindFirstCustLedgEntryWithAppliesToID(AccNo) THEN BEGIN
                        ClearCustApplnEntryFields;
                        CustEntrySetApplID.SetApplId(CustLedgEntry, TempCustLedgEntry, '');
                    END
                END ELSE
                    IF "Applies-to Doc. No." <> '' THEN
                        IF FindFirstCustLedgEntryWithAppliesToDocNo(AccNo) THEN BEGIN
                            ClearCustApplnEntryFields;
                            CustEntryEdit.RUN(CustLedgEntry);
                        END;

            AccType::Vendor:
                IF "Applies-to ID" <> '' THEN BEGIN
                    IF FindFirstVendLedgEntryWithAppliesToID(AccNo) THEN BEGIN
                        ClearVendApplnEntryFields;
                        VendEntrySetApplID.SetApplId(VendLedgEntry, TempVendLedgEntry, '');
                    END
                END ELSE
                    IF "Applies-to Doc. No." <> '' THEN
                        IF FindFirstVendLedgEntryWithAppliesToDocNo(AccNo) THEN BEGIN
                            ClearVendApplnEntryFields;
                            VendEntryEdit.RUN(VendLedgEntry);
                        END;
        END;
    end;

    local procedure SetJournalLineFieldsFromApplication()
    var
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        AccNo: Code[20];
    begin
        //"Exported to Payment File" := FALSE;
        GetAccTypeAndNo(AccType, AccNo);
        CASE AccType OF
            AccType::Customer:
                IF "Applies-to ID" <> '' THEN BEGIN
                    IF FindFirstCustLedgEntryWithAppliesToID(AccNo) THEN BEGIN
                        CustLedgEntry.SETRANGE("Exported to Payment File", TRUE);
                        //"Exported to Payment File" := CustLedgEntry.FINDFIRST;
                    END
                END ELSE
                    IF "Applies-to Doc. No." <> '' THEN
                        IF FindFirstCustLedgEntryWithAppliesToDocNo(AccNo) THEN BEGIN
                            //"Exported to Payment File" := CustLedgEntry."Exported to Payment File";
                            "Applies-to Ext. Doc. No." := CustLedgEntry."External Document No.";
                        END;
            AccType::Vendor:
                IF "Applies-to ID" <> '' THEN BEGIN
                    IF FindFirstVendLedgEntryWithAppliesToID(AccNo) THEN BEGIN
                        VendLedgEntry.SETRANGE("Exported to Payment File", TRUE);
                        //"Exported to Payment File" := VendLedgEntry.FINDFIRST;
                    END
                END ELSE
                    IF "Applies-to Doc. No." <> '' THEN
                        IF FindFirstVendLedgEntryWithAppliesToDocNo(AccNo) THEN BEGIN
                            //"Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                            "Applies-to Ext. Doc. No." := VendLedgEntry."External Document No.";
                        END;
        END;
    end;

    local procedure GetAccTypeAndNo(var AccType: Option; var AccNo: Code[20])
    begin
        IF "Bal. Account Type" IN
           ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor]
        THEN BEGIN
            AccType := "Bal. Account Type";
            AccNo := "Bal. Account No.";
        END ELSE BEGIN
            AccType := "Account Type";
            AccNo := "Account No.";
        END;
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToID(AccNo: Code[20]): Boolean
    begin
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open);
        CustLedgEntry.SETRANGE("Customer No.", AccNo);
        CustLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
        CustLedgEntry.SETRANGE(Open, TRUE);
        EXIT(CustLedgEntry.FINDFIRST)
    end;

    local procedure FindFirstEmpLedgEntryWithAppliesToID(AccNo: Code[20]): Boolean
    begin
        EmpLedgEntry.RESET;
        EmpLedgEntry.SETCURRENTKEY("Employee No.", "Applies-to ID", Open);
        EmpLedgEntry.SETRANGE("Employee No.", AccNo);
        EmpLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
        EmpLedgEntry.SETRANGE(Open, TRUE);
        EXIT(EmpLedgEntry.FINDFIRST)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToID(AccNo: Code[20]): Boolean
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open);
        VendLedgEntry.SETRANGE("Vendor No.", AccNo);
        VendLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
        VendLedgEntry.SETRANGE(Open, TRUE);
        EXIT(VendLedgEntry.FINDFIRST)
    end;

    local procedure ClearCustApplnEntryFields()
    begin
        CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
        CustLedgEntry."Accepted Payment Tolerance" := 0;
        CustLedgEntry."Amount to Apply" := 0;
    end;

    local procedure ClearVendApplnEntryFields()
    begin
        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
        VendLedgEntry."Accepted Payment Tolerance" := 0;
        VendLedgEntry."Amount to Apply" := 0;
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToDocNo(AccNo: Code[20]): Boolean
    begin
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Document No.");
        CustLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
        CustLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
        CustLedgEntry.SETRANGE("Customer No.", AccNo);
        CustLedgEntry.SETRANGE(Open, TRUE);
        EXIT(CustLedgEntry.FINDFIRST)
    end;

    local procedure FindFirstEmpLedgEntryWithAppliesToDocNo(AccNo: Code[20]): Boolean
    begin
        EmpLedgEntry.RESET;
        EmpLedgEntry.SETCURRENTKEY("Document No.");
        EmpLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
        EmpLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
        EMpLedgEntry.SETRANGE("Employee No.", AccNo);
        EmpLedgEntry.SETRANGE(Open, TRUE);
        EXIT(EmpLedgEntry.FINDFIRST)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToDocNo(AccNo: Code[20]): Boolean
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
        VendLedgEntry.SETRANGE("Document Type", "Applies-to Doc. Type");
        VendLedgEntry.SETRANGE("Vendor No.", AccNo);
        VendLedgEntry.SETRANGE(Open, TRUE);
        EXIT(VendLedgEntry.FINDFIRST)
    end;
}

