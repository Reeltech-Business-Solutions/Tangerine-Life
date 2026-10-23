table 50606 "Withholding Tax"
{
    Caption = 'Withholding Tax';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Withholding Tax";
    LookupPageId = "Withholding Tax";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'WHT Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Percentage; Decimal)
        {
            Caption = 'Witholding Tax Percentage';
            DataClassification = ToBeClassified;
        }
        field(4; "WHT Account"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "VAT Account"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}

