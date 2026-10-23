page 50688 "Receipt and Pay Types List"
{
    PageType = List;
    Caption = 'Receipt and Pay Types List';
    SourceTable = "Receipts and Payment Types";
    //Editable = true;

    ApplicationArea = all;
    UsageCategory = Lists;
    AdditionalSearchTerms = 'Receipt and Pay Types List';

    layout
    {
        area(content)
        {
            repeater(Control1102758000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = ALL;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = ALL;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = ALL;
                }
                field("VAT Chargeable"; Rec."VAT Chargeable")
                {
                    ApplicationArea = ALL;

                }
                field("Withholding Tax Chargeable"; Rec."Withholding Tax Chargeable")
                {
                    ApplicationArea = ALL;

                }
                field("VAT Code"; Rec."VAT Code")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Withholding Tax Code"; Rec."Withholding Tax Code")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Default Grouping"; Rec."Default Grouping")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("G/L Account"; Rec."Account No.")
                {
                    ApplicationArea = ALL;
                }
                field("Pending Voucher"; Rec."Pending Voucher")
                {
                    ApplicationArea = ALL;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = ALL;
                }
                field("Transation Remarks"; Rec."Transation Remarks")
                {
                    ApplicationArea = ALL;

                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

