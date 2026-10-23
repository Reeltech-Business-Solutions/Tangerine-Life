tableextension 50644 PurchHeaderExt extends "Purchase Header"
{
    fields
    {
        field(50000; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(50001; "Request Type"; Option)
        {
            Caption = 'Request Type';
            OptionMembers = " ","Requisition";
            OptionCaption = ' ,Requisition';
        }
        field(50002; "VendorNoFilter"; Code[20])
        {

        }
        field(50003; "Requisition No."; Code[20])
        {

        }
        field(50004; "Purchase Type"; Enum "Purchase Type")
        {

        }
        field(50005; "RFQ No."; Code[20])
        {

        }
        field(50006; "ApprovalCode"; Code[20])
        {
            Caption = 'Approval Code';
            DataClassification = ToBeClassified;
            TableRelation = "Group Head Approval";
        }
        field(50009; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                          Blocked = const(false));

            trigger OnValidate()
            var
                purchase_line: Record "Purchase Line";
            begin
                Rec.ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
                purchase_line.SetRange("Document Type", Rec."Document Type");
                purchase_line.SetRange("Document No.", Rec."No.");
                if purchase_line.FindSet() then begin
                    repeat
                        purchase_line.Validate("Shortcut Dimension 3 Code", Rec."Shortcut Dimension 3 Code");
                        purchase_line.Modify();
                    until purchase_line.Next() = 0;
                end

            end;
        }
        field(50010; "Created By"; Code[50])
        {

        }
        field(50011; "Created Date"; Date)
        {

        }
        field(50012; "Withholding Tax Group Code"; Code[20])
        {
            caption = 'With-Holding Tax Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Withholding Tax";
            trigger onValidate()
            var
                Confirmed: Boolean;
                Text001: Label 'Do you want to update the %1 on the related lines?';
            begin
                if xRec."Withholding Tax Group Code" <> Rec."Withholding Tax Group Code" then begin
                    If HideValidationDialog or
                      (xRec."Withholding Tax Group Code" = '')
                    then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text001, false, FieldCaption("Withholding Tax Group Code"));
                    if Confirmed then
                        UpdatePurchaseLines(FieldNo("Withholding Tax Group Code"))
                    else begin
                        "Withholding Tax Group Code" := xRec."Withholding Tax Group Code";
                        exit;
                    end;
                end

            end;

        }
        field(50013; "WIthholdingTax %"; Decimal)
        {
            Caption = 'With-Holding Tax %';
            DataClassification = ToBeClassified;
        }
        field(50014; "Budget Check"; Boolean)
        {

        }

    }

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created Date" := Today;
    end;

    trigger OnBeforeDelete()
    begin
        if Status = Status::"Pending Approval" then
            Error('You can not delete Pending Approval purchase documents');

        if Status = Status::Released then
            Error('You can not delete Release purchase documents');
    end;

    local procedure UpdatePurchaseLines(FieldRef: Integer)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.LockTable;
        PurchaseLine.SetRange("Document No.", "No.");
        PurchaseLine.setRange("No.", wth);
        if not PurchaseLine.FindFirst() then begin
            PurchaseLine.reset();
            PurchaseLine.SetRange("Document No.", "No.");
            PurchaseLine.SetRange("No.", vat);
        end;
        if PurchaseLine.Find('-') then begin
            repeat
                if FieldRef = FieldNo("Withholding Tax Group Code") then begin
                    PurchaseLine.Validate("Withholding Tax Group Code", "Withholding Tax Group Code");
                end;

                PurchaseLine.Modify(true);
            until PurchaseLine.Next = 0;
        end;
    end;

    procedure wth(): Text
    begin
        if witholdingTax.FindFirst() then
            exit(witholdingTax."WHT Account");
    end;

    procedure vat(): Text
    begin
        if witholdingTax.FindFirst() then
            exit(witholdingTax."VAT Account");
    end;

    var
        witholdingTax: Record "Withholding Tax";

}