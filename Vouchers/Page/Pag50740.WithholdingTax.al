page 50740 "Withholding Tax"
{
    ApplicationArea = All;
    Caption = 'Withholding Tax';
    PageType = List;
    SourceTable = "Withholding Tax";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                }
                field("WHT Account"; Rec."WHT Account")
                {
                    ApplicationArea = All;
                }
                field("VAT Account"; Rec."VAT Account")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

