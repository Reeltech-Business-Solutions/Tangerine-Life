tableextension 50602 FinanceCueExt extends "Finance Cue"
{
    fields
    {
        field(50600; "Adv. Not Retired"; Integer)
        {
            CalcFormula = count("Staff Advance Header" where(Posted = const(true), "Expected Retire Date" = field("Adv Date Filter"), Retired = const(false)));
            FieldClass = FlowField;
        }
        field(50601; "Adv Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Editable = false;
        }
    }
}
