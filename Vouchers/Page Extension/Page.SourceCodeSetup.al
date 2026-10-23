pageextension 50622 "SourceCode Setup" extends "Source Code Setup"
{
    layout
    {
        addafter("Cost Accounting")
        {
            group(Vouchers)
            {
                field("Cash Receipt Voucher"; Rec."Cash Receipt Voucher") { ApplicationArea = All; }
                field("Cash Payment Voucher"; Rec."Cash Payment Voucher") { ApplicationArea = All; }
                field("Bank Receipt Voucher"; Rec."Bank Receipt Voucher") { ApplicationArea = All; }
                field("Bank Payment Voucher"; Rec."Bank Payment Voucher") { ApplicationArea = All; }
                field("Journal Voucher"; Rec."Journal Voucher") { ApplicationArea = All; }
                field("IOU Voucher"; Rec."IOU Voucher") { ApplicationArea = All; }
                field("IOU Retirement Voucher"; Rec."IOU Retirement Voucher") { ApplicationArea = All; }
                field("Petty Cash Voucher"; Rec."Petty Cash Voucher") { ApplicationArea = All; }
                field("Import Purchase"; Rec."Import Purchase") { ApplicationArea = All; }
                field("Import File - Charge Invoice"; Rec."Import File - Charge Invoice") { ApplicationArea = All; }
                field("Contra Voucher"; Rec."Contra Voucher") { ApplicationArea = All; }

            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}