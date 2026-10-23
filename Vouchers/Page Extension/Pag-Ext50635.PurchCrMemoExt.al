pageextension 50635 "Purch Cr. Memo Ext" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        addafter("Direct Unit Cost")
        {
            field("1VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field("1Gen. Prod. Posting Group";Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}
