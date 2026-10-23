table 50607 "FnO Integration Setup"
{
    Caption = 'FnO Integration Setup';
    DataClassification = SystemMetadata;
    
    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
        }
        field(2; "Tenant Id"; Text[100])
        {
            Caption = 'Tenant Id';
        }
        field(3; "Client id"; Text[100])
        {
            Caption = 'Client id';
        }
        field(4; "F&O Environment URL"; Text[250])
        {
            Caption = 'F&O Environment URL';
        }
        field(5; "Data Area Id"; Text[10])
        {
            Caption = 'Data Area Id';
        }
        field(6; "Batch Size"; integer)
        {
            Caption = 'Batch Size';
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
