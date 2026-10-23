page 50613 "Receipt Pay Type List API"
{
    APIGroup = 'PayType';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'receiptPayTypeListAPI';
    DelayedInsert = true;
    EntityName = 'ReceiptPaytype';
    EntitySetName = 'ReceiptPayTypeAPI';
    PageType = API;
    SourceTable = "Receipts and Payment Types";
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(accountType; Rec."Account Type")
                {
                    Caption = 'Account Type';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(vatChargeable; Rec."VAT Chargeable")
                {
                    Caption = 'VAT Chargeable';
                }
                field(withholdingTaxChargeable; Rec."Withholding Tax Chargeable")
                {
                    Caption = 'Withholding Tax Chargeable';
                }
                field(vatCode; Rec."VAT Code")
                {
                    Caption = 'VAT Code';
                }
                field(gLAccount; Rec."Account No.")
                {
                    Caption = 'G/L Account';
                }
                field(pendingVoucher; Rec."Pending Voucher")
                {
                    Caption = 'Pending Voucher';
                }
                field(bankAccount; Rec."Bank Account")
                {
                    Caption = 'Bank Account';
                }
                field(transationRemarks; Rec."Transation Remarks")
                {
                    Caption = 'Transation Remarks';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
