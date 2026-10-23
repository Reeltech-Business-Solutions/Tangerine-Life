page 50635 "Payment Types5"
{
    PageType = Card;
    SourceTable = "Receipts and Payment Types";
    SourceTableView = WHERE(Type = CONST(Payment));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        AccountTypeOnAfterValidate;
                    end;
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = All;
                }
                field("VAT Chargeable"; Rec."VAT Chargeable")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        UpdateControl;
                    end;
                }
                field("Withholding Tax Chargeable"; rec."Withholding Tax Chargeable")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        UpdateControl;
                    end;
                }
                field("Calculate Retention"; Rec."Calculate Retention")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        UpdateControl;
                    end;
                }
                field("VAT Code"; Rec."VAT Code")
                {
                    ApplicationArea = All;
                    Enabled = "VAT CodeEnable";
                }
                field("Withholding Tax Code"; Rec."Withholding Tax Code")
                {
                    ApplicationArea = All;
                    Enabled = "Withholding Tax CodeEnable";
                }
                field("Retention Code"; Rec."Retention Code")
                {
                    ApplicationArea = All;
                    Enabled = "Retention CodeEnable";
                }
                field("Default Grouping"; Rec."Default Grouping")
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Pending Voucher"; Rec."Pending Voucher")
                {
                    ApplicationArea = All;
                }
                field("Transation Remarks"; Rec."Transation Remarks")
                {
                    ApplicationArea = All;
                }
                field("Direct Expense"; Rec."Direct Expense")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //CurrPage."G/L AccountVisible":=("Account Type"="Account Type"::"G/L Account");
        OnAfterGetCurrrRecord;
    end;

    trigger OnInit()
    begin
        "Retention CodeEnable" := true;
        "Withholding Tax CodeEnable" := true;
        "VAT CodeEnable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Payment;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Account Type" := Rec."Account Type"::None;
        OnAfterGetCurrrRecord;
    end;

    trigger OnOpenPage()
    begin
        UpdateControl;
    end;

    var
        // [InDataSet]
        "VAT CodeEnable": Boolean;
        //  [InDataSet]
        "Withholding Tax CodeEnable": Boolean;
        // [InDataSet]
        "Retention CodeEnable": Boolean;

    procedure UpdateControl()
    begin
        if Rec."VAT Chargeable" = Rec."VAT Chargeable"::Yes then
            "VAT CodeEnable" := true
        else
            "VAT CodeEnable" := false;

        if Rec."Withholding Tax Chargeable" = Rec."Withholding Tax Chargeable"::Yes then
            "Withholding Tax CodeEnable" := true
        else
            "Withholding Tax CodeEnable" := false;

        if Rec."Calculate Retention" = Rec."Calculate Retention"::Yes then
            "Retention CodeEnable" := true

        else
            "Retention CodeEnable" := false;
    end;

    local procedure AccountTypeOnAfterValidate()
    begin
        //CurrPage."G/L Account".VISIBLE:=("Account Type"="Account Type"::"G/L Account");
    end;

    local procedure OnAfterGetCurrrRecord()
    begin
        xRec := Rec;
        UpdateControl;
    end;
}

