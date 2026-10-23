// page 50164 "Posted Store Requisition"
// {
//     Editable = false;
//     PageType = Document;
//     PromotedActionCategories = 'New,Process,Reports,Approvals,Cancellation,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
//     SourceTable = "Store Requistion Header";
//     SourceTableView = WHERE(Status = CONST(Posted));

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field("No."; "No.")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Request date"; "Request date")
//                 {
//                     Editable = statuseditable;
//                     ApplicationArea = all;
//                 }
//                 field("Global Dimension 1 Code"; "Global Dimension 1 Code")
//                 {
//                     Editable = statuseditable;
//                     ApplicationArea = all;
//                 }
//                 field("Function Name"; "Function Name")
//                 {
//                     Caption = 'Description';
//                     Editable = false;
//                     ApplicationArea = all;
//                 }
//                 field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
//                 {
//                     Editable = statuseditable;
//                     ApplicationArea = all;
//                 }
//                 field("Budget Center Name"; "Budget Center Name")
//                 {
//                     Caption = 'Description';
//                     Editable = false;
//                     ApplicationArea = all;
//                 }
//                 field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
//                 {
//                     Editable = false;
//                     ApplicationArea = all;
//                 }
//                 field(Dim3; Dim3)
//                 {
//                     Caption = 'Description';
//                     Editable = false;
//                     ApplicationArea = all;
//                 }
//                 field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code")
//                 {
//                     Editable = false;
//                     ApplicationArea = all;
//                 }
//                 field(Dim4; Dim4)
//                 {
//                     Caption = 'Description';
//                     Editable = false;
//                     ApplicationArea = all;
//                 }
//                 field("Request Description"; "Request Description")
//                 {
//                     Editable = statuseditable;
//                     ApplicationArea = all;
//                 }
//                 field("Required Date"; "Required Date")
//                 {
//                     Editable = statuseditable;
//                     ApplicationArea = all;
//                 }
//                 field("Issuing Store"; "Issuing Store")
//                 {
//                     Editable = statuseditable;
//                     ApplicationArea = all;
//                 }
//                 field(Status; Status)
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Responsibility Center"; "Responsibility Center")
//                 {
//                     Editable = statuseditable;
//                     ApplicationArea = all;
//                 }
//             }
//             part("Store Requisition Line"; "Store Requisition Line")
//             {
//                 Editable = true;
//                 SubPageLink = "Requistion No" = FIELD("No.");
//                 ApplicationArea = all;
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
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             group("&Functions")
//             {
//                 Caption = '&Functions';
//                 action("Post Store Requisition")
//                 {
//                     Caption = 'Post Store Requisition';
//                     Image = Post;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ApplicationArea = all;

//                     trigger OnAction()
//                     begin
//                         IF NOT LinesExists THEN
//                             ERROR('There are no Lines created for this Document');

//                         IF Status = Status::Posted THEN
//                             ERROR('The Document Has Already been Posted');

//                         IF Status <> Status::Released THEN
//                             ERROR('The Document Has not yet been Approved');
//                         IF InventorySetup.GET THEN BEGIN
//                             InventorySetup.TESTFIELD(InventorySetup."Item Jnl Template");
//                             InventorySetup.TESTFIELD(InventorySetup."Item Jnl Batch");
//                             GenJnline.RESET;
//                             GenJnline.SETRANGE(GenJnline."Journal Template Name", InventorySetup."Item Jnl Template");
//                             GenJnline.SETRANGE(GenJnline."Journal Batch Name", InventorySetup."Item Jnl Batch");
//                             IF GenJnline.FIND('-') THEN GenJnline.DELETEALL;

//                             TESTFIELD("Issuing Store");
//                             ReqLine.RESET;
//                             ReqLine.SETRANGE(ReqLine."Requistion No", "No.");
//                             TESTFIELD("Issuing Store");
//                             IF ReqLine.FIND('-') THEN BEGIN
//                                 REPEAT
//                                     //Issue
//                                     LineNo := LineNo + 1000;
//                                     GenJnline.INIT;
//                                     GenJnline."Journal Template Name" := InventorySetup."Item Jnl Template";
//                                     GenJnline."Journal Batch Name" := InventorySetup."Item Jnl Batch";
//                                     GenJnline."Line No." := LineNo;
//                                     GenJnline."Entry Type" := GenJnline."Entry Type"::"Negative Adjmt.";
//                                     GenJnline."Document No." := "No.";
//                                     GenJnline."Item No." := ReqLine."No.";
//                                     GenJnline.VALIDATE("Item No.");
//                                     GenJnline."Location Code" := ReqLine."Issuing Store";
//                                     GenJnline."Bin Code" := ReqLine."Bin Code";
//                                     GenJnline.VALIDATE("Location Code");
//                                     GenJnline."Posting Date" := "Request date";
//                                     GenJnline.Description := ReqLine.Description;
//                                     GenJnline.Quantity := ReqLine.Quantity;
//                                     GenJnline."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
//                                     GenJnline.VALIDATE("Shortcut Dimension 1 Code");
//                                     GenJnline."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//                                     GenJnline.VALIDATE("Shortcut Dimension 2 Code");
//                                     GenJnline.ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
//                                     GenJnline.ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
//                                     GenJnline.VALIDATE(Quantity);
//                                     GenJnline.VALIDATE("Unit Amount");
//                                     GenJnline."Reason Code" := '221';
//                                     GenJnline.VALIDATE("Reason Code");
//                                     GenJnline.INSERT(TRUE);

