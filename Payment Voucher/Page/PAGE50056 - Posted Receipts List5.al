page 50632 "Posted Receipts List"
{
    CardPageID = "Posted Receipts Header5";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    SourceTable = "Receipts Header";
    UsageCategory = Lists;
    ApplicationArea = All;
    AdditionalSearchTerms = '"Posted Receipts", Receipts';
    SourceTableView = WHERE(Posted = CONST(true),
                            "Receipt Type" = CONST(Bank));

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
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

