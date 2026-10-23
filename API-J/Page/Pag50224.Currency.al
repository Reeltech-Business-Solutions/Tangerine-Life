page 50615 Currency
{
    APIGroup = 'Currencies';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'currency';
    DelayedInsert = true;
    EntityName = 'Currency';
    EntitySetName = 'CurrencyAPI';
    PageType = API;
    SourceTable = Currency;

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
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
