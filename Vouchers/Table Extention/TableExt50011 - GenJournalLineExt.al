tableextension 50622 GenJournalLine extends "Gen. Journal Line"
{
    fields
    {
        field(50004; "Payment Request No."; Code[20])
        {

        }
        field(70014; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(70015; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(70016; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(70022; "Loan ID"; Code[20]) { }
        field(70023; "Acct. No."; Code[20]) { }
        field(80001; "Voucher Type"; Option)
        {
            OptionMembers = JV,CPV,CRV,BPV,BRV,IOUV,IOURV,FAGLJV,SJV,PJV,RJV,CONTRA,PETTYCASH;
            OptionCaption = 'JV,CPV,CRV,BPV,BRV,IOUV,IOURV,FAGLJV,SJV,PJV,RJV,CONTRA,PETTYCASH';

        }
        field(80002; "Status"; Option)
        {
            OptionMembers = Open,Released,"Pending Approval";
            OptionCaption = 'Open,Released,"Pending Approval"';
        }
        field(80003; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(80005; "Narration 1"; Text[150]) { }
        field(80006; "Narration 2"; Text[150]) { }
        field(80007; "Narration 3"; Text[150]) { }
        field(80008; "FA Account Name"; Text[150])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Fixed Asset".Description WHERE("No." = FIELD("Account No.")));
        }
        field(80009; "GL Account Name"; Text[150])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("Account No.")));
        }
        field(80010; "PL Group"; Text[30]) { }
        /*
        field(80030; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }

        field(80031; "Shortcut Dimension 4 Code"; Code[20]) { CaptionClass = '1,2,4'; tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4)); }
        field(80032; "Shortcut Dimension 5 Code"; Code[20]) { CaptionClass = '1,2,5'; tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5)); }
        */
        field(80033; "Shortcut Dimension 6 Code"; Code[20]) { CaptionClass = '1,2,6'; tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6)); }
        field(80034; "Shortcut Dimension 7 Code"; Code[20]) { CaptionClass = '1,2,7'; tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7)); }
        field(80035; "Shortcut Dimension 8 Code"; Code[20]) { CaptionClass = '1,2,8'; tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8)); }
        field(80036; "Shortcut Dimension 3 Name"; Text[50]) { }
        field(80037; "Shortcut Dimension 4 Name"; Text[50]) { }
        field(80038; "Shortcut Dimension 5 Name"; Text[50]) { }
        field(80039; "Shortcut Dimension 6 Name"; Text[50]) { }
        field(80040; "Shortcut Dimension 7 Name"; Text[50]) { }
        field(80041; "Shortcut Dimension 8 Name"; Text[50]) { }
        field(80050; "Import File No."; Code[20]) { }
        field(80051; "Created By Name"; Text[50]) { }
        field(80052; "Created Date"; Date) { }
        field(80053; "Created Time"; Time) { }
        field(80054; "Modified By"; Code[50]) { }
        field(80055; "Modified By Name"; Text[50]) { }
        field(80056; "Modified Date"; Date) { }
        field(80057; "Modified Time"; Time) { }
        field(80058; "Paid To / Received By"; Text[50]) { }
        field(80060; "Payment Mode"; Option)
        {
            OptionMembers = ,Cheque,Teller;
            OptionCaption = ' ,Cheque,Teller';
        }
        field(80061; "Posted By"; Code[50]) { }
        field(80062; "Posted By Name"; Text[50]) { }
        field(80063; "Posted Date"; Date) { }
        field(80064; "Posted Time"; Time) { }
        field(80065; "Cheque No."; Code[30]) { }
        field(80067; "Responsibility Center"; Code[20]) { TableRelation = "Responsibility Center"; }
        field(80068; "Sales Representative"; Code[20]) { }
        field(80069; "Salesperson Code"; Code[20]) { }
        field(80070; "Customer Opening Amount"; Decimal) { }
        field(50308; "OEM Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(50309; "LPO"; Text[50])
        {

        }

        field(50600; "Account Class Name"; Text[200])
        {
            Caption = 'Account Class Name';
            DataClassification = ToBeClassified;
        }

        field(50601; "Transaction Class Name"; Text[200])
        {
            Caption = 'Transaction Class Name';
            DataClassification = ToBeClassified;
        }

        field(50602; "Transaction Class Code"; code[20])
        {
            Caption = 'Transaction Class Code';
            DataClassification = ToBeClassified;
        }

        field(50603; "Account Class Code"; code[20])
        {
            Caption = 'Account Class Code';
            DataClassification = ToBeClassified;
        }
        field(50604; "refnum"; code[20])
        {
            Caption = 'Refnum';
            DataClassification = ToBeClassified;
        }

        field(50605; note; text[500])
        {
            Caption = 'Note';
            DataClassification = ToBeClassified;
        }

        field(50606; "Cheque Num"; code[200])
        {
            Caption = 'Cheque Number';
            DataClassification = ToBeClassified;
        }

        field(50607; "Effective Date"; date)
        {
            Caption = 'Effective Date';
            DataClassification = ToBeClassified;
        }

        field(50608; "Transaction Date"; date)
        {
            Caption = 'Transaction Date';
            DataClassification = ToBeClassified;
        }

        field(50609; "Proposal Number"; code[50])
        {
            Caption = 'Proposal Number';
            DataClassification = ToBeClassified;
        }

        field(50610; "Policy Number"; code[50])
        {
            Caption = 'Policy Number';
            DataClassification = ToBeClassified;
        }

        field(50611; "Policy Class"; code[50])
        {
            Caption = 'Policy Class';
            DataClassification = ToBeClassified;
        }

        field(50612; branch; code[50])
        {
            Caption = 'Branch';
            DataClassification = ToBeClassified;
        }

        field(50613; agency; code[50])
        {
            Caption = 'Agency';
            DataClassification = ToBeClassified;
        }

        field(50614; "CBA Trans ID"; Code[50])
        {
            Caption = 'CBA Trans ID';
            DataClassification = CustomerContent;
        }

        field(50615; "Bank ref id"; code[200])
        {
            Caption = 'Bank ref id';
            DataClassification = ToBeClassified;
        }
        field(50616; "CBA Processed"; boolean)
        {

        }


        field(50620; beneficiary; code[200])
        {

        }






    }

    var
        myInt: Integer;
}