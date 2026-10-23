codeunit 50603 DocAttachment
{
    //EventSubscriberInstance = StaticAutomatic;
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure DocAttachment(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)

    begin
        case DocumentAttachment."Table ID" of

            DATABASE::"Staff Advanc Surrender Header":
                begin
                    RecRef.Open(Database::"Staff Advanc Surrender Header");
                    If StaffRet.get(DocumentAttachment."No.") then
                        RecRef.GetTable(StaffRet);
                end;
            DATABASE::"Staff Advance Header":
                begin
                    RecRef.Open(Database::"Staff Advance Header");
                    If StaffAdv.get(DocumentAttachment."No.") then
                        RecRef.GetTable(StaffAdv);
                end;
            DATABASE::"Staff Claims Header":
                begin
                    RecRef.Open(Database::"Staff Claims Header");
                    If StaffClaim.get(DocumentAttachment."No.") then
                        RecRef.GetTable(StaffClaim);
                end;
            DATABASE::"Voucher Header":
                begin
                    RecRef.Open(Database::"Voucher Header");
                    VHeader.SetFilter("No.", DocumentAttachment."No.");
                    if VHeader.FindFirst() then
                        RecRef.GetTable(VHeader);
                end;
            DATABASE::"Purchase Quote Header":
                begin
                    RecRef.Open(Database::"Purchase Quote Header");
                    If PurchaseQuoteHeader.get(DocumentAttachment."Document Type", DocumentAttachment."No.") then
                        RecRef.GetTable(PurchaseQuoteHeader);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure DocAttachmentDetails(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin

        case RecRef.Number of
            DATABASE::"Staff Advance Header",
            DATABASE::"Staff Advanc Surrender Header",
            DATABASE::"Staff Claims Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Service Header",
            DATABASE::"Service Line":
                begin
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    DocumentAttachment.SetRange("Document Type", DocType);

                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);

                    FlowFieldsEditable := false;
                end;
        end;

        Case RecRef.Number of
            Database::"Voucher Header":
                begin

                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);


                end;
        End;

        Case RecRef.Number of
            Database::"Purchase Quote Header":
                begin

                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;

    end;


    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Voucher Header":
                begin
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;

                    DocumentAttachment.Validate("Document Type", DocType);

                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Staff Advance Header",
            DATABASE::"Staff Advanc Surrender Header",
            DATABASE::"Staff Claims Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Service Header",
            DATABASE::"Service Line":
                begin
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    DocumentAttachment.Validate("Document Type", DocType);

                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);

                    FlowFieldsEditable := false;
                end;
        end;

        case RecRef.Number of
            DATABASE::"Purchase Quote Header":
                begin
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    DocumentAttachment.Validate("Document Type", DocType);

                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;

    end;

    var
        StaffClaim: Record "Staff Claims Header";
        VHeader: Record "Voucher Header";
        ServiceItem: Record "Service Item";
        ServiceHeader: Record "Service Header";
        RFQ: Record "Purchase Quote Header";
        RecNo: Code[20];
        DocType: Enum DocType;
        AttachmentDocumentType: enum "Attachment Document Type";
        LineNo: Integer;
        FieldRef: FieldRef;
        StaffRet: Record "Staff Advanc Surrender Header";
        StaffAdv: Record "Staff Advance Header";
        PurchaseQuoteHeader: Record "Purchase Quote Header";
        FlowFieldsEditable: Boolean;

}
