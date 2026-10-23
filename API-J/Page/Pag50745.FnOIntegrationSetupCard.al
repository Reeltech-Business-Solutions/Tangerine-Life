page 50745 "FnO Integration Setup Card"
{
    ApplicationArea = All;
    Caption = 'FnO Integration Setup Card';
    PageType = Card;
    SourceTable = "FnO Integration Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Tenant Id"; Rec."Tenant Id") { ApplicationArea = All; }
                field("Client Id"; Rec."Client Id") { ApplicationArea = All; }
                field("F&O Environment URL"; Rec."F&O Environment URL") { ApplicationArea = All; }
                field("Data Area Id"; Rec."Data Area Id") { ApplicationArea = All; }
                field("Batch Size"; Rec."Batch Size") { ApplicationArea = All; }

                field(ClientSecretInput; ClientSecretInputTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Client Secret';
                    ExtendedDatatype = Masked;
                    ToolTip = 'Enter the Azure AD app client secret. Stored securely; not shown again after saving.';

                    trigger OnValidate()
                    var
                        SecretMgt: Codeunit "FnO Secret Mgt";
                    begin
                        if ClientSecretInputTxt <> '' then
                            SecretMgt.SetClientSecret(ClientSecretInputTxt);
                        ClientSecretInputTxt := '';
                    end;
                }
            }
        }
    }

    var
        ClientSecretInputTxt: Text[250];
        Scheduler: Codeunit "FnO Job Queue Scheduler";

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
    
}

