page 50714 "Posted Approval Status"
{
    PageType = Card;
    SourceTable = "Posted Approval Entry";

    layout
    {
        area(content)
        {
            repeater(New)
            {
                Editable = false;
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

