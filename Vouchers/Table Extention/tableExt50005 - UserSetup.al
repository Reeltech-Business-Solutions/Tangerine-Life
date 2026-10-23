tableextension 50616 UsersetupExt extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = ToBeClassified;
        }
        field(50002; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = ToBeClassified;
        }
        field(50003; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
            DataClassification = ToBeClassified;
        }
        field(50004; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
            DataClassification = ToBeClassified;
        }
        field(50005; "Staff Travel Account"; Code[20])
        {
            Caption = 'Staff Travel Account';
            DataClassification = ToBeClassified;
            TableRelation = Employee Where(Status = filter(Active));
        }
        field(50006; "Cash Advance Staff Account"; Code[20])
        {
            Caption = 'Staff Advance Staff Account';
            DataClassification = ToBeClassified;
            TableRelation = Employee Where(Status = filter(Active));
        }
        field(50007; "Maximum Amount"; Decimal)
        {
            Caption = 'Maximum Amount';
            DataClassification = ToBeClassified;
        }
        field(50008; "Is In HR"; Boolean)
        {
            Caption = 'Is In HR';
            DataClassification = ToBeClassified;
        }
        field(50009; "Employee No"; Code[20])
        {
            Caption = 'Employee No';
            DataClassification = ToBeClassified;
            TableRelation = Employee Where(Status = filter(Active));
        }
        field(50010; "Released Status"; Boolean)
        {
            Caption = 'Released Status';
            DataClassification = ToBeClassified;
        }
        field(50011; "ReOpen Job Card"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Confirm warranty"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "ReOpen Service Quote"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Close Job"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Create Vend"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
pageextension 50628 UserSetupExt extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sales Resp. Ctr. Filter")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                Caption = 'Global Dimension 1 Code';
                ApplicationArea = All;
            }

            field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                Caption = 'Shortcut Dimension 2 Code';
                ApplicationArea = All;
            }

            field("Staff Travel Account"; Rec."Staff Travel Account")
            {
                Caption = 'Staff Travel Account';
                ApplicationArea = All;
            }

            field("Cash Advance Staff Account"; Rec."Cash Advance Staff Account")
            {
                Caption = 'Staff Advance Account';
                ApplicationArea = All;
            }
            field("Released Status"; Rec."Released Status")
            {
                ApplicationArea = All;
            }
            field("Create Vend"; Rec."Create Vend")
            {
                ApplicationArea = All;
            }

        }
    }

    var
        myInt: Integer;
}