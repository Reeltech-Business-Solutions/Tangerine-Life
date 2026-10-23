tableextension 50619 CustomerExt extends Customer
{
    fields
    {
        field(50001; "Customer Type"; Option)
        {
            OptionMembers = "",Normal,Employee;
            OptionCaption = ' ,Normal,Employee';
        }
        field(50002; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers =" ","Staff Advance",Partner,"Staff Loan",Others,Accrual;
        }
        field(50003; "G/L Account No."; Code[20])
        {

        }
        field(50004; "Shortcut Dimension 3 Code"; Code[20])

        {
            CaptionClass = '1,2,3';
            tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(50005; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(50006; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(50007; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(50008; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(50009; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            tableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
        field(50010; "Check Payment term"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Payment Terms".Code WHERE(Code = FIELD("Payment Terms Code")));
        }
        field(50011; "Customer Category"; Option)
        {
            OptionMembers = ,Internal,External,Warranty,Contract,"Lease Operation",Insurance,GroupHead;
        }

    }


}