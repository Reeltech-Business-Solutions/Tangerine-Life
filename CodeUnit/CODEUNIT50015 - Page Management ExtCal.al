codeunit 50613 applyvendorledger3
{

    trigger OnRun()
    begin
    end;

    var
        ApplyingVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        AppliedVendLedgEntry: Record "Vendor Ledger Entry";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        PurchHeader: Record "Purchase Header";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        TotalPurchLine: Record "Purchase Line";
        TotalPurchLineLCY: Record "Purchase Line";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        PurchPost: Codeunit "Purch.-Post";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        Navigate: Page Navigate;
        GenJnlLineApply: Boolean;
        AppliedAmount: Decimal;
        ApplyingAmount: Decimal;
        PmtDiscAmount: Decimal;
        ApplnDate: Date;
        ApplnCurrencyCode: Code[20];
        ApplnRoundingPrecision: Decimal;
        ApplnRounding: Decimal;
        ApplnType: Option " ","Applies-to Doc. No.","Applies-to ID";
        AmountRoundingPrecision: Decimal;
        VATAmount: Decimal;
        VATAmountText: Text[30];
        StyleTxt: Text;
        CalcType: Option Direct,GenJnlLine,PurchHeader,PV;
        VendEntryApplID: Code[50];
        AppliesToID: Code[50];
        ValidExchRate: Boolean;
        DifferentCurrenciesInAppln: Boolean;
        ShowAppliedEntries: Boolean;
        OK: Boolean;
        PostingDone: Boolean;
        // [InDataSet]
        AppliesToIDVisible: Boolean;
        ActionPerformed: Boolean;
        IsOfficeAddin: Boolean;
        HasDocumentAttachment: Boolean;
        VendNameVisible: Boolean;
        PVLine: Record "Voucher Line";
        AppliedVendorentry: Page "Apply Vendor Entries";

    [EventSubscriber(ObjectType::Page, 233, 'OnAfterCalcApplnAmount', '', false, false)]
    procedure OnAfterCalcApplnAmount(VendorLedgerEntry: Record "Vendor Ledger Entry"; var AppliedAmount: Decimal; var ApplyingAmount: Decimal)
    begin
        //PV
        case CalcType of
            CalcType::PV:
                begin
                    FindAmountRounding;

                    case ApplnType of
                        ApplnType::"Applies-to Doc. No.":
                            begin
                                AppliedVendLedgEntry := VendorLedgerEntry;
                                // with AppliedVendLedgEntry do begin
                                AppliedVendLedgEntry.CalcFields("Remaining Amount");

                                if AppliedVendLedgEntry."Currency Code" <> ApplnCurrencyCode then
                                    AppliedVendLedgEntry."Remaining Amount" :=
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        ApplnDate, AppliedVendLedgEntry."Currency Code", ApplnCurrencyCode, AppliedVendLedgEntry."Remaining Amount");

                                AppliedAmount := AppliedAmount + Round(AppliedVendLedgEntry."Remaining Amount", AmountRoundingPrecision);

                                if not DifferentCurrenciesInAppln then
                                    DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntry."Currency Code";


                                CheckRounding;
                            end;

                        ApplnType::"Applies-to ID":
                            begin
                                //with VendLedgEntry do begin
                                AppliedVendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                                AppliedVendLedgEntry.SetRange("Vendor No.", PVLine."Account No.");
                                AppliedVendLedgEntry.SetRange(Open, true);
                                AppliedVendLedgEntry.SetRange("Applies-to ID", PVLine."Applies-to ID");

                                /*HandlChosenEntries(2,
                                  GenJnlLine.Amount,
                                  GenJnlLine."Currency Code",
                                  GenJnlLine.");*/

                                HandleChosenEntries(2,
                                PVLine.Amount,
                                PVLine."Currency Code",
                                PVLine."Document Date");

                            end;
                    end;
                end;
        end;

        //PV
    end;



    local procedure FindAmountRounding()
    begin
        if ApplnCurrencyCode = '' then begin
            Currency.Init;
            Currency.Code := '';
            Currency.InitRoundingPrecision;
        end else
            if ApplnCurrencyCode <> Currency.Code then
                Currency.Get(ApplnCurrencyCode);

        AmountRoundingPrecision := Currency."Amount Rounding Precision";
    end;

    [Scope('Cloud')]
    procedure CheckRounding()
    begin
        ApplnRounding := 0;

        case CalcType of
            CalcType::PurchHeader:
                exit;
            CalcType::GenJnlLine:
                if (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Payment) and
                   (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Refund)
                then
                    exit;
        end;

        if ApplnCurrencyCode = '' then
            ApplnRoundingPrecision := GLSetup."Appln. Rounding Precision"
        else begin
            if ApplnCurrencyCode <> ApplyingVendLedgEntry."Currency Code" then
                Currency.Get(ApplnCurrencyCode);
            ApplnRoundingPrecision := Currency."Appln. Rounding Precision";
        end;

        if (Abs((AppliedAmount - PmtDiscAmount) + ApplyingAmount) <= ApplnRoundingPrecision) and DifferentCurrenciesInAppln then
            ApplnRounding := -((AppliedAmount - PmtDiscAmount) + ApplyingAmount);
    end;

    [EventSubscriber(ObjectType::Page, 233, 'OnBeforeHandledChosenEntries', '', false, false)]
    procedure OnBeforeHandledChosenEntries(var Sender: Page "Apply Vendor Entries"; Type: Option Direct,GenJnlLine,PurchHeader; CurrentAmount: Decimal; CurrencyCode: Code[20]; PostingDate: Date; var AppliedVendLedgEntry: Record "Vendor Ledger Entry"; var IsHandled: Boolean)
    begin
    end;

    local procedure HandleChosenEntries(Type: Option Direct,GenJnlLine,PurchHeader; CurrentAmount: Decimal; CurrencyCode: Code[20]; PostingDate: Date)
    var
        TempAppliedVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        PossiblePmtdisc: Decimal;
        OldPmtdisc: Decimal;
        CorrectionAmount: Decimal;
        RemainingAmountExclDiscounts: Decimal;
        CanUseDisc: Boolean;
        FromZeroGenJnl: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeHandledChosenEntries(Type,CurrentAmount,CurrencyCode,PostingDate,AppliedVendLedgEntry,IsHandled);
        if IsHandled then
            exit;

        if not AppliedVendLedgEntry.Find('-') then
            exit;

        repeat
            TempAppliedVendLedgEntry := AppliedVendLedgEntry;
            TempAppliedVendLedgEntry.Insert;
        until AppliedVendLedgEntry.Next = 0;

        FromZeroGenJnl := (CurrentAmount = 0) and (Type = Type::GenJnlLine);

        repeat
            if not FromZeroGenJnl then
                TempAppliedVendLedgEntry.SetRange(Positive, CurrentAmount < 0);
            if TempAppliedVendLedgEntry.FindFirst then begin
                // AppliedVendorentry.ExchangeAmountsOnLedgerEntry(Type, CurrencyCode, TempAppliedVendLedgEntry, PostingDate);

                case Type of
                    Type::Direct:
                        CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscVend(VendLedgEntry, TempAppliedVendLedgEntry, 0, false, false);
                    Type::GenJnlLine:
                        CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine2, TempAppliedVendLedgEntry, 0, false)
                    else
                        CanUseDisc := false;
                end;

                if CanUseDisc and
                   (Abs(TempAppliedVendLedgEntry."Amount to Apply") >=
                    Abs(TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible"))
                then
                    if Abs(CurrentAmount) >
                       Abs(TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible")
                    then begin
                        PmtDiscAmount += TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                        CurrentAmount += TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                    end else
                        if Abs(CurrentAmount) =
                           Abs(TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible")
                        then begin
                            PmtDiscAmount += TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                            CurrentAmount +=
                              TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                            AppliedAmount += CorrectionAmount;
                        end else
                            if FromZeroGenJnl then begin
                                PmtDiscAmount += TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                                CurrentAmount +=
                                  TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                            end else begin
                                PossiblePmtdisc := TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                                RemainingAmountExclDiscounts :=
                                  TempAppliedVendLedgEntry."Remaining Amount" - PossiblePmtdisc - TempAppliedVendLedgEntry."Max. Payment Tolerance";
                                if Abs(CurrentAmount) + Abs(AppliedVendorentry.CalcOppositeEntriesAmount(TempAppliedVendLedgEntry)) >=
                                   Abs(RemainingAmountExclDiscounts)
                                then begin
                                    PmtDiscAmount += PossiblePmtdisc;
                                    AppliedAmount += CorrectionAmount;
                                end;
                                CurrentAmount +=
                                  TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
                            end
                else begin
                    if ((CurrentAmount + TempAppliedVendLedgEntry."Amount to Apply") * CurrentAmount) >= 0 then
                        AppliedAmount += CorrectionAmount;
                    CurrentAmount += TempAppliedVendLedgEntry."Amount to Apply";
                end;
            end else begin
                TempAppliedVendLedgEntry.SetRange(Positive);
                TempAppliedVendLedgEntry.FindFirst;
                //  AppliedVendorentry.ExchangeAmountsOnLedgerEntry(Type, CurrencyCode, TempAppliedVendLedgEntry, PostingDate);
            end;

            if OldPmtdisc <> PmtDiscAmount then
                AppliedAmount += TempAppliedVendLedgEntry."Remaining Amount"
            else
                AppliedAmount += TempAppliedVendLedgEntry."Amount to Apply";
            OldPmtdisc := PmtDiscAmount;

            if PossiblePmtdisc <> 0 then
                CorrectionAmount := TempAppliedVendLedgEntry."Remaining Amount" - TempAppliedVendLedgEntry."Amount to Apply"
            else
                CorrectionAmount := 0;

            if not DifferentCurrenciesInAppln then
                DifferentCurrenciesInAppln := ApplnCurrencyCode <> TempAppliedVendLedgEntry."Currency Code";

            TempAppliedVendLedgEntry.Delete;
            TempAppliedVendLedgEntry.SetRange(Positive);

        until not TempAppliedVendLedgEntry.FindFirst;
        CheckRounding;
    end;

    local procedure "----SetPVLine added by gbenga"()
    begin
    end;

    procedure SetPVLine(NewPVLine: Record "Voucher Line"; var NewVendLedgEntry: Record "Vendor Ledger Entry"; ApplnTypeSelect: Integer)
    var
        PaymentHeader: Record "Voucher Header";
    begin
        PVLine := NewPVLine;
        ApplyingVendLedgEntry.CopyFilters(NewVendLedgEntry);

        ApplyingAmount := PVLine.Amount;

        PaymentHeader.Reset;
        PaymentHeader.SetRange(PaymentHeader."No.", NewPVLine."Document No.");

        if PaymentHeader.Find('-') then begin
            ApplnDate := PaymentHeader."Document Date";
            ApplnCurrencyCode := PaymentHeader."Currency Code";

            CalcType := CalcType::PV;
        end;

        case ApplnTypeSelect of
            NewPVLine.FieldNo("Applies-to Doc. No."):
                ApplnType := ApplnType::"Applies-to Doc. No.";
            NewPVLine.FieldNo("Applies-to ID"):
                ApplnType := ApplnType::"Applies-to ID";
        end;

        SetApplyingVendLedgEntry;
    end;

    procedure SetApplyingVendLedgEntry()
    begin
        case CalcType of
            CalcType::PV:
                begin
                    ApplyingVendLedgEntry."Posting Date" := PVLine."Document Date";
                    ApplyingVendLedgEntry."Document Type" := ApplyingVendLedgEntry."Document Type"::Payment;
                    ApplyingVendLedgEntry."Document No." := PVLine."Document No.";
                    ApplyingVendLedgEntry."Vendor No." := PVLine."Account No.";
                    ApplyingVendLedgEntry.Description := PVLine."Account Name";
                    ApplyingVendLedgEntry."Currency Code" := PVLine."Currency Code";
                    ApplyingVendLedgEntry.Amount := PVLine.Amount;
                    ApplyingVendLedgEntry."Remaining Amount" := -PVLine.Amount;
                    OnAfterCalcApplnAmount(AppliedVendLedgEntry, AppliedAmount, ApplyingAmount);
                end;

        end;
    end;
}

