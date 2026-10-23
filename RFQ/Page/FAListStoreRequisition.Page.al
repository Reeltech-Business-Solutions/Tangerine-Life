page 50649 "FA List-Store Requisition"
{
    PageType = List;
    SourceTable = "Fixed Asset";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                // field("User Of Asset"; "User Of Asset")
                // {
                // } Dennis
                field("FA Location Code"; Rec."FA Location Code")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(5600), "No." = FIELD("No.");
            }
        }
    }

    actions
    {
    }
}

