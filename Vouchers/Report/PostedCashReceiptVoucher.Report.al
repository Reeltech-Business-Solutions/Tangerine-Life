report 50617 "Posted Cash Receipt Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PostedCashReceiptVoucher.rdlc';

    dataset
    {
        dataitem(DataItem1000000030; "Posted Voucher Header")
        {
            CalcFields = Amount, "Amount (LCY)", "Debit Amount", "Credit Amount";
            DataItemTableView = SORTING("Voucher Type", "No.")
                                WHERE("Voucher Type" = FILTER(CRV));
            RequestFilterFields = "No.";
            column(SourceDesc; SourceDesc)
            {
            }
            column(No_VoucherHeader; "No.")
            {
                IncludeCaption = true;
            }
            column(AccountName_VoucherHeader; "Account Name")
            {
                IncludeCaption = true;
            }
            column(AmountLCY_VoucherHeader; "Amount (LCY)")
            {
                IncludeCaption = true;
            }
            column(PostingDate_VoucherHeader; "Posting Date")
            {
                IncludeCaption = true;
            }
            column(Date______FORMAT__Posting_Date__; 'Date: ' + FORMAT("Posting Date"))
            {
            }
            column(ABS_Voucher_Header__Amount_LCY; ABS("Amount (LCY)"))
            {
            }
            column(Rs____NumberText_1_______NumberText_2_; ToWords.ToWords("Amount (LCY)", 'NAIRA', 'KOBO', 0, ''))
            {
            }
            column(Narration_VoucherHeader; Narration)
            {
                IncludeCaption = true;
            }
            column(CrText; CrText)
            {
            }
            column(VoucherName; VoucherName)
            {
            }
            dataitem(DataItem1000000015; "Posted Voucher Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Voucher Type", "Document No.", "Line No.")
                                    WHERE("Voucher Type" = FILTER(CRV),
                                          "Account No." = FILTER(<> ''));
                column(DocumentNo_VoucherLine; "Document No.")
                {
                }
                column(AccountName_VoucherLine; "Account Name")
                {
                    IncludeCaption = true;
                }
                column(ABS_Voucher_Line__Amount_LCY; ABS("Amount (LCY)"))
                {
                }
                column(DrText; DrText)
                {
                }
                column(CrText1; CrText1)
                {
                }
                dataitem(DataItem1000000009; "Company Information")
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
                    dataitem(DataItem1000000001; Integer)
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

                CASE "Voucher Type" OF
                    "Voucher Type"::CRV:
                        VoucherName := Text001;
                    "Voucher Type"::CPV:
                        VoucherName := Text002;
                    "Voucher Type"::BRV:
                        VoucherName := Text003;
                    "Voucher Type"::BPV:
                        VoucherName := Text004;
                    "Voucher Type"::JV:
                        VoucherName := Text005;
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
        IntegerOccurces: Integer;
        SourceCode: Record "Source Code";
        PostedVoucherLine: Record "Posted Voucher Line";
        PVL: Record "Posted Voucher Line";
        VoucherName: Text[50];
        Text001: Label 'Cash Receipt Voucher';
        Text002: Label 'Cash Payment Voucher';
        Text003: Label 'Bank Receipt Voucher';
        Text004: Label 'Bank Payment Voucher';
        Text005: Label 'Journal Voucher';
        VoucherType: Option JV,CPV,CRV,BPV,BRV,Contra,PettyCash;
        VoucherDocNo: Code[20];
        VoucherLineNo: Integer;

}

