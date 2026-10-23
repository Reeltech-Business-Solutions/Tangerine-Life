pageextension 50609 LocationListExt extends "Location List"
{
    trigger OnOpenPage()
    var
        WHSE: Record "Warehouse Employee";
        Loc: Record Location;
    begin
        WHSE.Reset();
        WHSE.FilterGroup(-1);
        WHSE.SetRange("User ID", UserId);
        WHSE.SetRange("Location Code", Loc.Code);
        if WHSE.FindSet() then begin
            if rec.Code <> WHSE."Location Code" then
                rec.SetRange(Code, WHSE."Location Code");
            WHSE.FilterGroup(0);
        end;
    end;
}
