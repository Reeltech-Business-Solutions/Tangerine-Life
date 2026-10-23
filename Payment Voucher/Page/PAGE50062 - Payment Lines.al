page 50637 "Payment Lines"
{
    PageType = ListPart;
    SourceTable = "Payments Line";

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Caption = 'Beneficiary Name';
                    Editable = true;
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
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Amount; REC.Amount)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        //check if the payment reference is for farmer purchase
                        if Rec."Payment Reference" = Rec."Payment Reference"::"Farmer Purchase" then begin
                            if Rec.Amount <> xRec.Amount then begin
                                Error('Amount cannot be modified');
                            end;
                        end;
                        RecPayTypes.Reset();
                        RecPayTypes.SetRange(Code, rec.Type);
                        if RecPayTypes.FindFirst() then begin
                            Rec."Amount With VAT" := Rec.Amount;
                            IF Rec."Account Type" IN [Rec."Account Type"::Customer, Rec."Account Type"::Vendor,
                             Rec."Account Type"::"G/L Account", Rec."Account Type"::"Bank Account", Rec."Account Type"::"Fixed Asset"] THEN
                                CASE Rec."Account Type" OF
                                    Rec."Account Type"::"G/L Account":
                                        BEGIN

                                            REC.TESTFIELD(Amount);
                                            RecPayTypes.RESET;
                                            RecPayTypes.SETRANGE(RecPayTypes.Code, Rec.Type);
                                            RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                            IF RecPayTypes.FIND('-') THEN BEGIN
                                                IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                                                    RecPayTypes.TESTFIELD(RecPayTypes."VAT Code");
                                                    TarriffCodes.RESET;
                                                    TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."VAT Code");
                                                    IF TarriffCodes.FIND('-') THEN BEGIN
                                                        Rec."VAT Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                        Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                    END;
                                                END
                                                ELSE BEGIN
                                                    Rec."VAT Amount" := 0;
                                                END;

                                                IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN BEGIN
                                                    RecPayTypes.TESTFIELD(RecPayTypes."Withholding Tax Code");
                                                    TarriffCodes.RESET;
                                                    TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."Withholding Tax Code");
                                                    IF TarriffCodes.FIND('-') THEN BEGIN
                                                        Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                        Rec."Withholding Tax Amount" := (Rec.Amount - Rec."VAT Amount") * (TarriffCodes.Percentage / 100);
                                                    END;
                                                END
                                                ELSE BEGIN
                                                    Rec."Withholding Tax Amount" := 0;
                                                END;
                                            END;
                                        END;
                                    Rec."Account Type"::Customer:
                                        BEGIN

                                            REC.TESTFIELD(Amount);
                                            RecPayTypes.RESET;
                                            RecPayTypes.SETRANGE(RecPayTypes.Code, Rec.Type);
                                            RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                            IF RecPayTypes.FIND('-') THEN BEGIN
                                                IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                                                    REC.TESTFIELD("VAT Code");
                                                    TarriffCodes.RESET;
                                                    TarriffCodes.SETRANGE(TarriffCodes.Code, Rec."VAT Code");
                                                    IF TarriffCodes.FIND('-') THEN BEGIN
                                                        //"VAT Amount":=(TarriffCodes.Percentage/100)*Amount;
                                                        Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                        //
                                                    END;
                                                END
                                                ELSE BEGIN
                                                    Rec."VAT Amount" := 0;
                                                END;

                                                IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN BEGIN
                                                    REC.TESTFIELD("Withholding Tax Code");
                                                    TarriffCodes.RESET;
                                                    TarriffCodes.SETRANGE(TarriffCodes.Code, Rec."Withholding Tax Code");
                                                    IF TarriffCodes.FIND('-') THEN BEGIN
                                                        //Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;

                                                        // Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");
                                                        Rec."Withholding Tax Amount" := (Rec.Amount / (100 + rec."VAT Rate")) * rec."W/Tax Rate";

                                                    END;
                                                END
                                                ELSE BEGIN
                                                    Rec."Withholding Tax Amount" := 0;
                                                END;
                                            END;



                                        END;
                                    Rec."Account Type"::Vendor:
                                        BEGIN

                                            REC.TESTFIELD(Amount);
                                            RecPayTypes.RESET;
                                            RecPayTypes.SETRANGE(RecPayTypes.Code, Rec.Type);
                                            RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                            IF RecPayTypes.FIND('-') THEN BEGIN
                                                IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                                                    REC.TESTFIELD("VAT Code");
                                                    TarriffCodes.RESET;
                                                    TarriffCodes.SETRANGE(TarriffCodes.Code, Rec."VAT Code");
                                                    IF TarriffCodes.FIND('-') THEN BEGIN
                                                        Rec."VAT Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                        //
                                                        Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                        //
                                                    END;
                                                END
                                                ELSE BEGIN
                                                    Rec."VAT Amount" := 0;
                                                END;

                                                IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN BEGIN
                                                    REC.TESTFIELD("Withholding Tax Code");
                                                    TarriffCodes.RESET;
                                                    TarriffCodes.SETRANGE(TarriffCodes.Code, Rec."Withholding Tax Code");
                                                    IF TarriffCodes.FIND('-') THEN BEGIN
                                                        Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                        //
                                                        Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");
                                                        //
                                                    END;
                                                END
                                                ELSE BEGIN
                                                    Rec."Withholding Tax Amount" := 0;
                                                END;
                                            END;


                                        END;
                                    Rec."Account Type"::"Bank Account":
                                        BEGIN

                                            REC.TESTFIELD(Amount);
                                            RecPayTypes.RESET;
                                            RecPayTypes.SETRANGE(RecPayTypes.Code, Rec.Type);
                                            RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                            IF RecPayTypes.FIND('-') THEN BEGIN
                                                IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                                                    RecPayTypes.TESTFIELD(RecPayTypes."VAT Code");
                                                    TarriffCodes.RESET;
                                                    TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."VAT Code");
                                                    IF TarriffCodes.FIND('-') THEN BEGIN
                                                        //
                                                        Rec."VAT Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                        Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                        //
                                                    END;
                                                END
                                                ELSE BEGIN
                                                    Rec."VAT Amount" := 0;
                                                END;

                                                IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN BEGIN
                                                    RecPayTypes.TESTFIELD(RecPayTypes."Withholding Tax Code");
                                                    TarriffCodes.RESET;
                                                    TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."Withholding Tax Code");
                                                    IF TarriffCodes.FIND('-') THEN BEGIN
                                                        //
                                                        Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                        Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");
                                                        //
                                                    END;
                                                END
                                                ELSE BEGIN
                                                    Rec."Withholding Tax Amount" := 0;
                                                END;
                                            END;


                                        END;
                                    Rec."Account Type"::"Fixed Asset":
                                        BEGIN

                                            REC.TESTFIELD(Amount);
                                            RecPayTypes.RESET;
                                            RecPayTypes.SETRANGE(RecPayTypes.Code, Rec.Type);
                                            RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
                                            IF RecPayTypes.FIND('-') THEN BEGIN
                                                IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN BEGIN
                                                    RecPayTypes.TESTFIELD(RecPayTypes."VAT Code");
                                                    TarriffCodes.RESET;
                                                    TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."VAT Code");
                                                    IF TarriffCodes.FIND('-') THEN BEGIN
                                                        //"VAT Amount":=(TarriffCodes.Percentage/100)*Amount;
                                                        Rec."VAT Amount" := (Rec.Amount / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage);
                                                    END;
                                                END
                                                ELSE BEGIN
                                                    Rec."VAT Amount" := 0;
                                                END;

                                                IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN BEGIN
                                                    RecPayTypes.TESTFIELD(RecPayTypes."Withholding Tax Code");
                                                    TarriffCodes.RESET;
                                                    TarriffCodes.SETRANGE(TarriffCodes.Code, RecPayTypes."Withholding Tax Code");
                                                    IF TarriffCodes.FIND('-') THEN BEGIN
                                                        //
                                                        Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * Rec.Amount;
                                                        Rec."Withholding Tax Amount" := (TarriffCodes.Percentage / 100) * (Rec.Amount - Rec."VAT Amount");
                                                        //
                                                    END;
                                                END
                                                ELSE BEGIN
                                                    Rec."Withholding Tax Amount" := 0;
                                                END;
                                            END;


                                        END;
                                END;
                        end;


                        Rec."Net Amount" := Rec.Amount - Rec."Withholding Tax Amount";
                        Rec.VALIDATE("Net Amount");


                    end;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax Code"; REC."Withholding Tax Code")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = true;

                    trigger OnValidate()
                    begin
                        TarriffCodes.Reset;
                        TarriffCodes.SetRange(TarriffCodes.Code, Rec."Withholding Tax Code");
                        if TarriffCodes.FindFirst then begin
                            //    "Withholding Tax Amount":=(TarriffCodes.Percentage/100)*Amount;
                            Rec."Withholding Tax Amount" := (Rec."Amount With VAT" - Rec."VAT Amount") * (TarriffCodes.Percentage / (100 + TarriffCodes.Percentage));
                        end
                        else begin
                            Rec."Withholding Tax Amount" := 0;
                        end;
                        Rec."Net Amount" := Rec.Amount - Rec."Withholding Tax Amount";
                    end;
                }
                field("Withholding Tax Amount"; Rec."Withholding Tax Amount")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("VAT Code"; Rec."VAT Code")
                {
                    ApplicationArea = All;
                }
                field("NetAmount LCY"; Rec."NetAmount LCY")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = All;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = All;
                }
                field("Total Invoice Amount"; Rec."Total Invoice Amount")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        RecPayTypes: Record "Receipts and Payment Types";
        TarriffCodes: Record "Tariff Codes2";
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        CustLedger: Record "Vendor Ledger Entry";
        CustLedger1: Record "Vendor Ledger Entry";
        Amt: Decimal;
        TotAmt: Decimal;
        ApplyInvoice: Codeunit "Purchase Header Apply";
        VendEntries: Record "Vendor Ledger Entry";
        PInv: Record "Purch. Inv. Header";
        VATPaid: Decimal;
        VATToPay: Decimal;
        PInvLine: Record "Purch. Inv. Line";
        VATBase: Decimal;
}

