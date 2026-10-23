codeunit 50624 MoveToGeneralJournal
{
    procedure MoveToGeneralJournalLine()
    var
        CBA: Record TangerinelifeCBA;
        GeneralJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TotalMoved: Integer;
        GLAccountNo: Code[20];
        isSkipped: boolean;
        TotalSkipped: integer;
        GLEntry: Record "G/L Entry";
    begin
        CBA.Reset();
        CBA.SetRange("is Processed", false);


        if CBA.FindSet() then begin


            GeneralJournalLine.Reset();
            GeneralJournalLine.SetRange("Journal Template Name", 'GENERAL');
            GeneralJournalLine.SetRange("Journal Batch Name", 'CBA2');
            if GeneralJournalLine.FindFirst() then begin
                // if not confirm('Journal batch %1 already has %2 existing lines.\' +
                //  'Do you want to clear them and replace with fresh lines?', false, GeneralJournalLine.Count()) then
                // exit;
                GeneralJournalLine.DeleteAll();
            end;
            LineNo := 10000;
            repeat
                if ((CBA.debit_balance = 0) and (CBA.credit_balance = 0) OR ((CBA.business_central_bank = '') and (CBA.business_central_gl = ''))) then begin
                    CBA."is Processed" := true;
                    CBA.Modify();
                    TotalSkipped += 1;
                    IsSkipped := true;
                end;

                if not IsSkipped then begin
                    GLEntry.Reset();
                    GLEntry.SetRange("CBA Trans ID", CBA.No);
                    if GLEntry.FindFirst() then begin
                        // Message('Transaction %1 (TransID: %2) has already been posted to G/L Entries. Skipping.',
                        //     CBA.refnum, CBA.No);
                        TotalSkipped += 1;
                        IsSkipped := true;
                    end;
                end;

                if not IsSkipped then begin
                    GeneralJournalLine.init();
                    GeneralJournalLine.Validate("Journal Template Name", 'GENERAL');
                    GeneralJournalLine.Validate("Journal Batch Name", 'CBA2');
                    GeneralJournalLine.Validate("Line No.", LineNo);
                    GeneralJournalLine.Validate("Debit Amount", CBA.debit_balance);
                    GeneralJournalLine.Validate("Credit Amount", Abs(CBA.credit_balance));
                    GeneralJournalLine.Validate("Posting Date", CBA.entry_date);
                    GeneralJournalLine.Validate("Account Class Name", CBA.account_class_name);
                    GeneralJournalLine.Validate("Transaction Class Name", CBA.transaction_class_name);
                    GeneralJournalLine.Validate("Transaction Class Code", CBA.transaction_class_code);
                    GeneralJournalLine.Validate("Account Class Code", CBA.account_class_code);
                    if (CBA.refnum <> '') then
                        GeneralJournalLine.Validate("Document No.", CBA.refnum) else
                        GeneralJournalLine.validate("Document No.", CBA.debit_note);
                    GeneralJournalLine.Validate(description, CBA.note);
                    GeneralJournalLine.Validate("Cheque Num", CBA.cheque_num);
                    GeneralJournalLine.Validate("Effective Date", CBA.effective_date);
                    GeneralJournalLine.Validate("Transaction Date", CBA.transaction_date);
                    GeneralJournalLine.Validate("Proposal Number", CBA.proposal_number);
                    GeneralJournalLine.Validate("Policy Number", CBA.policy_number);
                    GeneralJournalLine.Validate("Policy Class", CBA.policy_class);
                    GeneralJournalLine.Validate(branch, CBA.branch);
                    GeneralJournalLine.Validate(agency, CBA.agency);
                    GeneralJournalLine.Validate("Bank ref id", CBA.bank_refid);
                    GeneralJournalLine.Validate("CBA Trans ID", CBA.No);
                    if CBA.business_central_bank <> '' then begin
                        // Entry has a Bank Account — e.g GTB-01
                        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"Bank Account");
                        GeneralJournalLine.Validate("Account No.", CBA.business_central_bank);
                    end else if CBA.business_central_gl <> '' then begin
                        // Entry has a GL Account — e.g 411106
                        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"G/L Account");
                        GeneralJournalLine.Validate("Account No.", CBA.business_central_gl);
                    end;

                    GeneralJournalLine.insert(true);
                    LineNo += 10000;

                    LineNo += 10000;
                    TotalMoved += 1;
                end;
            until CBA.Next() = 0;
            //Message('Done. Lines successfully moved to General Journal.');
        end
        //else
        //Message('No unprocessed records to move to journal');

    end;


}
