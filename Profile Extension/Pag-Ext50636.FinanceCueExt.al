pageextension 50636 FinanceCueExt extends "Account Manager Activities"
{
    layout
    {
        addafter("SOs Pending Approval")
        {
            field("Adv. Not Retired"; Rec."Adv. Not Retired")
            {
                Caption = 'Staff advance not retired';
                ApplicationArea = All;
                DrillDownPageId = "Posted Staff Adv Request List";

            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter("Adv Date Filter", '<=%1', Today);
    end;
}

