tableextension 50607 "Purch&PayablesExt" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Requisition No."; Code[20])
        {
            Caption = 'Requisition No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "RFQ No."; Code[20])
        {
            Caption = 'RFQ No.';
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
    }
}

pageextension 50623 "Purch&PayablesExt." extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Vendor Nos.")
        {
            field("Requisition No."; Rec."Requisition No.")
            {
                ApplicationArea = All;
            }
            field("RFQ No."; Rec."RFQ No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
