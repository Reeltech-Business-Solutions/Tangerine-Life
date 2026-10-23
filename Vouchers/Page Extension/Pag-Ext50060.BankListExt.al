pageextension 50619 BankListExt extends "Bank Account List"
{
    layout
    {
        addbefore(BalanceAmt)
        {
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = All;
            }
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
                ApplicationArea = All;
            }
        }
    }
}
