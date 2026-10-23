page 50728 "Posted Voucher List"
{
    CardPageID = "Posted Journal Voucher";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Posted Voucher Header";
    SourceTableView = WHERE("Voucher Type" = FILTER(JV));

    layout
    {
        area(content)
        {
            repeater(New)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Reference Voucher No."; Rec."Reference Voucher No.")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field(Narration; Rec.Narration)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Voucher")
            {
                Caption = '&Voucher';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ApplicationArea = All;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        /*IF PostedVoucherHeader.GET("Voucher Type","No.") THEN
                         BEGIN
                           CASE "Voucher Type"  OF
                             "Voucher Type"::JV :
                               PAGE.RUN(PAGE::"Posted Journal Voucher",PostedVoucherHeader);
                             "Voucher Type" :: CPV :
                               PAGE.RUN(PAGE::Page50065,PostedVoucherHeader);
                             "Voucher Type" :: CRV :
                               PAGE.RUN(PAGE::Page50067,PostedVoucherHeader);
                             "Voucher Type" :: BRV :
                               PAGE.RUN(PAGE::Page50069,PostedVoucherHeader);
                             "Voucher Type" :: BPV :
                               PAGE.RUN(PAGE::"Purchase Request List",PostedVoucherHeader);
                           END;
                         END;
                        */

                    end;
                }
            }
        }
    }

    var
        PostedVoucherHeader: Record "Posted Voucher Header";
}

