// page 50166 "Posted Store Requisitions List"
// {
//     CardPageID = "Posted Store Requisition";
//     PageType = List;
//     PromotedActionCategories = 'New,Process,Reports,Approvals,Cancellation,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
//     SourceTable = "Store Requistion Header";
//     SourceTableView = WHERE(Status = CONST(Posted));

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("No."; "No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Request date"; "Request date")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Request Description"; "Request Description")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Requester ID"; "Requester ID")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field(Status; Status)
//                 {
//                     ApplicationArea = all;
//                 }
//                 field(TotalAmount; TotalAmount)
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Issuing Store"; "Issuing Store")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Responsibility Center"; "Responsibility Center")
//                 {
//                     ApplicationArea = all;
//                 }
//             }
//         }
//         area(factboxes)
//         {

//             part("Attached Documents"; "Document Attachment Factbox")
//             {
//                 ApplicationArea = All;
//                 Caption = 'Attachments';
//                 SubPageLink = "Table ID" = CONST(51534358), "No." = FIELD("No.");

//             }
//             systempart(Notes; Notes)
//             {
//                 ApplicationArea = all;
//             }
//             systempart(MyNotes; MyNotes)
//             {
//                 ApplicationArea = all;
//             }
//             systempart(Links; Links)
//             {
//                 ApplicationArea = all;
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             group("<Action1102755026>")
//             {
//                 Caption = '&Functions';
//                 action("<Action1102755028>")
//                 {
//                     Caption = 'Post Store Requisition';
//                     Image = Post;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ApplicationArea = all;

//                     trigger OnAction()
//                     begin
//                         // IF NOT LinesExists THEN
//                         //     ERROR('There are no Lines created for this Document');

//                         // IF Status = Status::Posted THEN
//                         //     ERROR('The Document Has Already been Posted');

//                         // IF Status <> Status::Released THEN
//                         //     ERROR('The Document Has not yet been Approved');


//                         // TESTFIELD("Issuing Store");
//                         // ReqLine.RESET;
//                         // ReqLine.SETRANGE(ReqLine."Requistion No", "No.");
//                         // TESTFIELD("Issuing Store");
//                         // IF ReqLine.FIND('-') THEN BEGIN
//                         //     REPEAT
//                         //         //Issue
//                         //         IF InventorySetup.GET THEN BEGIN
//                         //             InventorySetup.TESTFIELD(InventorySetup."Item Jnl Template");
//                         //             InventorySetup.TESTFIELD(InventorySetup."Item Jnl Batch");
//                         //             GenJnline.RESET;
//                         //             GenJnline.SETRANGE(GenJnline."Journal Template Name", InventorySetup."Item Jnl Template");
//                         //             GenJnline.SETRANGE(GenJnline."Journal Batch Name", InventorySetup."Item Jnl Batch");
//                         //             IF GenJnline.FIND('-') THEN GenJnline.DELETEALL;
//                         //             LineNo := LineNo + 1000;
//                         //             GenJnline.INIT;
//                         //             GenJnline."Journal Template Name" := InventorySetup."Item Jnl Template";
//                         //             GenJnline."Journal Batch Name" := InventorySetup."Item Jnl Batch";
//                         //             GenJnline."Line No." := LineNo;
//                         //             GenJnline."Entry Type" := GenJnline."Entry Type"::"Negative Adjmt.";
//                         //             GenJnline."Document No." := "No.";
//                         //             GenJnline."Item No." := ReqLine."No.";
//                         //             GenJnline.VALIDATE("Item No.");
//                         //             GenJnline."Location Code" := "Issuing Store";
//                         //             GenJnline.VALIDATE("Location Code");
//                         //             GenJnline."Posting Date" := "Request date";
//                         //             GenJnline.Description := ReqLine.Description;
//                         //             GenJnline.Quantity := ReqLine.Quantity;
//                         //             GenJnline."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
//                         //             GenJnline.VALIDATE("Shortcut Dimension 1 Code");
//                         //             GenJnline."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//                         //             GenJnline.VALIDATE("Shortcut Dimension 2 Code");
//                         //             GenJnline.ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
//                         //             GenJnline.ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
//                         //             GenJnline.VALIDATE(Quantity);
//                         //             GenJnline.VALIDATE("Unit Amount");
//                         //             GenJnline."Reason Code" := '221';
//                         //             GenJnline.VALIDATE("Reason Code");
//                         //             GenJnline.INSERT(TRUE);

