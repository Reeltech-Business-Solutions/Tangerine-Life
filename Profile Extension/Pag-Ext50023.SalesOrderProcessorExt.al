pageextension 50605 SalesOrderProcessorExt extends "Order Processor Role Center"
{
    actions
    {
        addlast(sections)
        {
            group("Staff Advance")
            {
                action("Staff Advance Requests")
                {
                    Caption = 'Staff Advance Requests';
                    RunObject = page "Staff Advance Request List";
                    ApplicationArea = All;
                }
                action("Staff Advance Retirement")
                {
                    Caption = 'Staff Advance Retirement';
                    RunObject = page "Staff Advance Surrender List";
                    ApplicationArea = All;
                }
                action("Staff Claims")
                {
                    Caption = 'Staff Claims';
                    RunObject = page "Staff Claims List";
                    ApplicationArea = All;
                }

            }

        }
    }
}
