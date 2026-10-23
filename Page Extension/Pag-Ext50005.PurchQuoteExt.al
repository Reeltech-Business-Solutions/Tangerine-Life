pageextension 50600 PurchQuoteExt extends "Purchase Quotes"
{
    trigger OnOpenPage()
    begin
        Rec.SetRange("Purchase Type", 0);
    end;
}