//                         //             ReqLine."Request Status" := ReqLine."Request Status"::Closed;

//                         //         END;
//                         //     UNTIL ReqLine.NEXT = 0;
//                         //     //Post Entries
//                         //     GenJnline.RESET;
//                         //     GenJnline.SETRANGE(GenJnline."Journal Template Name", InventorySetup."Item Jnl Template");
//                         //     GenJnline.SETRANGE(GenJnline."Journal Batch Name", InventorySetup."Item Jnl Batch");
//                         //     CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", GenJnline);
//                         //     //End Post entries

//                         //Modify All
//                         // Post := FALSE;
//                         // Post := JournlPosted.PostedSuccessfully();
//                         // IF Post THEN
//                         ReqLine.MODIFYALL(ReqLine."Request Status", ReqLine."Request Status"::Closed);
//                         Status := Status::Posted;
//                         //END;
//                     end;
//                 }
//                 separator(a)
//                 {
//                 }
//                 action("<Action1102755032>")
//                 {
//                     Caption = 'Approvals';
//                     Image = Approvals;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     ApplicationArea = all;

//                     trigger OnAction()
//                     var
//                         ApprovalEntries: Page 658;
//                     begin
//                         DocumentType := DocumentType::Requisition;
//                         ApprovalEntries.Setfilters(DATABASE::"Store Requistion Header", DocumentType, "No.");
//                         ApprovalEntries.RUN;
//                     end;
//                 }
//                 action("<Action1102755030>")
//                 {
//                     Caption = 'Send A&pproval Request';
//                     Image = SendApprovalRequest;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     ApplicationArea = all;

//                     trigger OnAction()
//                     begin
//                         IF NOT LinesExists THEN
//                             ERROR('There are no Lines created for this Document');

//                         //Release the Imprest for Approval
//                         // IF ApprovalMgt.SendSRequestApprovalRequest(Rec) THEN;
//                     end;
//                 }
//                 action("<Action1102755031>")
//                 {
//                     Caption = 'Cancel Approval Re&quest';
//                     Image = Reject;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     ApplicationArea = all;

//                     trigger OnAction()
//                     begin
//                         //ApprovalMgt.OnCancelStoreReqForApproval(Rec); Dennis
//                     end;
//                 }
//                 separator(d)
//                 {
//                 }
//                 action("<Action1102755036>")
//                 {
//                     Caption = 'Print/Preview';
//                     Image = Print;
//                     Promoted = true;
//                     PromotedCategory = "Report";
//                     PromotedIsBig = true;
//                     ApplicationArea = all;

//                     trigger OnAction()
//                     begin
//                         RESET;
//                         SETFILTER("No.", "No.");
//                         //REPORT.RUN(50528, TRUE, TRUE, Rec);
//                         RESET;
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnOpenPage()
//     begin
//         /*
//         IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
//           FILTERGROUP(2);
//           SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
//           FILTERGROUP(0);
//         END;
//         */
//         // IF UserMgt.GetSetDimensions(USERID, 2) <> '' THEN BEGIN
//         //     FILTERGROUP(2);
//         //     SETRANGE("Shortcut Dimension 2 Code", UserMgt.GetSetDimensions(USERID, 2));
//         //     FILTERGROUP(0);
//         // END;

//     end;

//     var
//         //UserMgt: Codeunit 39005487;
//         ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
//         ReqLine: Record "Store Requistion Line";
//         InventorySetup: Record 313;
//         GenJnline: Record 83;
//         LineNo: Integer;
//         Post: Boolean;
//         DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
//         HasLines: Boolean;
//         AllKeyFieldsEntered: Boolean;

//     [Scope('Internal')]
//     procedure LinesExists(): Boolean
//     var
//         PayLines: Record "Store Requistion Line";
//     begin
//         HasLines := FALSE;
//         PayLines.RESET;
//         PayLines.SETRANGE(PayLines."Requistion No", "No.");
//         IF PayLines.FIND('-') THEN BEGIN
//             HasLines := TRUE;
//             EXIT(HasLines);
//         END;
//     end;
// }

