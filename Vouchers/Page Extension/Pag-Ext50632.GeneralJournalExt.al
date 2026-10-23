pageextension 50632 "General Journal Ext" extends "General Journal"
{
    layout
    {
        addafter(Description)
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
            field("Account Class Name"; Rec."Account Class Name")
            {
                ApplicationArea = All;
            }

            field("Transaction Class Name"; Rec."Transaction Class Name")
            {
                ApplicationArea = All;
            }

            field("Transaction Class Code"; Rec."Transaction Class Code")
            {
                ApplicationArea = All;
            }

            field("Account Class Code"; Rec."Account Class Code")
            {
                ApplicationArea = All;
            }

            field(refnum; Rec.refnum)
            {
                ApplicationArea = All;
            }

            // field(note; Rec.note)
            // {
            //     ApplicationArea = All;
            // }

            field("Cheque Num"; Rec."Cheque Num")
            {
                ApplicationArea = All;
            }

            field("Effective Date"; Rec."Effective Date")
            {
                ApplicationArea = All;
            }

            field("Transaction Date"; Rec."Transaction Date")
            {
                ApplicationArea = All;
            }

            field("Proposal Number"; Rec."Proposal Number")
            {
                ApplicationArea = All;
            }

            field("Policy Number"; Rec."Policy Number")
            {
                ApplicationArea = All;
            }

            field("Policy Class"; Rec."Policy Class")
            {
                ApplicationArea = All;
            }

            field(branch; Rec.branch)
            {
                ApplicationArea = All;
            }

            field(agency; Rec.agency)
            {
                ApplicationArea = All;
            }
            field(beneficiary; Rec.beneficiary)
            {
                ApplicationArea = All;
            }

        }
        modify("Amount (LCY)")
        {
            Visible = false;
        }
        modify(Amount)
        {
            Visible = false;
        }

    }
    actions
    {
        addafter(Reconcile)
        {
            action("XML Import")
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Import Salary Batch';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    XML: XmlPort GenJnlXML;
                begin


                    if not Confirm('Are you sure you want to proceed with the XML import') then
                        exit;

                    // Rec.Reset();
                    // Rec.SetRange("Journal Template Name", 'SALARY');
                    // Rec.SetRange("Journal Batch Name", 'GENERAL');
                    //  Rec.SetRange("Document No.", Rec."Document No.");
                    // if rec.FindFirst() then
                    //     Rec.DeleteAll();
                    XML.Run();
                end;
            }
            action(ImportGeneralXml)
            {
                ApplicationArea = All;
                Caption = 'Import General Batch';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    XML: XmlPort GenJnlBatchXML;
                begin

                    if not Confirm('Are you sure you want to proceed with the XML import') then
                        exit;

                    // Rec.Reset();
                    // Rec.SetRange("Journal Template Name", 'GENERAL');
                    // Rec.SetRange("Journal Batch Name", 'GENERAL');
                    // // Rec.SetRange("Document No.", Rec."Document No.");
                    // if rec.FindFirst() then
                    //     Rec.DeleteAll();

                    XML.Run();
                end;

            }
        }
    }
}

