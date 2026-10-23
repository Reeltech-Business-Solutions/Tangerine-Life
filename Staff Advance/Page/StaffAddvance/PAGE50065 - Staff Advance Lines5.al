page 50669 "Staff Advance Lines"
{
    Caption = 'Staff Advance Rqt Line';
    PageType = ListPart;
    SourceTable = "Staff Advance Lines";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = Editno;
                ShowCaption = false;
                field("Advance Type"; Rec."Advance Type")
                {
                    ApplicationArea = all;

                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Caption = 'Description';
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Type of Advance"; Rec."Type of Advance")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    //Editable = false;
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = Editno;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin

                        /*{Get the total amount paid}
                        Bal:=0;
                        
                        PayHeader.RESET;
                        PayHeader.SETRANGE(PayHeader."Line No.",No);
                        IF PayHeader.FINDFIRST THEN
                          BEGIN
                            PayLine.RESET;
                            PayLine.SETRANGE(PayLine.No,PayHeader."Line No.");
                            IF PayLine.FIND('-') THEN
                              BEGIN
                                REPEAT
                                  Bal:=Bal + PayLine."Pay Mode";
                                UNTIL PayLine.NEXT=0;
                              END;
                          END;
                        //Bal:=Bal + Amount;
                        
                        IF Bal > PayHeader.Amount THEN
                          BEGIN
                            ERROR('Please ensure that the amount inserted does not exceed the amount in the header');
                          END;
                          */

                    end;
                }
                field("Amount LCY"; Rec."Amount LCY")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                    Caption = 'Payment Date';
                }
                field("Date Issued"; Rec."Date Issued")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    Visible = true;
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        DimVal.Reset;
                        DimVal.SetRange(DimVal."Global Dimension No.", 1);
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        DimVal.Reset;
                        DimVal.SetRange(DimVal."Global Dimension No.", 2);
                    end;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Editno := true;
        if Rec.Status <> Rec.Status::Open
        then
            Editno := false;
    end;


    var
        PayHeader: Record "Staff Advance Header";
        PayLine: Record "Staff Advance Lines";
        Bal: Decimal;
        DimVal: Record "Dimension Value";
        Editno: Boolean;
}

