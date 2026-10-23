page 50746 POAttach
{
    ApplicationArea = All;
    Caption = 'POAttach';
    PageType = List;
    SourceTable = POAttach;
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(General)
            {


                field("Purchase order"; Rec."Purchase order")
                {
                    ApplicationArea = all;
                }

                field(Voucher; Rec.Voucher)
                {
                    ApplicationArea = all;
                }

                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
