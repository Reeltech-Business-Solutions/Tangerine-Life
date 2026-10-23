page 50736 TangerineCBA
{
    ApplicationArea = All;
    Caption = 'TangerineCBA';
    PageType = Card;
    SourceTable = TangerinelifeCBA;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                }
                field(Ledger_name; Rec.Ledger_name)
                {
                    ToolTip = 'Specifies the value of the Ledger_name field.', Comment = '%';
                }
                field(ledger_code; Rec.ledger_code)
                {
                    ToolTip = 'Specifies the value of the ledger_code field.', Comment = '%';
                }
                field(account_class_name; Rec.account_class_name)
                {
                    ToolTip = 'Specifies the value of the account_class_name field.', Comment = '%';
                }
                field(account_class_code; Rec.account_class_code)
                {
                    ToolTip = 'Specifies the value of the account_class_code field.', Comment = '%';
                }
                field(transaction_class_name; Rec.transaction_class_name)
                {
                    ToolTip = 'Specifies the value of the transaction_class_name field.', Comment = '%';
                }
                field(transaction_class_code; Rec.transaction_class_code)
                {
                    ToolTip = 'Specifies the value of the transaction_class_code field.', Comment = '%';
                }
                field(refnum; Rec.refnum)
                {
                    ToolTip = 'Specifies the value of the refnum field.', Comment = '%';
                }
                field(note; Rec.note)
                {
                    ToolTip = 'Specifies the value of the note field.', Comment = '%';
                }
                field(opening_balance; Rec.opening_balance)
                {
                    ToolTip = 'Specifies the value of the opening_balance field.', Comment = '%';
                }
                field(balance_bf; Rec.balance_bf)
                {
                    ToolTip = 'Specifies the value of the balance_bf field.', Comment = '%';
                }
                field(period_balance; Rec.period_balance)
                {
                    ToolTip = 'Specifies the value of the period_balance field.', Comment = '%';
                }
                field(current_balance; Rec.current_balance)
                {
                    ToolTip = 'Specifies the value of the current_balance field.', Comment = '%';
                }
                field(credit_balance; Rec.credit_balance)
                {
                    ToolTip = 'Specifies the value of the credit_balance field.', Comment = '%';
                }
                field(debit_balance; Rec.debit_balance)
                {
                    ToolTip = 'Specifies the value of the debit_balance field.', Comment = '%';
                }
                field(cheque_num; Rec.cheque_num)
                {
                    ToolTip = 'Specifies the value of the cheque_num field.', Comment = '%';
                }
                field(effective_date; Rec.effective_date)
                {
                    ToolTip = 'Specifies the value of the effective_date field.', Comment = '%';
                }
                field(transaction_date; Rec.transaction_date)
                {
                    ToolTip = 'Specifies the value of the transaction_date field.', Comment = '%';
                }
                field(entry_date; Rec.entry_date)
                {
                    ToolTip = 'Specifies the value of the entry_date field.', Comment = '%';
                }
                field(proposal_number; Rec.proposal_number)
                {
                    ToolTip = 'Specifies the value of the proposal_number field.', Comment = '%';
                }
                field(policy_number; Rec.policy_number)
                {
                    ToolTip = 'Specifies the value of the policy_number field.', Comment = '%';
                }
                field(policy_class; Rec.policy_class)
                {
                    ToolTip = 'Specifies the value of the policy_class field.', Comment = '%';
                }
                field(debit_note; Rec.debit_note)
                {
                    ToolTip = 'Specifies the value of the debit_note field.', Comment = '%';
                }
                field(bank; Rec.bank)
                {
                    ToolTip = 'Specifies the value of the bank field.', Comment = '%';
                }
                field(bank_refid; Rec.bank_refid)
                {
                    ToolTip = 'Specifies the value of the bank_refid field.', Comment = '%';
                }
                field(branch; Rec.branch)
                {
                    ToolTip = 'Specifies the value of the branch field.', Comment = '%';
                }
                field(agency; Rec.agency)
                {
                    ToolTip = 'Specifies the value of the agency field.', Comment = '%';
                }
                field(currency; Rec.currency)
                {
                    ToolTip = 'Specifies the value of the currency field.', Comment = '%';
                }

                field(fx_value; Rec.fx_value)
                {
                    ToolTip = 'Specifies the value of the fx_value field.', Comment = '%';
                }


                field(beneficiary; Rec.beneficiary)
                {
                    ToolTip = 'Specifies the value of the fx_value field.', Comment = '%';
                }


                field(product_dimension; Rec.product_dimension)
                {
                    ToolTip = 'Specifies the value of the product dimension field.', Comment = '%';
                }

            }
        }
    }
}
