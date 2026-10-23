pageextension 50633 PurchaseOrderExt extends "purchase order"
{
    layout
    {

        addafter(Status)
        {
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
            field("Requisition No."; Rec."Requisition No.")
            {
                ApplicationArea = All;
                Visible = false;

            }
        }
        addafter("Currency Code")
        {
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;

            }
        }
        addafter("Posting Date")
        {
            field("Posting Description1"; Rec."Posting Description")
            {
                ApplicationArea = All;
            }
        }
        modify("Quote No.")
        {
            Caption = 'Requisition No.';
        }
        modify("Your Reference")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("No. of Archived Versions")
        {
            Visible = false;
        }
        modify("Vendor Order No.")
        {
            Visible = false;
        }
        modify("Vendor Shipment No.")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }
        modify("Tax Liable")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("Inbound Whse. Handling Time")
        {
            Visible = false;
        }
        modify("Lead Time Calculation")
        {
            Visible = false;
        }
        modify("Requested Receipt Date")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        modify(Status)
        {
            Editable = EditStatus;
        }
    }
    actions
    {
        addafter("Create &Whse. Receipt")
        {
            action("Generate with-Holding Tax")
            {
                ApplicationArea = All;
                caption = 'Generate WithHolding Tax';
                Image = CalculateCost;
                promoted = true;
                PromotedCategory = process;

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                begin

                    PurchHeader.Get(Rec."Document Type", Rec."No.");
                    witholdingTax2();


                    CurrPage.Update();
                end;
            }
        }

    }
    trigger OnOpenPage()
    begin
        if Userset.Get(UserId) then begin
            if Userset."Released Status" = false then
                EditStatus := false else
                EditStatus := true;
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec.Status = Rec.Status::"Pending Approval" then
            Error('You can not delete pending approval documents');

        if Rec.Status = Rec.Status::Released then
            Error('You can not delete Released documents');
    end;

    var
        wthTax: Record "Withholding Tax";
        Userset: Record "User Setup";
        EditStatus: Boolean;

    procedure witholdingTax2()

    var
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        NewLine: Record "Purchase Line";
        LineNo: Integer;
        TotalBaseAmount: Decimal;
        WHTPercent: Decimal;
        WHTAmount: Decimal;
        BaseLine: Record "Purchase Line";
        WhtResult: Decimal;
        checkWHT: Boolean;
        PurchLine3: Record "Purchase Line";
        PurchLine4: Record "Purchase Line";
        wthAccount: code[20];

        // percentage: decimal;
        BaseLine2: Record "Purchase Line";
    begin

        PurchHeader.Get(Rec."Document Type", Rec."No.");
        WthTax.Reset();
        if wthTax.findfirst() then begin
            wthAccount := wthTax."WHT Account";

        end;
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::" ");
        PurchLine.SetRange("No.", wthAccount);

        if PurchLine.FindFirst() then
            PurchLine.Delete;
        BaseLine2.Reset();
        BaseLine2.SetRange("Document Type", PurchHeader."Document Type");
        BaseLine2.SetRange("Document No.", PurchHeader."No.");
        if BaseLine2.FindSet() then
            repeat
                if BaseLine2.Type <> BaseLine2.Type::" " then
                    TotalBaseAmount += BaseLine2.Amount;
            until BaseLine2.Next() = 0;

        PurchLine3.Reset();
        PurchLine3.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine3.SetRange("Document No.", PurchHeader."No.");
        if PurchLine3.FindLast() then
            LineNo := PurchLine3."Line No." + 10000
        else
            LineNo := PurchLine3."Line No.";

        PurchLine2.Reset();
        PurchLine2.setRange("Document Type", PurchHeader."Document Type");
        PurchLine2.setRange("Document No.", PurchHeader."No.");
        PurchLine2.setRange("No.", wthAccount);

        if PurchLine2.findset() then begin
            checkWHT := false;

            repeat
                if PurchLine2."Withholding Tax Group Code" <> '' then
                    checkWHT := true;

            //   WhtResult += PurchLine2."Withholding Tax %" * 0.01 * (PurchLine2.Quantity * PurchLine2."Direct Unit Cost");
            until PurchLine2.next() = 0;
            if not checkWHT then
                Error('Kindly select with-Holding tax group code');


        end;


        PurchLine3.Reset();
        PurchLine3.init();
        PurchLine3.validate("Document Type", rec."Document Type");
        PurchLine3.Validate("Document No.", rec."No.");
        PurchLine3."Line No." := LineNo;
        PurchLine3.validate(Type, NewLine.Type::"G/L Account");
        if wthTax.Get(PurchHeader."Withholding Tax Group Code") then
            PurchLine3."No." := wthTax."WHT Account";

        // PurchLine3.Validate("No.", wthAccount); // WHT G/L Account
        PurchLine3.Description := 'Withholding Tax for ' + Rec."No.";
        PurchLine3.Validate("WIthholdingTax %", PurchHeader."WIthholdingTax %");
        PurchLine3.Validate(Quantity, 1);
        PurchLine."Qty. to Invoice" := 1;
        PurchLine3."Qty. to Receive" := 1;
        PurchLine3.Validate("Direct Unit Cost", Round((TotalBaseAmount) * ((PurchLine3."WIthholdingTax %" / 100) * -1), 0.01));
        // PurchLine3.Validate("Direct Unit Cost", (WhtResult * -1));
        Message('With-Holding Tax created successfully.');

        PurchLine3.Validate("VAT Prod. Posting Group", 'NOVAT');
        PurchLine3.Insert(true);
    end;

}

