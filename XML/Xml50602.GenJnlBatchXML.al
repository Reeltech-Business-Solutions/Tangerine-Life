xmlport 50602 GenJnlBatchXML
{
    Caption = 'GenJnlBatchXML';
    Direction = import;
    Format = VariableText;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                AutoReplace = true;
                AutoUpdate = true;
                XmlName = 'GenJnlBatchXML';
                AutoSave = false;

                fieldelement(PostingDate; "Gen. Journal Line"."Posting Date")
                {

                }
                fieldelement(VATDate; "Gen. Journal Line"."VAT Reporting Date")
                {

                }
                fieldelement(DocumentNo; "Gen. Journal Line"."Document No.")
                {

                }
                fieldelement(AccountType; "Gen. Journal Line"."Account Type")
                {

                }
                fieldelement(AccountNo; "Gen. Journal Line"."Account No.")
                {

                }
                fieldelement(AccountName; "Gen. Journal Line"."GL Account Name")
                {

                }
                fieldelement(Description; "Gen. Journal Line".Description)
                {

                }
                fieldelement(DebitAmount; "Gen. Journal Line"."Debit Amount")
                {

                }
                fieldelement(CreditAmount; "Gen. Journal Line"."Credit Amount")
                {

                }
                fieldelement(ProductCode; "Gen. Journal Line"."Shortcut Dimension 1 Code")
                {

                }
                fieldelement(BranchCode; "Gen. Journal Line"."Shortcut Dimension 2 Code")
                {

                }
                fieldelement(DepartmentCode; "Gen. Journal Line"."Shortcut Dimension 3 Code")
                {

                }



                trigger OnAfterInitRecord()
                begin
                    JournalTemplateName := 'GENERAL';
                    JournalBatchName := 'GENERAL';

                    "Gen. Journal Line"."Journal Template Name" := JournalTemplateName;
                    "Gen. Journal Line"."Journal Batch Name" := JournalBatchName;

                end;

                trigger OnBeforeInsertRecord()
                begin
                    "Gen. Journal Line"."Line No." := LineNo;
                    LineNo += 10000;

                    "Gen. Journal Line".ValidateShortcutDimCode(3, "Gen. Journal Line"."Shortcut Dimension 3 Code");

                    "Gen. Journal Line".Insert(true);


                end;
            }


        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnPostXmlPort()
    begin
        Message('The lines have been imported successfully.');
    end;

    trigger OnPreXmlPort()
    var
        GenJnlLine: Record "Gen. Journal Line";

    begin

        JournalTemplateName := 'GENERAL';
        JournalBatchName := 'GENERAL';

        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);

        GenJnlLine.DeleteAll(true);

        if GenJnlLine.FindLast() then
            LineNo := GenJnlLine."Line No." + 10000
        else
            LineNo := 10000;

    end;

    var
        LineNo: Integer;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];

}
