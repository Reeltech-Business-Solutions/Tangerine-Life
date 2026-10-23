table 50653 "Dimension Temporary"
{
    Caption = 'Dimension Temporary';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Dimension name"; Code[20])
        {
            Caption = 'Dimension name';
            DataClassification = ToBeClassified;
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Global Dimension No"; Integer)
        {
            Caption = 'Global Dimension No';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Dimension Code", "Dimension name")
        {
            Clustered = true;
        }
    }
}
