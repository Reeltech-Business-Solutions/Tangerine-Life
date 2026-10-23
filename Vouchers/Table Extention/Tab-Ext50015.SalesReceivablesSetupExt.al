tableextension 50608 "Sales&ReceivablesSetupExt" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Admin Fee %"; Decimal)
        {
            Caption = 'Admin Fee %';
            DataClassification = ToBeClassified;
        }
        field(50001; "Adm Fee GL Account"; Code[20])
        {
            Caption = 'GL Account';
        }
    }
}

pageextension 50624 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Document Default Line Type")
        {
            field("Admin Fee %"; Rec."Admin Fee %")
            {
                Caption = 'Admin Fee %';
                ApplicationArea = All;
            }
            field("Adm Fee GL Account"; Rec."Adm Fee GL Account")
            {
                ApplicationArea = All;
                Caption = 'Admin Fee GL Account';
            }
        }
    }
}
