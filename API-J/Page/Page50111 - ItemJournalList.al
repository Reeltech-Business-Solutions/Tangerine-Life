page 50621 "Item Journal List"
{

    Caption = 'Item Journal List';
    PageType = List;
    SourceTable = "Item Journal";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Cost Center"; Rec."Cost Center")
                {
                    ToolTip = 'Specifies the value of the Cost Center field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.';
                    ApplicationArea = All;
                }
                field("Item Journal Batch"; Rec."Item Journal Batch")
                {
                    ToolTip = 'Specifies the value of the Item Journal Batch field.';
                    ApplicationArea = All;
                }
                field("Item Journal Template Name"; Rec."Item Journal Template Name")
                {
                    ToolTip = 'Specifies the value of the Item Journal Template Name field.';
                    ApplicationArea = All;
                }
                field("Item No"; Rec."Item No")
                {
                    ToolTip = 'Specifies the value of the Item No field.';
                    ApplicationArea = All;
                }
                field("Line No"; Rec."Line No")
                {
                    ToolTip = 'Specifies the value of the Line No field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field("Profit Center"; Rec."Profit Center")
                {
                    ToolTip = 'Specifies the value of the Profit Center field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }

            }
        }
    }

}
