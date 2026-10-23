// table 50037 "Store Requistion Line"
// {
//     DrillDownPageID = "Store Requisition Line";
//     LookupPageID = "Store Requisition Line";

//     fields
//     {
//         field(1; "Requistion No"; Code[20])
//         {
//             trigger OnValidate()
//             begin
//                 /*
//                   IF ReqHeader.GET("Requistion No") THEN BEGIN
//                     IF ReqHeader."Global Dimension 1 Code"='' THEN
//                        ERROR('Please Select the Global Dimension 1 Requisitioning')
//                   END;
//                  */
//             end;
//         }
//         field(3; "Line No."; Integer)
//         {
//             AutoIncrement = true;
//             Caption = 'Line No.';
//         }
//         field(4; Type; Option)
//         {
//             Caption = 'Type';
//             OptionCaption = 'Item';
//             OptionMembers = Item;
//         }
//         field(5; "No."; Code[20])
//         {
//             Caption = 'No.';
//             TableRelation = Item."No." WHERE(Blocked = CONST(False));//, "Approval Status" = FILTER(Approved));

//             trigger OnValidate()
//             begin
//                 "Action Type" := "Action Type"::"Ask for Quote";

//                 IF Type = Type::Item THEN BEGIN
//                     QtyStore.SETFILTER(QtyStore.Location, "Issuing Store");//ibd
//                     IF QtyStore.GET("No.") THEN
//                         Description := QtyStore.Description;
//                     "Unit of Measure" := QtyStore."Base Unit of Measure";
//                     "Unit Cost" := QtyStore."Unit Cost";
//                     "Line Amount" := "Unit Cost" * Quantity;
//                     QtyStore.CALCFIELDS(QtyStore.Inventory);
//                     "Qty in store" := QtyStore.Inventory;
//                     "Gen. Prod. Posting Group" := QtyStore."Gen. Prod. Posting Group";
//                 END;
//             end;
//         }
//         field(6; Description; Text[200])
//         {
//             Caption = 'Description';
//         }
//         field(7; "Description 2"; Text[200])
//         {
//             Caption = 'Description 2';
//         }
//         field(8; Quantity; Decimal)
//         {
//             Caption = 'Quantity';
//             DecimalPlaces = 0 : 5;

//             trigger OnValidate()
//             begin

//                 IF Type = Type::Item THEN BEGIN
//                     "Line Amount" := "Unit Cost" * Quantity;
//                 END;

//                 IF QtyStore.GET("No.") THEN
//                     QtyStore.CALCFIELDS(QtyStore.Inventory);
//                 "Qty in store" := QtyStore.Inventory;

//                 IF Quantity > "Qty in store" THEN
//                     ERROR('You cannot Issue More than what is available in store. Contact your MIS Administrator');
//             end;
//         }
//         field(9; "Qty in store"; Decimal)
//         {
//             Editable = false;
//             FieldClass = Normal;
//         }
//         field(10; "Request Status"; Option)
//         {
//             Editable = true;
//             //OptionMembers = Open,"Pending Approval",Released,Approved,Closed;
//             OptionMembers =Open,"Pending Approval",Release,Posted,Cancelled,Closed;
//         }
//         field(11; "Action Type"; Option)
//         {
//             OptionMembers = " ",Issue,"Ask for Quote",Receive;

//             trigger OnValidate()
//             begin
//                 IF Type = Type::Item THEN BEGIN
//                     IF "Action Type" = "Action Type"::Issue THEN
//                         ERROR('You cannot Issue a G/L Account please order for it')
//                 END;
//             end;
//         }
//         field(12; "Unit of Measure"; Code[20])
//         {
//             TableRelation = "Unit of Measure";
//         }
//         field(13; "Total Budget"; Decimal)
//         {
//         }
//         field(14; "Current Month Budget"; Decimal)
//         {
//         }
//         field(15; "Unit Cost"; Decimal)
//         {
//             Editable = false;

//             trigger OnValidate()
//             begin
//                 // IF Type=Type::Item THEN
//                 "Line Amount" := "Unit Cost" * Quantity;
//             end;
//         }
//         field(16; "Line Amount"; Decimal)
//         {
//             Editable = false;
//         }
//         field(17; "Quantity Requested"; Decimal)
//         {
//             Caption = 'Quantity Requested';
//             DecimalPlaces = 0 : 5;

