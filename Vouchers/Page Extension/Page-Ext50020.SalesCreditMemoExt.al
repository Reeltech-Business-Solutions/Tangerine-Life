pageextension 50620 SalesCrMemoExt extends "Sales Credit Memo"
{
    layout
    {
        addafter(Status)
        {
            field("Admin Fee %"; Rec."Admin Fee %")
            {
                ApplicationArea = All;

            }
        }
    }

}

