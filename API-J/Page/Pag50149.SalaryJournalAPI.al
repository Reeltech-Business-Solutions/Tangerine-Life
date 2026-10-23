page 50609 "Salary Journal "
{
    APIGroup = 'Journal';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'salaryJournalAPI';
    DelayedInsert = true;
    EntityName = 'salaryjournal';
    EntitySetName = 'SalaryJournalAPI';
    PageType = API;
    SourceTable = "Salary Journal";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(accountType; Rec."Account Type")
                {
                    Caption = 'Account Type';
                }
                field(accountNo; Rec."Account No.")
                {
                    Caption = 'Account No.';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(amountLCY; Rec."Amount (LCY)")
                {
                    Caption = 'Amount (LCY)';
                }
                field(balAccountType; Rec."Bal. Account Type")
                {
                    Caption = 'Bal. Account Type';
                }
                field(balAccountNo; Rec."Bal. Account No.")
                {
                    Caption = 'Bal. Account No.';
                }
                field(costCentreCode; Rec."Cost centre Code")
                {
                    Caption = 'Cost centre Code';
                }
                field(revenueCentreCode; Rec."Revenue centre Code")
                {
                    Caption = 'Revenue centre Code';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
