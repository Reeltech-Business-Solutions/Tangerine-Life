page 50648 "Approved PRF Lists"
{
    ApplicationArea = All;
    Caption = 'Approved PR List';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = CONST(Quote), Status = filter(Released));
    Deleteallowed = false;
    Editable = false;

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

                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Purchase Type"; Rec."Purchase Type")
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
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(51534578), "No." = FIELD("No.");

            }
        }
    }

    actions
    {
    }

    [Scope('Cloud')]
    procedure SetSelection(var Collection: Record "Purchase Line")
    begin
        CurrPage.SETSELECTIONFILTER(Collection);
    end;

    trigger OnOpenPage()
    var
        PHeader: Record "Purchase Header";
        PLine: Record "Purchase Line";
    begin
        Rec.CalcFields("Purchase Type");
        Rec.CalcFields(Status);
        Rec.SetFilter("Purchase Type", '%1|%2', "Purchase Type"::"Foreign Requisition", "Purchase Type"::"Requisition");
        // PHeader.SetRange("No.", Rec."Document No.");

        // PHeader.SetFilter("Purchase Type", '%1', 4);
        // PHeader.Validate(Status);
        // PHeader.Validate("Purchase Type");

        // PHeader.SetFilter(Status, '%1', pheader.Status::Released);
    end;


}


