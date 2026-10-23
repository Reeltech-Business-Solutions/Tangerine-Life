table 50601 "Posted Voucher Line"
{

    fields
    {
        field(1; "Voucher Type"; Option)
        {
            OptionCaption = 'JV,CPV,CRV,BPV,BRV,Contra,PettyCash';
            OptionMembers = JV,CPV,CRV,BPV,BRV,Contra,PettyCash;
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account"),
                                "Voucher Type" = CONST(JV)) "G/L Account" WHERE("Direct Posting" = FILTER(true))
            ELSE
            IF ("Account Type" = CONST(Customer),
                                         "Voucher Type" = CONST(JV)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor),
                                                  "Voucher Type" = CONST(JV)) Vendor
            ELSE
            IF ("Voucher Type" = CONST(CPV),
                                                           "Account Type" = CONST("Bank Account")) "Bank Account"."No." WHERE("Bank Type" = Filter(Cash))
            ELSE
            IF ("Voucher Type" = CONST(CRV),
                                                                    "Account Type" = CONST("Bank Account")) "Bank Account"."No." WHERE("Bank Type" = Filter(Cash))
            ELSE
            IF ("Voucher Type" = CONST(BPV),
                                                                             "Account Type" = CONST("Bank Account")) "Bank Account"."No." WHERE("Bank Type" = Filter(Normal | Cash | Cheque | EFT))
            ELSE
            IF ("Voucher Type" = CONST(BRV),
                                                                                      "Account Type" = CONST("Bank Account")) "Bank Account"."No." WHERE("Bank Type" = Filter(Normal | Cash | Cheque | EFT));
        }
        field(5; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(6; Amount; Decimal)
        {
        }
        field(7; "Amount (LCY)"; Decimal)
        {
        }
        field(8; "Debit Amount"; Decimal)
        {
        }
        field(9; "Credit Amount"; Decimal)
        {
        }
        field(10; "Line No."; Integer)
        {
        }
        field(15; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
        }
        field(16; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(17; Narration; Text[150])
        {
        }
        field(19; "Document Date"; Date)
        {
        }
        field(20; "Posting Date"; Date)
        {
        }
        field(21; Status; Option)
        {
            OptionCaption = 'Open,Released,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";
        }
        field(23; "Exchange Rate"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(24; "Posting Group"; Code[20])
        {
        }
        field(25; Account; Option)
        {
            OptionCaption = 'G/L Account,Customer,Local Vendor,Foreign Vendor,Import File,Intercomany,Local Staff,Expat Staff,Cash,Bank,Other Bank,Fixed Asset';
            OptionMembers = "G/L Account",Customer,"Local Vendor","Foreign Vendor","Import File",Intercomany,"Local Staff","Expat Staff",Cash,Bank,"Other Bank","Fixed Asset";
        }
        field(30; "Bal. Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(31; "Bal. Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = FILTER(true))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = FILTER("Fixed Asset")) "Fixed Asset";
        }
        field(34; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(35; "Applies Document No."; Code[20])
        {
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
        field(50006; "Teller / Cheque No."; Code[30])
        {
        }
        field(50007; "External Document No."; Code[30])
        {
        }
        field(50008; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(50013; "Cheque No."; Code[20])
        {
        }
        field(60000; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(60001; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(60002; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(60003; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(60004; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(60005; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(60006; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(60007; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
        field(60008; PostedEntry; Code[20])
        {
            CalcFormula = Lookup("G/L Entry"."Document No." WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(60010; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer."No.";
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
            SumIndexFields = Amount, "Amount (LCY)", "Debit Amount", "Credit Amount";
        }
    }

    fieldgroups
    {
    }

    [Scope('Cloud')]
    procedure ShowDimensions()
    var
        DocDim: Record "IC Document Dimension";
    begin
        //TESTFIELD("Transaction No.");
        //TESTFIELD("Line No.");
        DocDim.SETRANGE("Table ID", DATABASE::"Posted Voucher Line");
        /*CASE "Voucher Type" OF
        "Voucher Type"::JV:
          DocDim.SETRANGE("Document Type",DocDim."Document Type"::JV);
        "Voucher Type"::CPV:
          DocDim.SETRANGE("Document Type",DocDim."Document Type"::CPV);
        "Voucher Type"::CRV:
          DocDim.SETRANGE("Document Type",DocDim."Document Type"::CRV);
        "Voucher Type"::BPV:
          DocDim.SETRANGE("Document Type",DocDim."Document Type"::BPV);
        "Voucher Type"::BRV:
          DocDim.SETRANGE("Document Type",DocDim."Document Type"::BRV);
        END;
        */
        //DocDim.SETRANGE("Document No.","Document No.");
        //DocDim.SETRANGE("Line No.","Line No.");
        //DocDimensions.SETTABLEVIEW(DocDim);
        //DocDimensions.RUNMODAL;

    end;
}

