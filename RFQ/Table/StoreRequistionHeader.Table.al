// table 50036 "Store Requistion Header"
// {
//     DrillDownPageID = "Store Requisition List";
//     LookupPageID = "Store Requisition List";

//     fields
//     {
//         field(1; "No."; Code[20])
//         {
//             NotBlank = false;

//             trigger OnValidate()
//             begin
//                 //IF "No." = '' THEN BEGIN
//                 IF "No." <> xRec."No." THEN BEGIN
//                     GenLedgerSetup.GET();
//                     NoSeriesMgt.TestManual(GenLedgerSetup."Stores Requisition No");
//                     "No." := '';
//                 END;
//                 //END;
//             end;
//         }
//         field(2; "Request date"; Date)
//         {
//         }
//         field(5; "Required Date"; Date)
//         {

//         }
//         field(6; "Requester ID"; Code[50])
//         {
//             Caption = 'Requester ID';
//             Editable = false;
//             //This property is currently not supported
//             //TestTableRelation = false;
//             //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
//             //ValidateTableRelation = false;

//             trigger OnLookup()
//             var
//                 LoginMgt: Codeunit 418;
//             begin
//             end;

//             trigger OnValidate()
//             var
//                 LoginMgt: Codeunit 418;
//             begin
//             end;
//         }
//         field(7; "Request Description"; Text[150])
//         {
//         }
//         field(9; "No. Series"; Code[20])
//         {
//             Caption = 'No. Series';
//             Editable = false;
//             TableRelation = "No. Series";
//         }
//         field(10; Status; Option)
//         {
//             Editable = true;
//             OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Cancelled,Posted;
//         }
//         field(11; Supplier; Code[20])
//         {
//             TableRelation = Vendor;
//         }
//         field(12; "Action Type"; Option)
//         {
//             OptionMembers = " ","Ask for Tender","Ask for Quote";

//             trigger OnValidate()
//             begin
//                 /*
//                 IF Type=Type::"G/L Account" THEN BEGIN
//                    IF "Action Type"="Action Type"::Issue THEN
//                             ERROR('You cannot Issue a G/L Account please order for it')
//                 END;


//                //Compare Quantity in Store and Qty to Issue
//                 IF Type=Type::Item THEN BEGIN
//                    IF "Action Type"="Action Type"::Issue THEN BEGIN
//                     IF Quantity>"Qty in store" THEN
//                       ERROR('You cannot Issue More than what is available in store')
//                    END;
//                 END;
//                 */

//             end;
//         }
//         field(29; Justification; Text[250])
//         {
//         }
//         field(30; "User ID"; Code[50])
//         {
//         }
//         field(31; "Global Dimension 1 Code"; Code[20])
//         {
//             CaptionClass = '1,1,1';
//             Caption = 'Global Dimension 1 Code';
//             Description = 'Stores the reference to the first global dimension in the database';
//             NotBlank = false;
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

//             trigger OnValidate()
//             begin
//                 Dimval.RESET;
//                 Dimval.SETRANGE(Dimval."Global Dimension No.", 1);
//                 Dimval.SETRANGE(Dimval.Code, "Global Dimension 1 Code");
//                 IF Dimval.FIND('-') THEN
//                     "Function Name" := Dimval.Name
//             end;
//         }
//         field(56; "Shortcut Dimension 2 Code"; Code[20])
//         {
//             CaptionClass = '1,2,2';
//             Caption = 'Shortcut Dimension 2 Code';
//             Description = 'Stores the reference of the second global dimension in the database';
//             NotBlank = false;
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

//             trigger OnValidate()
//             begin
//                 Dimval.RESET;
//                 Dimval.SETRANGE(Dimval."Global Dimension No.", 2);
//                 Dimval.SETRANGE(Dimval.Code, "Shortcut Dimension 2 Code");
//                 IF Dimval.FIND('-') THEN
//                     "Budget Center Name" := Dimval.Name
//             end;
//         }
//         field(57; "Function Name"; Text[100])
//         {
//             Description = 'Stores the name of the function in the database';
//         }
//         field(58; "Budget Center Name"; Text[100])
//         {
//             Description = 'Stores the name of the budget center in the database';
//         }
//         field(81; "Shortcut Dimension 3 Code"; Code[20])
//         {
//             CaptionClass = '1,2,3';
//             Caption = 'Shortcut Dimension 3 Code';
//             Description = 'Stores the reference of the Third global dimension in the database';
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

