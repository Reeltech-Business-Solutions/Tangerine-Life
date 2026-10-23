page 50737 "Tangerine-List"
{
    ApplicationArea = All;
    Caption = 'CBA';
    PageType = List;
    SourceTable = TangerinelifeCBA;
    CardPageId = TangerineCBA;
    UsageCategory = Lists;
    AdditionalSearchTerms = 'CBA';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                    Caption = 'No.';
                }
                field(Ledger_name; Rec.Ledger_name)
                {
                    ToolTip = 'Specifies the value of the Ledger_name field.', Comment = '%';
                    caption = 'Ledger Name';
                }
                field(ledger_code; Rec.ledger_code)
                {
                    ToolTip = 'Specifies the value of the ledger_code field.', Comment = '%';
                    Caption = 'Ledger Code';
                }
                field(account_class_name; Rec.account_class_name)
                {
                    ToolTip = 'Specifies the value of the account_class_name field.', Comment = '%';
                    caption = 'Account Class Name';
                }
                field(transaction_class_name; Rec.transaction_class_name)
                {
                    ToolTip = 'Specifies the value of the transaction_class_name field.', Comment = '%';
                    caption = 'Transaction Class Name';
                }
                field(transaction_class_code; Rec.transaction_class_code)
                {
                    ToolTip = 'Specifies the value of the transaction_class_code field.', Comment = '%';
                    Caption = 'Transaction Class Code';
                }
                field(refnum; Rec.refnum)
                {
                    ToolTip = 'Specifies the value of the refnum field.', Comment = '%';
                    Caption = 'RefNum';
                }
                field(credit_balance; Rec.credit_balance)
                {
                    ToolTip = 'Specifies the value of the credit_balance field.', Comment = '%';
                }
                field(debit_balance; Rec.debit_balance)
                {
                    ToolTip = 'Specifies the value of the debit_balance field.', Comment = '%';
                }
                // field(note; Rec.note)
                // {
                //     ToolTip = 'Specifies the value of the note field.', Comment = '%';
                // }
                // field(account_class_code; Rec.account_class_code)
                // {
                //     ToolTip = 'Specifies the value of the account_class_code field.', Comment = '%';
                // }
                // field(opening_balance; Rec.opening_balance)
                // {
                //     ToolTip = 'Specifies the value of the opening_balance field.', Comment = '%';
                // }
                // field(balance_bf; Rec.balance_bf)
                // {
                //     ToolTip = 'Specifies the value of the balance_bf field.', Comment = '%';
                // }
                // field(period_balance; Rec.period_balance)
                // {
                //     ToolTip = 'Specifies the value of the period_balance field.', Comment = '%';
                // }
                // field(current_balance; Rec.current_balance)
                // {
                //     ToolTip = 'Specifies the value of the current_balance field.', Comment = '%';
                // }
                // field(credit_balance; Rec.credit_balance)
                // {
                //     ToolTip = 'Specifies the value of the credit_balance field.', Comment = '%';
                // }
                // field(debit_balance; Rec.debit_balance)
                // {
                //     ToolTip = 'Specifies the value of the debit_balance field.', Comment = '%';
                // }
                // field(cheque_num; Rec.cheque_num)
                // {
                //     ToolTip = 'Specifies the value of the cheque_num field.', Comment = '%';
                // }
                // field(effective_date; Rec.effective_date)
                // {
                //     ToolTip = 'Specifies the value of the effective_date field.', Comment = '%';
                // }
                // field(transaction_date; Rec.transaction_date)
                // {
                //     ToolTip = 'Specifies the value of the transaction_date field.', Comment = '%';
                // }
                // field(entry_date; Rec.entry_date)
                // {
                //     ToolTip = 'Specifies the value of the entry_date field.', Comment = '%';
                // }
                // field(proposal_number; Rec.proposal_number)
                // {
                //     ToolTip = 'Specifies the value of the proposal_number field.', Comment = '%';
                // }
                // field(policy_number; Rec.policy_number)
                // {
                //     ToolTip = 'Specifies the value of the policy_number field.', Comment = '%';
                // }
                // field(policy_class; Rec.policy_class)
                // {
                //     ToolTip = 'Specifies the value of the policy_class field.', Comment = '%';
                // }
                // field(debit_note; Rec.debit_note)
                // {
                //     ToolTip = 'Specifies the value of the debit_note field.', Comment = '%';
                // }
                // field(bank; Rec.bank)
                // {
                //     ToolTip = 'Specifies the value of the bank field.', Comment = '%';
                // }
                // field(bank_refid; Rec.bank_refid)
                // {
                //     ToolTip = 'Specifies the value of the bank_refid field.', Comment = '%';
                // }
                // field(branch; Rec.branch)
                // {
                //     ToolTip = 'Specifies the value of the branch field.', Comment = '%';
                // }
                // field(agency; Rec.agency)
                // {
                //     ToolTip = 'Specifies the value of the agency field.', Comment = '%';
                // }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            /*  action("Fetch from CBA")
              {

                  Promoted = true;
                  PromotedCategory = Process;
                  // PromotedIsBig = true;
                  Image = Create;
                  trigger OnAction()
                  var
                      dialog: Page dialog;
                      startDate: date;
                      endDate: date;
                      callAPI: Codeunit tangerine_life_cba;
                      cba: Record TangerinelifeCBA;



                  begin
                      if dialog.RunModal() = Action::OK then begin
                          startDate := dialog.GetstartDate();
                          endDate := dialog.GetEndDate();
                      end;
                      // Cba.Reset();
                      // if not CheckUnprocessedBeforeDelete() then
                      //     exit else if CheckUnprocessedBeforeDelete() then
                      //              if not Confirm('There are records in the CBA table. Do you want to delete them and import new data?', false) then
                      //                  exit;
                      // cba.DeleteAll();
                      callAPI.HttpGetTangerineLive(startDate, endDate, false, false, true);
                  end;
              }*/

            //    action("Regenerate CBA")
            //     {

            //         Promoted = true;
            //         PromotedCategory = Process;
            //         // PromotedIsBig = true;
            //         Image = Create;
            //         trigger OnAction()
            //         var
            //             dialog: Page dialog;
            //             startDate: date;
            //             endDate: date;
            //             callAPI: Codeunit tangerine_life_cba;
            //             cba: Record TangerinelifeCBA;


            //         begin
            //             if dialog.RunModal() = Action::OK then begin
            //                 startDate := dialog.GetstartDate();
            //                 endDate := dialog.GetEndDate();
            //             end;
            //             Cba.Reset();
            //             // if not CheckUnprocessedBeforeDelete() then
            //             //   exit;

            //             // Then check if any records exist at all before deleting
            //             /*  CBA.Reset();
            //               if CBA.FindFirst() then
            //                   if not Confirm('There are records in the CBA table. Do you want to delete them and import new data?', false) then
            //                       exit;
            //               cba.DeleteAll();*/
            //             callAPI.HttpGetTangerineLive(startDate, endDate, true, false);

            //         end;
            //     }

            // action("Move to General Journal")
            // {

            //     Promoted = true;
            //     PromotedCategory = Process;

            //     Image = Journal;

            //     trigger OnAction()
            //     var
            //         GenJnl: Codeunit MoveToGeneralJournal;
            //         GeneralJournal: Record "Gen. Journal Line";
            //         GeneralJournalPage: page "General Journal";
            //     begin
            //         GeneralJournal.Reset();
            //         GenJnl.MoveToGeneralJournalLine();
            //         Message('Item moved to general journal successfully!');

            //         // GeneralJournal.setRange("Journal Template Name", 'GENERAL');
            //         // GeneralJournal.setRange("Journal Batch Name", 'CBA');
            //         // if GeneralJournal.Findfirst() then begin
            //         //     GeneralJournalPage.SetTableView(GeneralJournal);
            //         //     GeneralJournalPage.Run();
            //         //end;



            //     end;

            // }
            action("Register Job Queue")
            {
                promoted = true;
                PromotedCategory = process;
                Image = Job;
                ApplicationArea = all;

                trigger OnAction()
                var
                    jobQueue: Codeunit JobQueue;
                begin
                    Jobqueue.RegisterCBADailyJob();

                end;
            }

            action("Register Attachment")
            {
                promoted = true;
                PromotedCategory = process;
                Image = Job;
                ApplicationArea = all;

                trigger OnAction()
                var
                    Scheduler: Codeunit "FnO Job Queue Scheduler";
                begin
                    Scheduler.ScheduleImportJob();

                end;
            }

            action("ImportExpAttachedDocuments")
            {
                ApplicationArea = All;
                Caption = 'Import Exp Attached Documents';
                ToolTip = 'Pulls all Expense Attached Documents from F&O and stores them locally.';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ExpImport: Codeunit "FnO Exp Attachment Import";
                    Imported: Integer;
                    Skipped: Integer;
                begin
                    if not Confirm('This will import all Expense Attached Documents from F&O. Continue?') then
                        exit;

                    ExpImport.ImportAllAttachments(Imported, Skipped);

                    Message('Import complete.\Imported: %1\nSkipped: %2', Imported, Skipped);
                end;
            }
        }

    }

    local procedure CheckUnprocessedBeforeDelete(): Boolean
    var
        CBAImport: Record TangerinelifeCBA;
        UnprocessedCount: Integer;
    begin
        CBAImport.Reset();
        CBAImport.SetRange("Is Processed", false);
        UnprocessedCount := CBAImport.Count();

        if UnprocessedCount > 0 then begin
            if not Confirm(
                'WARNING: There are %1 UNPROCESSED records in the staging table.\' +
                'These have NOT been posted to GL yet.\' +
                'Deleting them means they will be LOST.\' +
                '\Are you sure you want to delete and replace?',
                false,
                UnprocessedCount) then
                exit(false);
        end;

        exit(true);
    end;
}