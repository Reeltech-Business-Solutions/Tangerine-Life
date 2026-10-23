page 50605 "Staff Claim Line API"
{
    APIGroup = 'Claims';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'staffClaimLineAPI';
    DelayedInsert = true;
    EntityName = 'StaffClaim';
    EntitySetName = 'StaffclaimAPI';
    PageType = API;
    SourceTable = "Staff Claim Lines";


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(advanceType; Rec."Advance Type")
                {
                    Caption = 'Claim Type';
                    ApplicationArea = All;
                }
                field(no; Rec.No)
                {
                    Caption = 'No';
                    ApplicationArea = All;
                }
                field(accountType; Rec."Account type")
                {
                    Caption = 'Account type';
                    ApplicationArea = All;
                }
                field(accountNo; Rec."Account No:")
                {
                    Caption = 'Account No:';
                    ApplicationArea = All;
                }
                field(accountName; Rec."Account Name")
                {
                    Caption = 'Account Name';
                    ApplicationArea = All;
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                }
                field(claimReceiptNo; Rec."Claim Receipt No")
                {
                    Caption = 'Claim Receipt No';
                    ApplicationArea = All;
                }
                field(expenditureDate; Rec."Expenditure Date")
                {
                    Caption = 'Expenditure Date';
                    ApplicationArea = All;
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Global Dimension 1 Code';
                    ApplicationArea = All;
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                    ApplicationArea = All;
                }
                field(shortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    Caption = 'Shortcut Dimension 3 Code';
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
