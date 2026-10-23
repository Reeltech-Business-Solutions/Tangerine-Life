page 50661 "RFQ Subform"
{
    PageType = ListPart;
    SourceTable = "Purchase Quote Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Expense Code"; Rec."Expense No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("PRF No"; Rec."PRF No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Specification")
            {
                Caption = 'Set Specification';
                ApplicationArea = All;
                Visible = false; //jj290522

                trigger OnAction()
                var
                    PParams: Record "Purchase Quote Params";
                begin
                    PParams.RESET;
                    PParams.SETRANGE(PParams."Document Type", Rec."Document Type");
                    PParams.SETRANGE(PParams."Document No.", Rec."Document No.");
                    PParams.SETRANGE(PParams."Line No.", Rec."Line No.");
                    PAGE.RUN(51534353, PParams);
                end;
            }
        }
    }
}

