page 50734 "Dimension Temporary"
{
    ApplicationArea = All;
    Caption = 'Dimension Temporary';
    PageType = List;
    SourceTable = "Dimension Temporary";
    UsageCategory = Lists;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ToolTip = 'Specifies the value of the Dimension Code field.';
                    ApplicationArea = All;
                }
                field("Dimension name"; Rec."Dimension name")
                {
                    ToolTip = 'Specifies the value of the Dimension name field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                }
                field("Global Dimension No"; Rec."Global Dimension No")
                {
                    ToolTip = 'Specifies the value of the Global Dimension No field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
