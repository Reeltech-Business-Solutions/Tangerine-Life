page 50616 BankAccount
{
    APIGroup = 'Account';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'bankAccount';
    DelayedInsert = true;
    EntityName = 'BankAcc';
    EntitySetName = 'BankAccAPI';
    PageType = API;
    SourceTable = "Bank Account";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(bank; Rec.Bank)
                {
                    Caption = 'Bank';
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Account Name';
                }
                field(bankAccountNo; Rec."Bank Account No.")
                {
                    Caption = 'Bank Account No.';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
