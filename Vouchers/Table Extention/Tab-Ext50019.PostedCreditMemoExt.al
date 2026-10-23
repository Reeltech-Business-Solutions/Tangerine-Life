tableextension 50612 PostedCreditMemoExt extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50000; "Admin Fee %"; Decimal)
        {
            Caption = 'Admin Fee %';
            Editable = false;
            DataClassification = ToBeClassified;

        }
    }
}

pageextension 50626 PostedSalesCreditMemoExt extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("No. Printed")
        {
            field("Admin Fee %"; Rec."Admin Fee %")
            {
                ApplicationArea = All;
            }
        }
    }
}
