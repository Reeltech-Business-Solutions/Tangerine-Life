pageextension 50621 RespCenterExt extends "Responsibility Center List"
{
    layout
    {
        addafter("Location Code")
        {
            // Add changes to table fields here
            field("CPV Nos."; Rec."CPV Nos.")
            {
                ApplicationArea = All;
                TableRelation = "No. Series";
            }
            field("BPV Nos."; Rec."BPV Nos.")
            {
                ApplicationArea = All;
            }
            field("CRV Nos."; Rec."CRV Nos.")
            {
                ApplicationArea = All;

            }
            field("BRV Nos."; Rec."BRV Nos.")
            {
                ApplicationArea = All;

            }
            field("JV Nos."; Rec."JV Nos.")
            {
                ApplicationArea = All;

            }
            field("Posted CPV Nos."; Rec."Posted CPV Nos.")
            {
                ApplicationArea = All;

            }
            field("Posted BPV Nos."; Rec."Posted BPV Nos.")
            {
                ApplicationArea = All;

            }
            field("Posted CRV Nos."; Rec."Posted CRV Nos.")
            {
                ApplicationArea = All;

            }
            field("Posted BRV Nos."; Rec."Posted BRV Nos.")
            {
                ApplicationArea = All;

            }
            field("Posted JV Nos."; Rec."Posted JV Nos.")
            {
                ApplicationArea = All;

            }
            field("Posted Contra Voucher Nos."; Rec."Posted Contra Voucher Nos.")
            {
                ApplicationArea = All;

            }
            field("Petty Cash Nos"; Rec."Petty Cash Nos")
            {
                ApplicationArea = All;

            }
            field("Posted Petty Cash Nos"; Rec."Posted Petty Cash Nos")
            {
                ApplicationArea = All;

            }
            field("Contra Voucher Nos."; Rec."Contra Voucher Nos.")
            {
                ApplicationArea = All;

            }

        }

    }
}