table 50652 "Item Journal"
{
    Caption = 'Item Journal';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item Journal Template Name"; Code[20])
        {
            Caption = 'Item Journal Template Name';
            DataClassification = ToBeClassified;
        }
        field(2; "Item Journal Batch"; Code[20])
        {
            Caption = 'Item Journal Batch';
            DataClassification = ToBeClassified;
        }
        field(3; "Entry Type"; Integer)
        {
            Caption = 'Entry Type';
            DataClassification = ToBeClassified;
            InitValue = 3;
        }
        field(4; "Line No"; Integer)
        {
            Caption = 'Line No';
            DataClassification = ToBeClassified;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(6; "Item No"; Code[20])
        {
            Caption = 'Item No';
            DataClassification = ToBeClassified;
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(9; "Profit Center"; Code[20])
        {
            Caption = 'Profit Center';
            DataClassification = ToBeClassified;
        }
        field(10; "Cost Center"; Code[20])
        {
            Caption = 'Cost Center';
            DataClassification = ToBeClassified;
            //TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
    }
    keys
    {
        key(PK; "Item Journal Template Name", "Item Journal Batch", "Line No", "Posting Date")
        {
            Clustered = true;
        }
    }

}
