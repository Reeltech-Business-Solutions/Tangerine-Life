table 50642 "Quotation Specification Lines"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Quote));
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Code"; Code[20])
        {
            //TableRelation = Table39004361.Field1;

            trigger OnValidate()
            begin
                QuoteSpec.GET(Code);
                "Max Score" := QuoteSpec."Value/Weight";
                Description := QuoteSpec.Description;
            end;
        }
        field(4; Description; Text[60])
        {
        }
        field(5; Score; Decimal)
        {

            trigger OnValidate()
            begin
                IF Score > "Max Score" THEN
                    ERROR('The score can not be graeter than the max score specified');
            end;
        }
        field(6; "Request No."; Code[20])
        {
            TableRelation = "Purchase Quote Header"."No." WHERE(Status = CONST(Released));
        }
        field(7; "Request Line No."; Integer)
        {
            //TableRelation = Table39004360.Field4;
        }
        field(8; Type; Text[30])
        {
        }
        field(9; "Type No."; Code[20])
        {
        }
        field(10; "Type Name"; Text[100])
        {
        }
        field(11; "Max Score"; Decimal)
        {
        }
        field(12; "Total Score"; Decimal)
        {
            // CalcFormula = Sum(Table39004362.Field5 WHERE (Field1=FIELD("Document No."),
            //                                               Field6=FIELD("Request No.")));
            // FieldClass = FlowField;
        }
        field(13; "Temp Total Score"; Decimal)
        {
        }
        field(14; "issued date"; Date)
        {
            Caption = 'Issued Date';

        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.", "Code", "Request No.", "Request Line No.", Score)
        {
            Clustered = true;
        }
        key(Key2; Score)
        {
        }
        key(Key3; "Request No.", "Code", Type, "Type No.", Score)
        {
        }
        key(Key4; "Document No.", "Request No.")
        {
            SumIndexFields = Score;
        }
        key(Key5; "Temp Total Score")
        {
        }
    }

    fieldgroups
    {
    }

    var
        QuoteSpec: Record "Quote Specifications";
}

