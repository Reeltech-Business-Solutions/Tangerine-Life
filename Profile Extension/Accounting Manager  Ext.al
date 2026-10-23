pageextension 50603 ExtendNavigationArea extends "Accounting Manager Role Center"
{
    layout
    {
        modify("Job Queue Tasks Activities")
        {
            Visible = false;
        }
    }

    actions
    {
        addafter("Fixed Assets")
        {

            Group(Advance)
            {
                action("Staff Advance Request")
                {
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

            // action("Staff Loan List")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Staff Loan List', comment = '="List of Staff loan"';
            //     RunObject = Page "Employee Loan";

            // }

        }
        addafter("Posted Bank Deposits")
        {
            action("Posted Staff Claims")
            {
                RunObject = page "Posted Staff Claims List";
                ApplicationArea = All;
            }
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

        }
        modify("Sales &Credit Memo")
        {
            Visible = false;
        }
        modify("P&urchase Credit Memo")
        {
            Visible = false;
        }
        modify("Cas&h Receipt Journal")
        {
            Visible = false;
        }
        modify("Calculate Deprec&iation")
        {
            Visible = false;
        }
        modify("Analysis Views")
        {
            Visible = false;
        }
        modify("Import Co&nsolidation from Database")
        {
            Visible = false;
        }
        modify("C&reate Reminders")
        {
            Visible = false;
        }
        modify("Create Finance Charge &Memos")
        {
            Visible = false;
        }
        modify("Calc. and Pos&t VAT Settlement")
        {
            Visible = false;
        }
        modify("Cost Accounting Setup")
        {
            Visible = false;
        }
        modify("Cash Flow Date List")
        {
            Visible = false;
        }
        modify("VAT - VIES Declaration Dis&k")
        {
            Visible = false;
        }
        modify("VAT - VIES Declaration Tax Aut&h")
        {
            Visible = false;
        }
        modify("VAT E&xceptions")
        {
            Visible = false;
        }
        modify("EC Sales &List")
        {
            Visible = false;
        }
        modify("Cost Accounting P/L Statement")
        {
            Visible = false;
        }
        modify("CA P/L Statement per Period")
        {
            Visible = false;
        }
        modify("CA P/L Statement with Budget")
        {
            Visible = false;
        }
        modify("Cost Accounting Analysis")
        {
            Visible = false;
        }
        modify("&Fixed Asset Setup")
        {
            Visible = false;
        }
        modify("Analysis &Views")
        {
            Visible = false;
        }
        modify("Cash Flow Setup")
        {
            Visible = false;
        }
        modify("&Purchases && Payables Setup")
        {
            Visible = false;
        }
        modify("&Sales && Receivables Setup")
        {
            Visible = false;
        }
        
       

    }

}