page 50667 "Staff Advance List"
{
    ApplicationArea = All;
    Caption = 'Staff Advance List';
    PageType = List;
    SourceTable = "Staff Advance Header";


    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    //ApplicationArea = All;
                    Editable = False;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                    Caption = 'Account Name';
                    Editable = false;
                }
                
            }
        }
    }
}
