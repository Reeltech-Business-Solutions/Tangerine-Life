page 50631 "Receipts List"
{
    ApplicationArea = All;
    CardPageID = "Receipts Header";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Receipts Header";
    AdditionalSearchTerms = '"Posted Receipts", Receipts';
    SourceTableView = WHERE("Receipt Type" = CONST(Bank));
    UsageCategory = Lists;

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
                field(Date; rEC.Date)
                {
                    ApplicationArea = All;
                }
                field(Cashier; REC.Cashier)
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

