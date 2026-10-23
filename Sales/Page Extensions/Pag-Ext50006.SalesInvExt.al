pageextension 50607 "SalesInv.Ext" extends "Sales Invoice"
{
    layout
    {
        addafter(Status)
        {
            field("Admin Fee %"; Rec."Admin Fee %")
            {
                Caption = 'Admin Fee %';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Function_CustomerCard)
        {
            action("CalculateAdmin-Fee")
            {
                Caption = 'Calcuate Admin Fee';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = CalculateCost;

                trigger OnAction()
                begin
                    CalculateAdminFee();
                end;
            }
        }
    }

    procedure getAdminFee(): decimal;
    var
        salesSetup: Record "Sales & Receivables Setup";

    begin
        if salesSetup.Get() then
            exit(salesSetup."Admin Fee %");

    end;

    procedure GetGLAcct(): Code[20];
    var
        salesSetup: Record "Sales & Receivables Setup";
    begin
        if salesSetup.Get() then
            exit(salesSetup."Adm Fee GL Account");
    end;

    procedure CalculateAdminFee()
    var
        AdmFeeAcct: Code[20];
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesInv: Record "Sales Header";
        SalesLine2: Record "Sales Line";
        LineNo: Integer;
        SalesLine3: Record "Sales Line";
        TotalAmount: decimal;
    begin
        AdmFeeAcct := GetGLAcct();

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
        SalesLine.SetRange("No.", AdmFeeAcct);
        IF SalesLine.FindFirst() then
            SalesLine.DeleteAll();

        SalesLine3.Reset();
        SalesLine3.SetRange("Document Type", rec."Document Type");
        SalesLine3.SetRange("Document No.", rec."No.");

        if SalesLine3.findset() then begin
            SalesLine3.CalcSums("Line Amount");
            TotalAmount := SalesLine3."Line Amount";
        end;

        SalesLine2.Reset();
        SalesLine2.SetRange("Document Type", rec."Document Type");
        SalesLine2.SetRange("Document No.", rec."No.");
        if SalesLine2.FindLast() then
            LineNo := SalesLine2."Line No." + 10000
        else
            LineNo := SalesLine2."Line No.";

        SalesLine2.Reset();
        SalesLine2.Init();
        SalesLine2.Validate("Document Type", Rec."Document Type");
        SalesLine2.Validate("Document No.", Rec."No.");
        SalesLine2."Line No." := LineNo;
        SalesLine2.Validate(Type, SalesLine.Type::"G/L Account");
        SalesLine2.Validate("No.", AdmFeeAcct);
        SalesLine2.Description := 'Admin Fee for ' + Rec."No.";
        SalesLine2.Validate(Quantity, 1);
        SalesLine2.Validate("Unit Price", ((TotalAmount * Rec."Admin Fee %" / 100) * 1));
        SalesLine2.Validate("VAT Prod. Posting Group", 'VAT25');
        SalesLine2.Insert(true);
        CurrPage.Update(false);
        Message('Admin fee has been created');

    end;
}
