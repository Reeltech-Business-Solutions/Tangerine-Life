tableextension 50610 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50000; "Admin Fee %"; Decimal)
        {
            Caption = 'Admin Fee %';
            DataClassification = ToBeClassified;
        }
    }
}
