table 50612 "F&OTable"
{
    Caption = 'FnO Exp Attached Document';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Id"; Code[100])
        {
            Caption = 'Document Id';
            DataClassification = CustomerContent;
        }
        field(10; "Ent Rec Id"; BigInteger)
        {
            Caption = 'Ent Rec Id';
        }
        field(20; "File Name"; Text[250])
        {
            Caption = 'File Name';
        }
        field(30; "File Extension"; Code[20])
        {
            Caption = 'File Extension';
        }
        field(40; "Content Type"; Text[100])
        {
            Caption = 'Content Type';
        }
        field(50; "Ref Company Id"; Code[20])
        {
            Caption = 'Ref Company Id';
        }
        field(60; "Actual Company Id"; Code[20])
        {
            Caption = 'Actual Company Id';
        }
        field(70; "Ref Rec Id"; BigInteger)
        {
            Caption = 'Ref Rec Id';
        }
        field(80; "Ref Table Id"; Integer)
        {
            Caption = 'Ref Table Id';
        }
        field(90; "Value Rec Id"; BigInteger)
        {
            Caption = 'Value Rec Id';
        }
        field(100; "Default Attachment"; Text[10])
        {
            Caption = 'Default Attachment';
        }
        field(110; "Is Justification"; Text[10])
        {
            Caption = 'Is Justification';
        }
        field(120; "Is Receipt Attached"; Text[10])
        {
            Caption = 'Is Receipt Attached';
        }
        field(130; "Is Receipt Valid"; Text[10])
        {
            Caption = 'Is Receipt Valid';
        }
        field(140; "Captured Receipt"; Text[250])
        {
            Caption = 'Captured Receipt';
        }
        field(150; "Document Created By"; Text[100])
        {
            Caption = 'Document Created By';
        }
        field(160; "Creating Worker"; BigInteger)
        {
            Caption = 'Creating Worker';
        }
        field(170; Notes; Text[250])
        {
            Caption = 'Notes';
        }
        field(180; "Exp Trans Number"; Text[50])
        {
            Caption = 'Exp Trans Number';
        }
        field(190; "Docu Ref Table Name"; Text[100])
        {
            Caption = 'Docu Ref Table Name';
        }
        field(200; Author; Integer)
        {
            Caption = 'Author';
        }
        field(210; "Creating Date Time"; Text[50])
        {
            Caption = 'Creating Date Time';
        }
        field(220; "Document Created Date Time"; Text[50])
        {
            Caption = 'Document Created Date Time';
        }
        field(230; Attachment; Blob)
        {
            Caption = 'Attachment';
        }
        field(240; "Attachment Size"; Integer)
        {
            Caption = 'Attachment Size';
        }
        field(250; "Imported DateTime"; DateTime)
        {
            Caption = 'Imported DateTime';
        }
    }

    keys
    {
        key(PK; "Document Id")
        {
            Clustered = true;
        }
    }
}