//             trigger OnValidate()
//             begin
//                 Dimval.RESET;
//                 //Dimval.SETRANGE(Dimval."Global Dimension No.",3);
//                 Dimval.SETRANGE(Dimval.Code, "Shortcut Dimension 3 Code");
//                 IF Dimval.FIND('-') THEN
//                     Dim3 := Dimval.Name
//             end;
//         }
//         field(82; "Shortcut Dimension 4 Code"; Code[20])
//         {
//             CaptionClass = '1,2,4';
//             Caption = 'Shortcut Dimension 4 Code';
//             Description = 'Stores the reference of the Third global dimension in the database';
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

//             trigger OnValidate()
//             begin
//                 Dimval.RESET;
//                 //Dimval.SETRANGE(Dimval."Global Dimension No.",4);
//                 Dimval.SETRANGE(Dimval.Code, "Shortcut Dimension 4 Code");
//                 IF Dimval.FIND('-') THEN
//                     Dim4 := Dimval.Name
//             end;
//         }
//         field(83; Dim3; Text[250])
//         {
//         }
//         field(84; Dim4; Text[250])
//         {
//         }
//         field(85; "Responsibility Center"; Code[20])
//         {
//             Caption = 'Responsibility Center';
//             TableRelation = "Responsibility Center";

//             trigger OnValidate()
//             begin

//                 //TESTFIELD(Status, Status::Open);
//                 // IF NOT UserMgt.CheckRespCenter(1, "Responsibility Center") THEN
//                 // ERROR(
//                 // Text001,
//                 //RespCenter.TABLECAPTION, UserMgt.GetPurchasesFilter);
//                 /*
//                "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
//                IF "Location Code" = '' THEN BEGIN
//                  IF InvtSetup.GET THEN
//                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
//                END ELSE BEGIN
//                  IF Location.GET("Location Code") THEN;
//                  "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
//                END;

//                UpdateShipToAddress;
//                   */
//                 /*
//              CreateDim(
//                DATABASE::"Responsibility Center","Responsibility Center",
//                DATABASE::Vendor,"Pay-to Vendor No.",
//                DATABASE::"Salesperson/Purchaser","Purchaser Code",
//                DATABASE::Campaign,"Campaign No.");

//              IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
//                RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
//                "Assigned User ID" := '';
//              END;
//                */

//             end;
//         }
//         field(86; TotalAmount; Decimal)
//         {
//             CalcFormula = Sum("Store Requistion Line"."Line Amount" WHERE("Requistion No" = FIELD("No.")));
//             FieldClass = FlowField;
//         }
//         field(87; "Issuing Store"; Code[20])
//         {
//             TableRelation = Location;

//             trigger OnValidate()
//             begin
//                 ReqLines.RESET;
//                 ReqLines.SETRANGE(ReqLines."Requistion No", "No.");
//                 IF ReqLines.FINDSET THEN
//                     REPEAT
//                         ReqLines."Issuing Store" := "Issuing Store";
//                         ReqLines.MODIFY;
//                     UNTIL ReqLines.NEXT = 0;
//             end;
//         }
//         field(88; "Job No"; Code[20])
//         {
//             //TableRelation = Table39006086;
//         }
//         field(89; "Document Type"; Option)
//         {
//             OptionMembers = Issue,Receipt;
//         }
//         field(50001; "Shortcut Dimension 4"; Code[20])
//         {
//         }
//         field(90; "issued date"; Date)
//         {
//             Caption = 'Issued Date';

//         }
//     }

//     keys
//     {
//         key(Key1; "No.")
//         {
//             Clustered = true;
//         }
//     }

//     fieldgroups
//     {
//     }

//     trigger OnDelete()
//     begin
//         IF Status <> Status::Open THEN
//             ERROR('You Cannot DELETE an already released Requisition')
//     end;

//     trigger OnInsert()
//     begin

//         IF "No." = '' THEN BEGIN
//             NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", 0D, "No.", "No. Series");
//         END;
//         //EXIT(GetNoSeriesRelCode(NoSeriesCode));

//         IF Status <> Status::Open THEN
//             ERROR('You Cannot Enter Entries if status is not Pending');
//     end;

//     trigger OnModify()
//     begin
//         //  IF Status=Status::Released THEN
//         //     ERROR('You Cannot modify an already Approved Requisition');



