page 50677 "Staff Claim Lines"
{
    Caption = 'Staff Claim Line';

    PageType = ListPart;
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
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Account type"; Rec."Account type")
                {
                    Caption = 'Account Type';
                    ApplicationArea = All;
                }
                field("Account No:"; Rec."Account No:")
                {
                    Editable = Edit1;
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Caption = 'Description';
                    Editable = false;
                    ApplicationArea = All;
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
                field("With-Holding Tax Code"; Rec."With-Holding Tax Code")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        WithHoldTax: Record "Withholding Tax";
                    begin
                        if WithHoldTax.Get(Rec."With-Holding Tax Code") then begin
                            Rec."Withholding Tax %" := WithHoldTax.Percentage;
                        end else
                            Rec."Withholding Tax %" := 0;

                    end;
                }
                field("Withholding Tax %"; Rec."Withholding Tax %")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Claim Receipt No"; Rec."Claim Receipt No")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Expenditure Date"; Rec."Expenditure Date")
                { ApplicationArea = All; }
                field(Purpose; Rec.Purpose)
                {
                    Caption = 'Expenditure Description';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                { ApplicationArea = All; }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                { ApplicationArea = All; }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    //Visible = false;
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Generate Withholding Tax")
            {
                ApplicationArea = All;
                caption = 'Generate WithHolding Tax';
                Image = CalculateCost;
                
                trigger OnAction()

                begin

                    if not confirm('Do you want to continue?', false) then
                        exit;

                    witholdingTax2();
                end;
            }
        }
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


    procedure witholdingTax2()

    var
        StaffClaimsLine: Record "Staff Claim Lines";
        StaffClaimsLine2: Record "Staff Claim Lines";
        ClaimsHeader: Record "Staff Claims Header";
        NewLine: Record "Staff Claim Lines";
        LineNo: Integer;
        TotalBaseAmount: Decimal;
        WHTPercent: Decimal;
        WHTAmount: Decimal;
        BaseLine: Record "Staff Claim Lines";
        WhtResult: Decimal;
        checkWHT: Boolean;
        StaffClaimsLine3: Record "Staff Claim Lines";
        StaffClaimsLine4: Record "Staff Claim Lines";
        wthAccount: code[20];
        percentage: decimal;
        Accessories: code[20];
        BaseLine2: Record "Staff Claim Lines";
        wthTax: Record "Withholding Tax";



    begin

        staffClaimsLine3.Reset();
        staffClaimsLine3.setRange(No, Rec.No);
        StaffClaimsLine3.setRange("WHT Base Line No", Rec."Line No.");
        if StaffClaimsLine3.findfirst() then
            StaffClaimsLine3.Delete();




        StaffClaimsLine.Init();
        StaffClaimsLine.SetRange(No, Rec.No);
        StaffClaimsLine.SetFilter("With-Holding Tax Code", '<>%1', '');
        StaffClaimsLine.SetRange("Line No.", Rec."Line No.");
        staffClaimsLine.setfilter("WHT Base Line No", '<%1', 1);

        if StaffClaimsLine.Find('-') then begin

            // repeat

            StaffClaimsLine.Validate(No, Rec.No);
            StaffClaimsLine2.SetRange(No, StaffClaimsLine.No);
            if StaffClaimsLine2.FindLast() then
                StaffClaimsLine."Line No." := StaffClaimsLine2."Line No." + 10000
            else
                StaffClaimsLine."Line No." := 10000;
            StaffClaimsLine.validate("Account Type", StaffClaimsLine."Account type"::"G/L Account");
            if wthTax.Get(StaffClaimsLine."With-Holding Tax Code") then
                StaffClaimsLine."Account No:" := wthTax."WHT Account";

            StaffClaimsLine."Account Name" := CopyStr('WHT On ' + StaffClaimsLine."Account Name", 1, 100);

            StaffClaimsLine.Validate(Amount, Round((StaffClaimsLine.Amount) * ((StaffClaimsLine."Withholding Tax %" / 100) * -1), 0.01));

            StaffClaimsLine."WHT Base Line No" := Rec."Line No.";
            StaffClaimsLine.Insert(true);

          

        end;

        //  Message('With-Holding Tax created successfully.');

    end;
}

