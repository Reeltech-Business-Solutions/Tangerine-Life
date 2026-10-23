table 50610 POAttach
{
    DataClassification = ToBeClassified;

    fields
    {

        field(1; "Purchase order"; code[20])
        {
            DataClassification = ToBeClassified;


        }

        field(2; "Voucher"; code[20])
        {
            DataClassification = ToBeClassified;


        }

        field(3; "Date"; date)
        {
            DataClassification = ToBeClassified;


        }
    }

    keys
    {
        key(Key1; "Purchase order")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}