//         //  IF Status<>Status::Open THEN
//         //      ERROR('You Cannot Enter Entries if status is not Pending');

//         ReqLines.RESET;
//         ReqLines.SETRANGE(ReqLines."Requistion No", "No.");
//         IF ReqLines.FIND('-') THEN BEGIN
//             REPEAT
//                 ReqLines."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
//                 ReqLines."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
//                 ReqLines."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
//                 ReqLines."Shortcut Dimension 4 Code" := "Shortcut Dimension 4 Code";
//             UNTIL ReqLines.NEXT = 0;
//         END;
//     end;

//     var
//         NoSeriesMgt: Codeunit 396;
//         GenLedgerSetup: Record "General Ledger Setup";
//         // UserDept: Record 39005902;
//         RespCenter: Record "Responsibility Center";
//         UserMgt: Codeunit "User Management";
//         Text001: Label 'Your identification is set up to process from %1 %2 only.';
//         Dimval: Record 349;
//         ReqLines: Record "Store Requistion Line";

//     [Scope('Cloud')]
//     procedure GetNoSeriesRelCode(NoSeriesCode: Code[20]): Code[20]
//     var
//         GenLedgerSetup: Record 98;
//         RespCenter: Record "Responsibility Center";
//         DimMgt: Codeunit 408;
//         NoSrsRel: Record 310;
//     begin
//         //EXIT(GetNoSeriesRelCode(NoSeriesCode));
//         GenLedgerSetup.GET;
//         CASE GenLedgerSetup."Base No. Series" OF
//             GenLedgerSetup."Base No. Series"::"Responsibility Center":
//                 BEGIN
//                     NoSrsRel.RESET;
//                     NoSrsRel.SETRANGE(Code, NoSeriesCode);
//                     NoSrsRel.SETRANGE("Series Filter", "Responsibility Center");
//                     IF NoSrsRel.FINDFIRST THEN
//                         EXIT(NoSrsRel."Series Code")
//                 END;
//             GenLedgerSetup."Base No. Series"::"Shortcut Dimension 1":
//                 BEGIN
//                     NoSrsRel.RESET;
//                     NoSrsRel.SETRANGE(Code, NoSeriesCode);
//                     NoSrsRel.SETRANGE("Series Filter", "Global Dimension 1 Code");
//                     IF NoSrsRel.FINDFIRST THEN
//                         EXIT(NoSrsRel."Series Code")
//                 END;
//             GenLedgerSetup."Base No. Series"::"Shortcut Dimension 2":
//                 BEGIN
//                     NoSrsRel.RESET;
//                     NoSrsRel.SETRANGE(Code, NoSeriesCode);
//                     NoSrsRel.SETRANGE("Series Filter", "Shortcut Dimension 2 Code");
//                     IF NoSrsRel.FINDFIRST THEN
//                         EXIT(NoSrsRel."Series Code")
//                 END;
//             GenLedgerSetup."Base No. Series"::"Shortcut Dimension 3 Code":
//                 BEGIN
//                     NoSrsRel.RESET;
//                     NoSrsRel.SETRANGE(Code, NoSeriesCode);
//                     NoSrsRel.SETRANGE("Series Filter", "Shortcut Dimension 3 Code");
//                     IF NoSrsRel.FINDFIRST THEN
//                         EXIT(NoSrsRel."Series Code")
//                 END;
//             GenLedgerSetup."Base No. Series"::"Shortcut Dimension 4":
//                 BEGIN
//                     NoSrsRel.RESET;
//                     NoSrsRel.SETRANGE(Code, NoSeriesCode);
//                     NoSrsRel.SETRANGE("Series Filter", "Shortcut Dimension 4 Code");
//                     IF NoSrsRel.FINDFIRST THEN
//                         EXIT(NoSrsRel."Series Code")
//                 END;
//             ELSE
//                 EXIT(NoSeriesCode);
//         END;
//     end;

//     local procedure GetNoSeriesCode(): Code[20]
//     var
//         NoSeriesCode: Code[20];
//     begin
//         GenLedgerSetup.GET();
//         GenLedgerSetup.TESTFIELD(GenLedgerSetup."Stores Requisition No");

//         NoSeriesCode := GenLedgerSetup."Stores Requisition No";
//         EXIT(GetNoSeriesRelCode(NoSeriesCode));
//     end;
// }

