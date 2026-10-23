page 50607 "Staff Advance Lines API"
{
    APIGroup = 'SAL';
    APIPublisher = 'Reeltech';
    APIVersion = 'v1.0';
    Caption = 'staffAdvanceLinesAPI';
    DelayedInsert = true;
    EntityName = 'Staffadvancelines';
    EntitySetName = 'StaffAdvLinesAPI';
    PageType = API;
    SourceTable = "Staff Advance Lines";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(advanceType; Rec."Advance Type")
                {
                    Caption = 'Advance Type';
                    ApplicationArea = All;
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                }
                field(gLAccountNo; Rec."Account No.")
                {
                    Caption = 'Account No.';
                    ApplicationArea = All;
                }
                field(accountName; Rec."Account Name")
                {
                    Caption = 'Account Name';
                    ApplicationArea = All;
                }
                field(purpose; Rec.Purpose)
                {
                    Caption = 'Purpose';
                    ApplicationArea = All;
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                    ApplicationArea = All;
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                }
                field(amountLCY; Rec."Amount LCY")
                {
                    Caption = 'Amount LCY';
                    ApplicationArea = All;
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                    ApplicationArea = All;
                }
                field(dateIssued; Rec."Date Issued")
                {
                    Caption = 'Date Issued';
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
