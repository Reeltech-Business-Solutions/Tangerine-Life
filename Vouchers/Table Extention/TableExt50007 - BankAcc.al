tableextension 50618 BankAccExt extends "Bank Account" //MyTargetTableId
{
    fields
    {
        field(50000; "Bank Type"; Option)
        {
            Caption = 'Bank Type';
            DataClassification = ToBeClassified;
            OptionMembers = ,Normal,Cash,Cheque,EFT,LC;
        }
        field(70001; Cash; Boolean)
        {
        }
        field(70002; "G/L Account No."; Code[20])
        {
            CalcFormula = Lookup("Bank Account Posting Group"."G/L Account No." WHERE(Code = FIELD("Bank Acc. Posting Group")));
            FieldClass = FlowField;
        }
        field(70003; Bank; Boolean)
        {

        }
        field(70004; "Other Ledger"; Boolean)
        {

        }
    }
}

pageextension 50629 BankAccExt extends "Bank Account Card"
{
    layout
    {
        addafter("Bank Account No.")
        {
            field("Bank Type"; Rec."Bank Type")
            {
                ApplicationArea = All;
                OptionCaption = ',Normal,Cash,Cheque,EFT,LC';
            }
        }
    }
}