pageextension 50617 "Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            field("User ID1"; Rec."User ID")
            {
                Caption = 'User ID';
                ApplicationArea = All;
            }
        }
        modify("Debit Amount")
        {
            Visible = false;
        }
        modify("Debit Amount (LCY)")
        {
            Visible = false;
        }
        modify("Credit Amount")
        {
            Visible = False;
        }
        modify("Credit Amount (LCY)")
        {
            Visible = false;
        }
        modify("Sales (LCY)")
        {
            Visible = False;
        }
        modify("Payment Method Code")
        {
            Visible = false;
        }
        modify("Exported to Payment File")
        {
            Visible = False;
        }
        modify("Message to Recipient")
        {
            Visible = False;
        }
        modify(RecipientBankAccount)
        {
            Visible = false;
        }

        addafter("Customer No.")
        {
            field("Customer Name1";Rec."Customer Name")
        {
            Caption ='Customer Name';
            ApplicationArea =All;
        }
        }
        

    }
}

