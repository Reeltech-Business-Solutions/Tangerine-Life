page 50628 StaffAdvanceLine
{
    ApplicationArea = All;
    Caption = 'StaffAdvanceLine';
    PageType = ListPart;
    SourceTable = "Staff Advance Lines";


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field("Date Issued"; Rec."Date Issued")
                {
                    ToolTip = 'Specifies the value of the Date Issued field.';
                    ApplicationArea = All;
                }
                field("Advance Type"; Rec."Advance Type")
                {
                    ToolTip = 'Specifies the value of the Advance Type field.';
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        IsDeepInsert: Boolean;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        StaffAdvHeader: Record "Staff Advance Header";
        StaffAdvLine: Record "Staff Advance Lines";
    begin
        if IsDeepInsert then begin
            StaffAdvHeader.GetBySystemId(Rec."Header Id");
            Rec."No." := StaffAdvHeader."No.";
            StaffAdvLine.SetRange("No.", Rec."No.");
            if StaffAdvLine.FindLast() then
                Rec."Line No." := StaffAdvLine."Line No." + 10000
            else
                Rec."Line No." := 10000;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        StaffAdvHeader: Record "Staff Advance Header";
    begin
        IsDeepInsert := IsNullGuid(Rec."Header Id");
        if not IsDeepInsert then begin
            StaffAdvHeader.GetBySystemId(Rec."Header Id");
            Rec."No." := StaffAdvHeader."No.";
        end;
    end;
}