// page 50178 "Store Requisition Line"
// {
//     PageType = ListPart;
//     SourceTable = "Store Requistion Line";

//     layout
//     {
//         area(content)
//         {
//             repeater(j)
//             {

//                 field(Type; Type)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("No."; "No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Description; Description)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Unit of Measure"; "Unit of Measure")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Qty in store"; "Qty in store")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Qty in store(Dynamic)';
//                 }
//                 field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Quantity Requested"; "Quantity Requested")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Unit Cost"; "Unit Cost")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Line Amount"; "Line Amount")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Quantity; Quantity)
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field("Issuing Store"; "Issuing Store")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Qty in Iss. Str."; "Qty in Iss. Str.")
//                 {
//                     ApplicationArea = All;
//                     Style = StrongAccent;
//                     StyleExpr = true;
//                 }
//                 field("Bin Code"; "Bin Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
//                 {
//                     ApplicationArea = All;
//                     TableRelation = "Gen. Business Posting Group";
//                 }
//                 field("Shortcut Dimension 4"; "Shortcut Dimension 4")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code")
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions
//     {
//     }

//     var
//         QtyStore: Record item;
// }

