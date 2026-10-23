table 50602 TangerinelifeCBA
{
    Caption = 'TangerinelifeCBA';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; code[20])
        {
            Caption = 'No';
            // AutoIncrement = true;
        }
        field(2; Ledger_name; Code[100])
        {
            Caption = 'Ledger Name';
        }
        field(3; ledger_code; Code[30])
        {
            Caption = 'Ledger Code';
        }
        field(4; account_class_name; Text[100])
        {
            Caption = 'Account Class Name';
        }
        field(5; transaction_class_name; Text[100])
        {
            Caption = 'Transaction Class Name';
        }
        field(6; transaction_class_code; Code[30])
        {
            Caption = 'Transaction Class Code';
        }
        field(7; refnum; Code[30])
        {
            Caption = 'RefNum';
        }
        field(8; note; Text[500])
        {
            Caption = 'Note';
        }
        field(9; opening_balance; decimal)
        {
            Caption = 'Opening Balance';
        }
        field(10; balance_bf; decimal)
        {
            Caption = 'Balance BF';
        }
        field(11; period_balance; decimal)
        {
            Caption = 'Period Balance';
        }
        field(12; current_balance; decimal)
        {
            Caption = 'Current Balance';
        }
        field(13; credit_balance; decimal)
        {
            Caption = 'Credit Balance';
        }
        field(14; debit_balance; decimal)
        {
            Caption = 'Debit Balance';
        }
        field(15; cheque_num; Code[200])
        {
            Caption = 'Cheque Num';
        }
        field(16; effective_date; Date)
        {
            Caption = 'Effective Date';
        }
        field(17; transaction_date; Date)
        {
            Caption = 'Transaction Date';
        }
        field(18; entry_date; Date)
        {
            Caption = 'Entry Date';
        }
        field(19; proposal_number; Code[50])
        {
            Caption = 'Proposal Number';
        }
        field(20; policy_number; Code[50])
        {
            Caption = 'Policy Number';
        }
        field(21; policy_class; Code[10])
        {
            Caption = 'Policy Class';
        }
        field(22; debit_note; Text[30])
        {
            Caption = 'Debit Note';
        }
        field(23; bank; Code[30])
        {
            Caption = 'Bank';
        }
        field(24; bank_refid; Text[200])
        {
            Caption = 'Bank Refid';
        }
        field(25; branch; Code[30])
        {
            Caption = 'Branch';
        }
        field(26; agency; Code[30])
        {
            Caption = 'Agency';
        }
        field(27; account_class_code; code[10])
        {
            Caption = 'Account Class Code';
        }
        field(28; "is Processed"; boolean)
        {
            Caption = 'is Processed';
        }

        field(29; business_central_gl; code[20])
        {
            Caption = 'Account Class Code';
        }

        field(30; business_central_bank; code[20])
        {
            Caption = 'Account Class Code';
        }

        field(32; currency; text[10])
        {
            Caption = 'currency';
        }

        field(33; fx_value; decimal)
        {
            Caption = 'fx_value';
        }


        field(34; product_dimension; code[100])
        {
            Caption = 'Product Dimension';
        }

        field(35; branch_dimension; code[100])
        {
            Caption = 'Branch Dimension';
        }

        field(36; department_dimension; code[100])
        {
            Caption = 'Department Dimension';
        }

        
        field(37; beneficiary; code[100])
        {
            Caption = 'Beneficiary';
        }
    }
    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }
}
