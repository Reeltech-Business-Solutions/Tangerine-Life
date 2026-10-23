table 50611 DocTrack
{
    Caption = 'DocTrack';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "FnO Document Id"; Text[100]) { }
        field(10; "Vendor No."; Code[20]) { }
        field(20; "Document Attachment Entry No."; Integer) { }
        field(30; "Imported DateTime"; DateTime) { }
    }

    keys
    {
        key(PK; "FnO Document Id") { Clustered = true; }
    }
}
