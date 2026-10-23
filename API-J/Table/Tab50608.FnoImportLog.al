table 50608 "Fno Import Log"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(10; "Start DateTime"; DateTime) { }
        field(20; "End DateTime"; DateTime) { }
        field(30; "Imported Count"; Integer) { }
        field(40; "Skipped Count"; Integer) { }
        field(50000; Status; Option)
        {
            OptionMembers = Ready,"In Process","On Hold",Error,Finished,Waiting,Success;
            OptionCaption = 'Ready,In Process,On Hold,Error,Finished,Waiting, Success';
        }
        field(60; "Error Message"; Text[2048]) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
