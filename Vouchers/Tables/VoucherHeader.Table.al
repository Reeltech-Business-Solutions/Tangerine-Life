table 50604 "Voucher Header"
{
    Caption = 'Voucher Header';
    DataCaptionFields = "Voucher Type", "No.";
    //LookupPageID = "Voucher List";

    fields
    {
        field(1; "Voucher Type"; Enum VoucherType)
        {
            //OptionCaption = 'JV,CPV,CRV,BPV,BRV,Contra,PettyCash';
            //OptionMembers = JV,CPV,CRV,BPV,BRV,Contra,PettyCash;
        }
        field(2; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    GLSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            end;
        }
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset",Employee;

            trigger OnValidate()
            begin
                //TESTFIELD(Status, Status::Open);

            end;
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("Bank Account"),
                                "Voucher Type" = FILTER(CPV | PettyCash)) "Bank Account"."No." WHERE("Bank Type" = CONST(cash))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"."No."
            ELSE
            IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No."
            else
            IF ("Account Type" = CONST("Employee")) Employee;

            trigger OnValidate()
            var

                GLAcc: record "G/L Account";
                Cust: Record customer;
                Vend: record vendor;
                bankAcc: record "bank account";
                fa: record "Fixed Asset";
                Emp: Record Employee;

            begin
                TESTFIELD(Status, Status::Open);

                VALIDATE("Shortcut Dimension 1 Code", "Responsibility Center");

                CASE "Account Type" OF
                    "Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Account No.");
                            "Account Name" := GLAcc.Name;
                        END;
                    "Account Type"::Customer:
                        BEGIN
                            Cust.GET("Account No.");
                            "Account Name" := Cust.Name;
                            "Currency Code" := Cust."Currency Code";
                            VALIDATE("Currency Code");
                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            Vend.GET("Account No.");
                            "Account Name" := Vend.Name;
                            "Currency Code" := Vend."Currency Code";
                            VALIDATE("Currency Code");
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
                    "Account Type"::Employee:
                        BEGIN
                            Emp.GET("Account No.");
                            "Account Name" := Emp.FullName();
                            //"Currency Code" := Emp."Currency Code";
                            //VALIDATE("Currency Code");
                        END;
                END;
            end;


        }
        field(5; "Account Name"; Text[50])
        {
            Editable = false;
            trigger OnValidate()

            begin
                Clear("Account No.");
            end;

        }
        field(6; Amount; Decimal)
        {
            CalcFormula = Sum("Voucher Line".Amount WHERE("Voucher Type" = FIELD("Voucher Type"),
                                                       "Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("Voucher Line"."Amount (LCY)" WHERE("Voucher Type" = FIELD("Voucher Type"),
                                                       "Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Currency Code"; Code[20])
        {
            TableRelation = Currency;

            trigger OnValidate()
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                TESTFIELD(Status, Status::Open);
                GetCurrency;
                IF "Currency Code" <> '' THEN BEGIN
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       ("Posting Date" <> xRec."Posting Date") OR
                       (CurrFieldNo = FIELDNO(Narration)) OR
                       ("Currency Factor" = 0)
                    THEN BEGIN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
                        //UpdateVoucherLines(FIELDNO("Currency Code"));
                    END;
                END ELSE
                    "Currency Factor" := 0;
                VALIDATE("Currency Factor");
                IF "Currency Factor" <> 0 THEN
                    VALIDATE("Exchange Rate", (1 / "Currency Factor"));
            end;
        }
        field(16; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            var
                Text002: Label 'cannot be specified without %1';
            begin
                TESTFIELD(Status, Status::Open);
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                UpdateVoucherLines(FIELDNO("Currency Factor"));
            end;
        }
        field(17; Narration; Text[150])
        {
        }
        field(19; "Document Date"; Date)
        {
        }
        field(20; "Posting Date"; Date)
        {

            trigger OnValidate()
            var
                Confirmed: Boolean;
            begin
                TESTFIELD(Status, Status::Open);
                /*
                IF (xRec."Posting Date" <> "Posting Date") THEN BEGIN
                  IF HideValidationDialog OR
                    (xRec."Posting Date" = 0D)
                  THEN
                    Confirmed := TRUE
                  ELSE
                    Confirmed := CONFIRM(Text008,FALSE,FIELDCAPTION("Posting Date"));
                  IF Confirmed THEN
                      UpdateVoucherLines(FIELDNO("Posting Date"))
                  ELSE BEGIN
                    "Posting Date" := xRec."Posting Date";
                    EXIT;
                  END;
                END;
                */

            end;
        }
        field(21; Status; Option)
        {
            OptionCaption = 'Open,Released,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";

            trigger OnValidate()
            begin
                UpdateVoucherLines(FIELDNO(Status));
            end;
        }
        field(23; "Exchange Rate"; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Exchange Rate" <> 0 THEN BEGIN
                    TESTFIELD("Currency Code");
                    VALIDATE("Currency Factor", (1 / "Exchange Rate"));
                    UpdateVoucherLines(FIELDNO("Exchange Rate"));
                END;
            end;
        }
        field(24; "External Document No."; Code[20])
        {
            trigger OnValidate()
            var
                Vheader: record "Voucher Header";
                PVHeader: record "Posted Voucher Header";
            begin
                Vheader.Setrange(Vheader."External Document No.", "External Document No.");
                if Vheader.find('-') then
                    Error('Document No. %1 Already exist', "External Document No.");

                PVheader.Setrange(PVheader."External Document No.", "External Document No.");
                if PVheader.find('-') then
                    Error('Document No. %1 Already exist', "External Document No.");
            end;

        }
        field(30; "Debit Amount"; Decimal)
        {
            CalcFormula = Sum("Voucher Line"."Debit Amount" WHERE("Voucher Type" = FIELD("Voucher Type"), "Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Credit Amount"; Decimal)
        {
            CalcFormula = Sum("Voucher Line"."Credit Amount" WHERE("Voucher Type" = FIELD("Voucher Type"), "Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(51; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(70; "Bank Payment Type"; Option)
        {
            Caption = 'Bank Payment Type';
            OptionCaption = ' ,Computer Check,Manual Check';
            OptionMembers = " ","Computer Check","Manual Check";

            trigger OnValidate()
            var
                Text007: Label '%1 or %2 must be a Bank Account.';
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
        field(121; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                //VALIDATE("Shortcut Dimension 1 Code", "Responsibility Center");
                UpdateVoucherLines(FIELDNO("Responsibility Center"));
            end;
        }
        field(123; "Posting No."; Code[20])
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(50000; "Expense Request No."; Code[20])
        {
        }
        field(50001; "Bank Receipt Type"; Option)
        {
            OptionMembers = " ","Advance Payment";
        }
        field(50002; "Teller / Cheque No."; Code[20])
        {
        }
        field(50003; "Debit Amount LCY"; Decimal)
        {
            CalcFormula = Sum("Voucher Line"."Amount (LCY)" WHERE("Voucher Type" = FIELD("Voucher Type"),
                                                                   "Document No." = FIELD("No."),
                                                                   "Amount (LCY)" = FILTER(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Credit Amount LCY"; Decimal)
        {
            CalcFormula = Sum("Voucher Line"."Amount (LCY)" WHERE("Voucher Type" = FIELD("Voucher Type"),
                                                                   "Document No." = FIELD("No."),
                                                                   "Amount (LCY)" = FILTER(< 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Customer No."; Code[20])
        {
            CalcFormula = Lookup("Voucher Line"."Account No." WHERE("Voucher Type" = FIELD("Voucher Type"),
                                                                     "Document No." = FIELD("No."),
                                                                     "Account Type" = FILTER(Customer)));
            FieldClass = FlowField;
        }
        field(50006; "Customer Name"; Text[50])
        {
            CalcFormula = Lookup("Voucher Line"."Account Name" WHERE("Voucher Type" = FIELD("Voucher Type"),
                                                                      "Document No." = FIELD("No."),
                                                                      "Account Type" = FILTER(Customer)));
            FieldClass = FlowField;
        }
        field(60000; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                UpdateVoucherLines(FIELDNO("Shortcut Dimension 1 Code"));

                //"Responsibility Center" := "Shortcut Dimension 1 Code";
            end;
        }
        field(60001; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                UpdateVoucherLines(FIELDNO("Shortcut Dimension 2 Code"));
            end;
        }
        field(60002; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
                UpdateVoucherLines(FIELDNO("Shortcut Dimension 3 Code"));
            end;
        }
        field(60003; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
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
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(60007; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
        Field(60008; Budget; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Budget Entry".Amount where("Global Dimension 2 Code" = field("Shortcut Dimension 2 Code")));
        }
        field(60009; "Expended Value"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount where("Global Dimension 2 Code" = field("Shortcut Dimension 2 Code")));
        }
        field(60010; "Line Account Name"; Code[20])
        {

        }
        field(60011; "Payment Request No."; Code[20])
        {

        }
        field(60012; "JV Type"; Option)
        {
            OptionMembers = " ",Scrap;
        }
    }

    keys
    {
        key(Key1; "Voucher Type", "No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD("Check Printed", FALSE);
        //ApprovalMgt.DeleteApprovalEntry(DATABASE::"Voucher Header","Voucher Type","No.");

        VoucherLine.SETRANGE("Voucher Type", "Voucher Type");
        VoucherLine.SETRANGE("Document No.", "No.");
        IF VoucherLine.FIND('-') THEN
            VoucherLine.DELETEALL;
    end;

    trigger OnInsert()
    var

    begin
        GLSetup.GET;

        IF "No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        END;

        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;

        "Responsibility Center" := UserMgt.GetRespCenter(3, "Responsibility Center");

        InitRecord;
    end;

    trigger OnModify()
    begin
        TESTFIELD("Check Printed", FALSE);
    end;

    trigger OnRename()
    begin
        ERROR(Text003, TABLECAPTION);
    end;

    var
        //NoSeriesMgt: Codeunit "NoSeriesManagement";
        Text002: Label 'cannot be specified without %1';
        Text001: Label 'Intercompany partners do not have ledger entries.';
        DimMgt: Codeunit "DimensionManagement";
        Text003: Label 'You cannot rename a %1.';
        Text004: Label 'Account Type should not be %1, in %2.';
        CurrencyCode: Code[20];
        Text007: Label '%1 or %2 must be a Bank Account.';
        //HideValidationDialog: Boolean;
        Text008: Label 'Do you want to change %1?';
        Text009: Label 'You must Select Expense Request No. in %1,%2';
        Text010: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        //UserMgt: Codeunit "User Setup Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        Cust: Record "Customer";
        Vend: Record "Vendor";
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GenJrnlLine: Record "Gen. Journal Line";
        VoucherLine: Record "Voucher Line";
        SourceCodeSetup: Record "Source Code Setup";
        HideValidationDialog: Boolean;
        DimValue: Record "Dimension Value";
        UserMgt: Codeunit "User Setup Management";
        RespCenter: Record "Responsibility Center";
        VoucherHeader: Record "Voucher Header";
        UserSetup: Record "User Setup";


    [Scope('Cloud')]
    procedure InitRecord()
    begin
        GLSetup.GET;
        "Posting Date" := WORKDATE;

        IF GLSetup."Default Posting Date" = GLSetup."Default Posting Date"::"No Date" THEN BEGIN
            "Posting Date" := 0D;
            "Document Date" := 0D;
        END ELSE BEGIN
            "Posting Date" := WORKDATE;
            "Document Date" := WORKDATE;
        END;

        CASE "Voucher Type" OF
            "Voucher Type"::JV:
                BEGIN
                    SourceCodeSetup.GET;
                    "Source Code" := SourceCodeSetup."Journal Voucher";

                    IF "Posting No. Series" = '' THEN BEGIN
                        IF RespCenter.GET("Responsibility Center") THEN BEGIN
                            IF (RespCenter."Posted JV Nos." <> '') THEN
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", RespCenter."Posted JV Nos.");
                        END ELSE
                            NoSeriesMgt.SetDefaultSeries("Posting No. Series", GLSetup."Posted Journal Voucher Nos.");
                    END;
                END;


            "Voucher Type"::CPV:
                BEGIN
                    SourceCodeSetup.GET;
                    "Source Code" := SourceCodeSetup."Cash Payment Voucher";

                    IF "Posting No. Series" = '' THEN BEGIN
                        IF RespCenter.GET("Responsibility Center") THEN BEGIN
                            IF (RespCenter."Posted CPV Nos." <> '') THEN
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", RespCenter."Posted CPV Nos.");
                        END ELSE
                            NoSeriesMgt.SetDefaultSeries("Posting No. Series", GLSetup."Posted Cash Payment Voucher No")
                    END;
                END;



            "Voucher Type"::CRV:
                BEGIN
                    SourceCodeSetup.GET;
                    "Source Code" := SourceCodeSetup."Cash Receipt Voucher";
                    "Account Type" := "Account Type"::"Bank Account";

                    IF "Posting No. Series" = '' THEN BEGIN
                        IF RespCenter.GET("Responsibility Center") THEN BEGIN
                            IF (RespCenter."Posted CRV Nos." <> '') THEN
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", RespCenter."Posted CRV Nos.");
                        END ELSE
                            NoSeriesMgt.SetDefaultSeries("Posting No. Series", GLSetup."Posted Cash Receipt Voucher No")
                    END;
                END;


            "Voucher Type"::BPV:
                BEGIN
                    SourceCodeSetup.GET;
                    "Source Code" := SourceCodeSetup."Bank Payment Voucher";
                    "Account Type" := "Account Type"::"Bank Account";

                    IF "Posting No. Series" = '' THEN BEGIN
                        IF RespCenter.GET("Responsibility Center") THEN BEGIN
                            IF (RespCenter."Posted BPV Nos." <> '') THEN
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", RespCenter."Posted BPV Nos.");
                        END ELSE
                            NoSeriesMgt.SetDefaultSeries("Posting No. Series", GLSetup."Posted Bank Payment Voucher No")
                    END;
                END;


            "Voucher Type"::BRV:
                BEGIN
                    SourceCodeSetup.GET;
                    "Source Code" := SourceCodeSetup."Bank Receipt Voucher";
                    "Account Type" := "Account Type"::"Bank Account";

                    IF "Posting No. Series" = '' THEN BEGIN
                        IF RespCenter.GET("Responsibility Center") THEN BEGIN
                            IF (RespCenter."Posted BRV Nos." <> '') THEN
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", RespCenter."Posted JV Nos.");
                        END ELSE
                            NoSeriesMgt.SetDefaultSeries("Posting No. Series", GLSetup."Posted Bank Receipt Voucher No")
                    END;
                END;
            /*
            "Voucher Type"::Contra:
              BEGIN
                IF "Posting No. Series" = '' THEN
                  BEGIN
                   IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    IF (RespCenter."Posted Contra Voucher Nos." <> '') THEN
                      NoSeriesMgt.SetDefaultSeries("Posting No. Series",RespCenter."Posted Contra Voucher Nos.");
                   END ELSE
                    NoSeriesMgt.SetDefaultSeries("Posting No. Series",GLSetup."Posted Contra Voucher Nos.");
                    END;
              END;
              */
            "Voucher Type"::PettyCash:
                BEGIN
                    SourceCodeSetup.GET;
                    "Source Code" := SourceCodeSetup."Petty Cash Voucher";

                    IF "Posting No. Series" = '' THEN BEGIN
                        IF RespCenter.GET("Responsibility Center") THEN BEGIN
                            IF (RespCenter."Posted Petty Cash Nos" <> '') THEN
                                NoSeriesMgt.SetDefaultSeries("Posting No. Series", RespCenter."Posted Petty Cash Nos");
                        END ELSE
                            NoSeriesMgt.SetDefaultSeries("Posting No. Series", GLSetup."Posted Petty Cash No")
                    END;
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
    procedure AssistEdit(OldVoucherHeader: Record "Voucher Header"): Boolean
    begin
        GLSetup.GET;
        TestNoSeries;

        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldVoucherHeader."No. Series", "No. Series") THEN BEGIN
            GLSetup.GET;
            TestNoSeries;
            NoSeriesMgt.SetSeries("No.");
            EXIT(TRUE);
        END;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        CASE "Voucher Type" OF
            "Voucher Type"::JV:
                GLSetup.TESTFIELD(GLSetup."Journal Voucher Nos.");
            "Voucher Type"::CPV:
                GLSetup.TESTFIELD(GLSetup."Cash Payment Voucher No");
            "Voucher Type"::CRV:
                GLSetup.TESTFIELD(GLSetup."Cash Receipt Voucher No");
            "Voucher Type"::BPV:
                GLSetup.TESTFIELD(GLSetup."Bank Payment Voucher No");
            "Voucher Type"::BRV:
                GLSetup.TESTFIELD(GLSetup."Bank Receipt Voucher No");
            "Voucher Type"::Contra:
                //GLSetup.TESTFIELD(GLSetup."Contra Voucher Nos.");
                //"Voucher Type":: PettyCash:
                GLSetup.TESTFIELD(GLSetup."Petty Cash Voucher No");

        END;
    end;

    local procedure GetNoSeriesCode(): Code[20]
    begin
        /*CASE "Voucher Type" OF
          "Voucher Type"::JV:
            EXIT(GLSetup."Journal Voucher Nos.");
          "Voucher Type"::CRV:
            EXIT(GLSetup."Cash Receipt Voucher No");
          "Voucher Type"::BPV:
            EXIT(GLSetup."Bank Payment Voucher No");
          "Voucher Type"::BRV:
            EXIT(GLSetup."Bank Receipt Voucher No");
          "Voucher Type":: CPV:
            EXIT(GLSetup."Cash Payment Voucher No");
          "Voucher Type":: Contra:
            EXIT(GLSetup."Contra Voucher Nos.");
          "Voucher Type":: PettyCash:
            EXIT(GLSetup."Petty Cash Voucher No");
        
        END;
        */

        CASE "Voucher Type" OF
            "Voucher Type"::JV:
                BEGIN
                    IF "Responsibility Center" = '' THEN
                        EXIT(GLSetup."Journal Voucher Nos.")
                    ELSE BEGIN
                        RespCenter.GET("Responsibility Center");
                        IF RespCenter."JV Nos." = '' THEN
                            EXIT(GLSetup."Journal Voucher Nos.")
                        ELSE
                            EXIT(RespCenter."JV Nos.")
                    END;
                END;

            "Voucher Type"::CRV:
                BEGIN
                    IF "Responsibility Center" = '' THEN
                        EXIT(GLSetup."Cash Receipt Voucher No")
                    ELSE BEGIN
                        RespCenter.GET("Responsibility Center");
                        IF RespCenter."CRV Nos." = '' THEN
                            EXIT(GLSetup."Cash Receipt Voucher No")
                        ELSE
                            EXIT(RespCenter."CRV Nos.")
                    END;
                END;

            "Voucher Type"::BPV:
                BEGIN
                    IF "Responsibility Center" = '' THEN
                        EXIT(GLSetup."Bank Payment Voucher No")
                    ELSE BEGIN
                        RespCenter.GET("Responsibility Center");
                        IF RespCenter."BPV Nos." = '' THEN
                            EXIT(GLSetup."Bank Payment Voucher No")
                        ELSE
                            EXIT(RespCenter."BPV Nos.")
                    END;
                END;

            "Voucher Type"::BRV:
                BEGIN
                    IF "Responsibility Center" = '' THEN
                        EXIT(GLSetup."Bank Receipt Voucher No")
                    ELSE BEGIN
                        RespCenter.GET("Responsibility Center");
                        IF RespCenter."BRV Nos." = '' THEN
                            EXIT(GLSetup."Bank Receipt Voucher No")
                        ELSE
                            EXIT(RespCenter."BRV Nos.")
                    END;
                END;

            "Voucher Type"::CPV:
                BEGIN
                    IF "Responsibility Center" = '' THEN
                        EXIT(GLSetup."Cash Payment Voucher No")
                    ELSE BEGIN
                        RespCenter.GET("Responsibility Center");
                        IF RespCenter."CPV Nos." = '' THEN
                            EXIT(GLSetup."Cash Payment Voucher No")
                        ELSE
                            EXIT(RespCenter."CPV Nos.")
                    END;
                END;


            "Voucher Type"::Contra:
                BEGIN
                    IF "Responsibility Center" = '' THEN
                        EXIT(GLSetup."Contra Voucher Nos.")
                    ELSE BEGIN
                        RespCenter.GET("Responsibility Center");
                        IF RespCenter."Contra Voucher Nos." = '' THEN
                            EXIT(GLSetup."Contra Voucher Nos.")
                        ELSE
                            EXIT(RespCenter."Contra Voucher Nos.")
                    END;
                END;

            "Voucher Type"::PettyCash:
                BEGIN
                    IF "Responsibility Center" = '' THEN
                        EXIT(GLSetup."Petty Cash Voucher No")
                    ELSE BEGIN
                        RespCenter.GET("Responsibility Center");
                        IF RespCenter."Petty Cash Nos" = '' THEN
                            EXIT(GLSetup."Petty Cash Voucher No")
                        ELSE
                            EXIT(RespCenter."Petty Cash Nos")
                    END;
                END;



        END;

    end;

    [Scope('Cloud')]
    procedure VoucherLinesExist(): Boolean
    var
        VoucherLine: Record "voucher Line";
    begin
        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher Type", "Voucher Type");
        VoucherLine.SETRANGE("Document No.", "No.");
        EXIT(VoucherLine.FINDFIRST);
    end;

    [Scope('Cloud')]
    procedure ShowDocDim()
    var
        DocDim: Record "IC Document Dimension";
        ///DocDims: Page "IC Document Dimensions";
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', "Voucher Type", "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF VoucherLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
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

    local procedure UpdateVoucherLines(FieldRef: Integer)
    var
        VoucherLine: Record "voucher Line";
    begin
        VoucherLine.LOCKTABLE;
        VoucherLine.SETRANGE("Document No.", "No.");
        VoucherLine.SETFILTER("Account No.", '<>%1', '');
        IF VoucherLine.FIND('-') THEN BEGIN
            REPEAT
                CASE FieldRef OF
                    FIELDNO("Posting Date"):
                        VoucherLine.VALIDATE("Posting Date", "Posting Date");
                    FIELDNO(Status):
                        VoucherLine.VALIDATE(Status, Status);
                    FIELDNO("Shortcut Dimension 1 Code"):
                        VoucherLine.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    FIELDNO("Shortcut Dimension 2 Code"):
                        VoucherLine.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    FIELDNO("Shortcut Dimension 3 Code"):
                        VoucherLine.VALIDATE("Shortcut Dimension 3 Code", "Shortcut Dimension 3 Code");
                    FIELDNO("Shortcut Dimension 4 Code"):
                        VoucherLine.VALIDATE("Shortcut Dimension 4 Code", "Shortcut Dimension 4 Code");
                    FIELDNO("Shortcut Dimension 5 Code"):
                        VoucherLine.VALIDATE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");
                    FIELDNO("Shortcut Dimension 6 Code"):
                        VoucherLine.VALIDATE("Shortcut Dimension 6 Code", "Shortcut Dimension 6 Code");
                    FIELDNO("Shortcut Dimension 7 Code"):
                        VoucherLine.VALIDATE("Shortcut Dimension 7 Code", "Shortcut Dimension 7 Code");
                    FIELDNO("Shortcut Dimension 8 Code"):
                        VoucherLine.VALIDATE("Shortcut Dimension 8 Code", "Shortcut Dimension 8 Code");
                    FIELDNO("Currency Code"):
                        VoucherLine.VALIDATE("Currency Code", "Currency Code");
                    FIELDNO("Currency Factor"):
                        VoucherLine.VALIDATE("Currency Factor", "Currency Factor");
                    FIELDNO("Responsibility Center"):
                        VoucherLine.VALIDATE("Responsibility Center", "Responsibility Center");
                    FIELDNO("External Document No."):
                        VoucherLine.VALIDATE("External Document No.", "External Document No.");

                END;
                VoucherLine.MODIFY(TRUE);
            UNTIL VoucherLine.NEXT = 0;
        END;
    end;

    [Scope('Cloud')]
    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    [Scope('Cloud')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF "No." <> '' THEN
            MODIFY;

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF VoucherLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;

    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        ATOLink: Record "Assemble-to-Order Link";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        IF NewParentDimSetID = OldParentDimSetID THEN
            EXIT;
        IF NOT CONFIRM(Text010) THEN
            EXIT;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher Type", "Voucher Type");
        VoucherLine.SETRANGE("Document No.", "No.");
        VoucherLine.LOCKTABLE;
        IF VoucherLine.FIND('-') THEN
            REPEAT
                NewDimSetID := DimMgt.GetDeltaDimSetID(VoucherLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                IF VoucherLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
                    VoucherLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      VoucherLine."Dimension Set ID", VoucherLine."Shortcut Dimension 1 Code", VoucherLine."Shortcut Dimension 2 Code");
                    VoucherLine.MODIFY;
                END;
            UNTIL VoucherLine.NEXT = 0;
    end;
}

