page 50612 "Staff Advance Request API"
{
    APIGroup = 'StaffAdvReq';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'staffAdvanceRequestAPI';
    DelayedInsert = true;
    EntityName = 'StaffAdvance';
    EntitySetName = 'StaffAdvanceRequestAPI';
    PageType = API;
    SourceTable = "Staff Advance Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                }
                field("date"; Rec."Date")
                {
                    Caption = 'Date';
                    ApplicationArea = All;
                }
                field(accountType; Rec."Account Type")
                {
                    Caption = 'Account Type';
                    ApplicationArea = All;
                }
                field(accountNo; Rec."Account No.")
                {
                    Caption = 'Account No.';
                    ApplicationArea = All;
                }
                field(payee; Rec.Payee)
                {
                    Caption = 'Payee';
                    ApplicationArea = All;
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                    ApplicationArea = All;
                }
                field(payingBankAccount; Rec."Paying Bank Account")
                {
                    Caption = 'Paying Bank Account';
                    ApplicationArea = All;
                }
                field(bankName; Rec."Bank Name")
                {
                    Caption = 'Bank Name';
                    ApplicationArea = All;
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                }
                field(totalNetAmount; Rec."Total Net Amount")
                {
                    Caption = 'Total Net Amount';
                    ApplicationArea = All;
                }
                field(totalNetAmountLCY; Rec."Total Net Amount LCY")
                {
                    Caption = 'Total Net Amount LCY';
                    ApplicationArea = All;
                }
                field(responsibilityCenter; Rec."Responsibility Center")
                {
                    Caption = 'Responsibility Center';
                    ApplicationArea = All;
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                    ApplicationArea = All;
                }
            }
        }
    }
}
