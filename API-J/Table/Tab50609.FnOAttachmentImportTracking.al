table 50609 "FnO Attachment Import Tracking"
{
    Caption = 'FnO Attachment Import Tracking';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "FnO Document Id"; Text[100]) { }
        field(10; "Vendor No."; Code[20]) { }
        field(20; "Document Attachment Entry No."; Integer) { }
        field(30; "Imported DateTime"; DateTime) { }

        field(40; "Incoming Document Entry No."; integer)
        {

        }

        field(50; "Voucher No."; code[20])
        {

        }
    }

    keys
    {
        key(PK; "FnO Document Id") { Clustered = true; }
    }
}