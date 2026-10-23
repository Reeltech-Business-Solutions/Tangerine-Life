page 50653 "Approved Purchase Req."
{
    ApplicationArea = All;
    Caption = 'Approved Purchase Req.';
    CardPageId = "Approved Requisistion PRO";
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Header";
    UsageCategory = Lists;
    AdditionalSearchTerms = 'Local Requisition,Purchase Requisition';
    SourceTableView = WHERE("Document Type" = CONST(Quote), Status = filter("Released"));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                // field("Purchase Type"; Rec."Purchase Type")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Purchase Type field.';
                // }

                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = All;
                }
                // field("Requisition No."; Rec."Requisition No.")
                // {
                //     ToolTip = 'Specifies the value of the Requisition No. field.';
                //     ApplicationArea = All;
                // } RBS 08/10/25
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }


            }
        }
    }
    trigger OnOpenPage()
    begin
        // RBS08/10/25  Rec.SetFilter("Purchase Type", '%1|%2', Rec."Purchase Type"::"Local Requisition", Rec."Purchase Type"::"Foreign Requisition");


        // repeat
        //     Validate(Status);
        //     Validate("Purchase Type");
        // until rec.Next() = 0;
    end;

}
