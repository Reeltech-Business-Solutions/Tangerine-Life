tableextension 50611 PostedSalesInvExt extends "Sales Invoice Header"
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

pageextension 50625 PostedSalesInvExt extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Dispute Status")
        {
            field("Admin Fee %"; Rec."Admin Fee %")
            {
                ApplicationArea = All;
            }
        }
    }
}
