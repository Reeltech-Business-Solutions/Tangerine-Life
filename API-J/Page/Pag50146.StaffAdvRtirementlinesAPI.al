page 50606 "Staff Adv Retirement lines API"
{
    APIGroup = 'SARLines';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'staffAdvRtirementLinesAPI';
    DelayedInsert = true;
    EntityName = 'StaffAdvSur';
    EntitySetName = 'StaffAdvSurAPI';
    PageType = API;
    SourceTable = "Staff Advan Surrender Details";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(imprestType; Rec."Imprest Type")
                {
                    Caption = 'Imprest Type';
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
                field(actualSpent; Rec."Actual Spent")
                {
                    Caption = 'Actual Spent';
                    ApplicationArea = All;
                }
                field(cashReceiptNo; Rec."Cash Receipt No")
                {
                    Caption = 'Cash Receipt No';
                    ApplicationArea = All;
                }
                field(applyTo; Rec."Apply to")
                {
                    Caption = 'Apply to';
                    ApplicationArea = All;
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                    ApplicationArea = All;
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                    ApplicationArea = All;
                }
                field(shortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    Caption = 'Posting Location';
                    ApplicationArea = All;
                }
                field(advanceHolder; Rec."Advance Holder")
                {
                    Caption = 'Advance Holder';
                    ApplicationArea = All;
                }
                field(surrenderDocNo; Rec."Surrender Doc No.")
                {
                    Caption = 'Surrender Doc No.';
                    ApplicationArea = All;
                }
                field(appliesToDocType; Rec."Applies-to Doc. Type")
                {
                    Caption = 'Applies-to Doc. Type';
                    ApplicationArea = All;
                }
                field(appliesToDocNo; Rec."Applies-to Doc. No.")
                {
                    Caption = 'Applies-to Doc. No.';
                    ApplicationArea = All;
                }
                field(appliesToID; Rec."Applies-to ID")
                {
                    Caption = 'Applies-to ID';
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
