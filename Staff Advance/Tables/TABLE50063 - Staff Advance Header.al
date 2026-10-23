table 50629 "Staff Advance Header"
{
    Caption = 'Staff Advance Request';


    fields
    {
        field(1; "No."; Code[20])
        {

            Description = 'Stores the reference of the payment voucher in the database';
            //Editable = false;
            //NotBlank = false;

            trigger OnValidate()
            var
                Stadv: Record "Staff Advance Header";
            begin
                if "No." < xRec."No." then
                    if not Stadv.Get(Rec."No.") then begin
                        GLSetup.GET;
                        NseriesMgt.TestManual(GetNoSeriesCode);
                        "No. Series" := '';
                    end;
            end;
        }
        field(2; Date; Date)
        {
            Description = 'Stores the date when the payment voucher was inserted into the system';

            trigger OnValidate()
            begin
                if ImpLinesExist then begin
                    Error('You first need to delete the existing imprest lines before changing the Currency Code'
                    );
                end;

                if "Currency Code" = xRec."Currency Code" then
                    UpdateCurrencyFactor;

                if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                    //RecreatePurchLines(FIELDCAPTION("Currency Code"));
                end else
                    if "Currency Code" <> '' then
                        UpdateCurrencyFactor;
                // UpdateHeaderToLine;
            end;
        }
        field(3; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(4; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            Editable = true;
            Enabled = true;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if ImpLinesExist then begin
                    Error('You first need to delete the existing imprest lines before changing the Currency Code'
                    );
                end;
                UpdateLines(FieldNo("Currency Code"));
                if "Currency Code" = xRec."Currency Code" then
                    UpdateCurrencyFactor;

                if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                end else
                    if "Currency Code" <> '' then
                        UpdateCurrencyFactor;
                //UpdateHeaderToLine;
            end;
        }
        field(9; Payee; Text[40])
        {
            Description = 'Stores the name of the person who received the money';
        }
        field(10; "On Behalf Of"; Text[100])
        {
            Description = 'Stores the name of the person on whose behalf the payment voucher was taken';
        }
        field(11; Cashier; Code[40])
        {
            Description = 'Stores the identifier of the cashier in the database';
        }
        field(16; Posted; Boolean)
        {
            Description = 'Stores whether the payment voucher is posted or not';
        }
        field(17; "Date Posted"; Date)
        {
            Description = 'Stores the date when the payment voucher was posted';
        }
        field(18; "Time Posted"; Time)
        {
            Description = 'Stores the time when the payment voucher was posted';
        }
        field(19; "Posted By"; Code[50])
        {
            Description = 'Stores the name of the person who posted the payment voucher';
        }
        field(20; "Total Payment Amount"; Decimal)
        {
            CalcFormula = Sum("Voucher Line".Amount WHERE("Document No." = FIELD("No.")));
            Description = 'Stores the amount of the payment voucher';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Paying Bank Account"; Code[50])
        {
            Description = 'Stores the name of the paying bank account in the database';
            TableRelation = IF ("Pay Mode" = CONST(Cash)) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"))
            // "Bank Type" = CONST(Cash))
            ELSE
            IF ("Pay Mode" = CONST(Cheque)) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code")) //"Bank Type" = const(Cheque))

            ELSE
            IF ("Pay Mode" = CONST(EFT)) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"))// "Bank Type" = const(EFT))
            ELSE
            IF ("Pay Mode" = CONST(" ")) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"));

            trigger OnValidate()
            begin
                BankAcc.Reset;
                "Bank Name" := '';
                if BankAcc.Get("Paying Bank Account") then begin
                    "Bank Name" := BankAcc.Name;

                end;
            end;
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
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
                Validate("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
            end;
        }
        field(35; Status; Option)
        {
            Description = 'Stores the status of the record in the database';
            OptionMembers = Open,Posted,Cancelled,"Pending Approval",Approved;
        }
        field(38; "Payment Type"; Option)
        {
            OptionMembers = Imprest;
        }
        field(55; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                UpdateLines(FIELDNO("Shortcut Dimension 1 Code"));
                //"Responsibility Center" := "Shortcut Dimension 1 Code";
                //UpdateLines(FIELDNO("Shortcut Dimension 1 Code"));
            end;
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                UpdateLines(FIELDNO("Shortcut Dimension 2 Code"));

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;
            end;
        }
        field(57; "Function Name"; Text[50])
        {
            Description = 'Stores the name of the function in the database';
        }
        field(58; "Budget Center Name"; Text[50])
        {
            Description = 'Stores the name of the budget center in the database';
        }
        field(59; "Bank Name"; Text[50])
        {
            Description = 'Stores the description of the paying bank account in the database';
        }
        field(60; "No. Series"; Code[20])
        {
            Description = 'Stores the number series in the database';
            TableRelation = "No. Series";
        }
        field(61; Select; Boolean)
        {
            Description = 'Enables the user to select a particular record';
        }
        field(62; "Total VAT Amount"; Decimal)
        {/*
            CalcFormula = Sum("Voucher Line"."VAT Amount" WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            */
        }
        field(63; "Total Witholding Tax Amount"; Decimal)
        {/*
            CalcFormula = Sum("Voucher Line"."Withholding Tax Amount" WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            */
        }
        field(64; "Total Net Amount"; Decimal)
        {
            CalcFormula = Sum("Staff Advance Lines".Amount WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Current Status"; Code[20])
        {
            Description = 'Stores the current status of the payment voucher in the database';
        }
        field(66; "Cheque No."; Code[20])
        {
        }
        field(67; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT;
        }
        field(68; "Payment Release Date"; Date)
        {

            trigger OnValidate()
            begin
                /*
                  //Changed to ensure Release date is not less than the Date entered
                  IF "Payment Release Date"<Date THEN
                     ERROR('The Payment Release Date cannot be lesser than the Document Date');
                 */

            end;
        }
        field(69; "No. Printed"; Integer)
        {
        }
        field(70; "VAT Base Amount"; Decimal)
        {
        }
        field(71; "Exchange Rate"; Decimal)
        {
        }
        field(72; "Currency Reciprical"; Decimal)
        {
        }
        field(73; "Current Source A/C Bal."; Decimal)
        {
        }
        field(74; "Cancellation Remarks"; Text[250])
        {
        }
        field(75; "Register Number"; Integer)
        {
        }
        field(76; "From Entry No."; Integer)
        {
        }
        field(77; "To Entry No."; Integer)
        {
        }
        field(78; "Invoice Currency Code"; Code[20])
        {
            Caption = 'Invoice Currency Code';
            Editable = true;
            TableRelation = Currency;
        }
        field(79; "Total Net Amount LCY"; Decimal)
        {
            CalcFormula = Sum("Staff Advance Lines"."Amount LCY" WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Document Type"; Option)
        {
            OptionMembers = "Payment Voucher","Petty Cash";
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
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    "ECU Code Description" := DimVal.Name;
                Dim3 := DimVal.Name;

                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
                UpdateLines(FIELDNO("Shortcut Dimension 3 Code"));
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
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name;

                UpdateHeaderToLine;
            end;
        }
        field(83; Dim3; Text[250])
        {
        }
        field(84; Dim4; Text[250])
        {
        }
        field(85; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                //TestField(Status, Status::Open);
                //if not UserMgt.CheckRespCenter(1, "Shortcut Dimension 3 Code") then
                //  Error(
                //  Text001,
                //RespCenter.TableCaption, UserMgt.GetPurchasesFilter); RBS
                /*
               "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
               IF "Location Code" = '' THEN BEGIN
                 IF InvtSetup.GET THEN
                   "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
               END ELSE BEGIN
                 IF Location.GET("Location Code") THEN;
                 "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
               END;

               UpdateShipToAddress;
                  */
                /*
             CreateDim(
               DATABASE::"Responsibility Center","Responsibility Center",
               DATABASE::Vendor,"Pay-to Vendor No.",
               DATABASE::"Salesperson/Purchaser","Purchaser Code",
               DATABASE::Campaign,"Campaign No.");

             IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
               RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
               "Assigned User ID" := '';
             END;
               */

            end;
        }
        field(86; "Account Type"; Enum "Account Type")
        {
            Caption = 'Account Type';
            Editable = false;
            // OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(87; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            Editable = true;
            //TableRelation = Employee where(Status = filter(Active));
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
            // if ("Account Type" = FILTER(Employee), "Type of Advance" = filter("Trip Advance")) Employee."No." Where(Status = filter(Active), "Account Type" = filter(Drivers))
            // else
            // if ("Account Type" = FILTER(Employee), "Type of Advance" = filter(LC)) Employee."No." Where(Status = filter(Active), "Account Type" = filter("Staff Debtors"))
            // else
            if ("Account Type" = FILTER(Employee), "Type of Advance" = filter("Staff Advance")) Employee."No." Where(Status = filter(Active));

            trigger OnValidate()
            begin
                // Employ.Reset;
                // case "Account Type" of
                //     "Account Type"::Employee:
                //         if Employ.Get("Account No.") then begin
                //             //Employ.SetRange("No.", "Account No.");
                //             Employ.TestField("Employee Posting Group");
                //             Employ.TestField(Status, Employ.Status::Active);
                //             //Payee := Employ.FullName;
                //             "On Behalf Of" := Employ.FullName;

                //             if Employ.Find('-') then begin
                //                 // if Employ."Middle Name" = '' then
                //                 //     Payee := Employ."First Name" + ' ' + Employ."Last Name"
                //                 // else
                //                 Payee := Employ."First Name" + ' ' + Employ."Middle Name" + ' ' + Employ."Last Name";
                //             End;
                //         End;
                // "Account Type"::"Bank Account":
                //     IF BankAcc.GET("Account No.") then
                //         Payee := BankAcc.Name
                //     else
                //Payee := '';
                if Employ.Get("Account No.") then
                    Payee := Employ."First Name" + ' ' + Employ."Middle Name" + ' ' + Employ."Last Name";
                "Global Dimension 1 Code" := Employ."Global Dimension 1 Code";
                "Shortcut Dimension 2 Code" := Employ."Global Dimension 2 Code";
                // "Responsibility Center" := Employ."Responsibility Center";




                //Check CreditLimit Here In cases where you have a credit limit set for employees
                // Cust.CALCFIELDS(Cust."Balance (LCY)");
                //  IF Cust."Credit Limit (LCY)" > 0 THEN
                //  IF Cust."Balance (LCY)">Cust."Credit Limit (LCY)" THEN
                //   ERROR('The allowable unaccounted balance of %1 has been exceeded',Cust."Credit Limit (LCY)");

                //Check Unretired staff Advances Here In cases where you have a limit set for employees
                /*  StaffAdvances.RESET;
                  StaffAdvances.SETRANGE(StaffAdvances."Account No.","Account No.");
                  StaffAdvances.SETRANGE(StaffAdvances."Surrender Status",StaffAdvances."Surrender Status"::" ");
                  IF StaffAdvances.FINDSET THEN BEGIN
                  IF Cust."Advance Limit" = 0 THEN EXIT;

                IF StaffAdvances.COUNT > Employ."Advance Limit" THEN
                    IF NOT CONFIRM('You have exceeded the allowable number of %1 unretired staff advances, You currently have %2 unretired staff advances of %3, Do you want to continue ?',
                    FALSE, Cust."Advance Limit", StaffAdvances.COUNT, Cust."Balance (LCY)") THEN
                                                  */
                // end;

            end;
        }
        field(88;
        "Surrender Status";
        Option)
        {
            OptionMembers = " ",Full,Partial;
        }
        field(89;
        Purpose;
        Text[250])
        {
        }
        field(90;
        "Commitment Status";
        Boolean)
        {
        }
        field(100;
        "Date Filter";
        Date)
        {
            FieldClass = FlowFilter;
        }
        field(101;
        "Responsibility Center Filter";
        Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(480;
        "Dimension Set ID";
        Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions
            end;
        }
        field(481; "External Doc No."; Code[20])
        {
            CalcFormula = Lookup("Voucher Header"."No." WHERE("External Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(482; Attachment; Boolean)
        {
            // CalcFormula = Lookup(Attachment.Attached WHERE ("Document No."=FIELD("No.")));
            Editable = false;
            // FieldClass = FlowField;
        }
        field(483; "ECU Code Description"; Text[50])
        {
            Description = 'Stores the name of the ECU Code Description in the database';
            Editable = false;

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    "ECU Code Description" := DimVal.Name;

                // UpdateHeaderToLine;
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(484; "Group Head"; Code[20])
        {
            TableRelation = "Group Head Approval";
        }
        field(50010; "Type of Advance"; Option)
        {
            OptionMembers = "Staff Advance","Trip Advance",LC;
            OptionCaption = 'Staff Advance, Trip Advance,LC';

            trigger OnValidate()
            begin
                // UpdateLines(FIELDNO("Type of Advance"));
            end;
        }
        field(50011; "Payment Request No."; code[20])
        {
            TableRelation = "Payments Header"."No." where(Posted = filter(true));
        }
        field(50012; "Created By"; Text[50])
        {

        }
        field(50013; "Created Date"; Date)
        {

        }
        field(50014; "Budget Check"; Boolean)
        {

        }
        field(50015; "Expected Retire Date"; Date)
        {

        }
        field(50016; Retired; Boolean)
        {

        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Account No.")
        {
        }
        key(Key3; Date)
        {
        }
        key(Key4; "Global Dimension 1 Code")
        {
        }
        key(Key5; "Shortcut Dimension 2 Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Account No.", "No.", Date)
        {

        }
        fieldgroup(Brick; "No.", Date, "Account No.")
        {

        }
    }

    trigger OnDelete()
    begin
        IF (Status = Status::Approved) OR (Status = Status::Posted) OR (Status = Status::"Pending Approval") THEN
            Error('You Cannot Delete this record its status is not Pending');
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GLSetup.Get;
            TestNoSeries;
            "No. Series" := GetNoSeriesCode();
            if NseriesMgt.AreRelated(GetNoSeriesCode, xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NseriesMgt.GetNextNo("No. Series");
            //  NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", 0D, "No.", "No. Series");
            //     NoSeriesMgt.InitSeries(GLSetup."Other Staff Advance No.",xRec."No. Series",0D,"No.","No. Series");
        end;
        // end;

        Date := Today;
        Cashier := UserId;
        Validate(Cashier);
        "Created By" := UserId;
        "Created Date" := Today;
        ;
    end;

    trigger OnModify()
    begin
        //if Status = Status::Open then
        // UpdateHeaderToLine;
        // UpdateLines();

        /* IF (Status=Status::Approved) OR (Status=Status::Posted)OR (Status=Status::"Pending Approval") THEN
            ERROR('You Cannot Modify this record its status is not Pending');*/
    end;

    var
        CStatus: Code[20];
        UserTemplate: Record "Cash Office User Template";
        GLAcc: Record "G/L Account";
        Employ: Record Employee;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NseriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Cash Office Setup";
        GLSetup: Record "General Ledger Setup";
        RecPayTypes: Record "Receipts and Payment Types";
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
        GenLedSetup: Record "General Ledger Setup";
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
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        CurrExchRate: Record "Currency Exchange Rate";
        UserSetup: Record "User Setup";
        StaffAdvances: Record "Staff Advance Lines";
        //RespCenter: Record "Receipts Line";
        UserMgt: Codeunit "User Setup Management BR1";
        maxAmount: Record "User Setup";
        StaffAdvLines: Record "Staff Advance Lines";


    procedure UpdateHeaderToLine()
    var
        PayLine: Record "Voucher Header";
    begin
        /*PayLine.RESET;
        PayLine.SETRANGE(PayLine.No,"No.");
        IF PayLine.FIND('-') THEN BEGIN
        REPEAT
        PayLine."Imprest Holder":="Account No.";
        PayLine."Global Dimension 1 Code":="Global Dimension 1 Code";
        PayLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
        PayLine."Shortcut Dimension 3 Code":="Shortcut Dimension 3 Code";
        PayLine."Shortcut Dimension 4 Code":="Shortcut Dimension 4 Code";
        PayLine."Currency Code":="Currency Code";
        PayLine."Currency Factor":="Currency Factor";
        PayLine.VALIDATE("Currency Factor");
        PayLine.MODIFY;
        UNTIL PayLine.NEXT=0;
        END;*/

    end;

    local procedure UpdateLines(FieldRef: Integer)
    var
        StaffAdvLines: Record "Staff Advance Lines";
    begin
        StaffAdvLines.LOCKTABLE;
        StaffAdvLines.SETRANGE("No.", "No.");
        StaffAdvLines.SETFILTER("Account No.", '<>%1', '');
        IF StaffAdvLines.FIND('-') THEN BEGIN
            REPEAT
                CASE FieldRef OF
                    FIELDNO("Date"):
                        StaffAdvLines.VALIDATE("Date taken", Date);
                    FIELDNO(Status):
                        StaffAdvLines.VALIDATE(Status, Status);
                    FIELDNO("Shortcut Dimension 1 Code"):
                        StaffAdvLines.VALIDATE("Global Dimension 1 Code", "Shortcut Dimension 1 Code");
                    FIELDNO("Global Dimension 1 Code"):
                        StaffAdvLines.VALIDATE("Global Dimension 1 Code", "Global Dimension 1 Code");
                    FIELDNO("Shortcut Dimension 2 Code"):
                        StaffAdvLines.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    FIELDNO("Shortcut Dimension 3 Code"):
                        StaffAdvLines.VALIDATE("Shortcut Dimension 3 Code", "Shortcut Dimension 3 Code");
                    FIELDNO("Shortcut Dimension 4 Code"):
                        StaffAdvLines.VALIDATE("Shortcut Dimension 4 Code", "Shortcut Dimension 4 Code");
                    FIELDNO("Currency Code"):
                        StaffAdvLines.VALIDATE("Currency Code", "Currency Code");
                    FIELDNO("Currency Factor"):
                        StaffAdvLines.VALIDATE("Currency Factor", "Currency Factor");
                    FIELDNO("Responsibility Center"):
                        StaffAdvLines.VALIDATE("Responsibility Center", "Responsibility Center");
                    FIELDNO(Purpose):
                        StaffAdvLines.VALIDATE(Purpose, Purpose);
                // FIELDNO("Type of Advance"):
                //     StaffAdvLines.VALIDATE("Type of Advance", "Type of Advance");


                END;
                StaffAdvLines.MODIFY(TRUE);
            UNTIL StaffAdvLines.NEXT = 0;
        END;
    end;

    local procedure UpdateCurrencyFactor()
    var
        CurrencyDate: Date;
    begin
        if "Currency Code" <> '' then begin
            CurrencyDate := Date;
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    procedure ImpLinesExist(): Boolean
    begin
    end;

    local procedure TestNoSeries(): Boolean
    begin
        if "Payment Type" = "Payment Type"::Imprest then
            GLSetup.TestField(GLSetup."Staff Advance No.")
    end;

    local procedure GetNoSeriesCode(): Code[20]
    var
        NoSrsRel: Record "No. Series Relationship";
        NoSeriesCode: Code[20];
    begin
        case "Type of Advance" of
            "Type of Advance"::"Staff Advance":
                NoSeriesCode := GLSetup."Staff Advance No.";
        end;
        exit(GetNoSeriesRelCode(NoSeriesCode));
    end;

    procedure ShowDimensions()
    var
        DimMgt2: Codeunit DimensionManagement;
    begin
        "Dimension Set ID" :=
          DimMgt2.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Staff Advance', "No."));
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
        // DimMgt: Codeunit DimensionManagement;
        NoSrsRel: Record "No. Series Relationship";
    begin
        //EXIT(GetNoSeriesRelCode(NoSeriesCode));
        GenLedgerSetup.Get;
        case GenLedgerSetup."Base No. Series" of
            GenLedgerSetup."Base No. Series"::"Responsibility Center":
                begin
                    NoSrsRel.Reset;
                    NoSrsRel.SetRange(Code, NoSeriesCode);
                    NoSrsRel.SetRange("Series Filter", "Responsibility Center");
                    if NoSrsRel.FindFirst then
                        exit(NoSrsRel."Series Code")
                end;
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