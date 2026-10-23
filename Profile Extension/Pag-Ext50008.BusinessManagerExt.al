pageextension 50604 "Business Manager Ext" extends "Business Manager Role Center"
{
    actions
    {
        addafter(Action41)
        {
            group("Expense MGT")
            {
                Caption = 'Expense Management';

                action("Staff Advance")
                {
                    Caption = 'Staff Advance Request';
                    RunObject = page "Staff Advance Request List";
                    ApplicationArea = All;
                }
                action("Approved Staff Advance")
                {
                    RunObject = page "Approved Staff Advances";
                    ApplicationArea = All;
                }
                action("Staff Advance Surrender")
                {
                    Caption = 'Staff Advance Retirement';
                    RunObject = page "Staff Advance Surrender List";
                    ApplicationArea = All;
                }
                action("Staff Claims")
                {
                    RunObject = page "Staff Claims List";
                    ApplicationArea = All;
                }

            }
            group("Posted Expense MGT")
            {
                Caption = 'Posted Expense Management';

                action("Posted Staff Advance Request")
                {
                    RunObject = page "Posted Staff Adv Request List";
                    ApplicationArea = All;
                }
                action("Posted Staff Advance Retirement")
                {
                    RunObject = page "Posted Staff Ret. List";
                    ApplicationArea = All;
                }
                action("Posted Staff Claims")
                {
                    RunObject = page "Posted Staff Claims List";
                    ApplicationArea = All;
                }

            }
        }
    }
}
