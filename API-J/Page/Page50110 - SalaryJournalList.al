page 50620 "Salary Journal List"
{

    Caption = 'Salary Journal List';
    PageType = List;
    SourceTable = "Salary Journal";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Basic field.';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Employee No field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Entertainment field.';
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Housing field.';
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ToolTip = 'Specifies the value of the Incentives/Drivers Payables field.';
                    ApplicationArea = All;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Leave field.';
                    ApplicationArea = All;
                }
                field("Cost centre Code"; Rec."Cost centre Code")
                {
                    ToolTip = 'Specifies the value of the Lunch field.';
                    ApplicationArea = All;
                }
                field("Revenue centre Code"; Rec."Revenue centre Code")
                {
                    ToolTip = 'Specifies the value of the PAYE field.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")

                {

                    ApplicationArea = All;
                }

            }
        }
    }

}
