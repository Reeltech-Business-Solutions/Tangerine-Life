table 50631 "Staff Advanc Surrender Header"
{
    LookupPageID = "Staff Advance Surrender List";


    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            var
                Stadvsurr: Record "Staff Advanc Surrender Header";
            begin

                if "No." < xRec."No." then
                    if not Stadvsurr.Get(Rec."No.") then begin
                        GenLedgerSetup.GET;
                        NseriesMgt.TestManual(GetNoSeriesCode);
                        "No. Series" := '';
                    end;
            end;
        }
        field(2; "Surrender Date"; Date)
        {
        }
        field(3; Type; Code[20])
        {
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = FILTER(Payment));

            trigger OnValidate()
            begin
                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);

                if RecPayTypes.Find('-') then begin
                    Grouping := RecPayTypes."Default Grouping";
                end;

                if RecPayTypes.Find('-') then begin
                    "Account Type" := RecPayTypes."Account Type";
                    "Transaction Name" := RecPayTypes.Description;

                    if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" then begin
                        RecPayTypes.TestField(RecPayTypes."Account No.");
                        "Account No." := RecPayTypes."Account No.";
                        Validate("Account No.");
                    end;

                    //Banks
                    if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"Bank Account" then begin
                        //RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                        "Account No." := RecPayTypes."Bank Account";
                        Validate("Account No.");
                    end;


                end;

                //VALIDATE("Account No.");
            end;
        }
        field(4; "Pay Mode"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,EFT';
            OptionMembers = ,Cash,Cheque,EFT;
        }
        field(5; "Cheque No"; Code[20])
        {
        }
        field(6; "Cheque Date"; Date)
        {
        }
        field(7; "Cheque Type"; Code[20])
        {
            //TableRelation = Table50002;
        }
        field(8; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            var
                Bank: Record "Bank Account";
            begin
                if Bank.get("Bank Code") then
                    "Bank Name" := Bank.Name;
            end;
        }
        field(9; "Received From"; Text[100])
        {
        }
        field(10; "On Behalf Of"; Text[100])
        {
        }
        field(11; Cashier; Code[50])
        {
        }
        field(12; "Account Type"; Enum "Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Staff No.';
            //TableRelation = Employee."No." where(Status = filter(Active));
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE(Blocked = FILTER(false))
            ELSE
            IF ("Account Type" = CONST(Customer), "Responsibility Center" = FILTER(<> '')) Customer."No." WHERE(Blocked = FILTER(' '), "Responsibility Center" = FIELD("Responsibility Center"), "Customer Type" = filter(<> Employee))
            ELSE
            IF ("Account Type" = FILTER("Vendor")) Vendor."No." WHERE(Blocked = FILTER(' '))
            ELSE
            IF ("Account Type" = FILTER("Bank Account")) "Bank Account"."No." WHERE(Blocked = CONST(false), "Bank Type" = filter(LC))
            ELSE
            IF ("Account Type" = FILTER("Fixed Asset")) "Fixed Asset"."No." WHERE(Blocked = FILTER(false))
            else
            if ("Account Type" = filter(Employee)) Employee."No." Where(Status = filter(Active));

            trigger OnValidate()
            var
                BankAcct: Record "Bank Account";
            begin
                /*
                "Account Name":='';
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code,Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type,RecPayTypes.Type::Payment);
                
                IF "Account Type" IN ["Account Type"::"G/L Account","Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"]
                THEN
                
                CASE "Account Type" OF
                  "Account Type"::"G/L Account":
                    BEGIN
                      GLAcc.GET("Account No.");
                      "Account Name":=GLAcc.Name;
                      "VAT Code":=RecPayTypes."VAT Code";
                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                      "Global Dimension 1 Code":='';
                    END;
                  "Account Type"::Customer:
                    BEGIN
                      Cust.GET("Account No.");
                      "Account Name":=Cust.Name;
                //      "VAT Code":=Cust."Default Withholding Tax Code";
                //      "Withholding Tax Code":=Cust."Default Withholding Tax Code";
                      "Global Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    END;
                  "Account Type"::Vendor:
                    BEGIN
                      Vend.GET("Account No.");
                      "Account Name":=Vend.Name;
                //      "VAT Code":=Vend."Default VAT Code";
                //      "Withholding Tax Code":=Vend."Default Withholding Tax Code";
                      "Global Dimension 1 Code":=Vend."Global Dimension 1 Code";
                    END;
                  "Account Type"::"Bank Account":
                    BEGIN
                      BankAcc.GET("Account No.");
                      "Account Name":=BankAcc.Name;
                      "VAT Code":=RecPayTypes."VAT Code";
                      "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                      "Global Dimension 1 Code":=BankAcc."Global Dimension 1 Code";
                
                    END;
                    {
                  "Account Type"::"Fixed Asset":
                    BEGIN
                      FA.GET("Account No.");
                      "Account Name":=FA.Description;
                      "VAT Code":=FA."Default VAT Code";
                      "Withholding Tax Code":=FA."Default Withholding Tax Code";
                       "Global Dimension 1 Code":=FA."Global Dimension 1 Code";
                    END;
                    }
                END;
                */
                case "Account Type" of
                    "Account Type"::Employee:
                        begin
                            Employ.Get("Account No.");
                            "Account Name" := Employ."First Name" + ' ' + Employ."Middle Name" + ' ' + Employ."Last Name";
                        end;
                    "Account Type"::"Bank Account":
                        begin
                            BankAcct.Get("Account No.");
                            "Account Name" := BankAcct.Name;
                        end;
                end;

            end;
        }
        field(14; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Account Name"; Text[30])
        {
            Caption = 'Staff Name';
        }
        field(16; Posted; Boolean)
        {
        }
        field(17; "Date Posted"; Date)
        {
        }
        field(18; "Time Posted"; Time)
        {
        }
        field(19; "Posted By"; Code[50])
        {
        }
        field(20; Amount; Decimal)
        {
        }
        field(21; Remarks; Text[250])
        {
        }
        field(22; "Transaction Name"; Text[100])
        {
        }
        field(27; "Net Amount"; Decimal)
        {
        }
        field(28; "Paying Bank Account"; Code[20])
        {
        }
        field(29; Payee; Text[100])
        {
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Function Name" := DimVal.Name;
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(31; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Global Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(33; "Bank Account No"; Code[20])
        {
        }
        field(34; "Cashier Bank Account"; Code[20])
        {
        }
        field(35; Status; enum Status)
        {
            // OptionMembers = Open,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
            // OptionCaption = 'Open,,,,Posted,Cancelled,,,"Pending Approval",Approved';
        }
        field(37; Grouping; Code[20])
        {
            TableRelation = "Customer Posting Group".Code;
        }
        field(38; "Payment Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";
        }
        field(39; "Bank Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";
        }
        field(40; "PV Type"; Option)
        {
            OptionMembers = Normal,Other;
        }
        field(42; "Apply to ID"; Code[20])
        {
        }
        field(44; "Imprest Issue Date"; Date)
        {
        }
        field(45; Surrendered; Boolean)
        {
        }
        field(46; "Imprest Issue Doc. No"; Code[20])
        {
            Caption = 'Advance Issue Doc. No';
            TableRelation = if ("Retirement Type" = filter("Advance Retirement")) "Staff Advance Header" WHERE(Status = filter(Posted), "Account No." = field("Account No."), "Surrender Status" = filter(" "), "Type of Advance" = filter("Staff Advance"));

            trigger OnValidate()
            begin
                /*Copy the details from the payments header tableto the imprest surrender table to enable the user work on the same document*/
                /*Retrieve the header details using the get statement*/
                //delete any existing lines

                ImpSurrLine.Reset;
                ImpSurrLine.SetRange(ImpSurrLine."Surrender Doc No.", "No.");
                ImpSurrLine.DeleteAll;

                PayHeader.Reset;
                if not PayHeader.Get(Rec."Imprest Issue Doc. No") then exit;
                /*Copy the details to the user interface*/
                "Paying Bank Account" := PayHeader."Paying Bank Account";
                Payee := PayHeader.Payee;

                PayHeader.CalcFields(PayHeader."Total Net Amount");
                Amount := PayHeader."Total Net Amount";
                "Amount Surrendered LCY" := PayHeader."Total Net Amount LCY";
                //Currencies
                "Currency Factor" := PayHeader."Currency Factor";
                "Currency Code" := PayHeader."Currency Code";
                "Bank Code" := PayHeader."Paying Bank Account";
                Validate("Bank Code");
                Narration := PayHeader.Purpose;

                "Date Posted" := PayHeader."Date Posted";
                "Global Dimension 1 Code" := PayHeader."Global Dimension 1 Code";
                Validate("Global Dimension 1 Code");
                "Shortcut Dimension 2 Code" := PayHeader."Shortcut Dimension 2 Code";
                VALIDATE("Shortcut Dimension 2 Code");
                "Shortcut Dimension 3 Code" := PayHeader."Shortcut Dimension 3 Code";
                VALIDATE("Shortcut Dimension 3 Code");
                Dim3 := PayHeader.Dim3;
                "Shortcut Dimension 4 Code" := PayHeader."Shortcut Dimension 4 Code";
                VALIDATE("Shortcut Dimension 4 Code");
                Dim4 := PayHeader.Dim4;
                "Imprest Issue Date" := PayHeader.Date;
                "Advance Narration" := PayHeader.Purpose;
                "Responsibility Center" := PayHeader."Responsibility Center";
                "Group Head" := PayHeader."Group Head";
                //Yusuf Added
                //Get Line No
                if ImpSurrLine.FindLast then
                    LineNo := ImpSurrLine."Line No." + 1
                else
                    LineNo := LineNo + 1;

                /*Copy the detail lines from the imprest details table in the database*/
                PayLine.Reset;
                PayLine.SetRange(PayLine."No.", "Imprest Issue Doc. No");
                if PayLine.Find('-') then /*Copy the lines to the line table in the database*/
                  begin
                    repeat
                        ImpSurrLine.Init;
                        ImpSurrLine."Surrender Doc No." := Rec."No.";
                        //ImpSurrLine."Account No:" := '';//PayLine."Account No."  commented to allow the system not to pick control account from posted cash advance;
                        ImpSurrLine.VALIDATE("Imprest Type", PayLine."Advance Type");
                        ImpSurrLine."Account Type" := PayLine."Account Type";
                        ImpSurrLine.Grouping := PayLine.Grouping;
                        ImpSurrLine.Validate(ImpSurrLine."Account No:");
                        ImpSurrLine."Account Name" := PayLine."Account Name";
                        ImpSurrLine.Amount := PayLine.Amount;
                        ImpSurrLine."Due Date" := PayLine."Due Date";
                        ImpSurrLine."Advance Holder" := "Account No.";//PayLine."Advance Holder"
                        ImpSurrLine."Actual Spent" := PayLine."Actual Spent";
                        ImpSurrLine."Apply to" := PayLine."Apply to";
                        ImpSurrLine."Apply to ID" := PayLine."Apply to ID";
                        ImpSurrLine."Surrender Date" := PayLine."Surrender Date";
                        ImpSurrLine.Surrendered := PayLine.Surrendered;
                        ImpSurrLine."Cash Receipt No" := PayLine."M.R. No";
                        ImpSurrLine."Date Issued" := PayLine."Date Issued";
                        ImpSurrLine."Type of Surrender" := PayLine."Type of Surrender";
                        ImpSurrLine."Dept. Vch. No." := PayLine."Dept. Vch. No.";
                        ImpSurrLine."Currency Factor" := PayLine."Currency Factor";
                        ImpSurrLine."Currency Code" := PayLine."Currency Code";
                        ImpSurrLine."Imprest Req Amt LCY" := PayLine."Amount LCY";
                        ImpSurrLine."Budgetary Control A/C" := PayLine."Budgetary Control A/C";
                        ImpSurrLine."Shortcut Dimension 1 Code" := PayLine."Global Dimension 1 Code";
                        ImpSurrLine."Shortcut Dimension 2 Code" := PayLine."Shortcut Dimension 2 Code";
                        ImpSurrLine."Shortcut Dimension 3 Code" := PayLine."Shortcut Dimension 3 Code";
                        ImpSurrLine."Shortcut Dimension 4 Code" := PayLine."Shortcut Dimension 4 Code";
                        ImpSurrLine."Line on Original Document" := true;
                        LineNo += 1;
                        ImpSurrLine."Line No." := LineNo;
                        ImpSurrLine.Insert;
                    until PayLine.Next = 0;
                end;

            end;
        }
        field(47; "Vote Book"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(48; "Total Allocation"; Decimal)
        {
        }
        field(49; "Total Expenditure"; Decimal)
        {
        }
        field(50; "Total Commitments"; Decimal)
        {
        }
        field(51; Balance; Decimal)
        {
        }
        field(52; "Balance Less this Entry"; Decimal)
        {
        }
        field(54; "Petty Cash"; Boolean)
        {
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name
            end;
        }
        field(59; "Function Name"; Text[50])
        {
        }
        field(60; "Budget Center Name"; Text[50])
        {
        }
        field(61; "User ID"; Code[50])
        {
            TableRelation = User."User Security ID";
        }
        field(62; "Issue Voucher Type"; Option)
        {
            OptionMembers = " ","Cash Voucher","Payment Voucher";
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 3);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name
            end;
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 4);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(83; Dim3; Text[250])
        {
        }
        field(84; Dim4; Text[250])
        {
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
        field(87; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                /*
               TESTFIELD(Status,Status::Open,);
               IF NOT UserMgt.CheckRespCenter(1,"Shortcut Dimension 3 Code") THEN
                 ERROR(
                   Text001,
                   RespCenter.TABLECAPTION,UserMgt.GetPurchasesFilter);
                 */

            end;
        }
        field(88; "Amount Surrendered LCY"; Decimal)
        {
        }
        field(89; "Actual Spent"; Decimal)
        {
            CalcFormula = Sum("Staff Advan Surrender Details"."Actual Spent" WHERE("Surrender Doc No." = FIELD("No.")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(90; "No. Printed"; Integer)
        {
        }
        field(91; "Surrender Posting Date"; Date)
        {

            trigger OnValidate()
            begin
                //Changed to ensure Posting date is not less than the Surrender Date entered
                //COMMENTED BY LK TO CATER FOR AGL MOTORS LATE POSTING
                // if "Surrender Posting Date" <> "Surrender Date" then
                //   Error('The retirement date must be the same as posting date');
            end;
        }
        field(92; "Total Amount Advanced"; Decimal)
        {
        }
        field(95; "Allow Overexpenditure"; Boolean)
        {
            Editable = false;
        }
        field(96; "Open for Overexpenditure by"; Code[30])
        {
            Editable = false;
        }
        field(97; "Date opened for OvExpenditure"; Date)
        {
            Editable = false;
        }
        field(98; "Cash Receipt Amount"; Decimal)
        {
            CalcFormula = Sum("Staff Advan Surrender Details"."Cash Receipt Amount" WHERE("Surrender Doc No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(99; "Actual Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("Staff Advan Surrender Details"."Amount LCY" WHERE("Surrender Doc No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(100; "Commitment Status"; Boolean)
        {
        }
        field(101; Difference; Decimal)
        {
            CalcFormula = Sum("Staff Advan Surrender Details".Difference WHERE("Surrender Doc No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(102; "Amount on Original Document"; Decimal)
        {
            Description = 'Inserted when document is sent for approval';
        }
        field(103; "Bank Name"; Text[150])
        {
            Editable = false;
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
        field(50001; Description2; Text[100])
        {
        }
        field(50002; Attachment; Boolean)
        {
            // CalcFormula = Lookup(Attachment.Attached WHERE("Document No." = FIELD(No)));
            // Editable = false;
            //   FieldClass = FlowField;
        }
        field(50003; "Group Head"; Code[20])
        {
            TableRelation = "Group Head Approval";
        }
        field(50004; Narration; Text[100])
        {
        }
        field(50005; "Advance Narration"; Text[100])
        {
            TableRelation = "Staff Advance Header".Purpose;
        }
        field(50006; "Retirement Type"; Enum "Retirement Type")
        {
            //OptionMembers = "Advance Retirement","Trip Retirement",LC;
        }
        field(50007; "Created By"; Text[50])
        {

        }
        field(50008; "Created Date"; Date)
        {

        }
        field(50009; "Budget Check"; Boolean)
        {
            
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Imprest Issue Doc. No")
        {
        }
        key(Key3; "Imprest Issue Date")
        {
        }
        key(Key4; "Account No.")
        {
        }
        key(Key5; "Global Dimension 1 Code")
        {
        }
        key(Key6; "Global Dimension 2 Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // IF  Status=Status::Posted THEN
        //ERROR('Cannot Delete Document is already Posted');
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin

            GenLedgerSetup.Get;
            TestNoSeries;
            "No. Series" := GetNoSeriesCode();
            if NseriesMgt.AreRelated(GetNoSeriesCode, xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NseriesMgt.GetNextNo("No. Series");
            //  NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", 0D, "No.", "No. Series");

        end;

        //"Account Type" := "Account Type"::Employee;

        // "Surrender Date" := Today;
        //Cashier := UserId;
        // "Surrender Posting Date" := Today;
        // Validate(Cashier);

        //if UserSetup.Get(UserId) then begin
        //   UserSetup.TestField("Staff Travel Account");
        //"Account No." := UserSetup."Staff Travel Account";
        //Validate("Account No.");
        // end else
        //    Error('User must be setup under User Setup and their respective Account Entered');

        "Created By" := UserId;
        "Created Date" := Today;
    end;

    trigger OnModify()
    begin
        if Status = Status::Posted then
            Error('Cannot Modify Document is already Posted');
    end;

    var
        ImpSurrLine: Record "Staff Advan Surrender Details";
        PayHeader: Record "Staff Advance Header";
        PayLine: Record "Staff Advance Lines";
        "Withholding Tax Code": Code[200];
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        Employ: Record Employee;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NseriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "General Ledger Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        CashierLinks: Record "Cash Office User Template";
        GLAccount: Record "G/L Account";
        EntryNo: Integer;
        SingleMonth: Boolean;
        DateFrom: Date;
        DateTo: Date;
        Budget: Decimal;
        CurrMonth: Code[20];
        CurrYR: Code[20];
        BudgDate: Text[30];
        BudgetDate: Date;
        YrBudget: Decimal;
        BudgetDateTo: Date;
        BudgetAvailable: Decimal;
        GenLedSetup: Record "Cash Office Setup";
        "Total Budget": Decimal;
        CommittedAmount: Decimal;
        MonthBudget: Decimal;
        Expenses: Decimal;
        Header: Text[250];
        "Date From": Text[30];
        "Date To": Text[30];
        LastDay: Date;
        TotAmt: Decimal;
        DimVal: Record "Dimension Value";
        "VAT Code": Code[20];
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        LineNo: Integer;
        UserSetup: Record "User Setup";
        AdvHeader: Record "Staff Advance Header";

    local procedure TestNoSeries(): Boolean
    begin
        if "Payment Type" = "Payment Type"::Normal then
            GenLedgerSetup.TestField(GenLedgerSetup."Staff Advance Surrender No.")
    end;

    local procedure GetNoSeriesCode(): Code[20]
    var
        NoSrsRel: Record "No. Series Relationship";
        NoSeriesCode: Code[20];
    begin

        case "Retirement Type" of
            "Retirement Type"::"Advance Retirement":
                NoSeriesCode := GenLedgerSetup."Staff Advance Surrender No.";
        end;
        exit(GetNoSeriesRelCode(NoSeriesCode));

    end;

    procedure ShowDimensions()
    var
        DimMgt2: Codeunit DimensionManagement;
    begin
        "Dimension Set ID" :=
          DimMgt2.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Advance Surrender', "No."));
        //VerifyItemLineDim;
        DimMgt2.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt2: Codeunit DimensionManagement;
    begin
        DimMgt2.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt2: Codeunit DimensionManagement;
    begin
        DimMgt2.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    var
        DimMgt2: Codeunit DimensionManagement;
    begin
        DimMgt2.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure GetNoSeriesRelCode(NoSeriesCode: Code[20]): Code[20]
    var
        GenLedgerSetup: Record "General Ledger Setup";
        DimMgt2: Codeunit DimensionManagement;
        NoSrsRel: Record "No. Series Relationship";
    begin
        //EXIT(GetNoSeriesRelCode(NoSeriesCode));
        GenLedgerSetup.Get;
        case GenLedgerSetup."Base No. Series" of
            /*GenLedgerSetup."Base No. Series"::"1":
             BEGIN
              NoSrsRel.RESET;
              NoSrsRel.SETRANGE(Code,NoSeriesCode);
              NoSrsRel.SETRANGE("Series Filter","Responsibility Center");
              IF NoSrsRel.FINDFIRST THEN
                EXIT(NoSrsRel."Series Code")
             END;*/
            GenLedgerSetup."Base No. Series"::"Shortcut Dimension 1":
                begin
                    NoSrsRel.Reset;
                    NoSrsRel.SetRange(Code, NoSeriesCode);
                    NoSrsRel.SetRange("Series Filter", "Global Dimension 1 Code");
                    if NoSrsRel.FindFirst then
                        exit(NoSrsRel."Series Code")
                end;
            GenLedgerSetup."Base No. Series"::"Shortcut Dimension 2":
                begin
                    NoSrsRel.Reset;
                    NoSrsRel.SetRange(Code, NoSeriesCode);
                    NoSrsRel.SetRange("Series Filter", "Shortcut Dimension 2 Code");
                    if NoSrsRel.FindFirst then
                        exit(NoSrsRel."Series Code")
                end;
            GenLedgerSetup."Base No. Series"::"Shortcut Dimension 3 Code":
                begin
                    NoSrsRel.Reset;
                    NoSrsRel.SetRange(Code, NoSeriesCode);
                    NoSrsRel.SetRange("Series Filter", "Shortcut Dimension 3 Code");
                    if NoSrsRel.FindFirst then
                        exit(NoSrsRel."Series Code")
                end;
            GenLedgerSetup."Base No. Series"::"Shortcut Dimension 4":
                begin
                    NoSrsRel.Reset;
                    NoSrsRel.SetRange(Code, NoSeriesCode);
                    NoSrsRel.SetRange("Series Filter", "Shortcut Dimension 4 Code");
                    if NoSrsRel.FindFirst then
                        exit(NoSrsRel."Series Code")
                end;
            else
                exit(NoSeriesCode);
        end;

    end;
}

