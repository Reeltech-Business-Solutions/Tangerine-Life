codeunit 50607 "Tax Calculation1"
{

    trigger OnRun()
    begin
    end;

    procedure CalculateTax(Rec: Record "Payments Line"; CalculationType: Option VAT,"W/Tax",Retention) Amount: Decimal
    begin
        case CalculationType of
            CalculationType::VAT:
                begin
                    Amount := (Rec."VAT Rate" / (100 + Rec."VAT Rate")) * Rec.Amount;
                    exit(Amount);
                end;
            CalculationType::"W/Tax":
                begin
                    // Amount := (Rec.Amount - ((Rec."VAT Rate" / (100 + Rec."VAT Rate")) * Rec.Amount))
                    // * (Rec."W/Tax Rate" / (100 + Rec."W/Tax Rate"));
                    Amount := (Rec.Amount / (100 + rec."VAT Rate")) * rec."W/Tax Rate";
                    exit(Amount);


                end;
        /*
    CalculationType::Retention:
        begin
            Amount := (Rec.Amount - ((Rec."VAT Rate" / (100 + Rec."VAT Rate")) * Rec.Amount))
             * (Rec."Retention Rate" / 100);
        end;
        */
        end;
    end;

    procedure CalculatePurchTax(Rec: Record "Purchase Line"; CalculationType: Option VAT,"W/Tax",Retention) Amount: Decimal
    begin
        /*
        CASE CalculationType OF
          CalculationType::VAT:
            BEGIN
                //Amount:=(Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount;
                Amount:=(Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount;
            END;
          CalculationType::"W/Tax":
            BEGIN
                //Amount:=(Rec.Amount-((Rec."VAT Rate"/(100+Rec."VAT Rate"))*Rec.Amount))
                //*(Rec."W/Tax Rate"/100);
                Amount:=(Rec.Amount*(Rec."W/Tax Rate"/(100+Rec."VAT Rate")));
        
            END;
          CalculationType::Retention:
            BEGIN
                Amount:=(Rec.Amount-((Rec."VAT Rate"/100)*Rec.Amount))
                 *(Rec."Retention Rate"/100);
            END;
        END;
        */

    end;

    procedure AutoSignature(var DocNo: Code[20]) SignStatus: Boolean
    var
        Signapproved: Boolean;
        AutoSinature3: Boolean;
        Signrejected: Boolean;
        SignapprovedUser: Boolean;
        SignrejectedUser: Boolean;
        ApprovalEntry: Record "Approval Entry";
    begin
        AutoSinature3 := false;
        Signapproved := false;
        Signrejected := false;
        SignapprovedUser := false;
        SignrejectedUser := false;
        //DocNo :=''

        //CLEAR(ApprovalEntry.Status);
        ApprovalEntry.SetCurrentKey(ApprovalEntry."Document No.", ApprovalEntry.Status);
        ApprovalEntry.SetFilter(ApprovalEntry.Status, '%1|%2|%3', ApprovalEntry.Status::Approved, ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
        ApprovalEntry.SetRange(ApprovalEntry."Document No.", DocNo);
        if ApprovalEntry.Find('-') then begin
            repeat
                Message(Format(ApprovalEntry.Status));
                if (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                    Signapproved := true;
                if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or (ApprovalEntry.Status = ApprovalEntry.Status::Created) then
                    Signrejected := true;
            until ApprovalEntry.Next = 0;
            SignapprovedUser := Signapproved;
            SignrejectedUser := Signrejected;

        end;
        if ((SignapprovedUser = true) and (SignrejectedUser = true)) then
            SignStatus := false
        else
            if ((SignapprovedUser = false) and (SignrejectedUser = true)) then
                SignStatus := false
            else
                if ((SignapprovedUser = true) and (SignrejectedUser = false)) then
                    SignStatus := true
                else
                    if ((SignapprovedUser = false) and (SignrejectedUser = false)) then
                        SignStatus := false;
    end;
}

