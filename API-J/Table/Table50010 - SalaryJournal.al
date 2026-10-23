table 50651 "Salary Journal"
{
    Caption = 'Salary Journal';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Account Type"; Code[20])
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Description"; Text[150])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(7; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            DataClassification = ToBeClassified;
        }
        field(8; "Bal. Account Type"; Code[20])
        {
            Caption = 'Bal. Account Type';
            DataClassification = ToBeClassified;
        }
        field(9; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            DataClassification = ToBeClassified;
        }
        field(10; "Cost centre Code"; Code[20])
        {
            Caption = 'Cost centre Code';
            DataClassification = ToBeClassified;
        }
        field(11; "Revenue centre Code"; Code[20])
        {
            Caption = 'Revenue centre Code';
            DataClassification = ToBeClassified;
        }
        field(12; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(13; Utility; Decimal)
        {
            Caption = 'Utility';
            DataClassification = ToBeClassified;
        }
        field(14; "Incentives/Drivers Payables"; Decimal)
        {
            Caption = 'Incentives/Drivers Payables';
            DataClassification = ToBeClassified;
        }
        field(15; PAYE; Decimal)
        {
            Caption = 'PAYE';
            DataClassification = ToBeClassified;
        }
        field(16; "Pension Employee"; Decimal)
        {
            Caption = 'Pension Employee';
            DataClassification = ToBeClassified;
        }
        field(17; "Pension Employer"; Decimal)
        {
            Caption = 'Pension Employer';
            DataClassification = ToBeClassified;
        }
        field(18; "Total Monthly"; Decimal)
        {
            Caption = 'Total Monthly';
            DataClassification = ToBeClassified;
        }
        field(8000; Id; Guid)
        {
            Caption = 'Id';
            ObsoleteState = Pending;
            ObsoleteReason = 'This functionality will be replaced by the systemID field';
            ObsoleteTag = '15.0';
        }
    }
    keys
    {
        key(PK; "Document No.", "Posting Date", "Line No.")
        {
            Clustered = true;
        }
    }

}
