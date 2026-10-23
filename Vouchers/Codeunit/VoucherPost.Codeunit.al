codeunit 50622 "Voucher Post"
{
    SingleInstance = true;
    TableNo = "Voucher Header";

    trigger OnRun()
    var
        TmpGenJrnlLine: Record "Gen. Journal Line";
        TmpGenJrnlLine2: Record "Gen. Journal Line" temporary;
    begin
        Rec.TESTFIELD(Status, Rec.Status::Released);
        Rec.TESTFIELD("Posting Date");
        PostedVoucherHeader.LOCKTABLE;

        PostedVoucherHeader.INIT;
        PostedVoucherHeader.TRANSFERFIELDS(Rec);
        PostedVoucherHeader."Posted By" := USERID;
        PostedVoucherHeader."Posted Date" := TODAY;
        PostedVoucherHeader."Posted Time" := TIME;
        PostedVoucherHeader."Reference Voucher No." := Rec."No.";
        PostedVoucherHeader."No." := NoSeriesMgt.GetNextNo(Rec."Posting No. Series", Rec."Posting Date", TRUE);
        PostedVoucherHeader."No." := Rec."No.";
        CASE Rec."Voucher Type" OF
            Rec."Voucher Type"::JV:
                I := 7;
            Rec."Voucher Type"::CPV:
                I := 8;
            Rec."Voucher Type"::CRV:
                I := 9;
            Rec."Voucher Type"::BPV:
                I := 10;
            Rec."Voucher Type"::BRV:
                I := 11;
            Rec."Voucher Type"::Contra:
                I := 12;
        END;

        PostedVoucherHeader.INSERT;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher Type", Rec."Voucher Type");
        VoucherLine.SETRANGE("Document No.", Rec."No.");
        IF VoucherLine.FIND('-') THEN
            REPEAT
                PostedVoucherLine.TRANSFERFIELDS(VoucherLine);
                PostedVoucherLine."Document No." := PostedVoucherHeader."No.";
                PostedVoucherLine.INSERT;
                CASE Rec."Voucher Type" OF
                    Rec."Voucher Type"::JV:
                        I := 7;
                    Rec."Voucher Type"::CPV:
                        I := 8;
                    Rec."Voucher Type"::CRV:
                        I := 9;
                    Rec."Voucher Type"::BPV:
                        I := 10;
                    Rec."Voucher Type"::BRV:
                        I := 11;
                    Rec."Voucher Type"::Contra:
                        I := 12;
                END;
            UNTIL VoucherLine.NEXT = 0;

        CASE Rec."Voucher Type" OF
            Rec."Voucher Type"::JV:
                BEGIN
                    VoucherLine.RESET;
                    VoucherLine.SETRANGE("Voucher Type", VoucherLine."Voucher Type"::JV);
                    VoucherLine.SETRANGE("Document No.", Rec."No.");
                    IF VoucherLine.FIND('-') THEN
                        REPEAT
                            GenJrnlLine.RESET;
                            GenJrnlLine.SETRANGE("Journal Template Name", 'JV');
                            GenJrnlLine.SETRANGE("Journal Batch Name", 'JV');
                            GenJrnlLine.SETFILTER(Amount, '=%1', 0);
                            IF GenJrnlLine.FIND('-') THEN
                                GenJrnlLine.DELETEALL;
                            GenJrnlLine.RESET;
                            GenJrnlLine.INIT;
                            GenJrnlLine.VALIDATE("Journal Template Name", 'JV');
                            GenJrnlLine.VALIDATE("Journal Batch Name", 'JV');
                            GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No.");
                            GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                            GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                            GenJrnlLine.VALIDATE("Account Type", VoucherLine."Account Type");
                            GenJrnlLine.VALIDATE("Account No.", VoucherLine."Account No.");
                            GenJrnlLine.VALIDATE("Currency Code", VoucherLine."Currency Code");
                            GenJrnlLine."Cheque No." := VoucherLine."Teller / Cheque No.";
                            GenJrnlLine.VALIDATE("Currency Factor", VoucherLine."Currency Factor");
                            GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                            IF VoucherLine."Debit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Debit Amount", VoucherLine."Debit Amount");
                            IF VoucherLine."Credit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Credit Amount", VoucherLine."Credit Amount");
                            GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                            //GenJrnlLine.VALIDATE(Description,VoucherLine."Account Name");
                            Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                            GenJrnlLine.VALIDATE(Description, Narr);
                            IF VoucherLine."Posting Group" <> '' THEN
                                GenJrnlLine.VALIDATE("Posting Group", VoucherLine."Posting Group");
                            GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                            GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                            GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::JV);
                            GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                            GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                            GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                            GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                            GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                            GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                            GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                            GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                            GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                            GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                            GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";
                            GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                            GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", VoucherLine."Shortcut Dimension 1 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", VoucherLine."Shortcut Dimension 2 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", VoucherLine."Shortcut Dimension 3 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", VoucherLine."Shortcut Dimension 4 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", VoucherLine."Shortcut Dimension 5 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", VoucherLine."Shortcut Dimension 6 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", VoucherLine."Shortcut Dimension 7 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", VoucherLine."Shortcut Dimension 8 Code");
                            GenJrnlLine.VALIDATE(GenJrnlLine."FA Posting Type", VoucherLine."FA Posting Type");
                            GenJrnlLine.VALIDATE("FA Posting Date", VoucherLine."FA Posting Date");
                            GenJrnlLine.VALIDATE("Depreciation Book Code", VoucherLine."Depreciation Book Code");
                            //GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";

                            GenJrnlLine.INSERT;
                        UNTIL VoucherLine.NEXT = 0;
                    GenJrnlLine.RESET;
                    GenJrnlLine.SETRANGE("Journal Template Name", 'JV');
                    GenJrnlLine.SETRANGE("Journal Batch Name", 'JV');
                    GenJrnlLine.SETRANGE("Document No.", PostedVoucherHeader."No.");
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJrnlLine);
                    Message('Posted Successfully');//Biyi

                    /*   //print report UNL
                       PostedVoucherHeader2 := PostedVoucherHeader;
                       PostedVoucherHeader2.SETRECFILTER;
                       REPORT.RUN(50049,FALSE,FALSE,PostedVoucherHeader2);
                       */
                    /*TempApprovalEntry.RESET;
                    TempApprovalEntry.DELETEALL;
                    ApprovalEntry.SETRANGE("Table ID",DATABASE::"Voucher Header");
                    ApprovalEntry.SETRANGE("Document Type",ApprovalEntry."Document Type" :: JV);
                    ApprovalEntry.SETRANGE("Document No.","No.");
                    IF ApprovalEntry.FINDSET THEN BEGIN
                      REPEAT
                        TempApprovalEntry.INIT;
                        TempApprovalEntry := ApprovalEntry;
                        TempApprovalEntry.INSERT;
                      UNTIL ApprovalEntry.NEXT = 0;
                    END;
                    ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Posted Voucher Header",PostedVoucherHeader."No.");
                    ApprovalMgt.DeleteApprovalEntry(DATABASE::"Voucher Header",7,"No.");*/
                END;

            Rec."Voucher Type"::CPV:
                BEGIN
                    VoucherLine.RESET;
                    VoucherLine.SETRANGE("Voucher Type", VoucherLine."Voucher Type"::CPV);
                    VoucherLine.SETRANGE("Document No.", Rec."No.");
                    IF VoucherLine.FIND('-') THEN BEGIN
                        REPEAT //Voucher Line G/L
                            GenJrnlLine.RESET;
                            GenJrnlLine.SETRANGE("Journal Template Name", 'CPV');
                            GenJrnlLine.SETRANGE("Journal Batch Name", 'CPV');
                            GenJrnlLine.SETFILTER(Amount, '=%1', 0);
                            IF GenJrnlLine.FIND('-') THEN
                                GenJrnlLine.DELETEALL;
                            GenJrnlLine.RESET;
                            GenJrnlLine.INIT;
                            GenJrnlLine.VALIDATE("Journal Template Name", 'CPV');
                            GenJrnlLine.VALIDATE("Journal Batch Name", 'CPV');
                            GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No.");
                            GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                            GenJrnlLine."Cheque No." := VoucherLine."Teller / Cheque No.";
                            GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                            IF Rec."Account Type" = Rec."Account Type"::Customer then
                                GenJrnlLine."Document Type" := GenJrnlLine."Document Type"::" "//Dennis
                            else
                                GenJrnlLine."Document Type" := GenJrnlLine."Document Type"::Payment;
                            GenJrnlLine.VALIDATE("Account Type", VoucherLine."Account Type");
                            GenJrnlLine.VALIDATE("Account No.", VoucherLine."Account No.");
                            GenJrnlLine.VALIDATE("Currency Code", VoucherLine."Currency Code");
                            GenJrnlLine.VALIDATE("Currency Factor", VoucherLine."Currency Factor");
                            GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                            IF VoucherLine."Debit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Debit Amount", VoucherLine."Debit Amount");
                            IF VoucherLine."Credit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Credit Amount", VoucherLine."Credit Amount");
                            IF VoucherLine."Posting Group" <> '' THEN
                                GenJrnlLine.VALIDATE("Posting Group", VoucherLine."Posting Group");
                            GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                            //GenJrnlLine.VALIDATE(Description,VoucherLine."Account Name");
                            Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                            GenJrnlLine.VALIDATE(Description, Narr);
                            GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                            GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                            GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::CPV);
                            GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                            GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                            GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                            GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                            GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                            GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                            GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                            GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                            GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                            GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                            GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";
                            GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                            GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", VoucherLine."Shortcut Dimension 1 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", VoucherLine."Shortcut Dimension 2 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", VoucherLine."Shortcut Dimension 3 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", VoucherLine."Shortcut Dimension 4 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", VoucherLine."Shortcut Dimension 5 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", VoucherLine."Shortcut Dimension 6 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", VoucherLine."Shortcut Dimension 7 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", VoucherLine."Shortcut Dimension 8 Code");
                            GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                            GenJrnlLine.VALIDATE(GenJrnlLine."FA Posting Type", VoucherLine."FA Posting Type");
                            GenJrnlLine.VALIDATE("FA Posting Date", VoucherLine."FA Posting Date");
                            GenJrnlLine.VALIDATE("Depreciation Book Code", VoucherLine."Depreciation Book Code");
                            GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";

                            GenJrnlLine.INSERT;
                        UNTIL VoucherLine.NEXT = 0;

                        GenJrnlLine.INIT;
                        GenJrnlLine.VALIDATE("Journal Template Name", 'CPV');
                        GenJrnlLine.VALIDATE("Journal Batch Name", 'CPV');
                        GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No." + 10000);
                        GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                        GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                        IF Rec."Account Type" = Rec."Account Type"::Customer then
                            GenJrnlLine."Document Type" := GenJrnlLine."Document Type"::" "//Dennis
                        else
                            GenJrnlLine."Document Type" := GenJrnlLine."Document Type"::Payment;
                        GenJrnlLine.VALIDATE("Account Type", Rec."Account Type");
                        GenJrnlLine.VALIDATE("Account No.", Rec."Account No.");
                        GenJrnlLine.VALIDATE("Currency Code", Rec."Currency Code");
                        GenJrnlLine.VALIDATE("Currency Factor", Rec."Currency Factor");
                        GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                        GenJrnlLine."Responsibility Center" := Rec."Responsibility Center";
                        GenJrnlLine."Cheque No." := Rec."Teller / Cheque No.";
                        Rec.CALCFIELDS("Amount (LCY)");
                        IF Rec."Exchange Rate" <> 0 THEN
                            GenJrnlLine.VALIDATE(Amount, -(Rec."Amount (LCY)" / Rec."Exchange Rate"));
                        Rec.CALCFIELDS("Amount (LCY)");
                        GenJrnlLine.VALIDATE("Amount (LCY)", -Rec."Amount (LCY)");
                        GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                        //GenJrnlLine.VALIDATE(Description,VoucherLine.Narration);
                        Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                        GenJrnlLine.VALIDATE(Description, Narr);
                        GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                        GenJrnlLine."Document Type" := GenJrnlLine."Document Type"::Payment; //Dennis
                        GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                        GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::CPV);
                        GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                        GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                        GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                        GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                        GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                        GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                        GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                        GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                        GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                        GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                        GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";
                        GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                        GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", Rec."Shortcut Dimension 3 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", Rec."Shortcut Dimension 4 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", Rec."Shortcut Dimension 5 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", Rec."Shortcut Dimension 6 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", Rec."Shortcut Dimension 7 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", Rec."Shortcut Dimension 8 Code");
                        /*GenJrnlLine.VALIDATE(GenJrnlLine."FA Posting Type" ,VoucherLine."FA Posting Type");
                        GenJrnlLine.VALIDATE("FA Posting Date",VoucherLine."FA Posting Date");*/
                        GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";

                        GenJrnlLine.INSERT;
                    END;

                    GenJrnlLine.RESET;
                    GenJrnlLine.SETRANGE("Journal Template Name", 'CPV');
                    GenJrnlLine.SETRANGE("Journal Batch Name", 'CPV');
                    GenJrnlLine.SETRANGE("Document No.", PostedVoucherHeader."No.");
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJrnlLine);
                    Message('Posted Successfully');//Biyi

                    /*//print report UNL
                    PostedVoucherHeader2 := PostedVoucherHeader;
                    PostedVoucherHeader2.SETRECFILTER;
                    REPORT.RUN(50056,TRUE,FALSE,PostedVoucherHeader2);*/

                    /* TempApprovalEntry.RESET;
                     TempApprovalEntry.DELETEALL;
                     ApprovalEntry.SETRANGE("Table ID",DATABASE::"Voucher Header");
                     ApprovalEntry.SETRANGE("Document Type",ApprovalEntry."Document Type" :: CPV);
                     ApprovalEntry.SETRANGE("Document No.","No.");
                     IF ApprovalEntry.FINDSET THEN BEGIN
                       REPEAT
                         TempApprovalEntry.INIT;
                         TempApprovalEntry := ApprovalEntry;
                         TempApprovalEntry.INSERT;
                       UNTIL ApprovalEntry.NEXT = 0;
                     END;
                     ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Posted Voucher Header",PostedVoucherHeader."No.");
                     ApprovalMgt.DeleteApprovalEntry(DATABASE::"Voucher Header",8,"No.");*/
                END;

            Rec."Voucher Type"::BPV:
                BEGIN
                    VoucherLine.RESET;
                    VoucherLine.SETRANGE("Voucher Type", VoucherLine."Voucher Type"::BPV);
                    VoucherLine.SETRANGE("Document No.", Rec."No.");
                    IF VoucherLine.FIND('-') THEN BEGIN
                        REPEAT
                            GenJrnlLine.RESET;
                            GenJrnlLine.SETRANGE("Journal Template Name", 'BPV');
                            GenJrnlLine.SETRANGE("Journal Batch Name", 'BPV');
                            GenJrnlLine.SETFILTER(Amount, '=%1', 0);
                            IF GenJrnlLine.FIND('-') THEN
                                GenJrnlLine.DELETEALL;
                            GenJrnlLine.RESET;
                            GenJrnlLine.INIT;
                            GenJrnlLine.VALIDATE("Journal Template Name", 'BPV');
                            GenJrnlLine.VALIDATE("Journal Batch Name", 'BPV');
                            GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No.");
                            GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                            GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                            IF Rec.VoucherLinesExist then
                                GenJrnlLine."Document Type" := GenJrnlLine."Document Type"::" "//Dennis
                            else
                                GenJrnlLine."Document Type" := GenJrnlLine."Document Type"::Payment;

                            GenJrnlLine.VALIDATE("Account Type", VoucherLine."Account Type");
                            GenJrnlLine.VALIDATE("Account No.", VoucherLine."Account No.");
                            GenJrnlLine.VALIDATE("Currency Code", VoucherLine."Currency Code");
                            GenJrnlLine.VALIDATE("Currency Factor", VoucherLine."Currency Factor");
                            GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                            IF VoucherLine."Debit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Debit Amount", VoucherLine."Debit Amount");

                            IF VoucherLine."Credit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Credit Amount", VoucherLine."Credit Amount");
                            IF VoucherLine."Posting Group" <> '' THEN
                                GenJrnlLine.VALIDATE("Posting Group", VoucherLine."Posting Group");
                            GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                            //GenJrnlLine.VALIDATE(Description,VoucherLine."Account Name");
                            Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                            GenJrnlLine.VALIDATE(Description, Narr);
                            GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                            GenJrnlLine."Cheque No." := VoucherLine."Teller / Cheque No.";
                            GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                            GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::BPV);
                            GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                            GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                            //GenJrnlLine."Cheque No." := VoucherLine."Teller / Cheque No.";
                            GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                            GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                            GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                            GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                            GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                            GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                            GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                            GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                            GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                            GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                            GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";

                            GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                            GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", VoucherLine."Shortcut Dimension 1 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", VoucherLine."Shortcut Dimension 2 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", VoucherLine."Shortcut Dimension 3 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", VoucherLine."Shortcut Dimension 4 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", VoucherLine."Shortcut Dimension 5 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", VoucherLine."Shortcut Dimension 6 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", VoucherLine."Shortcut Dimension 7 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", VoucherLine."Shortcut Dimension 8 Code");
                            GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                            GenJrnlLine.VALIDATE(GenJrnlLine."FA Posting Type", VoucherLine."FA Posting Type");
                            GenJrnlLine.VALIDATE("FA Posting Date", VoucherLine."FA Posting Date");
                            GenJrnlLine.VALIDATE("Depreciation Book Code", VoucherLine."Depreciation Book Code");
                            GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";
                            GenJrnlLine.INSERT;
                        UNTIL VoucherLine.NEXT = 0;

                        GenJrnlLine.INIT;
                        GenJrnlLine.VALIDATE("Journal Template Name", 'BPV');
                        GenJrnlLine.VALIDATE("Journal Batch Name", 'BPV');
                        GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No." + 10000);
                        GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                        GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                        GenJrnlLine.VALIDATE("Account Type", Rec."Account Type");
                        GenJrnlLine.VALIDATE("Account No.", Rec."Account No.");
                        GenJrnlLine.VALIDATE("Currency Code", Rec."Currency Code");
                        GenJrnlLine.VALIDATE("Currency Factor", Rec."Currency Factor");
                        GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                        GenJrnlLine."Responsibility Center" := Rec."Responsibility Center";
                        GenJrnlLine."Cheque No." := VoucherLine."Teller / Cheque No.";
                        Rec.CALCFIELDS("Amount (LCY)");
                        IF Rec."Exchange Rate" <> 0 THEN
                            GenJrnlLine.VALIDATE(Amount, -(Rec."Amount (LCY)" / Rec."Exchange Rate"));
                        Rec.CALCFIELDS("Amount (LCY)");
                        GenJrnlLine.VALIDATE("Amount (LCY)", -Rec."Amount (LCY)");
                        GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                        //GenJrnlLine.VALIDATE(Description,VoucherLine."Account Name");

                        Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                        GenJrnlLine.VALIDATE(Description, Narr);
                        GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                        GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                        GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::BPV);
                        GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                        GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                        GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                        GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                        GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                        GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                        GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                        GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                        GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                        GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                        GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";
                        GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                        GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", Rec."Shortcut Dimension 3 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", Rec."Shortcut Dimension 4 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", Rec."Shortcut Dimension 5 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", Rec."Shortcut Dimension 6 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", Rec."Shortcut Dimension 7 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", Rec."Shortcut Dimension 8 Code");
                        GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                        GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";

                        /*GenJrnlLine.VALIDATE(GenJrnlLine."FA Posting Type" ,VoucherLine."FA Posting Type");
                        GenJrnlLine.VALIDATE("FA Posting Date",VoucherLine."FA Posting Date");*/

                        GenJrnlLine.INSERT;
                    END;
                    GenJrnlLine.RESET;
                    GenJrnlLine.SETRANGE("Journal Template Name", 'BPV');
                    GenJrnlLine.SETRANGE("Journal Batch Name", 'BPV');
                    GenJrnlLine.SETRANGE("Document No.", PostedVoucherHeader."No.");
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJrnlLine);
                    Message('Posted Successfully');//Biyi

                    /*//print report UNL
                    PostedVoucherHeader2 := PostedVoucherHeader;
                    PostedVoucherHeader2.SETRECFILTER;
                    REPORT.RUN(50058,TRUE,FALSE,PostedVoucherHeader2);*/

                    /* TempApprovalEntry.RESET;
                     TempApprovalEntry.DELETEALL;
                     ApprovalEntry.SETRANGE("Table ID",DATABASE::"Voucher Header");
                     ApprovalEntry.SETRANGE("Document Type",ApprovalEntry."Document Type" :: BPV);
                     ApprovalEntry.SETRANGE("Document No.","No.");
                     IF ApprovalEntry.FINDSET THEN BEGIN
                       REPEAT
                         TempApprovalEntry.INIT;
                         TempApprovalEntry := ApprovalEntry;
                         TempApprovalEntry.INSERT;
                       UNTIL ApprovalEntry.NEXT = 0;
                     END;
                     ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Posted Voucher Header",PostedVoucherHeader."No.");
                     ApprovalMgt.DeleteApprovalEntry(DATABASE::"Voucher Header",10,"No.");*/
                END;

            Rec."Voucher Type"::CRV:
                BEGIN
                    VoucherLine.RESET;
                    VoucherLine.SETRANGE("Voucher Type", VoucherLine."Voucher Type"::CRV);
                    VoucherLine.SETRANGE("Document No.", Rec."No.");
                    IF VoucherLine.FIND('-') THEN BEGIN
                        REPEAT
                            GenJrnlLine.RESET;
                            GenJrnlLine.SETRANGE("Journal Template Name", 'CRV');
                            GenJrnlLine.SETRANGE("Journal Batch Name", 'CRV');
                            GenJrnlLine.SETFILTER(Amount, '=%1', 0);
                            IF GenJrnlLine.FIND('-') THEN
                                GenJrnlLine.DELETEALL;
                            GenJrnlLine.RESET;
                            GenJrnlLine.INIT;
                            GenJrnlLine.VALIDATE("Journal Template Name", 'CRV');
                            GenJrnlLine.VALIDATE("Journal Batch Name", 'CRV');
                            GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No.");
                            GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                            GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                            GenJrnlLine.VALIDATE("Account Type", VoucherLine."Account Type");
                            GenJrnlLine.VALIDATE("Account No.", VoucherLine."Account No.");
                            GenJrnlLine.VALIDATE("Currency Code", VoucherLine."Currency Code");
                            GenJrnlLine.VALIDATE("Currency Factor", VoucherLine."Currency Factor");
                            GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                            IF VoucherLine."Debit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Debit Amount", VoucherLine."Debit Amount");
                            IF VoucherLine."Credit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Credit Amount", VoucherLine."Credit Amount");
                            IF VoucherLine."Posting Group" <> '' THEN
                                GenJrnlLine.VALIDATE("Posting Group", VoucherLine."Posting Group");
                            GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                            //GenJrnlLine.VALIDATE(Description,VoucherLine."Account Name");
                            Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                            GenJrnlLine.VALIDATE(Description, Narr);
                            GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                            GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                            GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::CRV);
                            GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                            GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                            GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                            GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                            GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                            GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                            GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                            GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                            GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                            GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                            GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";
                            GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                            GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                            GenJrnlLine.VALIDATE("Applies-to ID", VoucherLine."Applies-to ID");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", VoucherLine."Shortcut Dimension 1 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", VoucherLine."Shortcut Dimension 2 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", VoucherLine."Shortcut Dimension 3 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", VoucherLine."Shortcut Dimension 4 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", VoucherLine."Shortcut Dimension 5 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", VoucherLine."Shortcut Dimension 6 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", VoucherLine."Shortcut Dimension 7 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", VoucherLine."Shortcut Dimension 8 Code");
                            GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                            GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";

                            GenJrnlLine.INSERT;
                        UNTIL VoucherLine.NEXT = 0;
                        GenJrnlLine.INIT;
                        GenJrnlLine.VALIDATE("Journal Template Name", 'CRV');
                        GenJrnlLine.VALIDATE("Journal Batch Name", 'CRV');
                        GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No." + 10000);
                        GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                        GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                        GenJrnlLine.VALIDATE("Account Type", Rec."Account Type");
                        GenJrnlLine.VALIDATE("Account No.", Rec."Account No.");
                        GenJrnlLine.VALIDATE("Currency Code", Rec."Currency Code");
                        GenJrnlLine.VALIDATE("Currency Factor", Rec."Currency Factor");
                        GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                        GenJrnlLine."Responsibility Center" := Rec."Responsibility Center";
                        Rec.CALCFIELDS("Amount (LCY)");
                        IF Rec."Exchange Rate" <> 0 THEN
                            GenJrnlLine.VALIDATE(Amount, -(Rec."Amount (LCY)" / Rec."Exchange Rate"));
                        Rec.CALCFIELDS("Amount (LCY)");
                        GenJrnlLine.VALIDATE("Amount (LCY)", -Rec."Amount (LCY)");
                        GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                        //GenJrnlLine.VALIDATE(Description,VoucherLine."Account Name");
                        Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                        GenJrnlLine.VALIDATE(Description, Narr);
                        GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                        GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                        GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::CRV);
                        GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                        GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                        GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                        GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                        GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                        GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                        GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                        GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                        GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                        GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                        GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";
                        GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", VoucherLine."Shortcut Dimension 1 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", VoucherLine."Shortcut Dimension 2 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", VoucherLine."Shortcut Dimension 3 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", VoucherLine."Shortcut Dimension 4 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", VoucherLine."Shortcut Dimension 5 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", VoucherLine."Shortcut Dimension 6 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", VoucherLine."Shortcut Dimension 7 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", VoucherLine."Shortcut Dimension 8 Code");
                        GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                        GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                        GenJrnlLine.VALIDATE("Applies-to ID", VoucherLine."Applies-to ID");
                        GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";

                        GenJrnlLine.INSERT;
                    END;
                    GenJrnlLine.RESET;
                    GenJrnlLine.SETRANGE("Journal Template Name", 'CRV');
                    GenJrnlLine.SETRANGE("Journal Batch Name", 'CRV');
                    GenJrnlLine.SETRANGE("Document No.", PostedVoucherHeader."No.");
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJrnlLine);
                    Message('Posted Successfully');//Biyi

                    /* //print report UNL
                     PostedVoucherHeader2 := PostedVoucherHeader;
                     PostedVoucherHeader2.SETRECFILTER;
                     REPORT.RUN(50055,TRUE,FALSE,PostedVoucherHeader2);*/

                    /* TempApprovalEntry.RESET;
                     TempApprovalEntry.DELETEALL;
                     ApprovalEntry.SETRANGE("Table ID",DATABASE::"Voucher Header");
                     ApprovalEntry.SETRANGE("Document Type",ApprovalEntry."Document Type" :: CRV);
                     ApprovalEntry.SETRANGE("Document No.","No.");
                     IF ApprovalEntry.FINDSET THEN BEGIN
                       REPEAT
                         TempApprovalEntry.INIT;
                         TempApprovalEntry := ApprovalEntry;
                         TempApprovalEntry.INSERT;
                       UNTIL ApprovalEntry.NEXT = 0;
                     END;
                     ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Posted Voucher Header",PostedVoucherHeader."No.");
                     ApprovalMgt.DeleteApprovalEntry(DATABASE::"Voucher Header",9,"No.");*/
                END;

            Rec."Voucher Type"::BRV:
                BEGIN
                    VoucherLine.RESET;
                    VoucherLine.SETRANGE("Voucher Type", VoucherLine."Voucher Type"::BRV);
                    VoucherLine.SETRANGE("Document No.", Rec."No.");
                    IF VoucherLine.FIND('-') THEN BEGIN
                        REPEAT
                            GenJrnlLine.RESET;
                            GenJrnlLine.SETRANGE("Journal Template Name", 'BRV');
                            GenJrnlLine.SETRANGE("Journal Batch Name", 'BRV');
                            GenJrnlLine.SETFILTER(Amount, '=%1', 0);
                            IF GenJrnlLine.FIND('-') THEN
                                GenJrnlLine.DELETEALL;
                            GenJrnlLine.RESET;
                            GenJrnlLine.INIT;
                            GenJrnlLine.VALIDATE("Journal Template Name", 'BRV');
                            GenJrnlLine.VALIDATE("Journal Batch Name", 'BRV');
                            GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No.");
                            GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                            GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                            GenJrnlLine.VALIDATE("Account Type", VoucherLine."Account Type");
                            GenJrnlLine.VALIDATE("Account No.", VoucherLine."Account No.");
                            GenJrnlLine.VALIDATE("Currency Code", VoucherLine."Currency Code");
                            GenJrnlLine.VALIDATE("Currency Factor", VoucherLine."Currency Factor");
                            GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                            GenJrnlLine."Cheque No." := VoucherLine."Teller / Cheque No.";

                            IF VoucherLine."Debit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Debit Amount", VoucherLine."Debit Amount");
                            IF VoucherLine."Credit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Credit Amount", VoucherLine."Credit Amount");
                            IF VoucherLine."Posting Group" <> '' THEN
                                GenJrnlLine.VALIDATE("Posting Group", VoucherLine."Posting Group");
                            GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                            //GenJrnlLine.VALIDATE(Description,VoucherLine."Account Name");
                            Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                            GenJrnlLine.VALIDATE(Description, Narr);
                            GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                            GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                            GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::BRV);
                            GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                            GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                            GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                            GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                            GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                            GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                            GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                            GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                            GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                            GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                            GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";
                            GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                            GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                            GenJrnlLine.VALIDATE("Applies-to ID", VoucherLine."Applies-to ID");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", VoucherLine."Shortcut Dimension 1 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", VoucherLine."Shortcut Dimension 2 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", VoucherLine."Shortcut Dimension 3 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", VoucherLine."Shortcut Dimension 4 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", VoucherLine."Shortcut Dimension 5 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", VoucherLine."Shortcut Dimension 6 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", VoucherLine."Shortcut Dimension 7 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", VoucherLine."Shortcut Dimension 8 Code");
                            GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                            GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";

                            GenJrnlLine.INSERT;
                        UNTIL VoucherLine.NEXT = 0;
                        GenJrnlLine.RESET;
                        GenJrnlLine.INIT;
                        GenJrnlLine.VALIDATE("Journal Template Name", 'BRV');
                        GenJrnlLine.VALIDATE("Journal Batch Name", 'BRV');
                        GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No." + 10000);
                        GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                        GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                        GenJrnlLine.VALIDATE("Account Type", Rec."Account Type");
                        GenJrnlLine.VALIDATE("Account No.", Rec."Account No.");
                        GenJrnlLine.VALIDATE("Currency Code", Rec."Currency Code");
                        GenJrnlLine.VALIDATE("Currency Factor", Rec."Currency Factor");
                        GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                        GenJrnlLine."Responsibility Center" := Rec."Responsibility Center";
                        GenJrnlLine."Cheque No." := VoucherLine."Teller / Cheque No.";
                        Rec.CALCFIELDS("Amount (LCY)");

                        IF Rec."Exchange Rate" <> 0 THEN
                            GenJrnlLine.VALIDATE(Amount, -(Rec."Amount (LCY)" / Rec."Exchange Rate"));
                        Rec.CALCFIELDS("Amount (LCY)");
                        GenJrnlLine.VALIDATE("Amount (LCY)", -Rec."Amount (LCY)");
                        GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                        //GenJrnlLine.VALIDATE(Description,VoucherLine."Account Name");
                        Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                        GenJrnlLine.VALIDATE(Description, Narr);
                        GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                        GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                        GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::BRV);
                        GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                        GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                        GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                        GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                        GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                        GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                        GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                        GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                        GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                        GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                        GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";
                        GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", Rec."Shortcut Dimension 3 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", Rec."Shortcut Dimension 4 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", Rec."Shortcut Dimension 5 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", Rec."Shortcut Dimension 6 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", Rec."Shortcut Dimension 7 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", Rec."Shortcut Dimension 8 Code");
                        GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                        GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                        GenJrnlLine.VALIDATE("Applies-to ID", VoucherLine."Applies-to ID");
                        GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";
                        GenJrnlLine.INSERT;
                    END;
                    GenJrnlLine.RESET;
                    GenJrnlLine.SETRANGE("Journal Template Name", 'BRV');
                    GenJrnlLine.SETRANGE("Journal Batch Name", 'BRV');
                    GenJrnlLine.SETRANGE("Document No.", PostedVoucherHeader."No.");
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJrnlLine);
                    Message('Posted Successfully');//Biyi

                    //print report UNL
                    /* PostedVoucherHeader2 := PostedVoucherHeader;
                     PostedVoucherHeader2.SETRECFILTER;
                     REPORT.RUN(50057,TRUE,FALSE,PostedVoucherHeader2);*/


                    /*TempApprovalEntry.RESET;
                    TempApprovalEntry.DELETEALL;
                    ApprovalEntry.SETRANGE("Table ID",DATABASE::"Voucher Header");
                    ApprovalEntry.SETRANGE("Document Type",ApprovalEntry."Document Type" :: BRV);
                    ApprovalEntry.SETRANGE("Document No.","No.");
                    IF ApprovalEntry.FINDSET THEN BEGIN
                      REPEAT
                        TempApprovalEntry.INIT;
                        TempApprovalEntry := ApprovalEntry;
                        TempApprovalEntry.INSERT;
                      UNTIL ApprovalEntry.NEXT = 0;
                    END;
                    ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Posted Voucher Header",PostedVoucherHeader."No.");
                    ApprovalMgt.DeleteApprovalEntry(DATABASE::"Voucher Header",11,"No.");*/
                END;

            Rec."Voucher Type"::Contra:
                BEGIN
                    VoucherLine.RESET;
                    VoucherLine.SETRANGE("Voucher Type", VoucherLine."Voucher Type"::Contra);
                    VoucherLine.SETRANGE("Document No.", Rec."No.");
                    IF VoucherLine.FIND('-') THEN
                        REPEAT
                            GenJrnlLine.RESET;
                            GenJrnlLine.SETRANGE("Journal Template Name", 'CONTRA');
                            GenJrnlLine.SETRANGE("Journal Batch Name", 'CONTRA');
                            GenJrnlLine.SETFILTER(Amount, '=%1', 0);
                            IF GenJrnlLine.FIND('-') THEN
                                GenJrnlLine.DELETEALL;
                            GenJrnlLine.RESET;
                            GenJrnlLine.INIT;
                            GenJrnlLine.VALIDATE("Journal Template Name", 'CONTRA');
                            GenJrnlLine.VALIDATE("Journal Batch Name", 'CONTRA');
                            GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No.");
                            GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                            GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                            GenJrnlLine.VALIDATE("Account Type", VoucherLine."Account Type");
                            GenJrnlLine.VALIDATE("Account No.", VoucherLine."Account No.");
                            GenJrnlLine.VALIDATE("Currency Code", VoucherLine."Currency Code");
                            GenJrnlLine."Cheque No." := VoucherLine."Teller / Cheque No.";
                            GenJrnlLine.VALIDATE("Currency Factor", VoucherLine."Currency Factor");
                            GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                            IF VoucherLine."Debit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Debit Amount", VoucherLine."Debit Amount");
                            IF VoucherLine."Credit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Credit Amount", VoucherLine."Credit Amount");
                            GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                            //GenJrnlLine.VALIDATE(Description,VoucherLine."Account Name");
                            Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                            GenJrnlLine.VALIDATE(Description, Narr);
                            IF VoucherLine."Posting Group" <> '' THEN
                                GenJrnlLine.VALIDATE("Posting Group", VoucherLine."Posting Group");
                            GenJrnlLine.VALIDATE("Bal. Account Type", GenJrnlLine."Bal. Account Type"::Vendor);
                            GenJrnlLine.VALIDATE("Bal. Account No.", VoucherLine."Bal. Account No.");
                            GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                            GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                            GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::CONTRA);
                            GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                            GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                            GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                            GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                            GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                            GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                            GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                            GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                            GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                            GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                            GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";
                            GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", VoucherLine."Shortcut Dimension 1 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", VoucherLine."Shortcut Dimension 2 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", VoucherLine."Shortcut Dimension 3 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", VoucherLine."Shortcut Dimension 4 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", VoucherLine."Shortcut Dimension 5 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", VoucherLine."Shortcut Dimension 6 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", VoucherLine."Shortcut Dimension 7 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", VoucherLine."Shortcut Dimension 8 Code");
                            GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";
                            GenJrnlLine.INSERT;
                        UNTIL VoucherLine.NEXT = 0;
                    GenJrnlLine.RESET;
                    GenJrnlLine.SETRANGE("Journal Template Name", 'CONTRA');
                    GenJrnlLine.SETRANGE("Journal Batch Name", 'CONTRA');
                    GenJrnlLine.SETRANGE("Document No.", PostedVoucherHeader."No.");
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJrnlLine);
                    TempApprovalEntry.RESET;
                    TempApprovalEntry.DELETEALL;
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Voucher Header");
                    //ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::"15");
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    IF ApprovalEntry.FINDSET THEN BEGIN
                        REPEAT
                            TempApprovalEntry.INIT;
                            TempApprovalEntry := ApprovalEntry;
                            TempApprovalEntry.INSERT;
                        UNTIL ApprovalEntry.NEXT = 0;
                    END;
                    //ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Posted Voucher Header",PostedVoucherHeader."No.");
                    // ApprovalMgt.DeleteApprovalEntry(DATABASE::"Voucher Header",11,"No.");
                END;

            Rec."Voucher Type"::PettyCash:
                BEGIN
                    VoucherLine.RESET;
                    VoucherLine.SETRANGE("Voucher Type", VoucherLine."Voucher Type"::PettyCash);
                    VoucherLine.SETRANGE("Document No.", Rec."No.");
                    IF VoucherLine.FIND('-') THEN BEGIN
                        REPEAT //Voucher Line G/L
                            GenJrnlLine.RESET;
                            GenJrnlLine.SETRANGE("Journal Template Name", 'PettyCash');
                            GenJrnlLine.SETRANGE("Journal Batch Name", 'PettyCash');
                            GenJrnlLine.SETFILTER(Amount, '=%1', 0);
                            IF GenJrnlLine.FIND('-') THEN
                                GenJrnlLine.DELETEALL;
                            GenJrnlLine.RESET;
                            GenJrnlLine.INIT;
                            GenJrnlLine.VALIDATE("Journal Template Name", 'PettyCash');
                            GenJrnlLine.VALIDATE("Journal Batch Name", 'PettyCash');
                            GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No.");
                            GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                            GenJrnlLine."Cheque No." := VoucherLine."Teller / Cheque No.";
                            GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                            GenJrnlLine.VALIDATE("Account Type", VoucherLine."Account Type");
                            GenJrnlLine.VALIDATE("Account No.", VoucherLine."Account No.");
                            GenJrnlLine.VALIDATE("Currency Code", VoucherLine."Currency Code");
                            GenJrnlLine.VALIDATE("Currency Factor", VoucherLine."Currency Factor");
                            GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                            IF VoucherLine."Debit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Debit Amount", VoucherLine."Debit Amount");
                            IF VoucherLine."Credit Amount" <> 0 THEN
                                GenJrnlLine.VALIDATE("Credit Amount", VoucherLine."Credit Amount");
                            IF VoucherLine."Posting Group" <> '' THEN
                                GenJrnlLine.VALIDATE("Posting Group", VoucherLine."Posting Group");
                            GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                            //GenJrnlLine.VALIDATE(Description,VoucherLine."Account Name");
                            Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                            GenJrnlLine.VALIDATE(Description, Narr);
                            GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                            GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                            GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::PETTYCASH);
                            GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                            GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                            GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                            GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                            GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                            GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                            GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                            GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                            GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                            GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                            GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";
                            GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                            GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", VoucherLine."Shortcut Dimension 1 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", VoucherLine."Shortcut Dimension 2 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", VoucherLine."Shortcut Dimension 3 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", VoucherLine."Shortcut Dimension 4 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", VoucherLine."Shortcut Dimension 5 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", VoucherLine."Shortcut Dimension 6 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", VoucherLine."Shortcut Dimension 7 Code");
                            GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", VoucherLine."Shortcut Dimension 8 Code");
                            GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";

                            GenJrnlLine.INSERT;
                        UNTIL VoucherLine.NEXT = 0;

                        GenJrnlLine.INIT;
                        GenJrnlLine.VALIDATE("Journal Template Name", 'PettyCash');
                        GenJrnlLine.VALIDATE("Journal Batch Name", 'PettyCash');
                        GenJrnlLine.VALIDATE("Line No.", VoucherLine."Line No." + 10000);
                        GenJrnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                        GenJrnlLine.VALIDATE("Document No.", PostedVoucherHeader."No.");
                        GenJrnlLine.VALIDATE("Account Type", Rec."Account Type");
                        GenJrnlLine.VALIDATE("Account No.", Rec."Account No.");
                        GenJrnlLine.VALIDATE("Currency Code", Rec."Currency Code");
                        GenJrnlLine.VALIDATE("Currency Factor", Rec."Currency Factor");
                        GenJrnlLine.VALIDATE("External Document No.", Rec."External Document No.");
                        GenJrnlLine."Responsibility Center" := Rec."Responsibility Center";
                        GenJrnlLine."Cheque No." := Rec."Teller / Cheque No.";

                        Rec.CALCFIELDS("Amount (LCY)");
                        IF Rec."Exchange Rate" <> 0 THEN
                            GenJrnlLine.VALIDATE(Amount, -(Rec."Amount (LCY)" / Rec."Exchange Rate"));
                        Rec.CALCFIELDS("Amount (LCY)");
                        GenJrnlLine.VALIDATE("Amount (LCY)", -Rec."Amount (LCY)");
                        GenJrnlLine.VALIDATE("Narration 1", VoucherLine.Narration);
                        //GenJrnlLine.VALIDATE(Description,VoucherLine."Account Name");
                        Narr := COPYSTR(VoucherLine.Narration, 1, 50);
                        GenJrnlLine.VALIDATE(Description, Narr);
                        GenJrnlLine.VALIDATE("Source Code", Rec."Source Code");
                        GenJrnlLine."Responsibility Center" := VoucherLine."Responsibility Center";
                        GenJrnlLine.VALIDATE("Voucher Type", GenJrnlLine."Voucher Type"::PETTYCASH);
                        GenJrnlLine."Created By Name" := PostedVoucherHeader."Created By Name";
                        GenJrnlLine."Created Date" := PostedVoucherHeader."Created Date";
                        GenJrnlLine."Created Time" := PostedVoucherHeader."Created Time";
                        GenJrnlLine."Modified By" := PostedVoucherHeader."Modified By";
                        GenJrnlLine."Modified By Name" := PostedVoucherHeader."Modified By Name";
                        GenJrnlLine."Modified Date" := PostedVoucherHeader."Modified Date";
                        GenJrnlLine."Modified Time" := PostedVoucherHeader."Modified Time";
                        GenJrnlLine."Posted By" := PostedVoucherHeader."Posted By";
                        GenJrnlLine."Posted By Name" := PostedVoucherHeader."Posted By Name";
                        GenJrnlLine."Posted Date" := PostedVoucherHeader."Posted Date";
                        GenJrnlLine."Posted Time" := PostedVoucherHeader."Posted Time";
                        GenJrnlLine.VALIDATE("Applies-to Doc. Type", VoucherLine."Applies-to Doc. Type");
                        GenJrnlLine.VALIDATE("Applies-to Doc. No.", VoucherLine."Applies-to Doc. No.");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 3 Code", Rec."Shortcut Dimension 3 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 4 Code", Rec."Shortcut Dimension 4 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 5 Code", Rec."Shortcut Dimension 5 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 6 Code", Rec."Shortcut Dimension 6 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 7 Code", Rec."Shortcut Dimension 7 Code");
                        GenJrnlLine.VALIDATE("Shortcut Dimension 8 Code", Rec."Shortcut Dimension 8 Code");
                        GenJrnlLine."Payment Request No." := PostedVoucherHeader."Payment Request No.";
                        GenJrnlLine.INSERT;
                    END;
                    GenJrnlLine.RESET;
                    GenJrnlLine.SETRANGE("Journal Template Name", 'PettyCash');
                    GenJrnlLine.SETRANGE("Journal Batch Name", 'PettyCash');
                    GenJrnlLine.SETRANGE("Document No.", PostedVoucherHeader."No.");
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJrnlLine);
                    Message('Posted Successfully');//Biyi

                    //print report UNL
                    //PostedVoucherHeader2 := PostedVoucherHeader;
                    //PostedVoucherHeader2.SETRECFILTER;
                    //REPORT.RUN(50031, TRUE, FALSE, PostedVoucherHeader2);

                    /*  TempApprovalEntry.RESET;
                      TempApprovalEntry.DELETEALL;
                      ApprovalEntry.SETRANGE("Table ID",DATABASE::"Voucher Header");
                      ApprovalEntry.SETRANGE("Document Type",ApprovalEntry."Document Type" :: PettyCash);
                      ApprovalEntry.SETRANGE("Document No.","No.");
                      IF ApprovalEntry.FINDSET THEN BEGIN
                        REPEAT
                          TempApprovalEntry.INIT;
                          TempApprovalEntry := ApprovalEntry;
                          TempApprovalEntry.INSERT;
                        UNTIL ApprovalEntry.NEXT = 0;
                      END;
                      ApprovalMgt.MoveApprvalEntryToPosted(TempApprovalEntry,DATABASE::"Posted Voucher Header",PostedVoucherHeader."No.");
                      ApprovalMgt.DeleteApprovalEntry(DATABASE::"Voucher Header",8,"No.");*/
                END;



        END;
        Rec.DELETE(TRUE);
        COMMIT;

    end;

    var
        PostedVoucherHeader: Record "Posted Voucher Header";
        VoucherLine: Record "Voucher Line";
        PostedVoucherLine: Record "Posted Voucher Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineNo: Integer;
        TempJnlLineDim: Record "Dimension Set Entry" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJrnlLine: Record "Gen. Journal Line";
        ApprovalEntry: Record "Approval Entry";
        TempApprovalEntry: Record "Approval Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        I: Integer;
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        Text001: Label 'Voucher Successfully Posted';
        PostedVoucherHeader2: Record "Posted Voucher Header";
        Narr: Text[50];
        PHeaderRec: Record "Payments Header";
}

