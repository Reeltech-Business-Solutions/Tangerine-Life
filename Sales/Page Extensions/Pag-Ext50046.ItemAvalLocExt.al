pageextension 50610 "ItemAval.LocExt" extends "Item Avail. by Location Lines"
{
    trigger OnOpenPage()
    var
        Whse: Record "Warehouse Employee";
    begin
        Whse.Reset();
        Whse.SetFilter("User ID", UserId);
        if Whse.find('-') then
            rec.SetFilter(Code, Whse."Location Code");
    end;
}
