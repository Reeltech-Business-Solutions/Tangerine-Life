page 50658 "Quotation Req. Vendors"
{
    Caption = 'Quotation Request Vendors';
    PageType = ListPart;
    SourceTable = "Quotation Request Vendors";
    ApplicationArea = All;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    // area(factboxes)
    // {
    //     part("Attached Documents"; "Document Attachment Factbox")
    //     {
    //         ApplicationArea = All;

    //         Caption = 'Attachments';
    //         SubPageLink = "Table ID" = CONST(38),
    //                       "No." = FIELD("No."),
    //                       "Document Type" = FIELD("Document Type");
    //     }
    // }



    actions
    {
    }
}

