/// <summary>
/// PageExtension ExtendNavigationArea (ID 50001) extends Record Accounting Manager Role Center.
/// </summary>
pageextension 50602 AccountantExtendNavArea extends "Accountant Role Center"
{

    actions
    {

        addlast(Sections)
        {
            group("Cash Management...")
            {
                action("Staff Advance Request")
                {
                    RunObject = page "Staff Advance Request List";
                    ApplicationArea = All;
                }
                action("Staff Advance Surrender")
                {
                    RunObject = page "Staff Advance Surrender List";
                    ApplicationArea = All;
                }
                action("Payment Request List")
                {
                    RunObject = page "Payment Requests List";
                    ApplicationArea = All;
                }
                action("Payment List")
                {
                    RunObject = page "Payment List";
                    ApplicationArea = All;
                }
                action("Posted Staff Advance Request")
                {
                    RunObject = page "Posted Staff Adv Request List";
                    ApplicationArea = All;
                }
                action("Staff Claims")
                {
                    RunObject = page "Staff Claims List";
                    ApplicationArea = All;
                }

            }

            group("Posted Vouchers")
            {
                action("Posted Staff Claims")
                {
                    RunObject = page "Posted Staff Claims List";
                    ApplicationArea = All;
                }

                action("Posted Staff Advance Retirement")
                {
                    RunObject = page "Posted Staff Ret. List";
                    ApplicationArea = All;
                }

            }

        }

    }

}
