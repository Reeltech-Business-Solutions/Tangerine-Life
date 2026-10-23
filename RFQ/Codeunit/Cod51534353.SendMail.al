// codeunit 51534354 SendMail
// {
//  procedure PrintPurchQuoteHeader(PurchQuoteHeader: Record "Purchase Quote Header")
//     var
//         ReportSelections: Record "Report Selections";
//         ReportUsage: Enum "Report Selection Usage";
//         IsPrinted: Boolean;
//     begin
//         ReportUsage := GetPurchDocTypeUsage(PurchQuoteHeader);

//         PurchQuoteHeader.SetRange("Document Type", PurchQuoteHeader."Document Type");
//         PurchQuoteHeader.SetRange("No.", PurchQuoteHeader."No.");
//         CalcPurchDisc(PurchQuoteHeader);
//         OnBeforeDoPrintPurchQuoteHeader(PurchQuoteHeader, ReportUsage.AsInteger(), IsPrinted);
//         if IsPrinted then
//             exit;

//         ReportSelections.PrintWithDialogForVend(ReportUsage, PurchQuoteHeader, true, PurchQuoteHeader.FieldNo("Buy-from Vendor No."));
//     end;

//     procedure PrintPurchQuoteHeaderToDocumentAttachment(var PurchQuoteHeader: Record "Purchase Quote Header");
//     var
//         ShowNotificationAction: Boolean;
//     begin
//         ShowNotificationAction := PurchQuoteHeader.Count() = 1;
//         if PurchQuoteHeader.FindSet() then
//             repeat
//                 DoPrintPurchQuoteHeaderToDocumentAttachment(PurchQuoteHeader, ShowNotificationAction);
//             until PurchQuoteHeader.Next() = 0;
//     end;

//     local procedure DoPrintPurchQuoteHeaderToDocumentAttachment(PurchQuoteHeader: Record "Purchase Quote Header"; ShowNotificationAction: Boolean)
//     var
//         ReportSelections: Record "Report Selections";
//         ReportUsage: Enum "Report Selection Usage";
//     begin
//         ReportUsage := GetPurchDocTypeUsage(PurchQuoteHeader);

//         PurchQuoteHeader.SetRecFilter();
//         CalcPurchDisc(PurchQuoteHeader);
//         ReportSelections.SaveAsDocumentAttachment(ReportUsage.AsInteger(), PurchQuoteHeader, PurchQuoteHeader."No.", PurchQuoteHeader."Pay-to Vendor No.", ShowNotificationAction);
//     end;

// }
