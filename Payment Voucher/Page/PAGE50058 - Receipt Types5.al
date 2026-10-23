page 50634 "Receipt Types5"
{
    PageType = List;
    SourceTable = "Receipts and Payment Types";
    SourceTableView = WHERE(Type = CONST(Receipt));
    //UsageCategory = Lists;
    //ApplicationArea = All;

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
                        //check the account type selected by the user
                        case Rec."Account Type" of
                            "Account Type"::Customer:
                                begin
                                    CustomerPaymentOnAccountVisibl := true;
                                end;
                            "Account Type"::Vendor,
                            "Account Type"::"Bank Account",
                            "Account Type"::"Fixed Asset",
                            "Account Type"::"G/L Account":
                                begin
                                    CustomerPaymentOnAccountVisibl := false;
                                end;
                        end;
                    end;
                }
                /*  field("Customer Payment On Account"; "Customer Payment On Account")
                  {
                      Visible = CustomerPaymentOnAccountVisibl;
                  }
                  */
                field("Default Grouping"; Rec."Default Grouping")
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Transation Remarks"; Rec."Transation Remarks")
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
        OnAfterGetCurrrRecord;
    end;

    trigger OnInit()
    begin
        CustomerPaymentOnAccountVisibl := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Receipt;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrrRecord;
    end;

    var
        // [InDataSet]
        CustomerPaymentOnAccountVisibl: Boolean;

    local procedure OnAfterGetCurrrRecord()
    begin
        xRec := Rec;
        //check the account type selected by the user
        case Rec."Account Type" of
            Rec."Account Type"::Customer:
                begin
                    CustomerPaymentOnAccountVisibl := true;
                end;
            Rec."Account Type"::Vendor,
            Rec."Account Type"::"Bank Account",
            Rec."Account Type"::"Fixed Asset",
            Rec."Account Type"::"G/L Account":
                begin
                    CustomerPaymentOnAccountVisibl := false;
                end;
        end;
    end;
}

