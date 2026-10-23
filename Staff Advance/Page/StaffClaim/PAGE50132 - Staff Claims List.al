page 50681 "Staff Claim List"
{
    Caption = 'Staff Claim List';
    PageType = List;
    SourceTable = "Staff Claim Lines";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Advance Type"; Rec."Advance Type")
                {
                    ApplicationArea = All;
                }
                field(No; Rec.No)
                {
                    Editable = true;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Account type"; Rec."Account type")
                {
                    Caption = 'Account Type';
                    ApplicationArea = All;
                }
                field("Account No:"; Rec."Account No:")
                {
                    ApplicationArea = All;
                    Editable = Edit1;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;

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
                field("Claim Receipt No"; Rec."Claim Receipt No")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Expenditure Date"; Rec."Expenditure Date")
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    Caption = 'Expenditure Description';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        StaffClaimsHeader.SetRange("No.", StaffClaimLines.No);
        if StaffClaimsHeader.Find('-') then begin
            if StaffClaimsHeader.Status = StaffClaimsHeader.Status::Open then
                Edit1 := false;
        end;
    end;

    trigger OnOpenPage()
    begin
        Edit1 := true;
    end;

    var
        PayLine: Record "Voucher Line";
        Bal: Decimal;
        StaffClaimsHeader: Record "Staff Claims Header";
        StaffClaimLines: Record "Staff Claim Lines";
        Edit1: Boolean;
}

