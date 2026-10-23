page 50622 "Salary Journal Api"
{

    Caption = 'Salary Journal';
    PageType = API;
    APIVersion = 'v2.0';
    APIPublisher = 'reeltechConsulting';
    APIGroup = 'reeltechCustomer';
    EntityCaption = 'salaryJournal';
    EntitySetCaption = 'SalaryJournal';
    EntityName = 'salaryJournal';
    EntitySetName = 'salaryJournals';
    SourceTable = "Salary Journal";

    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(PostingDate; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Basic field.';
                    ApplicationArea = All;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field(AccountType; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field(AccountNo; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Employee No field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Entertainment field.';
                    ApplicationArea = All;
                }
                field(AmountLCY; Rec."Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Housing field.';
                    ApplicationArea = All;
                }
                field(BalAccountType; Rec."Bal. Account Type")
                {
                    ToolTip = 'Specifies the value of the Incentives/Drivers Payables field.';
                    ApplicationArea = All;
                }
                field(BalAccountNo; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Leave field.';
                    ApplicationArea = All;
                }
                field(CostcentreCode; Rec."Cost centre Code")
                {
                    ToolTip = 'Specifies the value of the Lunch field.';
                    ApplicationArea = All;
                }
                field(RevenuecentreCode; Rec."Revenue centre Code")
                {
                    ToolTip = 'Specifies the value of the PAYE field.';
                    ApplicationArea = All;
                }
                field(LineNo; Rec."Line No.")
                {

                }

                //https://nav.contoso.com:7048/TSL/api/v2.0
                //https://13.64.154.230:7048/TSL/api/reeltechConsulting/reeltechCustomer/v2.0

                //https://<base URL>:<port>/<serverinstance>/api/<API publisher>/<API group>/<API version>
            }
        }
    }

}
