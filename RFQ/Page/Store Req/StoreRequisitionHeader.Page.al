// page 50177 "Store Requisition Header"
// {
//     Caption = 'Store Requisition';
//     PageType = Document;
//     PromotedActionCategories = 'New,Process,Reports,Approvals,Cancellation,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
//     SourceTable = "Store Requistion Header";

//     layout
//     {
//         area(content)
//         {
//             group(General)
//             {
//                 Caption = 'General';
//                 field("No."; "No.")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field("Request date"; "Request date")
//                 {
//                     ApplicationArea = All;
//                     Editable = statuseditable;
//                 }
//                 field("Global Dimension 1 Code"; "Global Dimension 1 Code")
//                 {
//                     ApplicationArea = All;
//                     Editable = statuseditable;
//                 }
//                 field("Function Name"; "Function Name")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Description';
//                     Editable = false;
//                 }
//                 field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
//                 {
//                     ApplicationArea = All;
//                     Editable = statuseditable;
//                 }
//                 field("Budget Center Name"; "Budget Center Name")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Description';
//                     Editable = false;
//                 }
//                 field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
//                 {
//                     ApplicationArea = All;
//                     Editable = true;
//                 }
//                 field(Dim3; Dim3)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Description';
//                     Editable = false;
//                 }
//                 field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code")
//                 {
//                     ApplicationArea = All;
//                     //Editable = false;
//                 }
//                 field(Dim4; Dim4)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Description';
//                     Editable = false;
//                     //Visible = false;
//                 }
//                 field("Request Description"; "Request Description")
//                 {
//                     ApplicationArea = All;
//                     Editable = statuseditable;
//                 }
//                 field("Required Date"; "Required Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = statuseditable;
//                     Visible = false;
//                 }
//                 field("issued date"; "issued date")
//                 {
//                     ApplicationArea = All;
//                     Editable = statuseditable;
//                     trigger OnValidate()
//                     begin
//                         "Required Date" := "issued date";
//                     end;
//                 }
//                 field("Issuing Store"; "Issuing Store")
//                 {
//                     ApplicationArea = All;
//                     Editable = statuseditable;
//                 }
//                 field(Status; Status)
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field("Responsibility Center"; "Responsibility Center")
//                 {
//                     ApplicationArea = All;
//                     Editable = statuseditable;
//                 }
//                 field("Job No"; "Job No")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                 }
//             }
//             part("Store Requisition Line"; "Store Requisition Line")
//             {
//                 ApplicationArea = All;
//                 Editable = StatusEditable;
//                 SubPageLink = "Requistion No" = FIELD("No.");
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
//                     ApplicationArea = All;
//                     Caption = 'Post Store Requisition';
//                     Image = Post;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;

//                     trigger OnAction()
//                     var
//                         ItemLedger: Record 32;
//                     begin
//                         IF NOT LinesExists THEN
//                             ERROR('There are no Lines created for this Document');

//                         IF Status = Status::Cancelled THEN
//                             ERROR('The Document Has Already been Posted');


//                         //Added to allow system to stop negative stock takout
//                         ReqLine2.RESET;
//                         ReqLine2.SETRANGE(ReqLine2."Requistion No", "No.");
//                         TESTFIELD("Issuing Store");
//                         IF ReqLine2.FIND('-') THEN BEGIN
//                             REPEAT
//                                 ReqLine2.CALCFIELDS(ReqLine2."Qty in Iss. Str.");
//                                 IF ReqLine2."Qty in Iss. Str." < ReqLine2.Quantity THEN
//                                     ERROR('Item %1 is out of stock in store %2', ReqLine2.Description, ReqLine2."Issuing Store");
//                             UNTIL ReqLine2.NEXT = 0;
//                         END;
//                         //Added to allow system to stop negative stock takout   10/26/2020

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
//                                     //Removed to allow system to stop negative stock takout   10/26/2020
//                                     /*
//                                     ItemLedger.RESET;
//                                     ItemLedger.SETRANGE(ItemLedger."Item No.",ReqLine."No.");
//                                     ItemLedger.SETRANGE(ItemLedger."Location Code",ReqLine."Issuing Store");
//                                     ItemLedger.CALCSUMS(quantity);

//                                     //IF ItemLedger.Quantity<=0
//                                     //THEN ERROR('Item %1 is out of stock in store %2',ReqLine.Description,ReqLine."Issuing Store");

//                                     IF ItemLedger."Remaining Quantity" <= 0
//                                     THEN ERROR('Item %1 is out of stock in store %2',ReqLine.Description,ReqLine."Issuing Store");
//                                     */
//                                     //Removed to allow system to stop negative stock takout
//                                     Item.RESET;
//                                     Item.SETRANGE(Item."No.", ReqLine."No.");
//                                     Item.SETRANGE("Location Filter", ReqLine."Issuing Store");
//                                     Item.SETRANGE("Date Filter", 0D, GenJnline."Posting Date");
//                                     Item.FINDFIRST;
//                                     //Item.CALCFIELDS("Net Change");   aSK coRTEC
//                                     //IF Item."Net Change" < ReqLine.Quantity THEN

