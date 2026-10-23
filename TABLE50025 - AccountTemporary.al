table 50654 "Account Temporary"
{
    Caption = 'Account Temporary';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(2; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Account No.")
        {
            Clustered = true;
        }
    }
}
