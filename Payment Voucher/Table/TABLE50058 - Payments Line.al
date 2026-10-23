table 50647 "Payments Line"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = true;

        }
        field(2; Date; Date)
        {
        }
        field(3; Type; Code[20])
        {
            NotBlank = true;
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = FILTER(Payment),
                                                                     Blocked = CONST(false));

            trigger OnValidate()
            var
                TarrifCode: Record "Tariff Codes2";
            begin
                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);

                if RecPayTypes.Find('-') then begin
                    Grouping := RecPayTypes."Default Grouping";
                    "Require Surrender" := RecPayTypes."Pending Voucher";
                    "Payment Reference" := RecPayTypes."Payment Reference";
                    "Budgetary Control A/C" := RecPayTypes."Direct Expense";

                    if RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes then begin
                        "VAT Code" := RecPayTypes."VAT Code";
                        if TarrifCode.Get("VAT Code") then
                            "VAT Rate" := TarrifCode.Percentage;
                    end;
                    if RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes then begin
                        "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                        if TarrifCode.Get("Withholding Tax Code") then
                            "W/Tax Rate" := TarrifCode.Percentage;
                    end;

                    if RecPayTypes."Calculate Retention" = RecPayTypes."Calculate Retention"::Yes then begin
                        "Retention Code" := RecPayTypes."Retention Code";
                        if TarrifCode.Get("Retention Code") then
                            "Retention Rate" := TarrifCode.Percentage;

                    end;

                end;

                if RecPayTypes.Find('-') then begin
                    "Account Type" := RecPayTypes."Account Type";
                    Validate("Account Type");
                    "Transaction Name" := RecPayTypes.Description;
                    "Budgetary Control A/C" := RecPayTypes."Direct Expense";
                    if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" then begin
                        if RecPayTypes."Account No." <> '' then
                            RecPayTypes.TestField(RecPayTypes."Account No.");
                        "Account No." := RecPayTypes."Account No.";
                        Validate("Account No.");
                    end;

                    //Banks
                    if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"Bank Account" then begin
                        "Account No." := RecPayTypes."Bank Account";
                        Validate("Account No.");
                    end;
                end;

                PHead.Reset;
                PHead.SetRange(PHead."No.", "No.");
                if PHead.FindFirst then begin
                    Date := PHead.Date;
                    // PHead.TESTFIELD("Responsibility Center");
                    "Global Dimension 1 Code" := PHead."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PHead."Shortcut Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := PHead."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := PHead."Shortcut Dimension 4 Code";
                    "Currency Code" := PHead."Currency Code";
                    "Currency Factor" := PHead."Currency Factor";
                    "Payment Type" := PHead."Payment Type";
                end;
            end;
        }
        field(4; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Custom 2","Custom 3","Custom 4","Custom 5";
        }
        field(5; "Cheque No"; Code[20])
        {
        }
        field(6; "Cheque Date"; Date)
        {
        }
        field(7; "Cheque Type"; Option)
        {
            OptionCaption = ' , Local,Up Country';
            OptionMembers = " "," Local","Up Country";
        }
        field(8; "Bank Code"; Code[20])
        {
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
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee;';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
            ;

            trigger OnValidate()
            var
                PayLines: Record "Tariff Codes2";
            begin
                /*  PayLines.RESET;
                  PayLines.SETRANGE(PayLines."Account Type",PayLines."Account Type"::Vendor);
                  PayLines.SETRANGE(PayLines.No,No);
                  IF PayLines.FIND('-') THEN
                     ERROR('There is already another existing Payment to a Vendor in this document');

                  PayLines.RESET;
                  PayLines.SETRANGE(PayLines."Account Type",PayLines."Account Type"::Customer);
                  PayLines.SETRANGE(PayLines.No,No);
                  IF PayLines.FIND('-') THEN
                     ERROR('There is already another existing Payment to a Customer in this document');

                  IF ("Account Type"= "Account Type"::Vendor) OR  ("Account Type"= "Account Type"::Customer) THEN  BEGIN
                     IF PayLinesExist THEN
                     ERROR('There is already another existing Line for this document');
                  END;
                 */
                //IF "Account Type" = "Account Type"::Vendor THEN
                //"Applies-to Doc. Type":="Applies-to Doc. Type"::Invoice;

            end;
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = CONST(true))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer WHERE("Customer Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor WHERE("Vendor Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee WHERE("Employee Posting Group" = FIELD(Grouping));


            trigger OnValidate()
            var
                Text0001: Label 'The Account number CANNOT be the same as the Paying Bank Account No.';
                CustomerBankAccount: Record "Customer Bank Account";
                VendorBankAccount: Record "Vendor Bank Account";
                venrec: Record Vendor;
                Cusrec: Record Customer;
                EmployNo: Record Employee;
            begin
                PH.Reset;
                PH.Get("No.");
                "Account Name" := '';
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);

                if "Account Type" in ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner",
                "Account Type"::"Bank Account"]
                then
                    case "Account Type" of
                        "Account Type"::"G/L Account":
                            begin
                                if "Account No." <> '' then
                                    GLAcc.Get("Account No.");
                                "Account Name" := GLAcc.Name;
                                PH.TestField("Global Dimension 1 Code");
                                PH.TestField("Shortcut Dimension 2 Code");
                                //"Global Dimension 1 Code":='';
                                //"Shortcut Dimension 2 Code":='';
                            end;
                        "Account Type"::Customer:
                            begin
                                Cust.Get("Account No.");
                                "Account Name" := Cust.Name;
                                if "Global Dimension 1 Code" = '' then begin
                                    "Global Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                end;
                            end;
                        "Account Type"::Vendor:
                            begin
                                Vend.Get("Account No.");
                                "Account Name" := Vend.Name;
                                if "Global Dimension 1 Code" = '' then begin
                                    "Global Dimension 1 Code" := Vend."Global Dimension 1 Code";
                                end;
                                if (PH.Payee = '') or (PH.Payee <> '') then begin
                                    PH.Payee := "Account Name";
                                    PH.Modify;
                                end;
                                if (PH."On Behalf Of" = '') or (PH."On Behalf Of" <> '') then begin
                                    PH."On Behalf Of" := "Account Name";
                                    PH.Modify;
                                end;
                            end;
                        "Account Type"::"Bank Account":
                            begin

                                IF BankAcc.GET("Account No.") THEN
                                    "Account Name" := BankAcc.Name;
                                //PH.TESTFIELD("Paying Bank Account");
                                IF PH."Paying Bank Account" = "Account No." THEN
                                    ERROR(Text0001);

                                if "Global Dimension 1 Code" = '' then begin
                                    "Global Dimension 1 Code" := BankAcc."Global Dimension 1 Code";
                                end;
                            end;
                        "Account Type"::"IC Partner":
                            begin
                                ICPartner.Reset;
                                ICPartner.Get("Account No.");
                                "Account Name" := ICPartner.Name;
                            end;
                    end;
                //Set the application to Invoice if Account type is vendor
                //IF "Account Type"="Account Type"::Vendor THEN  HABA
                //  "Applies-to Doc. Type":="Applies-to Doc. Type"::Invoice;

                //update
                if "Account Type" = "Account Type"::Customer then begin
                    if Cusrec.Get("Account No.") then begin
                        Cusrec.TestField("Preferred Bank Account Code");
                        // TESTFIELD (CustomerBankAccount)."Bank Account No.";
                        // Cusrec.TESTFIELD ("Bank Account No");
                        CustomerBankAccount.Get("Account No.", Cusrec."Preferred Bank Account Code");
                        "Bank Code" := CustomerBankAccount.Code;
                        "Payee Bank Account No." := CustomerBankAccount."Bank Account No.";
                        //  "Payee Bank Code":=CustomerBankAccount."Bank Code";
                        Payee := Cusrec.Name;
                    end;
                end else
                    if "Account Type" = "Account Type"::Vendor then begin
                        if venrec.Get("Account No.") then begin
                            venrec.TestField("Preferred Bank Account Code");
                            // venrec.TESTFIELD ("Bank Code");
                            // venrec.TESTFIELD ("Bank Account No");
                            VendorBankAccount.Get("Account No.", venrec."Preferred Bank Account Code");
                            "Payee Bank Account No." := VendorBankAccount."Bank Account No.";
                            "Bank Code" := VendorBankAccount.Code;
                            //"Payee Bank Code":=VendorBankAccount."Bank Code";
                        end;
                    end else
                        if "Account Type" = "Account Type"::Employee then begin
                            if EmployNo.Get("Account No.") then begin
                                //EmployNo.TestField("Preferred Bank Account Code");
                                // venrec.TESTFIELD ("Bank Code");
                                // venrec.TESTFIELD ("Bank Account No");
                                // VendorBankAccount.Get("Account No.", venrec."Preferred Bank Account Code");
                                "Payee Bank Account No." := EmployNo."Bank Account No.";
                                //   "Bank Code" := VendorBankAccount.Code;
                                Payee := EmployNo.FullName();
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
        field(15; "Account Name"; Text[150])
        {
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

            trigger OnValidate()
            begin
                /*IF xRec.Amount <> 0 THEN BEGIN
                 IF Amount > "Total Invoice Amount" THEN
                  ERROR('You cannot pay more than the invoice amount');
                END;*/


                //CalculateTax();
                // Validate("Withholding Tax Code");
                // Validate("VAT Code");


            end;
        }
        field(21; Remarks; Text[250])
        {
        }
        field(22; "Transaction Name"; Text[100])
        {
        }
        field(23; "VAT Code"; Code[20])
        {
            TableRelation = "Tariff Codes2".Code WHERE(Type = CONST(VAT));

            trigger OnValidate()
            begin
                if TariffCode.Get("VAT Code") then
                    "VAT Rate" := TariffCode.Percentage
                else
                    "VAT Rate" := 0;
                CalculateTax();
            end;
        }
        field(24; "Withholding Tax Code"; Code[20])
        {
            TableRelation = "Tariff Codes2".Code WHERE(Type = CONST("W/Tax"));

            trigger OnValidate()
            begin
                if TariffCode.Get("Withholding Tax Code") then
                    "W/Tax Rate" := TariffCode.Percentage
                else
                    "W/Tax Rate" := 0;

                CalculateTax();
            end;
        }
        field(25; "VAT Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                //Should not be entered until VAT Code is entered
                TestField("VAT Code");
                "Net Amount" := Amount - ("VAT Amount" + "Withholding Tax Amount");
                Validate("Net Amount");
            end;
        }
        field(26; "Withholding Tax Amount"; Decimal)
        {

            trigger OnLookup()
            begin
                PHead.Reset;
                PHead.SetRange(PHead."No.", "No.");
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
            end;

            trigger OnValidate()
            begin
                //Should not be entered until W/Tax code is entered
                TestField("Withholding Tax Code");
                PHead.Reset;
                PHead.SetRange(PHead."No.", "No.");
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;

                "Net Amount" := Amount - ("Withholding Tax Amount" + "VAT Amount");
                Validate("Net Amount");
            end;
        }
        field(27; "Net Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Currency Factor" <> 0 then
                    "NetAmount LCY" := "Net Amount" / "Currency Factor"
                else
                    "NetAmount LCY" := "Net Amount";
            end;
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
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
        field(31; "Branch Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Branch Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;

                ValidateShortcutDimCode(2, "Branch Code");
            end;
        }
        field(32; "PO/INV No"; Code[20])
        {
        }
        field(33; "Bank Account No"; Code[20])
        {
        }
        field(34; "Cashier Bank Account"; Code[20])
        {
        }
        field(35; Status; Option)
        {
            OptionMembers = Open,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook;
        }
        field(36; Select; Boolean)
        {
        }
        field(37; Grouping; Code[20])
        {
            TableRelation = "Vendor Posting Group".Code;
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
        field(41; "Apply to"; Code[20])
        {
            TableRelation = "Vendor Ledger Entry"."Vendor No." WHERE("Vendor No." = FIELD("Account No."));
        }
        field(42; "Apply to ID"; Code[20])
        {
        }
        field(43; "No of Units"; Decimal)
        {
        }
        field(44; "Surrender Date"; Date)
        {
        }
        field(45; Surrendered; Boolean)
        {
        }
        field(46; "Surrender Doc. No"; Code[20])
        {
        }
        field(47; "Vote Book"; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                /*
                          IF Amount<=0 THEN
                        ERROR('Please enter the Amount');

                       //Confirm the Amount to be issued doesnot exceed the budget and amount Committed
                        EVALUATE(CurrMonth,FORMAT(DATE2DMY(Date,2)));
                        EVALUATE(CurrYR,FORMAT(DATE2DMY(Date,3)));
                        EVALUATE(BudgetDate,FORMAT('01'+'/'+CurrMonth+'/'+CurrYR));

                          //Get the last day of the month

                          LastDay:=CALCDATE('1M', BudgetDate);
                          LastDay:=CALCDATE('-1D',LastDay);


                        //Get Budget for the G/L
                      IF GenLedSetup.GET THEN BEGIN
                        GLAccount.SETFILTER(GLAccount."Budget Filter",GenLedSetup."Current Budget");
                        GLAccount.SETRANGE(GLAccount."No.","Vote Book");
                        GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                        {Get the exact Monthly Budget}
                        //Start from first date of the budget.//BudgetDate
                        GLAccount.SETRANGE(GLAccount."Date Filter",GenLedSetup."Current Budget Start Date",LastDay);

                        IF GLAccount.FIND('-') THEN BEGIN
                         GLAccount.CALCFIELDS(GLAccount."Budgeted Amount",GLAccount."Net Change");
                         MonthBudget:=GLAccount."Budgeted Amount";
                         Expenses:=GLAccount."Net Change";
                         BudgetAvailable:=GLAccount."Budgeted Amount"-GLAccount."Net Change";
                         "Total Allocation":=MonthBudget;
                         "Total Expenditure":=Expenses;
                         END;


                     END;

                     CommitmentEntries.RESET;
                     CommitmentEntries.SETCURRENTKEY(CommitmentEntries.Account);
                     CommitmentEntries.SETRANGE(CommitmentEntries.Account,"Vote Book");
                     CommitmentEntries.SETRANGE(CommitmentEntries."Commitment Date",GenLedSetup."Current Budget Start Date",LastDay);
                     CommitmentEntries.CALCSUMS(CommitmentEntries."Committed Amount");
                     CommittedAmount:=CommitmentEntries."Committed Amount";

                     "Total Commitments":=CommittedAmount;
                     Balance:=BudgetAvailable-CommittedAmount;
                     "Balance Less this Entry":=BudgetAvailable-CommittedAmount-Amount;
                     MODIFY;
                     {
                     IF CommittedAmount+Amount>BudgetAvailable THEN
                        ERROR('%1,%2,%3,%4','You have Exceeded Budget for G/L Account No',"Vote Book",'by',
                        ABS(BudgetAvailable-(CommittedAmount+Amount)));
                      }
                     //End of Confirming whether Budget Allows Posting
                */

            end;
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
        field(53; "Applicant Designation"; Text[100])
        {
        }
        field(54; "Petty Cash"; Boolean)
        {
        }
        field(55; "Supplier Invoice No."; Code[30])
        {
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(57; "Imprest Request No"; Code[20])
        {

            trigger OnValidate()
            begin

                /*
                          TotAmt:=0;
                     //On Delete/Change of Request No. then Clear from Imprest Details
                     IF ("Imprest Request No"='') OR ("Imprest Request No"<>xRec."Imprest Request No") THEN
                        LoadImprestDetails.RESET;
                        LoadImprestDetails.SETRANGE(LoadImprestDetails.No,No);
                        IF LoadImprestDetails.FIND('-') THEN BEGIN
                           LoadImprestDetails.DELETEALL;
                           Amount:=TotAmt;
                           "Net Amount":=Amount;
                           MODIFY;

                        END;
                     //New Imprest Details
                     ImprestReqDet.RESET;
                     ImprestReqDet.SETRANGE(ImprestReqDet.No,"Imprest Request No");
                     IF ImprestReqDet.FIND('-') THEN BEGIN
                     REPEAT
                         LoadImprestDetails.INIT;
                         LoadImprestDetails.No:=No;
                         LoadImprestDetails.Date:=ImprestReqDet."Account No:";
                         LoadImprestDetails.Type:=ImprestReqDet."Account Name";
                         LoadImprestDetails."Pay Mode":=ImprestReqDet.Amount;
                         LoadImprestDetails."Cheque No":=ImprestReqDet."Due Date";
                         LoadImprestDetails."Cheque Date":=ImprestReqDet."Imprest Holder";
                         LoadImprestDetails.INSERT;
                         TotAmt:=TotAmt+ImprestReqDet.Amount;
                     UNTIL ImprestReqDet.NEXT=0;
                         Amount:=TotAmt;
                         "Account No.":=ImprestReqDet."Imprest Holder";
                         "Net Amount":=Amount;
                         MODIFY;
                     END;
                {
                       //ImprestDetForm.GETRECORD(LoadImprestDetails);
                }
                      */

            end;
        }
        field(58; "Batched Imprest Tot"; Decimal)
        {
        }
        field(59; "Function Name"; Text[100])
        {
        }
        field(60; "Budget Center Name"; Text[100])
        {
        }
        field(61; "Farmer Purchase No"; Code[20])
        {
        }
        field(62; "Transporter Ananlysis No"; Code[20])
        {
        }
        field(63; "User ID"; Code[20])
        {
            TableRelation = User;
        }
        field(64; "Journal Template"; Code[20])
        {
        }
        field(65; "Journal Batch"; Code[20])
        {
        }
        field(66; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(67; "Require Surrender"; Boolean)
        {
            Editable = false;
        }
        field(69; "Select to Surrender"; Boolean)
        {
        }
        field(71; "Payment Reference"; Option)
        {
            OptionMembers = Normal,"Farmer Purchase";
        }
        field(72; "ID Number"; Code[8])
        {
        }
        field(73; "VAT Rate"; Decimal)
        {

            trigger OnValidate()
            begin
                // /*"VAT Amount":=(Amount * 100);
                // "VAT Amount":=Amount-("VAT Amount"/(100 + "VAT Rate"));*/

            end;
        }
        field(74; "Amount With VAT"; Decimal)
        {
        }
        field(75; "Currency Code"; Code[20])
        {
        }
        field(76; "Exchange Rate"; Decimal)
        {
        }
        field(77; "Currency Reciprical"; Decimal)
        {
        }
        field(78; "VAT Prod. Posting Group"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "VAT Product Posting Group".Code;
        }
        field(79; "Budgetary Control A/C"; Boolean)
        {
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
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name
            end;
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('VEHICLE'));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name
            end;
        }
        field(83; Committed; Boolean)
        {
        }
        field(84; "Currency Factor"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Currency Factor" <> 0 then
                    "NetAmount LCY" := "Net Amount" / "Currency Factor"
                else
                    "NetAmount LCY" := "Net Amount";
            end;
        }
        field(85; "NetAmount LCY"; Decimal)
        {
        }
        field(86; "Applies-to Doc. Type"; enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-to Doc. Type';
            // OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            // OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; tolu/26/10/23

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
        field(87; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
                PayToVendorNo: Code[20];
                OK: Boolean;
                Text000: Label 'You must specify %1 or %2.';
                CustLedgEntry: Record "Cust. Ledger Entry";
                PayToCustomerNo: Code[20];
            begin
                if (Rec."Account Type" <> Rec."Account Type"::Vendor) then
                    Error('You cannot apply to %1', "Account Type");
                if "Account Type" = "Account Type"::Vendor then begin
                    // with Rec do begin
                    //Amount:=0;
                    //VALIDATE(Amount);
                    PayToVendorNo := "Account No.";

                    VendLedgEntry.SetCurrentKey("Vendor No.", Open);
                    VendLedgEntry.SetRange("Vendor No.", PayToVendorNo);
                    VendLedgEntry.SetRange(Open, true);
                    if "Applies-to ID" = '' then
                        "Applies-to ID" := "No.";
                    if "Applies-to ID" = '' then
                        Error(
                          Text000,
                          FieldCaption("No."), FieldCaption("Applies-to ID"));

                    //ApplyVendEntries."SetPVLine-Delete"(PVLine,PVLine.FIELDNO("Applies-to ID"));
                    // ApplyVendEntriescodeunit.SetPVLine(Rec,VendLedgEntry,Rec.FIELDNO("Applies-to ID"));
                    ApplyVendEntries.SetPVLine(Rec, VendLedgEntry, Rec.FieldNo("Applies-to ID"));
                    ApplyVendEntries.SetRecord(VendLedgEntry);
                    ApplyVendEntries.SetTableView(VendLedgEntry);
                    ApplyVendEntries.LookupMode(true);
                    OK := ApplyVendEntries.RunModal = ACTION::LookupOK;
                    Clear(ApplyVendEntries);
                    if not OK then
                        exit;
                    VendLedgEntry.Reset;
                    VendLedgEntry.SetCurrentKey("Vendor No.", Open);
                    VendLedgEntry.SetRange("Vendor No.", PayToVendorNo);
                    VendLedgEntry.SetRange(Open, true);
                    VendLedgEntry.SetRange(VendLedgEntry."Applies-to ID", "Applies-to ID");
                    if VendLedgEntry.Find('-') then begin
                        "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                        "Applies-to Doc. No." := VendLedgEntry."Document No.";
                        Message(PayToVendorNo);
                    end else
                        "Applies-to ID" := '';
                end;
                //Calculate  Total To Apply
                VendLedgEntry.Reset;
                VendLedgEntry.SetCurrentKey("Vendor No.", Open, "Applies-to ID");
                VendLedgEntry.SetRange("Vendor No.", PayToVendorNo);
                VendLedgEntry.SetRange(Open, true);
                VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                if VendLedgEntry.Find('-') then begin
                    VendLedgEntry.CalcSums("Amount to Apply");
                    Amount := Abs(VendLedgEntry."Amount to Apply");
                    Validate(Amount);
                    //Total Invoice Amount
                    "Total Invoice Amount" := Abs(VendLedgEntry."Amount to Apply");
                    //Total Invoice Amount
                end;
            end;


            trigger OnValidate()
            begin
                if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." <> '') and
                   ("Applies-to Doc. No." <> '')
                then begin
                    SetAmountToApply("Applies-to Doc. No.", "Account No.");
                    SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
                end else
                    if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (xRec."Applies-to Doc. No." = '') then
                        SetAmountToApply("Applies-to Doc. No.", "Account No.")
                    else
                        if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and ("Applies-to Doc. No." = '') then
                            SetAmountToApply(xRec."Applies-to Doc. No.", "Account No.");
            end;
        }
        field(88; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';

            trigger OnLookup()
            begin
                PHead.Reset;
                PHead.SetRange(PHead."No.", "No.");
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
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

                if "Account Type" = "Account Type"::Vendor then begin
                    if ("Applies-to ID" <> xRec."Applies-to ID") and (xRec."Applies-to ID" <> '') then begin
                        VendLedgEntry.SetCurrentKey("Vendor No.", Open);
                        VendLedgEntry.SetRange("Vendor No.", "Account No.");
                        VendLedgEntry.SetRange(Open, true);
                        VendLedgEntry.SetRange("Applies-to ID", xRec."Applies-to ID");
                        if VendLedgEntry.FindFirst then
                            VendEntrySetApplID.SetApplId(VendLedgEntry, TempVendLedgEntry, '');
                        VendLedgEntry.Reset;
                    end;
                end;

            end;
        }
        field(90; "Retention Code"; Code[20])
        {
            TableRelation = "Tariff Codes2".Code WHERE(Type = CONST(Retention));

            trigger OnValidate()
            begin
                if TariffCode.Get("Retention Code") then
                    "Retention Rate" := TariffCode.Percentage
                else
                    "Retention Rate" := 0;

                CalculateTax();
            end;
        }
        field(91; "Retention  Amount"; Decimal)
        {
        }
        field(92; "Retention Rate"; Decimal)
        {
        }
        field(93; "W/Tax Rate"; Decimal)
        {
        }
        field(94; "Payee Bank Account No."; Code[20])
        {
            Editable = false;

            trigger OnLookup()
            begin
                PHead.Reset;
                PHead.SetRange(PHead."No.", "No.");
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
            end;

            trigger OnValidate()
            begin
                PHead.Reset;
                PHead.SetRange(PHead."No.", "No.");
                if PHead.FindFirst then begin
                    if (PHead.Status = PHead.Status::Approved) or (PHead.Status = PHead.Status::Posted) or
                     (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                        Error('You Cannot modify documents that are approved/posted/Send for Approval');
                end;
            end;
        }
        field(95; "Trip No"; Code[20])
        {
        }
        field(96; "Driver No"; Code[20])
        {
        }
        field(97; "Loan No"; Integer)
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(50002; "Entry Type[Income/Expense]"; Option)
        {
            OptionCaption = ' ,Income,Expense';
            OptionMembers = " ",Income,Expense;
        }
        field(50003; "Asset No"; Code[20])
        {
            TableRelation = "Fixed Asset"."No.";
        }
        field(56000; "Invoice No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Vendor)) "Vendor Ledger Entry"."Document No." WHERE(Open = CONST(true),
                                                                                                          "Document Type" = CONST(Invoice),
                                                                                                          "Vendor No." = FIELD("Account No."))
            ELSE
            IF ("Account Type" = CONST(Customer)) "Cust. Ledger Entry"."Document No." WHERE(Open = CONST(true),
                                                                                                                                                                                              "Document Type" = CONST(Invoice),
                                                                                                                                                                                              "Customer No." = FIELD("Account No."));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                VendLedger.Reset;
                VendLedger.SetRange(VendLedger."Document No.", "Invoice No.");
                VendLedger.SetRange(VendLedger."Vendor No.", "Account No.");
                VendLedger.SetRange(VendLedger."Document Type", VendLedger."Document Type"::Invoice);
                if VendLedger.FindFirst then begin
                    VendLedger.CalcFields("Remaining Amount");
                    Amount := -VendLedger."Remaining Amount";
                    "Due Date" := VendLedger."Due Date";
                end
            end;
        }
        field(56001; "Due Date"; Date)
        {
        }
        field(56002; "Payee Bank Code"; Code[3])
        {
            Editable = false;
        }
        field(56003; "Total Invoice Amount"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Line No.", "No.", Type)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        // LCReqLin.checkstatus(Rec);

        PHead.Reset;
        PHead.SetRange(PHead."No.", "No.");
        if PHead.FindFirst then begin
            if
             // (PHead.Status=PHead.Status::Approved)
             (PHead.Status = PHead.Status::Posted) or
            (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                Error('You Cannot Delete this record its already approved/posted/Send for Approval');
        end;
        TestField(Committed, false);
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Normal Payments No");
            NoSeriesMgt.InitSeries(GenLedgerSetup."Normal Payments No", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        PHead.Reset;
        PHead.SetRange(PHead."No.", "No.");
        if PHead.FindFirst then begin
            Date := PHead.Date;
            // PHead.TESTFIELD("Responsibility Center");
            "Global Dimension 1 Code" := PHead."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := PHead."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := PHead."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := PHead."Shortcut Dimension 4 Code";
            "Currency Code" := PHead."Currency Code";
            "Currency Factor" := PHead."Currency Factor";
            "Payment Type" := PHead."Payment Type";
        end;

        //
        PHead.Reset;
        PHead.SetRange(PHead."No.", "No.");
        if PHead.FindFirst then begin
            if
            //(PHead.Status=PHead.Status::Approved)
            (PHead.Status = PHead.Status::Posted) or
             (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                Error('You Cannot modify documents that are approved/posted/Send for Approval');
        end;
        TestField(Committed, false);
    end;

    trigger OnModify()
    begin
        /*
        PHead.RESET;
        PHead.SETRANGE(PHead."No.",No);
         IF PHead.FINDFIRST THEN BEGIN
            IF (PHead.Status=PHead.Status::Approved) OR (PHead.Status=PHead.Status::Posted) OR
             (PHead.Status=PHead.Status::"Pending Approval") THEN
               ERROR('You Cannot modify documents that are approved/posted/Send for Approval');
         END;
          TESTFIELD(Committed,FALSE);
         */

    end;

    var
        PH: Record "Payments Header";
        VLedgEntry: Record "Vendor Ledger Entry";
        ICPartner: Record "IC Partner";
        FPurch: Record "Purch. Inv. Header";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenLedgerSetup: Record "Cash Office Setup";
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
        MonthBudget: Decimal;
        Expenses: Decimal;
        Header: Text[250];
        "Date From": Text[30];
        "Date To": Text[30];
        LastDay: Date;
        TotAmt: Decimal;
        DimVal: Record "Dimension Value";
        PHead: Record "Payments Header";
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        GenJnILine: Record "Gen. Journal Line";
        ApplyVendEntries: Page "Apply Vendor Entries2";
        TariffCode: Record "Tariff Codes2";
        VendLedger: Record "Vendor Ledger Entry";
        ApplyVendEntriescodeunit: Codeunit applyvendorledger3;
    //  LCReqLin: Page "LC Request Line";

    procedure SetAmountToApply(AppliesToDocNo: Code[20]; VendorNo: Code[20])
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        /*VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.",AppliesToDocNo);
        VendLedgEntry.SETRANGE("Vendor No.",VendorNo);
        VendLedgEntry.SETRANGE(Open,TRUE);
        IF VendLedgEntry.FINDFIRST THEN BEGIN
          IF VendLedgEntry."Amount to Apply" = 0 THEN  BEGIN
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
          END ELSE
            VendLedgEntry."Amount to Apply" := 0;
          VendLedgEntry."Accepted Payment Tolerance" := 0;
          VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
          CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
        END;
        */

        VendLedgEntry.SetCurrentKey("Document No.");
        VendLedgEntry.SetRange("Document No.", AppliesToDocNo);
        VendLedgEntry.SetRange("Vendor No.", VendorNo);
        VendLedgEntry.SetRange(Open, true);
        if VendLedgEntry.FindFirst then begin
            if VendLedgEntry."Amount to Apply" = 0 then begin
                VendLedgEntry.CalcFields("Remaining Amount");
                VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
            end else
                VendLedgEntry."Amount to Apply" := 0;
            VendLedgEntry."Accepted Payment Tolerance" := 0;
            VendLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
            CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
        end;

    end;

    procedure CalculateTax()
    var
        CalculationType: Option VAT,"W/Tax",Retention;
        TaxCalc: Codeunit "Tax Calculation1";
        TotalTax: Decimal;
    begin
        "VAT Amount" := 0;
        "Withholding Tax Amount" := 0;
        "Retention  Amount" := 0;
        TotalTax := 0;
        "Net Amount" := 0;
        if Amount <> 0 then begin
            if "VAT Rate" <> 0 then begin
                "VAT Amount" := TaxCalc.CalculateTax(Rec, CalculationType::VAT);
                TotalTax := TotalTax + "VAT Amount"
            end;

            if "W/Tax Rate" <> 0 then begin
                "Withholding Tax Amount" := TaxCalc.CalculateTax(Rec, CalculationType::"W/Tax");
                TotalTax := TotalTax + "Withholding Tax Amount"
            end;

            if "Retention Rate" <> 0 then begin
                "Retention  Amount" := TaxCalc.CalculateTax(Rec, CalculationType::Retention);
                TotalTax := TotalTax + "Retention  Amount"
            end;
        end;

        "Net Amount" := (Amount - TotalTax) + "VAT Amount";
        Validate("Net Amount");
        Modify();
    end;

    procedure PayLinesExist(): Boolean
    var
        PayLine: Record "Payments Line";
    begin
        PayLine.Reset;
        PayLine.SetRange("No.", "No.");
        exit(PayLine.FindFirst);
    end;

    procedure ShowDimensions()
    var
        DimMgt2: Codeunit DimensionManagement;
    begin
        "Dimension Set ID" :=
          DimMgt2.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Payment', "Line No."));
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
}

