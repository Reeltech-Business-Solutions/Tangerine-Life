report 50618 ModifyACperiod
{
    ApplicationArea = All;
    Caption = 'ModifyACperiod';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(AccountingPeriod; "Accounting Period")
        {
            trigger OnAfterGetRecord()
            begin
                Delete;
            end;


        }
    }


    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
