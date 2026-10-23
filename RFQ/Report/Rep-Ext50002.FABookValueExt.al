reportextension 50603 FABookValueExt extends "Fixed Asset - Book Value 01"
{
    RDLCLayout = 'FixedAssetBookValue01(1).rdlc';
    dataset
    {
        add("Fixed Asset")
        {
            column(FA_Location_Code; "FA Location Code")
            {
            }
        }
    }
}
