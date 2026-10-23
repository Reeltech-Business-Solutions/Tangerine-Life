page 50682 "Cash Off. User Temp. List"
{
    PageType = List;
    Editable = false;
    ApplicationArea = All;
    CardPageId = "Cash Office User Template";
    UsageCategory = Administration;
    SourceTable = "Cash Office User Template";
    Caption = 'Cash Office User Template';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(UserID; rec.UserID)
                {
                    ApplicationArea = All;

                }
                field("Journal Voucher Template"; Rec."Journal Voucher Template")
                {
                    ApplicationArea = All;
                }
                field("Journal Voucher Batch"; Rec."Journal Voucher Batch")
                {
                    ApplicationArea = All;
                }
                field("Payment Journal Template"; Rec."Payment Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Payment Journal Batch"; Rec."Payment Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Receipt Journal Template"; Rec."Receipt Journal Template")
                {
                    ApplicationArea = All;
                }

                field("Receipt Journal Batch"; Rec."Receipt Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Bank Pay In Journal Template"; Rec."Bank Pay In Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Bank Pay In Journal Batch"; Rec."Bank Pay In Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Default Payment Bank"; Rec."Default Payment Bank")
                {
                    ApplicationArea = All;
                }

                field("Default Petty Cash Bank"; Rec."Default Petty Cash Bank")
                {
                    ApplicationArea = All;
                }

                field("Default Receipts Bank"; Rec."Default Receipts Bank")
                {
                    ApplicationArea = All;
                }
                field("Petty Cash Template"; Rec."Petty Cash Template")
                {
                    ApplicationArea = All;
                }
                field("Petty Cash Batch"; Rec."Petty Cash Batch")
                {
                    ApplicationArea = All;
                }
                field("Advance Surr Template"; Rec."Advance Surr Template") { }
                field("Advance Surr Batch"; Rec."Advance Surr Batch") { }
                field("Claim Template"; Rec."Claim Template") { }
                field("Claim  Batch"; Rec."Claim  Batch") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
