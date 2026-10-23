page 50717 "Posted BRV"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
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
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Reference Voucher No."; Rec."Reference Voucher No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Narration; Rec.Narration)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(PostedVoucherList; "Posted Cash Rcpt. Vou. Subform")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                Editable = false;
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
                        REPORT.RUN(50060, TRUE, FALSE, pVoucherHeader);
                end;
            }
            action(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

    end;

    var
        pVoucherHeader: Record "Posted Voucher Header";
        Visible: Boolean;
}

