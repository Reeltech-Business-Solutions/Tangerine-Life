tableextension 50637 PurchLineExt extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Expense No."; code[20])
        {
            TableRelation = "Receipts and Payment Types".Code where(type = Const(Requisition), Blocked = CONST(false));

            trigger OnValidate()
            var
                RecPay: Record "Receipts and Payment Types";
            begin
                RecPay.Reset;
                RecPay.SetRange(RecPay.Code, "Expense No.");
                // RecPay.SetRange(RecPay.Type, RecPay.Type::Requisition);
                if RecPay.Find('-') then begin
                    Type := Type::"G/L Account";
                    "No." := RecPay."Account No.";
                    Validate("No.");
                    Description := RecPay.Description;
                    "Expense No." := RecPay.Code;


                end;
            end;
        }
        field(50002; "Direct Unit Cost Buffer"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Property Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Property Name"; Code[90])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "PRF No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50007; Committed; boolean)
        {
            Caption = 'Committed';
            //Editable = false;
        }
        field(50008; "RFQ No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50009; Status; Enum "Purchase Document Status")
        {
            Caption = 'Status';
            Editable = false;
            fieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Status where("No." = field("Document No.")));
        }
        field(50010; "Purchase Type"; Enum "Purchase Type")
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Purchase Type" where("No." = field("Document No.")));
        }
        field(50011; Copied; Boolean)
        {

        }

        field(60002; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                TestStatusOpen();
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
                //UpdatePurchaseLines(FIELDNO("Shortcut Dimension 3 Code"));
            end;
        }
        field(60003; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                TestStatusOpen();
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(60004; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                TestStatusOpen();
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(60005; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));

            trigger OnValidate()
            begin
                TestStatusOpen();
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(60006; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
                TestStatusOpen();
            end;
        }
        field(60007; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
                TestStatusOpen();
            end;
        }
        field(60009; "Withholding Tax Group Code"; Code[20])
        {
            TableRelation = "Withholding Tax";
        }
        field(60010; "WIthholdingTax %"; Decimal)
        {
            Caption = 'With-Holding Tax %';
            DataClassification = ToBeClassified;
        }
        field(60011; "WHT Base Line No"; Integer)
        {

        }
    }

    trigger Oninsert()
    var
        purchase_header: Record "Purchase Header";
        purchase_line: Record "Purchase Line";

    begin
        // purchase_line.Reset();
        // purchase_line.setRange("Document No.", 'LPR-00093');
        // purchase_line.setRange("Document Type", "Document Type"::Quote);
        // if purchase_line.Findfirst() then begin
        //     purchase_line.validate("Shortcut Dimension 3 Code", purchase_header."Shortcut Dimension 3 Code");
        //     purchase_line.Modify();


        // end;
        if purchase_header.Get(Rec."Document Type", Rec."Document No.") then begin
            // Rec."Shortcut Dimension 7 Code" := purchase_header."Shortcut Dimension 7 Code";
            // Rec."Shortcut Dimension 6 Code" := purchase_header."Shortcut Dimension 6 Code";
            Rec."Shortcut Dimension 1 Code" := purchase_header."Shortcut Dimension 1 Code";
            Rec."Shortcut Dimension 2 Code" := purchase_header."Shortcut Dimension 2 Code";
            Rec."Shortcut Dimension 3 Code" := purchase_header."Shortcut Dimension 3 Code";
        end;
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        myInt: Integer;
}

