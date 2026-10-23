table 50645 RFQ
{
    Caption = 'RFQ';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Enum "Purchase Document Type")
        {
        }
        field(2; "Sell-to Customer No."; Code[20]) { }
        field(3; "Document No."; Code[20]) { }
        field(4; "Line No."; Integer) { }
        field(5; "Type"; Enum "Purchase Line Type") { }
        field(7; "Location Code"; Code[20]) { }
        field(11; "Description"; Text[100]) { }
        field(15; "Quantity"; Decimal) { }
        field(18; "Qty. to Ship"; Decimal) { }
        field(19; "Manipulation Type"; Enum "Manipulation Type")
        {
        }
        field(20; "Creation Date"; Date) { }
        field(21; "User"; Code[20]) { }
        field(22; "Base Quantity"; Decimal) { }
        field(23; "No."; Code[20]) { }
        field(24; "Entry No."; Integer) { }
        field(25; "Quote No."; Code[20]) { }
        field(26; "Order Posted"; Boolean) { }
        field(27; "No. Series"; Code[20]) { }
        field(28; "issued date"; Date) { }
    }
    keys
    {
        key(PK; "Document Type")
        {
            Clustered = true;
        }
    }
}
