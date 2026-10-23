pageextension 50613 "Cash Receipt Jnl Ext" extends "Cash Receipt Journal"
{
    actions
    {
        addafter("Apply Entries")
        {
            action(Calculate_Commision)
            {
                Caption = 'Calculate Commission';
                Image = Calculate;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}
