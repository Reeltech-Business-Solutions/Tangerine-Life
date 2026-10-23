page 50735 "Account Temporary"
{
    ApplicationArea = All;
    Caption = 'Account Temporary';
    PageType = List;
    SourceTable = "Account Temporary";
    UsageCategory = Lists;
    SourceTableTemporary = true;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
