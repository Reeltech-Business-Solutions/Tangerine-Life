table 50643 "Quote Specifications"
{
    //LookupPageID = 39006078;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[60])
        {
        }
        field(3; "Value/Weight"; Decimal)
        {
        }
        field(4; "issued date"; Date)
        {

        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

