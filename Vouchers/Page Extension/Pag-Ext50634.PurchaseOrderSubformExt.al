pageextension 50634 PurchaseOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        addbefore(Description)
        {
            field("1VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = All;
            }
            field("1VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field("Withholding Tax Group Code"; Rec."Withholding Tax Group Code")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    WithHoldTax: Record "Withholding Tax";
                begin
                    if WithHoldTax.Get(Rec."Withholding Tax Group Code") then begin
                        Rec."WIthholdingTax %" := WithHoldTax.Percentage;
                    end else
                        Rec."WIthholdingTax %" := 0;
                end;

            }
            field("WIthholdingTax %"; Rec."WIthholdingTax %")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        addafter(BlanketOrder)
        {
            action("Generate Withholding Tax")
            {
                ApplicationArea = All;
                caption = 'Generate WithHolding Tax';
                Image = CalculateCost;

                trigger OnAction()

                begin

                    if not confirm('Do you want to continue?', false) then
                        exit;

                    witholdingTax2();
                end;
            }
        }
    }
    procedure witholdingTax2()

    var
        purchaseLine: Record "purchase Line";
        purchaseLine2: Record "purchase Line";
        //ClaimsHeader: Record "Staff Claims Header";
        NewLine: Record "purchase Line";
        LineNo: Integer;
        TotalBaseAmount: Decimal;
        WHTPercent: Decimal;
        WHTAmount: Decimal;
        BaseLine: Record "purchase line";
        WhtResult: Decimal;
        checkWHT: Boolean;
        purchaseLine3: Record "purchase line";
        purchaseLine4: Record "purchase line";
        wthAccount: code[20];
        percentage: decimal;
        Accessories: code[20];
        BaseLine2: Record "purchase Line";
        wthTax: Record "Withholding Tax";


    begin

        purchaseLine3.Reset();
        purchaseLine3.setRange("Document No.", Rec."Document No.");
        purchaseLine3.setRange("WHT Base Line No", Rec."Line No.");
        if purchaseLine3.findfirst() then
            purchaseLine3.Delete();




        purchaseLine.Init();
        purchaseLine.SetRange("Document No.", Rec."Document No.");
        purchaseLine.setRange("Document Type", purchaseLine."Document Type"::Order);
        purchaseLine.SetFilter("Withholding Tax Group Code", '<>%1', '');
        purchaseLine.SetRange("Line No.", Rec."Line No.");
        purchaseLine.setfilter("WHT Base Line No", '<%1', 1);

        if purchaseLine.Find('-') then begin

            // NewLine is clean — copy what you need from purchaseLine
            NewLine.Init();
            NewLine."Document Type" := purchaseLine."Document Type";
            NewLine."Document No." := purchaseLine."Document No.";

            // Safe line number
            purchaseLine2.Reset();
            purchaseLine2.SetRange("Document No.", purchaseLine."Document No.");
            purchaseLine2.SetRange("Document Type", purchaseLine."Document Type");
            if purchaseLine2.FindLast() then
                NewLine."Line No." := purchaseLine2."Line No." + 10000
            else
                NewLine."Line No." := 10000;


            //   NewLine."Expense No." := purchaseLine."Expense No.";


            NewLine.Validate(Type, NewLine.Type::"G/L Account");

            if wthTax.Get(purchaseLine."Withholding Tax Group Code") then
                NewLine."No." := wthTax."WHT Account";


            NewLine.Description := CopyStr('WHT On ' + purchaseLine.Description, 1, 100);
            NewLine.Validate(Quantity, 1);
            NewLine."Qty. to Invoice" := 1;
            NewLine."Qty. to Receive" := 1;
            WHTAmount := Round(purchaseLine.Amount * (purchaseLine."WIthholdingTax %" / 100) * -1, 0.01);
            NewLine.Validate("Direct Unit Cost", WHTAmount);

            NewLine."Withholding Tax Group Code" := '';  // WHT line itself should not have a WHT code
            NewLine."WHT Base Line No" := Rec."Line No.";
            NewLine.Validate("VAT Prod. Posting Group", 'NOVAT');
            NewLine.Validate("Gen. Bus. Posting Group", purchaseLine."Gen. Bus. Posting Group");
            NewLine.Insert(true);


        end;


    end;

}