//                                     Item.CALCFIELDS(Item.Inventory);
//                                     // IF Item.Inventory < ReqLine.Quantity THEN
//                                     // ERROR('Item %1 is out of stock in store %2',ReqLine.Description,ReqLine."Issuing Store");

//                                     GenJnline.Validate(Quantity, ReqLine.Quantity);
//                                     GenJnline."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
//                                     GenJnline.VALIDATE("Shortcut Dimension 1 Code");
//                                     GenJnline."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
//                                     GenJnline.VALIDATE("Shortcut Dimension 2 Code");
//                                     GenJnline.ValidateShortcutDimCode(3, ReqLine."Shortcut Dimension 3 Code");
//                                     GenJnline.ValidateShortcutDimCode(4, ReqLine."Shortcut Dimension 4");
//                                     GenJnline.VALIDATE(Quantity);
//                                     GenJnline.VALIDATE("Unit Amount");
//                                     //GenJnline."Reason Code" := '221';
//                                     //GenJnline.VALIDATE("Reason Code");
//                                     GenJnline."Gen. Prod. Posting Group" := ReqLine."Gen. Prod. Posting Group";
//                                     GenJnline."Gen. Bus. Posting Group" := ReqLine."Gen. Bus. Posting Group";
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
//                                 //Post := FALSE;
//                                 //Post := JournlPosted.PostedSuccessfully();  Dennis
//                                 //IF Post THEN BEGIN
//                                 ReqLine.MODIFYALL(ReqLine."Request Status", ReqLine."Request Status"::Closed);
//                                 Status := Status::Posted;
//                                 MODIFY;
//                                 //END
//                             END;
//                         END

//                     end;
//                 }
//                 separator(d)
//                 {
//                 }
//                 action(Approvals)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Approvals';
//                     Image = Approvals;
//                     Promoted = true;
//                     PromotedCategory = Category4;

//                     trigger OnAction()
//                     var
//                         WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
//                         DocumentType: enum DocType;

//                     begin
//                         DocumentType := DocumentType::"Store Requistion";
//                         WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RecordId, DATABASE::"Store Requistion Header", DocumentType.AsInteger(), "No.");
//                     end;
//                 }
//                 action("Send A&pproval Request")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Send A&pproval Request';
//                     Image = SendApprovalRequest;
//                     Promoted = true;
//                     PromotedCategory = Category4;

//                     trigger OnAction()
//                     begin
//                         IF NOT LinesExists THEN
//                             ERROR('There are no Lines created for this Document');

//                         //Status:=Status::Released;
//                         //MODIFY;

//                         //Release the Imprest for Approval
//                         // if ApprovalMgt.CheckStoreReqApprovalsWorkflowEnable(rec) then
//                         //ApprovalMgt.OnSendStoreReqForApproval(Rec); Dennis
//                     end;
//                 }
//                 action("Cancel Approval Re&quest")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Cancel Approval Re&quest';
//                     Image = Reject;
//                     Promoted = true;
//                     PromotedCategory = Category4;

//                     trigger OnAction()
//                     begin
//                         //ApprovalMgt.OnCancelStoreReqForApproval(Rec);
//                     end;
//                 }
//                 separator(f)
//                 {
//                 }
//                 action("Print/Preview")
//                 {
//                     Caption = 'Print/Preview';
//                     Image = Print;
//                     Promoted = true;
//                     PromotedCategory = "Report";
//                     PromotedIsBig = true;
//                     ApplicationArea = All;

//                     trigger OnAction()
//                     begin
//                         RESET;
//                         SETFILTER("No.", "No.");
//                         REPORT.RUN(51534351, TRUE, TRUE, Rec);
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
//         // VALIDATE("Shortcut Dimension 4 Code");  Dennis

//         UpdateControls;
//         "Request date" := WorkDate();
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
//         UpdateControls
//     end;

//     trigger OnModifyRecord(): Boolean
//     begin
//         UpdateControls;
//         CurrPage.Update();
//     end;


//     var
//         //UserMgt: Codeunit 39005487;
//         ApprovalMgt: Codeunit "Approval Mgmt. ExtCal";
//         ReqLine: Record "Store Requistion Line";
//         ReqLine2: Record "Store Requistion Line";
//         InventorySetup: Record 313;
//         GenJnline: Record 83;
//         LineNo: Integer;
//         Post: Boolean;
//         //JournlPosted: Codeunit 39005486;
//         DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
//         HasLines: Boolean;
//         AllKeyFieldsEntered: Boolean;
//         ApprovalEntries: Page 658;
//         StatusEditable: Boolean;
//         Item: Record Item;


//     [Scope('Cloud')]
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

//     [Scope('Cloud')]
//     procedure UpdateControls()
//     begin
//         IF Status = Status::Open THEN
//             StatusEditable := TRUE
//         ELSE
//             StatusEditable := false;
//     end;

//     [Scope('Cloud')]
//     procedure CurrPageUpdate()
//     begin
//         xRec := Rec;
//         UpdateControls;
//         CurrPage.UPDATE;
//     end;
// }

