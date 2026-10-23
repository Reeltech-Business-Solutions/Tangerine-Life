codeunit 50628 MoveToGeneralJournal2
{


    procedure MoveToGeneralJournalLine(FromDate: Date; ToDate: Date)
    var
        CBA: Record TangerinelifeCBA;
        GeneralJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TotalMoved: Integer;
        IsSkipped: Boolean;
        TotalSkipped: Integer;
        GLEntry: Record "G/L Entry";
        IES2codeunit: codeunit IES2;
        DimMgt: Codeunit DimensionManagement;
        DimSetID: Integer;
    begin
        CBA.Reset();
        CBA.SetRange("is Processed", false);
        CBA.SetRange(effective_date, FromDate, ToDate);

        if CBA.FindSet() then begin

            GeneralJournalLine.Reset();
            GeneralJournalLine.SetRange("Journal Template Name", 'CBA');
            GeneralJournalLine.SetRange("Journal Batch Name", 'CBA');
            if GeneralJournalLine.FindFirst() then
                GeneralJournalLine.DeleteAll();



            LineNo := 10000;

            repeat
                IsSkipped := false;

                // Skip if zero balances or both account fields empty
                if ((Abs(CBA.debit_balance) < 0.01) and (Abs(CBA.credit_balance) < 0.01))
                    // or ((CBA.business_central_bank = '') and (CBA.business_central_gl = '')) 
                    then begin
                    CBA."is Processed" := true;
                    CBA.Modify();
                    TotalSkipped += 1;
                    IsSkipped := true;
                end;

                if (CBA.currency <> '') and (abs(CBA.fx_value) < 0.01) then begin
                    CBA."is Processed" := true;
                    CBA.Modify();
                    TotalSkipped += 1;
                    IsSkipped := true;
                end;

                // Skip if already posted to GL
                if not IsSkipped then begin
                    GLEntry.Reset();
                    GLEntry.SetRange("CBA Trans ID", CBA.No);
                    if GLEntry.FindFirst() then begin
                        TotalSkipped += 1;
                        IsSkipped := true;
                    end;
                end;

                if not IsSkipped then begin
                    GeneralJournalLine.Init();
                    GeneralJournalLine.Validate("Journal Template Name", 'CBA');
                    GeneralJournalLine.Validate("Journal Batch Name", 'CBA');
                    GeneralJournalLine.Validate("Line No.", LineNo);

                    GeneralJournalLine.Validate("Debit Amount", CBA.debit_balance);
                    GeneralJournalLine.Validate("Credit Amount", Abs(CBA.credit_balance));
                    GeneralJournalLine.Validate("Posting Date", CBA.effective_date);
                    GeneralJournalLine.Validate("Account Class Name", CBA.account_class_name);
                    GeneralJournalLine.Validate("Transaction Class Name", CBA.transaction_class_name);
                    GeneralJournalLine.Validate("Transaction Class Code", CBA.transaction_class_code);
                    GeneralJournalLine.Validate("Account Class Code", CBA.account_class_code);
                    if (CBA.refnum <> '') then
                        GeneralJournalLine.Validate("Document No.", CBA.refnum) else
                        GeneralJournalLine.validate("Document No.", CBA.debit_note);
                    //GeneralJournalLine.Validate(Description, CBA.note);
                    GeneralJournalLine.Validate("Cheque Num", CBA.cheque_num);
                    GeneralJournalLine.Validate("Effective Date", CBA.effective_date);
                    GeneralJournalLine.Validate("Transaction Date", CBA.transaction_date);
                    GeneralJournalLine.Validate("Proposal Number", CBA.proposal_number);
                    GeneralJournalLine.Validate("Policy Number", CBA.policy_number);
                    GeneralJournalLine.Validate("Policy Class", CBA.policy_class);
                    GeneralJournalLine.Validate(Branch, CBA.branch);
                    GeneralJournalLine.Validate(Agency, CBA.agency);
                    GeneralJournalLine.Validate("Bank ref id", CBA.bank_refid);
                    GeneralJournalLine.Validate("CBA Trans ID", CBA.No);
                    GeneralJournalLine.Validate(beneficiary, CBA.beneficiary);
                    GeneralJournalLine."CBA Processed" := true;

                    // Resolve account type
                    if (CBA.business_central_bank <> '') and (CBA.business_central_gl <> '') then begin
                        // Both populated — Bank as primary, GL as balancing
                        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"Bank Account");
                        GeneralJournalLine.Validate("Account No.", CBA.business_central_bank);
                        GeneralJournalLine.Validate("Bal. Account Type", GeneralJournalLine."Bal. Account Type"::"G/L Account");
                        GeneralJournalLine.Validate("Bal. Account No.", CBA.business_central_gl);

                    end else if CBA.business_central_bank <> '' then begin
                        // Only Bank Account
                        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"Bank Account");
                        GeneralJournalLine.Validate("Account No.", CBA.business_central_bank);

                    end else if CBA.business_central_gl <> '' then begin
                        // Only GL Account
                        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"G/L Account");
                        GeneralJournalLine.Validate("Account No.", CBA.business_central_gl);

                    end;

                    if CBA.currency <> '' then begin
                        GeneralJournalLine.Validate("Currency Code", cba.currency);

                        if CBA.debit_balance <> 0 then begin
                            GeneralJournalLine.Validate("Debit Amount", CBA.fx_value);
                            GeneralJournalLine.Validate("Amount (LCY)", Round(CBA.debit_balance, 0.01));
                            GeneralJournalLine."Amount (LCY)" := Round(CBA.debit_balance, 0.01);
                        end;

                        if CBA.credit_balance <> 0 then begin
                            GeneralJournalLine.Validate("Credit Amount", Abs(CBA.fx_value));
                            GeneralJournalLine.Validate("Amount (LCY)", -Round(Abs(CBA.credit_balance), 0.01));
                            GeneralJournalLine."Amount (LCY)" := -Round(Abs(CBA.credit_balance), 0.01);
                        end;
                    end else begin
                        if CBA.debit_balance <> 0 then
                            GeneralJournalLine.Validate("Debit Amount", CBA.debit_balance);
                        if CBA.credit_balance <> 0 then
                            GeneralJournalLine.Validate("Credit Amount", Abs(CBA.credit_balance));
                    end;

                    GeneralJournalLine.Description := CopyStr(CBA.note, 1, 100);

                    if CBA.product_dimension <> '' then begin
                        GeneralJournalLine."Shortcut Dimension 1 Code" := CBA.product_dimension;
                        DimMgt.ValidateShortcutDimValues(
                            1,
                            GeneralJournalLine."Shortcut Dimension 1 Code",
                            GeneralJournalLine."Dimension Set ID"  // Updated by reference
                        );
                        // Explicitly assign it back to make sure it sticks
                        GeneralJournalLine.Validate("Shortcut Dimension 1 Code", CBA.product_dimension);
                    end;


                    if CBA.department_dimension <> '' then begin
                        GeneralJournalLine."Shortcut Dimension 2 Code" := CBA.department_dimension;
                        DimMgt.ValidateShortcutDimValues(
                            2,
                            GeneralJournalLine."Shortcut Dimension 2 Code",
                            GeneralJournalLine."Dimension Set ID"  // Updated by reference
                        );
                        // Explicitly assign it back to make sure it sticks
                        GeneralJournalLine.Validate("Shortcut Dimension 2 Code", CBA.department_dimension);
                    end;

                    if CBA.branch_dimension <> '' then begin
                        GeneralJournalLine."Shortcut Dimension 3 Code" := CBA.branch_dimension;
                        DimMgt.ValidateShortcutDimValues(
                            3,
                            GeneralJournalLine."Shortcut Dimension 3 Code",
                            GeneralJournalLine."Dimension Set ID"  // Updated by reference
                        );
                        // Explicitly assign it back to make sure it sticks
                        GeneralJournalLine.Validate("Shortcut Dimension 3 Code", CBA.branch_dimension);
                    end;
                    // Only insert if account was successfully resolved
                    if not IsSkipped then begin
                        GeneralJournalLine.Insert(true);
                        LineNo += 10000;
                        TotalMoved += 1;
                    end;
                end;

            until CBA.Next() = 0;
        end
        else begin
            GeneralJournalLine.Reset();
            GeneralJournalLine.SetRange("Journal Template Name", 'CBA');
            GeneralJournalLine.SetRange("Journal Batch Name", 'CBA');
            if GeneralJournalLine.FindFirst() then
                GeneralJournalLine.DeleteAll();
            // IES2codeunit.SendPostingFailureMailEmptyJournal('No journal lines found in GENERAL/CBA2 to post.');
            // exit;
        end;
    end;
}