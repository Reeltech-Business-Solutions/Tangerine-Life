page 50627 StaffAdvanceLineAPI
{
    PageType = ListPart;
    SourceTable = "Staff Advance Lines";
    DelayedInsert = true;
    AutoSplitKey = true;
    PopulateAllFields = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Format(Rec.SystemId, 0, 4).ToLower()) { ApplicationArea = All; }
                field(AdvanceType; Rec."Advance Type")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(lineNo; Rec."Line No.") { ApplicationArea = All; }
            }
        }
    }
    var
        IsDeepInsert: Boolean;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SAdvHeader: Record "Staff Advance Header";
        SAdvLine: Record "Staff Advance Lines";
    begin
        if IsDeepInsert then begin
            SAdvHeader.GetBySystemId(Rec."Header Id");
            Rec."No." := SAdvHeader."No.";
            SAdvLine.SetRange("No.", Rec."No.");
            if SAdvLine.FindLast() then
                Rec."Line No." := SAdvLine."Line No." + 10000
            else
                Rec."Line No." := 10000;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SAdvHeader: Record "Staff Advance Header";
    begin
        IsDeepInsert := IsNullGuid(Rec."Header Id");
        if not IsDeepInsert then begin
            SAdvHeader.GetBySystemId(Rec."Header Id");
            Rec."No." := SAdvHeader."No.";
        end;
    end;
}