//                                     ReqLine."Request Status" := ReqLine."Request Status"::Closed;

//                                 UNTIL ReqLine.NEXT = 0;
//                                 //Post Entries
//                                 GenJnline.RESET;
//                                 GenJnline.SETRANGE(GenJnline."Journal Template Name", InventorySetup."Item Jnl Template");
//                                 GenJnline.SETRANGE(GenJnline."Journal Batch Name", InventorySetup."Item Jnl Batch");
//                                 CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", GenJnline);
//                                 //End Post entries

//                                 //Modify All
//                                 // Post := FALSE;
//                                 // Post := JournlPosted.PostedSuccessfully();
//                                 // IF Post THEN BEGIN
//                                 //     ReqLine.MODIFYALL(ReqLine."Request Status", ReqLine."Request Status"::Closed);
//                                 //     Status := Status::Posted;
//                                 //     MODIFY;
//                                 // END
//                             END;
//                         END
//                     end;
//                 }
//                 separator(s)
//                 {
//                 }
//                 action(Approvals)
//                 {
//                     Caption = 'Approvals';
//                     Image = Approvals;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     ApplicationArea = all;

//                     trigger OnAction()
//                     begin
//                         DocumentType := DocumentType::Requisition;
//                         ApprovalEntries.Setfilters(DATABASE::"Store Requistion Header", DocumentType, "No.");
//                         ApprovalEntries.RUN;
//                     end;
//                 }
//                 action("Send A&pproval Request")
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
//                         //If ApprovalMgt.CheckStoreReqApprovalsWorkflowEnable(rec) then
//                         //  ApprovalMgt.OnSendStoreReqForApproval(Rec);  Dennis
//                     end;
//                 }
//                 action("Cancel Approval Re&quest")
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
//                 action("Print/Preview")
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
//                         REPORT.RUN(39005887, TRUE, TRUE, Rec);
//                         RESET;
//                     end;
//                 }
//             }

//         }

//     }

//     trigger OnAfterGetRecord()
//     begin
//         CurrPageUpdate;
//     end;

//     trigger OnNewRecord(BelowxRec: Boolean)
//     begin
//         // "Responsibility Center" := UserMgt.GetPurchasesFilter();
//         // //Add dimensions if set by default here
//         // "Global Dimension 1 Code" := UserMgt.GetSetDimensions(USERID, 1);
//         // VALIDATE("Global Dimension 1 Code");
//         // "Shortcut Dimension 2 Code" := UserMgt.GetSetDimensions(USERID, 2);
//         // VALIDATE("Shortcut Dimension 2 Code");
//         // "Shortcut Dimension 3 Code" := UserMgt.GetSetDimensions(USERID, 3);
//         // VALIDATE("Shortcut Dimension 3 Code");
//         // "Shortcut Dimension 4 Code" := UserMgt.GetSetDimensions(USERID, 4);
//         // VALIDATE("Shortcut Dimension 4 Code");

//         UpdateControls;
//     end;

//     trigger OnNextRecord(Steps: Integer): Integer
//     begin
//         UpdateControls;
//     end;

//     trigger OnOpenPage()
//     begin
//         /*
//         IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
//           FILTERGROUP(2);
//           SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
//           FILTERGROUP(0);
//         END;
//         */

//     end;

//     var
//         //UserMgt: Codeunit 39005487;
//         ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
//         ReqLine: Record "Store Requistion Line";
//         InventorySetup: Record 313;
//         GenJnline: Record 83;
//         LineNo: Integer;
//         Post: Boolean;
//         //JournlPosted: Codeunit "39005486";
//         DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
//         HasLines: Boolean;
//         AllKeyFieldsEntered: Boolean;
//         ApprovalEntries: Page 658;
//         StatusEditable: Boolean;

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

//     [Scope('Internal')]
//     procedure UpdateControls()
//     begin
//         IF Status = Status::Open THEN
//             StatusEditable := TRUE
//         ELSE
//             StatusEditable := FALSE;
//     end;

//     [Scope('Internal')]
//     procedure CurrPageUpdate()
//     begin
//         xRec := Rec;
//         UpdateControls;
//         CurrPage.UPDATE;
//     end;
// }

