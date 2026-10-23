tableextension 50621 GLEntryExt extends "G/L Entry"
{
    fields
    {
        field(50004; "Payment Request No."; Code[20])
        {

        }
        field(70013; "Loan ID"; Code[20]) { }
        field(70014; "Acct. No."; Code[20]) { }
        field(50308; "OEM Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(50309; "LPO"; Text[50])
        {

        }

        field(50600; "Account Class Name"; Text[200])
        {
            Caption = 'Account Class Name';
            DataClassification = ToBeClassified;
        }

        field(50601; "Transaction Class Name"; Text[200])
        {
            Caption = 'Transaction Class Name';
            DataClassification = ToBeClassified;
        }

        field(50602; "Transaction Class Code"; code[20])
        {
            Caption = 'Transaction Class Code';
            DataClassification = ToBeClassified;
        }

        field(50603; "Account Class Code"; code[20])
        {
            Caption = 'Account Class Code';
            DataClassification = ToBeClassified;
        }
        field(50604; "refnum"; code[20])
        {
            Caption = 'Refnum';
            DataClassification = ToBeClassified;
        }

        field(50605; note; text[500])
        {
            Caption = 'Note';
            DataClassification = ToBeClassified;
        }

        field(50606; "Cheque Num"; code[200])
        {
            Caption = 'Cheque Number';
            DataClassification = ToBeClassified;
        }

        field(50607; "Effective Date"; date)
        {
            Caption = 'Effective Date';
            DataClassification = ToBeClassified;
        }

        field(50608; "Transaction Date"; date)
        {
            Caption = 'Transaction Date';
            DataClassification = ToBeClassified;
        }

        field(50609; "Proposal Number"; code[50])
        {
            Caption = 'Proposal Number';
            DataClassification = ToBeClassified;
        }

        field(50610; "Policy Number"; code[50])
        {
            Caption = 'Policy Number';
            DataClassification = ToBeClassified;
        }

        field(50611; "Policy Class"; code[50])
        {
            Caption = 'Policy Class';
            DataClassification = ToBeClassified;
        }

        field(50612; branch; code[50])
        {
            Caption = 'Branch';
            DataClassification = ToBeClassified;
        }

        field(50613; agency; code[50])
        {
            Caption = 'Agency';
            DataClassification = ToBeClassified;
        }

        field(50614; "CBA Trans ID"; Code[50])
        {
            Caption = 'CBA Trans ID';
            DataClassification = CustomerContent;
        }

        field(50615; "Bank ref id"; code[100])
        {
            Caption = 'Bank ref id';
            DataClassification = ToBeClassified;
        }

        field(50616; "CBA Processed"; boolean)
        {
            Caption = 'Bank ref id';
            DataClassification = ToBeClassified;
        }
        field(50620; beneficiary; code[200])
        {

        }




    }

}


pageextension 50631 GLEntryExt extends "General Ledger Entries"
{
    layout
    {
        addafter("G/L Account No.")
        {
            field("Loan ID"; Rec."Loan ID") { ApplicationArea = All; }
            field("Acct. No."; Rec."Acct. No.") { ApplicationArea = All; }
            field("Job No.1"; Rec."Job No.") { ApplicationArea = All; }

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
        addbefore("Debit Amount")
        {
            field(Amount1; Rec.Amount)
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {
        addafter(ReverseTransaction)
        {
            action("IES REPORT")
            {
                ApplicationArea = all;
                caption = 'IES Report';
                Image = Report;
                Promoted = true;
                PromotedCategory = process;
                trigger onAction()
                var
                    cbaReport: report "CBA Report";
                begin
                    cbaReport.Run();
                end;
            }
        }
    }

    // Add changes to page layout here
}


