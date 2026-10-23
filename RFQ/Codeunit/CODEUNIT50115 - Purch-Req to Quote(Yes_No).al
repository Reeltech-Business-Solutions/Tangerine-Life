codeunit 50617 "Purch.-Req to Quote (Yes/No)"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    var
        ConfirmManagement: Codeunit "Confirm Management";
        IsHandled: Boolean;
    begin
        Rec.TestField("Document Type", Rec."Document Type"::Quote);
        if not ConfirmManagement.GetResponseOrDefault(ConvertReqToQuoteQst, true) then
            exit;

        IsHandled := false;
        OnBeforePurchQuoteToOrder(Rec, IsHandled);
        if IsHandled then
            exit;

        PurchaseReqToQuote.Run(Rec);
        PurchaseReqToQuote.GetPurchOrderHeader(PurchOrderHeader);

        if ConfirmManagement.GetResponseOrDefault(StrSubstNo(OpenNewQuoteQst, PurchOrderHeader."No."), true) then
            PAGE.Run(PAGE::"Purchase Quote", PurchOrderHeader);
        // if PurchOrderHeader."Purchase Type" = PurchOrderHeader."Purchase Type"::Local then
        //     PAGE.Run(PAGE::"Local Purch. Quote", PurchOrderHeader)
        // else
        //     PAGE.Run(PAGE::"Foreign Purchase Quote", PurchOrderHeader)
    end;

    var
        ConvertReqToQuoteQst: Label 'Do you want to convert the requisition to a quote?';
        PurchOrderHeader: Record "Purchase Header";
        PurchQuoteToOrder: Codeunit "Purch.-Quote to Order";
        PurchaseReqToQuote: Codeunit "Purch.-Requisition to-Quote";
        OpenNewQuoteQst: Label 'The request has been converted to Quote number %1. Do you want to open the new quote?', Comment = '%1 - No. of new purchase quote.';

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchQuoteToOrder(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
    end;
}