//             trigger OnValidate()
//             begin
//                 Quantity := "Quantity Requested";
//                 VALIDATE(Quantity);
//                 "Line Amount" := "Unit Cost" * Quantity;
//             end;
//         }
//         field(24; "Shortcut Dimension 1 Code"; Code[20])
//         {
//             CaptionClass = '1,2,1';
//             Caption = 'Shortcut Dimension 1 Code';
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
//         }
//         field(25; "Shortcut Dimension 2 Code"; Code[20])
//         {
//             CaptionClass = '1,2,2';
//             Caption = 'Shortcut Dimension 2 Code';
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
//         }
//         field(26; "Current Actuals Amount"; Decimal)
//         {
//         }
//         field(27; Committed; Boolean)
//         {
//         }
//         field(57; "Gen. Bus. Posting Group"; Code[20])
//         {
//             Caption = 'Gen. Bus. Posting Group';
//             TableRelation = "Gen. Business Posting Group".Code;// WHERE (Field50000=CONST(False));
//         }
//         field(58; "Gen. Prod. Posting Group"; Code[20])
//         {
//             Caption = 'Gen. Prod. Posting Group';
//             Editable = true;
//             TableRelation = "Gen. Product Posting Group";
//         }
//         field(81; "Shortcut Dimension 3 Code"; Code[20])
//         {
//             CaptionClass = '1,2,3';
//             Caption = 'Shortcut Dimension 3 Code';
//             Description = 'Stores the reference of the Third global dimension in the database';
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
//         }
//         field(82; "Shortcut Dimension 4 Code"; Code[20])
//         {
//             CaptionClass = '1,2,4';
//             Caption = 'Shortcut Dimension 4 Code';
//             Description = 'Stores the reference of the Third global dimension in the database';
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
//         }
//         field(83; "Issuing Store"; Code[20])
//         {
//             TableRelation = Location;
//         }
//         field(84; "Bin Code"; Code[20])
//         {
//             TableRelation = Bin.Code WHERE("Location Code" = FIELD("Issuing Store"));
//         }

//         field(50001; "Shortcut Dimension 4"; Code[20])
//         {
//             CaptionClass = '1,2,4';
//             Caption = 'Shortcut Dimension 1 Code';
//             TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
//         }

//         field(50002; "Qty in Iss. Str."; Decimal)
//         {
//             BlankZero = true;
//             CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Location Code" = FIELD("Issuing Store"),
//                                                                   "Item No." = FIELD("No.")));
//             FieldClass = FlowField;
//         }
//         field(39003900; "Vehicle Reg"; Code[20])
//         {
//             TableRelation = "Service Item"."No.";
//         }
//         field(39003901; "Service Job No."; Code[20])
//         {
//             TableRelation = "Service Header";
//         }
//         field(39003902; "Responsibility Center"; Code[30])
//         {
//         }
//         field(50000; "issued date"; Date)
//         {
//             Caption = 'Issued Date';

//         }
//     }

//     keys
//     {
//         key(Key1; "Requistion No", "Line No.")
//         {
//             Clustered = true;
//             SumIndexFields = "Line Amount";
//         }
//         key(Key2; "No.", Type, "Request Status")
//         {
//             SumIndexFields = Quantity;
//         }
//     }

//     fieldgroups
//     {
//     }

//     trigger OnDelete()
//     begin
//         /* ReqHeader.RESET;
//          ReqHeader.SETRANGE(ReqHeader."No.","Requistion No");
//          IF ReqHeader.FIND('-') THEN
//           IF ReqHeader.Status<>ReqHeader.Status::Open THEN
//               ERROR('You Cannot Delete Entries if status is not Pending')
//          */
//     end;

//     trigger OnInsert()
//     begin
//         "Line Amount" := "Unit Cost" * Quantity;

//         ReqHeader.RESET;
//         ReqHeader.SETRANGE(ReqHeader."No.", "Requistion No");
//         IF ReqHeader.FIND('-') THEN BEGIN
//             "Shortcut Dimension 1 Code" := ReqHeader."Global Dimension 1 Code";
//             "Shortcut Dimension 2 Code" := ReqHeader."Shortcut Dimension 2 Code";
//             "Shortcut Dimension 3 Code" := ReqHeader."Shortcut Dimension 3 Code";
//             "Shortcut Dimension 4 Code" := ReqHeader."Shortcut Dimension 4 Code";
//             "Issuing Store" := ReqHeader."Issuing Store";
//             "Responsibility Center" := ReqHeader."Responsibility Center";
//             IF ReqHeader.Status <> ReqHeader.Status::Open THEN
//                 ERROR('You Cannot Enter Entries if status is not Pending')
//         END;
//     end;

//     trigger OnModify()
//     begin
//         IF Type = Type::Item THEN
//             "Line Amount" := "Unit Cost" * Quantity;

//         ReqHeader.RESET;
//         ReqHeader.SETRANGE(ReqHeader."No.", "Requistion No");
//         IF ReqHeader.FIND('-') THEN BEGIN
//             "Shortcut Dimension 1 Code" := ReqHeader."Global Dimension 1 Code";
//             "Shortcut Dimension 2 Code" := ReqHeader."Shortcut Dimension 2 Code";
//             "Shortcut Dimension 3 Code" := ReqHeader."Shortcut Dimension 3 Code";
//             "Shortcut Dimension 4 Code" := ReqHeader."Shortcut Dimension 4 Code";
//             //  IF ReqHeader.Status<>ReqHeader.Status::Open THEN
//             //      ERROR('You Cannot Modify Entries if status is not Pending')
//         END;
//     end;

//     var
//         GLAccount: Record "G/L Account";
//         GenLedSetup: Record "General Ledger Setup";
//         QtyStore: Record item;
//         GenPostGroup: Record 252;
//         Budget: Decimal;
//         CurrMonth: Code[20];
//         RequisitionLine: Record "Requisition Line";
//         YrBudget: Decimal;
//         BudgetDate: Date;
//         ReqHeader: Record "Store Requistion Header";
//         BudgDate: Text[30];
//         CurrYR: Code[20];
//         ReqHead: Record "Store Requistion Header";
// }

