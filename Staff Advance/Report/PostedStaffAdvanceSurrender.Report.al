report 50605 "Posted Staff Advance Surrender"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PostedStaffAdvanceSurrender.rdl';

    dataset
    {
        dataitem(DataItem8154; "Staff Advanc Surrender Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            RequestFilterFields = "No.";
            column(Staff_Advance_Surrender_Header_No; "No.")
            {
            }
            column(StrCopyText; StrCopyText)
            {
            }
            column(Staff_Advance_Surrender_Header__Imprest_Issue_Doc__No_; "Imprest Issue Doc. No")
            {
            }
            column(Account_No___________CustName; "Account No." + ':   ' + EmpName)
            {
            }
            column(Staff_Advance_Surrender_Header_Amount; Amount)
            {
            }
            column(Staff_Advance_Surrender_Header__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
            }
            column(Staff_Advance_Surrender_Header__Shortcut_Dimension_2_Code_; "Shortcut Dimension 2 Code")
            {
            }
            column(Staff_Advance_Surrender_Header__Staff_Advance_Surrender_Header___Surrender_Date_; "Surrender Date")
            {
            }
            column(Staff_Advance_Surrender_Header__Currency_Code_; "Currency Code")
            {
            }
            column(STAFF_ADVANCE_SURRENDERCaption; STAFF_ADVANCE_SURRENDERCaptionLbl)
            {
            }
            column(Issue_Doc__No_Caption; Issue_Doc__No_CaptionLbl)
            {
            }
            column(Name_Caption; Name_CaptionLbl)
            {
            }
            column(Total_Amount_IssuedCaption; Total_Amount_IssuedCaptionLbl)
            {
            }
            column(Staff_Advance_Surrender_Header__Global_Dimension_1_Code_Caption; FIELDCAPTION("Global Dimension 1 Code"))
            {
            }
            column(Staff_Advance_Surrender_Header__Shortcut_Dimension_2_Code_Caption; FIELDCAPTION("Shortcut Dimension 2 Code"))
            {
            }
            column(Date_Caption; Date_CaptionLbl)
            {
            }
            column(Staff_Advance_Surrender_Header__Currency_Code_Caption; FIELDCAPTION("Currency Code"))
            {
            }
            column(PAYMENT_DETAILSCaption; PAYMENT_DETAILSCaptionLbl)
            {
            }
            column(ACTUAL_SPENTCaption; ACTUAL_SPENTCaptionLbl)
            {
            }
            column(CASH_SURRENDERCaption; CASH_SURRENDERCaptionLbl)
            {
            }
            column(Difference_StaffAdvanceSurrenderHeader; Difference)
            {
            }
            column(Staff_Advance_Surrender_Header_Cheque; "Cheque No")
            {
            }
            column(Staff_Advance_Surrender_Header_Pay_Mode; "Pay Mode")
            {
            }
            column(Staff_Advance_Surrender_Header_Bank_Code; "Bank Code")
            {
            }
            column(Staff_Advance_Surrender_Header_Account_Name; "Account Name")
            {
            }
            column(Staff_Advance_Surrender_Header_Function_Name; "Function Name")
            {
            }
            column(Staff_Advance_Surrender_Header_Budget_Center_Name; "Budget Center Name")
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAdd; CompanyInfo.Address)
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(Amountinword; Amountinword + ' ONLY')
            {
            }
            dataitem(DataItem8861; "Staff Advan Surrender Details")
            {
                DataItemLink = "Surrender Doc No." = FIELD("No.");
                DataItemTableView = SORTING("Surrender Doc No.", "Line No.")
                                    ORDER(Ascending);
                column(Staff_Advanc_Surrender_Details_Account_No; "Account No:")
                {
                }
                column(Staff_Advanc_Surrender_Details__Account_Name_; "Account Name")
                {
                }
                column(Staff_Advanc_Surrender_Details__Actual_Spent_; "Actual Spent")
                {
                }
                column(Staff_Advanc_Surrender_Details__Cash_Receipt_Amount_; "Cash Receipt Amount")
                {
                }
                column(Staff_Advanc_Surrender_Details__Actual_Spent__Control1000000000; "Actual Spent")
                {
                }
                column(TIME_PRINTED_____FORMAT_TIME_; 'TIME PRINTED:' + FORMAT(TIME))
                {
                    AutoFormatType = 1;
                }
                column(DATE_PRINTED_____FORMAT_TODAY_0_4_; 'DATE PRINTED:' + FORMAT(TODAY, 0, 4))
                {
                    AutoFormatType = 1;
                }
                column(USERID; USERID)
                {
                }
                column(Staff_Advanc_Surrender_Details__Currency_Code_; "Currency Code")
                {
                }
                column(NumberText_1_; NumberText[1])
                {
                }
                column(Staff_Advanc_Surrender_Details__Cash_Receipt_Amount__Control1102756007; "Cash Receipt Amount")
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(Date_Caption_Control1102755030; Date_Caption_Control1102755030Lbl)
                {
                }
                column(Name_Caption_Control1102755034; Name_Caption_Control1102755034Lbl)
                {
                }
                column(Approved_By_Caption; Approved_By_CaptionLbl)
                {
                }
                column(Name_Caption_Control1102755036; Name_Caption_Control1102755036Lbl)
                {
                }
                column(Date_Caption_Control1102755037; Date_Caption_Control1102755037Lbl)
                {
                }
                column(Signature_Caption; Signature_CaptionLbl)
                {
                }
                column(Printed_By_Caption; Printed_By_CaptionLbl)
                {
                }
                column(Prepared_By_Caption; Prepared_By_CaptionLbl)
                {
                }
                column(Signature_Caption_Control1102755042; Signature_Caption_Control1102755042Lbl)
                {
                }
                column(I_confirm_that_the_above_are_legitimate_business_expenses_and_have_not_been_claimed_before_Caption; I_confirm_that_the_above_are_legitimate_business_expenses_and_have_not_been_claimed_before_CaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(Approvals_Caption; Approvals_CaptionLbl)
                {
                }
                column(Amount_in_wordsCaption; Amount_in_wordsCaptionLbl)
                {
                }
                column(Staff_Advanc_Surrender_Details_Surrender_Doc_No_; "Surrender Doc No.")
                {
                }
                column(Staff_Advanc_Surrender_Details_Line_No_; "Line No.")
                {
                }
                column(Staff_Advanc_Surrender_Details_Amount; Amount)
                {
                }
                column(Staff_Advanc_Surrender_Details_Difference; Difference)
                {
                }
            }
            dataitem(DataItem1000000014; "Approval Entry")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Document Type" = CONST(" "),
                                          Status = CONST(Approved));
                column(ApproverID_ApprovalEntry; "Approver ID")
                {
                }
                column(LastDateTimeModified_ApprovalEntry; "Last Date-Time Modified")
                {
                }
                column(Sequence_No; "Sequence No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin

                StrCopyText := '';
                IF "No. Printed" >= 1 then begin
                    StrCopyText := 'DUPLICATE';
                end;

                IF Emp.GET("Account No.") THEN
                    EmpName := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";

                AmountRefundable := 0;
                CALCFIELDS(Difference);
                AmountRefundable := Difference;
                IF AmountRefundable < 0 THEN
                    AmountRefundable := AmountRefundable * -1;

                TAmount := Round(ABS("AmountRefundable"), 1, '<');
                TAmount2 := ABS(("AmountRefundable" - TAmount) * 100);

                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, TAmount, "Currency Code");
                AmountInWordsWhole := NumberText[1];


                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, TAmount2, "Currency Code");
                AmountInwordDecimal := NumberText[1];
                //AmountInWords := AmountInWordsWhole + ' AND ' + AmountInWordsDecimal;  BOLU
                IF "Currency Code" = '' THEN BEGIN
                    CurrText := 'NAIRA';
                    CurrText1 := 'KOBO';
                END;

                Amountinword := figure("AmountRefundable", CurrText, CurrText1);


                //Amount into words
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText, AmountRefundable, '');
            end;

            trigger OnPostDataItem()
            begin
                IF CurrReport.PREVIEW = FALSE then begin
                    "No. Printed" := "No. Printed" + 1;
                    MODIFY;
                end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("No.");
                //"Imprest Surrender Header".SETRANGE("Imprest Surrender Header".Posted,TRUE);
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Emp: Record Employee;
        EmpName: Text[250];
        CheckReport: Report Check;
        NumberText: array[2] of Text[80];
        StrCopyText: Text[30];
        STAFF_ADVANCE_SURRENDERCaptionLbl: Label 'STAFF ADVANCE SURRENDER';
        Issue_Doc__No_CaptionLbl: Label 'Issue Doc. No.';
        Name_CaptionLbl: Label 'Name:';
        Total_Amount_IssuedCaptionLbl: Label 'Total Amount Issued';
        Date_CaptionLbl: Label 'Date:';
        PAYMENT_DETAILSCaptionLbl: Label 'PAYMENT DETAILS';
        ACTUAL_SPENTCaptionLbl: Label 'ACTUAL SPENT';
        CASH_SURRENDERCaptionLbl: Label 'CASH SURRENDER';
        TotalCaptionLbl: Label 'Total';
        Date_Caption_Control1102755030Lbl: Label 'Date:';
        Name_Caption_Control1102755034Lbl: Label 'Name:';
        Approved_By_CaptionLbl: Label 'Approved By:';
        Name_Caption_Control1102755036Lbl: Label 'Name:';
        Date_Caption_Control1102755037Lbl: Label 'Date:';
        Signature_CaptionLbl: Label 'Signature:';
        Printed_By_CaptionLbl: Label 'Printed By:';
        Prepared_By_CaptionLbl: Label 'Prepared By:';
        Signature_Caption_Control1102755042Lbl: Label 'Signature:';
        I_confirm_that_the_above_are_legitimate_business_expenses_and_have_not_been_claimed_before_CaptionLbl: Label 'I confirm that the above are legitimate business expenses and have not been claimed before.';
        EmptyStringCaptionLbl: Label '================================================================================================================================================================================================';
        Approvals_CaptionLbl: Label 'Approvals:';
        Amount_in_wordsCaptionLbl: Label 'Amount in words';
        AmountRefundable: Decimal;
        CompanyInfo: Record "Company Information";

        AmountInwords: Text;
        AmountInwordDecimal: Text;
        AmountInWordsWhole: Text;
        Amountinword: Text[250];
        CurrText: Code[10];
        CurrText1: Code[10];
        TAmount: Decimal;
        TAmount2: Decimal;

    procedure figure(fig: Decimal; Currency: Text[30]; CurrencyUnit: Text[30]) figureinword: Text[250]
    var
        com: Text[1];
        value1: Integer;
        value2: Integer;
        value3: Decimal;
        value4: Integer;
        value5: Integer;
        valueword1: Text[10];
        valueword2: Text[10];
        valueword3: Text[10];
        valueword4: Text[20];
        valueword5: Text[250];
        word1: Text[60];
        word2: Text[100];
        word3: Text[60];
        word5: Text[30];
        wordarray: array[20] of Text[10];
        arrayval: array[20] of Text[10];
        a: Integer;
        VALLENT: Integer;
        valent: Integer;
        i: Integer;
        deci: Text[3];
    begin
        IF ABS(fig) > 0 THEN BEGIN
            wordarray[1] := 'ONE';
            wordarray[2] := 'TWO';
            wordarray[3] := 'THREE';
            wordarray[4] := 'FOUR';
            wordarray[5] := 'FIVE';
            wordarray[6] := 'SIX';
            wordarray[7] := 'SEVEN';
            wordarray[8] := 'EIGHT';
            wordarray[9] := 'NINE';
            wordarray[10] := 'TEN';
            wordarray[11] := 'ELEVEN';
            wordarray[12] := 'TWELVE';
            wordarray[13] := 'THIRTEEN';
            wordarray[14] := 'FOURTEEN';
            wordarray[15] := 'FIFTEEN';
            wordarray[16] := 'SIXTEEN';
            wordarray[17] := 'SEVENTEEN';
            wordarray[18] := 'EIGHTEEN';
            wordarray[19] := 'NINETEEN';
            wordarray[20] := 'TWENTY';
            arrayval[1] := 'TEN';
            arrayval[2] := 'TWENTY';
            arrayval[3] := 'THIRTY';
            arrayval[4] := 'FORTY';
            arrayval[5] := 'FIFTY';
            arrayval[6] := 'SIXTY';
            arrayval[7] := 'SEVENTY';
            arrayval[8] := 'EIGHTY';
            arrayval[9] := 'NINETY';
            arrayval[10] := 'HUNDRED';
            arrayval[11] := 'THOUSAND';
            arrayval[12] := 'MILLION';
            arrayval[13] := 'BILLION';
            arrayval[14] := 'TRILLION';
            valueword4 := FORMAT(ABS(ROUND(fig, 0.01, '>')));
            valueword4 := DELCHR(valueword4, '=', ',');
            value4 := STRPOS(valueword4, '.');
            IF value4 > 0 THEN BEGIN
                VALLENT := value4 - 1;
                deci := COPYSTR(valueword4, (STRPOS(valueword4, '.') + 1));
                IF STRLEN(deci) < 2 THEN deci := deci + '0'
            END
            ELSE
                VALLENT := STRLEN(valueword4);
            IF VALLENT > 15 THEN
                ERROR('VALUE IS TOO BIG TO CONVERT');
            value5 := VALLENT MOD 3;
            IF value5 > 0 THEN BEGIN                                             // unit and tens conversion begin
                valueword1 := COPYSTR(valueword4, 1, value5);
                EVALUATE(value3, valueword1);
                IF (value3 > 0) AND (value3 <= 20) THEN
                    word1 := wordarray[value3]
                ELSE BEGIN
                    valueword2 := COPYSTR(valueword1, 1, 1);
                    valueword3 := COPYSTR(valueword1, 2, 1);
                    EVALUATE(value3, valueword2);
                    word1 := arrayval[value3];
                    EVALUATE(value3, valueword3);
                    IF value3 > 0 THEN
                        word1 := word1 + ' ' + wordarray[value3];
                END;
                IF (VALLENT > 3) AND (VALLENT < 7) THEN
                    word1 := word1 + ' ' + arrayval[11];
                IF (VALLENT > 6) AND (VALLENT < 10) THEN
                    word1 := word1 + ' ' + arrayval[12];
                IF (VALLENT > 9) AND (VALLENT < 13) THEN
                    word1 := word1 + ' ' + arrayval[13];
                IF (VALLENT > 12) AND (VALLENT < 16) THEN
                    word1 := word1 + ' ' + arrayval[14];
            END;

            // Figure normal conversion begin by Hassan Sharafadeen
            IF VALLENT > 2 THEN BEGIN
                a := value5 + 1;
                REPEAT
                    valueword2 := COPYSTR(valueword4, a, 3);
                    EVALUATE(value4, valueword2);
                    IF value4 = 0 THEN BEGIN
                        word2 := '';
                        IF (VALLENT > 6) AND (VALLENT < 10) THEN
                            word2 := word2 + ' ' + arrayval[11];
                        IF (VALLENT > 9) AND (VALLENT < 13) THEN
                            word2 := word2 + ' ' + arrayval[12];
                        IF (VALLENT > 12) AND (VALLENT < 16) THEN
                            word2 := word2 + ' ' + arrayval[13];
                        a := a + 3;
                    END
                    ELSE BEGIN
                        valueword1 := COPYSTR(valueword2, 1, 1);
                        EVALUATE(value3, valueword1);
                        IF value3 > 0 THEN BEGIN
                            word2 := wordarray[value3];
                            word2 := word2 + ' ' + arrayval[10];
                        END
                        ELSE
                            word2 := '';
                        valueword1 := COPYSTR(valueword2, 2);
                        EVALUATE(value3, valueword1);
                        IF value3 > 0 THEN BEGIN
                            IF (value3 > 0) AND (value3 <= 20) THEN
                                IF word2 <> '' THEN
                                    word2 := word2 + ' ' + 'AND' + ' ' + wordarray[value3]
                                ELSE
                                    word2 := wordarray[value3]
                            ELSE
                                IF value3 > 20 THEN BEGIN
                                    valueword2 := COPYSTR(valueword1, 1, 1);
                                    valueword3 := COPYSTR(valueword1, 2, 1);
                                    EVALUATE(value3, valueword2);
                                    IF word2 <> '' THEN
                                        word2 := word2 + ' ' + 'AND' + ' ' + arrayval[value3]
                                    ELSE
                                        word2 := arrayval[value3];
                                    EVALUATE(value3, valueword3);
                                    IF value3 > 0 THEN
                                        word2 := word2 + ' ' + wordarray[value3];
                                END;
                        END;
                        a := a + 3;
                        IF a < VALLENT THEN BEGIN
                            IF i > 0 THEN BEGIN
                                CASE i OF
                                    3:
                                        BEGIN
                                            IF (VALLENT > 8) AND (VALLENT < 12) THEN
                                                word2 := word2 + ' ' + arrayval[11];
                                            IF (VALLENT > 11) AND (VALLENT < 15) THEN
                                                word2 := word2 + ' ' + arrayval[12];
                                            IF VALLENT = 15 THEN
                                                word2 := word2 + ' ' + arrayval[13];
                                        END;
                                    6:
                                        BEGIN
                                            IF (VALLENT > 11) AND (VALLENT < 15) THEN
                                                word2 := word2 + ' ' + arrayval[11];
                                            IF VALLENT = 15 THEN
                                                word2 := word2 + ' ' + arrayval[12];
                                        END;
                                    9:
                                        IF VALLENT = 15 THEN
                                            word2 := word2 + ' ' + arrayval[11];
                                END;
                            END
                            ELSE BEGIN
                                CASE a OF
                                    4:
                                        BEGIN
                                            IF VALLENT = 6 THEN
                                                word2 := word2 + ' ' + arrayval[11];
                                            IF VALLENT = 9 THEN
                                                word2 := word2 + ' ' + arrayval[12];
                                            IF VALLENT = 12 THEN
                                                word2 := word2 + ' ' + arrayval[13];
                                            IF VALLENT = 15 THEN
                                                word2 := word2 + ' ' + arrayval[14];
                                        END;
                                    5, 6:
                                        BEGIN
                                            IF (VALLENT > 6) AND (VALLENT < 9) THEN
                                                word2 := word2 + ' ' + arrayval[11];
                                            IF (VALLENT > 9) AND (VALLENT < 12) THEN
                                                word2 := word2 + ' ' + arrayval[12];
                                            IF (VALLENT > 12) AND (VALLENT < 15) THEN
                                                word2 := word2 + ' ' + arrayval[13];
                                        END;
                                END;
                            END;
                        END;
                        valueword5 := valueword5 + ' ' + word2;
                        i := i + 3;
                    END;
                UNTIL a > VALLENT;
            END;
            figureinword := word1 + ' ' + valueword5 + ' ' + Currency;
            IF deci <> '' THEN                 //Decimal conversion begin
            BEGIN
                EVALUATE(value3, deci);
                IF value3 <= 20 THEN
                    word3 := wordarray[value3]
                ELSE BEGIN
                    valueword2 := COPYSTR(deci, 1, 1);
                    valueword3 := COPYSTR(deci, 2, 1);
                    EVALUATE(value3, valueword2);
                    word3 := arrayval[value3];
                    EVALUATE(value3, valueword3);
                    IF value3 > 0 THEN
                        word3 := word3 + ' ' + wordarray[value3];
                END;
                word5 := word3 + ' ' + CurrencyUnit;           // Attach Decimal Unit of counting
            END
            ELSE
                word5 := ' ';
            figureinword := figureinword + ' ' + word5;
        END
        ELSE
            figureinword := '';
    end;

}

