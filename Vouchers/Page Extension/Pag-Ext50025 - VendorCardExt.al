pageextension 50616 VendorExt extends "Vendor Card"
{
    Layout
    {
        addafter(Name)
        {
            field("Vendor Type"; Rec."Vendor Type")
            {
                ApplicationArea = All;

                Importance = Promoted;
            }
            field("Commission %"; Rec."Commission %")
            {
                Caption = 'Broker s Commission %';
                ApplicationArea = All;
            }

        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // if rec."Vendor Type" = rec."Vendor Type"::" " then
        //     Error('Please select Vendor Type');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then begin
            if UserSet."Create Vend" = false then
                Error('You are not permitted to create vendors');
        end;
    end;

}