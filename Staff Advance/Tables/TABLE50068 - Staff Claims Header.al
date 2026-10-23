table 50634 "Staff Claims Header"
{
    LookupPageID = "Staff Claims List";
    DrillDownPageId = "Staff Claim List";

    fields
    {
        field(1; "No."; Code[40])
        {
            Description = 'Stores the reference of the payment voucher in the database';
            NotBlank = false;

            trigger OnValidate()
            var
                Stclm: Record "Staff Claims Header";
            begin
                if "No." < xRec."No." then
                    if not Stclm.Get(Rec."No.") then begin
                        GenLedgerSetup.GET;
                        NseriesMgt.TestManual(GenLedgerSetup."Staff Claim No.");
                        "No. Series" := '';
                    end;
                Date := Today;
                Cashier := UserId;
                //Validate(Cashier);

                "Payment Type" := "Payment Type"::Imprest;
                "Account Type" := "Account Type"::Employee;
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

                //UpdateHeaderToLine;
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

                if "Currency Code" = xRec."Currency Code" then
                    UpdateCurrencyFactor;

                if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                    //RecreatePurchLines(FIELDCAPTION("Currency Code"));
                end else
                    if "Currency Code" <> '' then
                        UpdateCurrencyFactor;

                //UpdateHeaderToLine;
            end;
        }
        field(9; Payee; Text[100])
        {
            Description = 'Stores the name of the person who received the money';
            caption = 'Staff Name';
        }
        field(10; "On Behalf Of"; Text[100])
        {
            Description = 'Stores the name of the person on whose behalf the payment voucher was taken';
        }
        field(11; Cashier; Code[50])
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
            CalcFormula = Sum("Staff Claim Lines".Amount WHERE(No = FIELD("No.")));
            Description = 'Stores the amount of the payment voucher';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            Description = 'Stores the name of the paying bank account in the database';
            TableRelation = IF ("Pay Mode" = CONST(Cash)) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"),
                                                                                    "Bank Type" = CONST(Cash))
            ELSE
            IF ("Pay Mode" = CONST(Cheque)) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"), "Bank Type" = const(Cheque))

            ELSE
            IF ("Pay Mode" = CONST(EFT)) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"), "Bank Type" = const(EFT))
            ELSE
            IF ("Pay Mode" = CONST("")) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"));
            ;


            trigger OnValidate()
            begin
                BankAcc.Reset;
                "Bank Name" := '';
                if BankAcc.Get("Paying Bank Account") then begin
                    "Bank Name" := BankAcc.Name;
                    // "Currency Code":=BankAcc."Currency Code";   //Currency Being determined first before document is released for approval
                    // VALIDATE("Currency Code");
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

                //UpdateHeaderToLine;
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(35; Status; Option)
        {
            Description = 'Stores the status of the record in the database';
            OptionMembers = Open,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
            OptionCaption = 'Open,,,,Posted,Cancelled,,,"Pending Approval",Approved';
        }
        field(38; "Payment Type"; Option)
        {
            OptionMembers = Imprest;
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;

                //UpdateHeaderToLine;
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(57; "Function Name"; Text[100])
        {
            Description = 'Stores the name of the function in the database';
        }
        field(58; "Budget Center Name"; Text[100])
        {
            Description = 'Stores the name of the budget center in the database';
        }
        field(59; "Bank Name"; Text[100])
        {
            Description = 'Stores the description of the paying bank account in the database';
        }
        field(60; "No. Series"; Code[20])
        {
            Description = 'Stores the number series in the database';
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(61; Select; Boolean)
        {
            Description = 'Enables the user to select a particular record';
        }
        field(62; "Total VAT Amount"; Decimal)
        {
            /*
            CalcFormula = Sum("Payments Line".Amount WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            */
        }
        field(63; "Total Witholding Tax Amount"; Decimal)
        {/*
            CalcFormula = Sum("Payments Line".Amount WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            */
        }
        field(64; "Total Net Amount"; Decimal)
        {
            CalcFormula = Sum("Staff Claim Lines".Amount WHERE(No = FIELD("No.")));
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
            OptionMembers = ,Cash,Cheque,EFT;

            trigger OnValidate()
            begin
                /*"Rebursehandler ID" := USERID;*/

            end;
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
            CalcFormula = Sum("Staff Claim Lines"."Amount LCY" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Document Type"; Option)
        {
            OptionMembers = "Payment Voucher","Petty Cash";
        }
        field(81; "Shortcut Dimension 3 Code"; Code[30])
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
                    Dim3 := DimVal.Name;

                //UpdateHeaderToLine;
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

                //UpdateHeaderToLine;
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

                // TestField(Status, Status::Open);
                //  if not UserMgt.CheckRespCenter(1, "Shortcut Dimension 3 Code") then
                //    Error(
                //    Text001,
                // RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
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
        field(86; "Account Type"; Option)
        {
            Caption = 'Account Type';
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(87; "Account No."; Code[20])
        {
            Caption = 'Staff No.';
            //Editable = true;
            TableRelation = Employee where(Status = filter(Active));

            trigger OnValidate()
            var
                Emp: record employee;
            begin
                Emp.Reset;
                if Emp.Get("Account No.") then begin
                    Emp.TestField("Employee Posting Group");
                    Emp.TestField(status, Emp.Status::Active);
                    Payee := Emp."First name";
                    "On Behalf Of" := Emp."First name";
                    /*
                       //Check CreditLimit Here In cases where you have a credit limit set for employees
                        Cust.CALCFIELDS(Cust."Balance (LCY)");
                         IF Cust."Balance (LCY)">Cust."Credit Limit (LCY)" THEN
                            ERROR('The allowable unaccounted balance of %1 has been exceeded',Cust."Credit Limit (LCY)");
                    */
                end;

            end;
        }
        field(88; "Surrender Status"; Option)
        {
            OptionMembers = " ",Full,Partial;
        }
        field(89; Purpose; Text[50])
        {
        }
        field(90; "External Document No"; Code[20])
        {
        }
        field(91; RecordId; RecordID)
        {
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
        field(481; "Claim Type"; Code[20])
        {
            CalcFormula = Lookup("Staff Claim Lines"."Advance Type" WHERE(No = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(482; Attachment; Boolean)
        {
            // CalcFormula = Lookup(Attachment.Attached WHERE ("Document No."=FIELD("No.")));
            //FieldClass = FlowField;
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

                ////UpdateHeaderToLine;
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(484; "Group Head to Approve"; Code[20])
        {
            TableRelation = "Group Head Approval";
        }
        field(485; "Rebursehandler ID"; Code[50])
        {
        }
        field(486; "Created By"; Text[50])
        {

        }
        field(487; "Created Date"; Date)
        {

        }
        field(488; "Beneficiary Acct"; Code[20])
        {

        }
        field(489; "Beneficiary Bank"; Code[50])
        {

        }
        field(490; "Beneficiary Name"; Text[250])
        {

        }
        field(92; "Budget Check"; Boolean)
        {

        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Date, "Account No.")
        {

        }
        fieldgroup(Brick; "No.", Date, "Account No.")
        {

        }
    }

    trigger OnDelete()
    begin
        if (Status = Status::Approved) or (Status = Status::Posted) or (Status = Status::"Pending Approval") then
            Error('You Cannot Delete this record its status is not Pending');
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GenLedgerSetup.Get();
            GenLedgerSetup.TestField("Staff Claim No.");
            "No. Series" := GenLedgerSetup."Staff Claim No.";
            if NseriesMgt.AreRelated(GenLedgerSetup."Staff Claim No.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NseriesMgt.GetNextNo("No. Series");
            // NoSeriesMgt.InitSeries(GenLedgerSetup."Staff Claim No.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Created By" := UserId;
        "Created Date" := Today;
    end;

    trigger OnModify()
    begin

    end;

    procedure AssistEdit(OldClaim: Record "Staff Claims Header"): Boolean
    var
        Claim: Record "Staff Claims Header";
    begin
        // with Claim do begin
        Claim := Rec;
        GenLedgerSetup.Get();
        GenLedgerSetup.TestField("Staff Claim No.");
        if NseriesMgt.LookupRelatedNoSeries(GenLedgerSetup."Staff Claim No.", "No. Series") then begin
            "No." := NseriesMgt.GetNextNo("No. Series");
            //if NoSeriesMgt.SelectSeries(GenLedgerSetup."Staff Claim No.", OldClaim."No. Series", "No. Series") then begin
            //  NoSeriesMgt.SetSeries("No.");
            Rec := Claim;
            exit(true);
        end;
    end;


    var
        CStatus: Code[20];
        UserTemplate: Record "Cash Office User Template";
        GLAcc: Record "G/L Account";
        Cust: Record Employee;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NseriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "General Ledger Setup";
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
        UserMgt: Codeunit "User Setup Management BR1";
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        CurrExchRate: Record "Currency Exchange Rate";
        UserSetup: Record "User Setup";
        DimMgt: Codeunit DimensionManagement;
        RespCenter: Record "Responsibility Center";

    // procedure UpdateHeaderToLine()
    // begin
    //     //PayLine.RESET;
    //     //PayLine.SETRANGE(PayLine.No,"No.");
    //     //IF PayLine.FIND('-') THEN BEGIN
    //     //REPEAT
    //     //PayLine."Imprest Holder":="Account No.";
    //     //PayLine."Global Dimension 1 Code":="Global Dimension 1 Code";
    //     //PayLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
    //     //PayLine."Shortcut Dimension 3 Code":="Shortcut Dimension 3 Code";
    //     //PayLine."Shortcut Dimension 4 Code":="Shortcut Dimension 4 Code";
    //     //PayLine."Currency Code":="Currency Code";
    //     //PayLine."Currency Factor":="Currency Factor";
    //     //PayLine.VALIDATE("Currency Factor");
    //     //PayLine.MODIFY;
    //     //UNTIL PayLine.NEXT=0;
    //     //END;
    // end;

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
        //ImpLines.RESET;
        //ImpLines.SETRANGE(No,"No.");
        //EXIT(ImpLines.FINDFIRST);
    end;

    procedure InsertRecID()
    var
        RecRef: RecordRef;
        RecID: RecordID;
    begin
        RecRef.Open(DATABASE::"Staff Claims Header");
        RecRef.FindLast;
        RecordId := RecRef.RecordId;
        //RecRef := RecID.GETRECORD;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        GenLedgerSetup.TestField(GenLedgerSetup."Staff Claim No.");
    end;

    local procedure GetNoSeriesCode(): Code[20]
    var
        NoSrsRel: Record "No. Series Relationship";
        NoSeriesCode: Code[20];
    begin
        NoSeriesCode := GenLedgerSetup."Staff Claim No.";

        exit(GetNoSeriesRelCode(NoSeriesCode));
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Staff Claim', "No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure GetNoSeriesRelCode(NoSeriesCode: Code[20]): Code[20]
    var
        GenLedgerSetup: Record "General Ledger Setup";
        RespCenter: Record "Responsibility Center";
        DimMgt: Codeunit DimensionManagement;
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

