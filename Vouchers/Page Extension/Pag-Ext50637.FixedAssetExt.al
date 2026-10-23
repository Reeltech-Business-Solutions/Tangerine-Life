pageextension 50637 FixedAssetExt extends "Fixed Asset Card"
{
    layout
    {
        addafter("No.")
        {
            field("No 2."; Rec."No 2.")
            {
                ApplicationArea = All;
            }
        }
    }
}
