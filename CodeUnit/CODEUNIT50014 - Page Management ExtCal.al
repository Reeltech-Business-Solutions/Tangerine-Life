codeunit 50612 "Page Management ExtCal"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 700, 'OnAfterGetPageID', '', false, false)]
    local procedure OnAfterGetPageID(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalCardPageID(RecordRef);
    end;

    local procedure GetConditionalCardPageID(RecordRef: RecordRef): Integer
    var
        CardPageID: Integer;
        VoucherHeader: Record "Voucher Header";
        PHeader: Record "Payments Header";
        StaffAdvance: Record "Staff Advance Header";
        Retirement: Record "Staff Advanc Surrender Header";
        PurchaseHeader: Record "Purchase Header";


    begin
        case RecordRef.Number of
            DATABASE::"Voucher Header":
                // exit(GetVoucherHeaderPageID(RecordRef));
                begin
                    RecordRef.SetTable(VoucherHeader);
                    case VoucherHeader."Voucher Type" of
                        VoucherHeader."Voucher Type"::BPV:
                            //begin
                            exit(PAGE::"Bank Payment Voucher");
                        //end;
                        VoucherHeader."Voucher Type"::BRV:
                            // begin
                            exit(PAGE::"Bank Receipt Voucher");
                        // end;
                        VoucherHeader."Voucher Type"::CPV:
                            //begin
                            exit(PAGE::"Cash Payment Voucher");
                        //end;
                        VoucherHeader."Voucher Type"::CRV:
                            begin
                                exit(PAGE::"Cash Receipt Voucher");
                            end;
                        VoucherHeader."Voucher Type"::JV:
                            begin
                                exit(PAGE::"Journal Voucher");
                            end;
                        VoucherHeader."Voucher Type"::PettyCash:
                            begin
                                exit(PAGE::"Petty Cash Voucher");
                            end;
                    end;
                end;
            DATABASE::"Payments Header":
                begin
                    RecordRef.SetTable(PHeader);
                    case PHeader."Payment Type" of
                        PHeader."Payment Type"::"Petty Cash":
                            exit(PAGE::"Payment Header");
                        PHeader."Payment Type"::Normal:
                            exit(PAGE::"Payment Header");
                    // PHeader."Payment Type"::LC:
                    //     EXIT(PAGE::"LC Request Card");
                    end;
                end;
            DATABASE::"Staff Advance Header":
                begin
                    RecordRef.SetTable(StaffAdvance);
                    case StaffAdvance."Type of Advance" of
                        StaffAdvance."Type of Advance"::"Staff Advance":
                            exit(PAGE::"Staff Advance Request");
                    end;
                end;
            DATABASE::"Staff Advanc Surrender Header":
                begin
                    RecordRef.SetTable(Retirement);
                    case Retirement."Retirement Type" of
                        Retirement."Retirement Type"::"Advance Retirement":
                            exit(PAGE::"Staff Advance Retirement");

                    end;
                end;

            DATABASE::"G/L Account":
                exit(PAGE::"G/L Account Card");

            DATABASE::"Staff Claims Header":
                exit(PAGE::"Staff Claim");
        // DATABASE::"Purchase Header":
        //     begin
        //         RecordRef.SetTable(PurchaseHeader);
        //         case PurchaseHeader."Purchase Type" of
        //             PurchaseHeader."Purchase Type"::Local:
        //                 exit(PAGE::"Purchase Local Req");
        //             PurchaseHeader."Purchase Type"::"Local Requisition":
        //                 exit(PAGE::"Purchase Local Req");
        //             PurchaseHeader."Purchase Type"::Foreign:
        //                 exit(PAGE::"Purchase Foreign Req");
        //             PurchaseHeader."Purchase Type"::"Foreign Requisition":
        //                 exit(PAGE::"Purchase Foreign Req");
        //             PurchaseHeader."Purchase Type"::Cash:
        //                 exit(PAGE::"Purchase Cash Req");
        //             PurchaseHeader."Purchase Type"::"Import Charge":
        //                 exit(PAGE::"Import File Card");
        //         end;
        //     end;


        end;
    end;

    local procedure GetVoucherHeaderPageID(RecordRef: RecordRef):
                                Integer
    var
        VoucherHeader: Record "Voucher Header";

    begin
        RecordRef.SETTABLE(VoucherHeader);
        CASE VoucherHeader."Voucher Type" OF
            VoucherHeader."Voucher Type"::BPV:
                EXIT(PAGE::"Bank Payment Voucher");
            VoucherHeader."Voucher Type"::BRV:
                EXIT(PAGE::"Bank Receipt Voucher");
            VoucherHeader."Voucher Type"::CRV:
                EXIT(PAGE::"Cash Receipt Voucher");
            VoucherHeader."Voucher Type"::CPV:
                EXIT(PAGE::"Cash Payment Voucher");
            VoucherHeader."Voucher Type"::PettyCash:
                EXIT(PAGE::"Petty Cash Voucher");
            VoucherHeader."Voucher Type"::JV:
                EXIT(PAGE::"Journal Voucher");
        END;

    end;

    /*
        local procedure GetVoucherHeaderListPageID(RecRef: RecordRef): Integer
        var
            VoucherHeader: Record "Voucher Header";
        begin
            RecRef.SetTable(VoucherHeader);
            case VoucherHeader."Voucher Type" of
                VoucherHeader."Voucher Type"::BPV:
                    exit(PAGE::"Bank Payment List");
                VoucherHeader."Voucher Type"::BRV:
                    exit(PAGE::"Bank Receipt  List");
                VoucherHeader."Voucher Type"::Contra:
                    exit(PAGE::"Contra Voucher List");
                VoucherHeader."Voucher Type"::CPV:
                    exit(PAGE::"Cash Payment List");
                VoucherHeader."Voucher Type"::CRV:
                    exit(PAGE::"Cash Receipt  List");
                VoucherHeader."Voucher Type"::JV:
                    exit(PAGE::"Journal Voucher List");
                VoucherHeader."Voucher Type"::PettyCash:
                    exit(PAGE::"Petty Cash List");
            end;
        end;

        procedure GetConditionalListPageID(RecRef: RecordRef): Integer
        var
            PageID: Integer;
            IsHandled: Boolean;
        begin
            IsHandled := false;
            OnBeforeGetConditionalListPageID(RecRef, PageID, IsHandled);
            if IsHandled then
                exit(PageID);

            case RecRef.Number of
                DATABASE::"Voucher Header":
                    exit(GetVoucherHeaderListPageID(RecRef));
            end;
            exit(0);
        end;
    */
    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetConditionalListPageID(RecRef: RecordRef; var PageID: Integer; var IsHandled: Boolean);
    begin
    end;
}

