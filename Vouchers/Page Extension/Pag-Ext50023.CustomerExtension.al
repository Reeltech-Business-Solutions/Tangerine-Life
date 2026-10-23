pageextension 50615 "Customer Extension" extends "Customer Card"
{

    layout
    {
        addafter(Name)
        {
            field("Account Type"; Rec."Account Type")
            {
                Caption = 'Customer Type';
                ApplicationArea = All;
            }
            field("G/L Account No."; Rec."G/L Account No.")
            {
                Caption = 'G/L Account No';
                ApplicationArea = All;
            }
        }
    }
}

