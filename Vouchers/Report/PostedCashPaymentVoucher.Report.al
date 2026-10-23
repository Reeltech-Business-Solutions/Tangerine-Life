report 50616 "Posted Cash Payment Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PostedCashPaymentVoucher.rdlc';

    dataset
    {
        dataitem(DataItem1000000000; "Posted Voucher Header")
        {
            CalcFields = Amount, "Amount (LCY)", "Debit Amount", "Credit Amount";
            DataItemTableView = SORTING("Voucher Type", "No.")
                                WHERE("Voucher Type" = FILTER(CPV));
            RequestFilterFields = "No.";
            column(SourceDesc; SourceDesc)
            {
            }
            column(No_PostedVoucherHeader; "No.")
            {
                IncludeCaption = true;
            }
            column(AccountName_PostedVoucherHeader; "Account Name")
            {
                IncludeCaption = true;
            }
            column(AmountLCY_PostedVoucherHeader; "Amount (LCY)")
            {
                IncludeCaption = true;
            }
            column(Amount_PostedVoucherHeader; Amount)
            {
            }
            column(PostingDate_PostedVoucherHeader; "Posting Date")
            {
                IncludeCaption = true;
            }
            column(CurrencyCode_PostedVoucherHeader; "Currency Code")
            {
            }
            column(Date______FORMAT__Posting_Date__; 'Date: ' + FORMAT("Posting Date"))
            {
            }
            column(ExchangeRate_PostedVoucherHeader; "Exchange Rate")
            {
            }
            column(ABS_Posted_Voucher_Header__Amount_LCY; ABS("Amount (LCY)"))
            {
            }
            column(ABS__Posted_Voucher_Header___Amount__LCY______Posted_Voucher_Header___Credit_Amount__; ABS("Amount (LCY)" + "Credit Amount"))
            {
            }
            column(Rs____NumberText_1_______NumberText_2_; ToWords.ToWords(ABS("Amount (LCY)" + "Credit Amount"), 'NAIRA', 'KOBO', 0, ''))
            {
            }
            column(Narration_VoucherHeader; Narration)
            {
                IncludeCaption = true;
            }
            column(CrText; CrText)
            {
            }
            dataitem(DataItem1000000006; "Posted Voucher Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Voucher Type", "Document No.", "Line No.")
                                    WHERE("Voucher Type" = FILTER(CPV));
                column(DocumentNo_PostedVoucherLine; "Document No.")
                {
                }
                column(AccountNo_PostedVoucherLine; "Account No.")
                {
                }
                column(AccountName_PostedVoucherLine; "Account Name")
                {
                    IncludeCaption = true;
                }
                column(DebitAmount_PostedVoucherLine; "Debit Amount")
                {
                }
                column(CreditAmount_PostedVoucherLine; "Credit Amount")
                {
                }
                column(ABS_Posted_Voucher_Line__Amount_LCY; ABS("Amount (LCY)"))
                {
                }
                column(DrText; DrText)
                {
                }
                column(CrText1; CrText1)
                {
                }
                dataitem(DataItem1000000014; "Company Information")
                {
                    column(Name_CompanyInformation; Name)
                    {
                        IncludeCaption = true;
                    }
                    column(Address_CompanyInformation; Address)
                    {
                        IncludeCaption = true;
                    }
                    column(Address2_CompanyInformation; "Address 2")
                    {
                        IncludeCaption = true;
                    }
                    column(Picture_CompanyInformation; Picture)
                    {
                    }
                    column(HomePage_CompanyInformation; "Home Page")
                    {
                    }
                    column(PhoneNo_CompanyInformation; "Phone No.")
                    {
                    }
                    column(EMail_CompanyInformation; "E-Mail")
                    {
                    }
                    dataitem(DataItem1000000012; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(Integer_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            PageLoop := PageLoop - 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            PostedVoucherLine.SETRANGE("Voucher Type", VoucherType);
                            PostedVoucherLine.SETRANGE("Document No.", VoucherDocNo);
                            PostedVoucherLine.FINDLAST;
                            IF NOT (PostedVoucherLine."Line No." = VoucherLineNo) THEN
                                CurrReport.BREAK;

                            SETRANGE(Number, 1, PageLoop)
                        end;
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    VoucherType := "Voucher Type";
                    VoucherDocNo := "Document No.";
                    VoucherLineNo := "Line No.";
                end;
            }

            trigger OnAfterGetRecord()
            begin

                DrText := 'Dr';
                CrText := 'To';
                CrText1 := 'Cr';

                SourceDesc := '';
                IF "Source Code" <> '' THEN BEGIN
                    SourceCode.GET("Source Code");
                    SourceDesc := SourceCode.Description;
                END;



                PageLoop := PageLoop - 1;
                LinesPrinted := LinesPrinted + 1;
            end;

            trigger OnPreDataItem()
            begin

                /*NUMLines := 13;
                PageLoop := NUMLines;
                LinesPrinted := 0;*/

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
        Particulars = 'Particulars';
        PreparedBy = 'Prepared By:';
        CheckedBy = 'Checked By:';
        ApprovedBy = 'Approved By:';
    }

    var
        PageLoop: Integer;
        LinesPrinted: Integer;
        NUMLines: Integer;
        ToWords: Codeunit Library;
        SourceDesc: Text[50];
        CrText: Text[2];
        DrText: Text[2];
        CrText1: Text[2];
        PostedVoucherLine: Record "Posted Voucher Line";
        PVL: Record "Posted Voucher Line";
        IntegerOccurces: Integer;
        SourceCode: Record "Source Code";
        VoucherType: Option JV,CPV,CRV,BPV,BRV,Contra,PettyCash;
        VoucherDocNo: Code[20];
        VoucherLineNo: Integer;
}

