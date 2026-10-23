page 50724 "Posted Journal Voucher"
{
    PageType = Card;
    SourceTable = "Posted Voucher Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Reference Voucher No."; Rec."Reference Voucher No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Narration; Rec.Narration)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                part(Approvals; "Approval Status")
                {
                    Caption = 'Approvals';
                    ApplicationArea = All;
                    SubPageLink = "Document No." = FIELD("No.");
                    SubPageView = SORTING("Table ID", "Document Type", "Document No.", "Sequence No.");
                }
            }
            part(PostedVoucherList; "Posted Journal Vou. Subform")
            {
                Caption = 'Lines';
                Editable = false;
                ApplicationArea = All;
                SubPageLink = "Voucher Type" = FIELD("Voucher Type"),
                              "Document No." = FIELD("No.");
            }
            group(Usertrail)
            {
                Editable = false;
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created By Name"; Rec."Created By Name")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; Rec."Created Time")
                {
                    ApplicationArea = All;
                }
                field("Modified By"; Rec."Modified By")
                {
                    ApplicationArea = All;
                }
                field("Modified By Name"; Rec."Modified By Name")
                {
                    ApplicationArea = All;
                }
                field("Modified Date"; Rec."Modified Date")
                {
                    ApplicationArea = All;
                }
                field("Modified Time"; Rec."Modified Time")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
                field("Posted By Name"; Rec."Posted By Name")
                {
                    ApplicationArea = All;
                }
                field("Posted Date"; Rec."Posted Date")
                {
                    ApplicationArea = All;
                }
                field("Posted Time"; Rec."Posted Time")
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
            action(Print)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin

                    pVoucherHeader.SETRANGE("Voucher Type", Rec."Voucher Type");
                    pVoucherHeader.SETRANGE("No.", Rec."No.");
                    IF pVoucherHeader.FINDFIRST THEN
                        REPORT.RUN(50049, TRUE, FALSE, pVoucherHeader);
                end;
            }
            action(Navigate)
            {
                ApplicationArea = All;
                Caption = 'Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
        }
    }

    var
        pVoucherHeader: Record "Posted Voucher Header";
}

