page 50729 "Voucher List"
{
    CardPageID = "Journal Voucher";
    Editable = false;
    PageType = List;
    SourceTable = "Voucher Header";
    AdditionalSearchTerms = 'Voucher List';
    SourceTableView = WHERE("Voucher Type" = CONST(JV));

    layout
    {
        area(content)
        {
            repeater(New)
            {
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; Rec."Created Time")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcTotals;
    end;

    var
        Amount: Decimal;
        TotalAmount: Decimal;
        VoucherHeader: Record "Voucher Header";
        TotalCredit: Decimal;

    [Scope('Cloud')]
    procedure CalcTotals()
    begin
        VoucherHeader.COPY(Rec);

        TotalAmount := 0;
        TotalCredit := 0;
        VoucherHeader.SETRANGE("Voucher Type", Rec."Voucher Type");
        IF VoucherHeader.FINDSET THEN
            REPEAT
                VoucherHeader.CALCFIELDS("Debit Amount");
                VoucherHeader.CALCFIELDS("Credit Amount");
                TotalAmount := TotalAmount + VoucherHeader."Debit Amount";
                TotalCredit := TotalCredit + VoucherHeader."Credit Amount";
            UNTIL VoucherHeader.NEXT = 0;
    end;
}

