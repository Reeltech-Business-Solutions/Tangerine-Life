page 50602 "Profit Center API"
{
    APIGroup = 'Dimention1';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'profitCenterAPI';
    DelayedInsert = true;
    EntityName = 'Profitcenter';
    EntitySetName = 'ProfitCenter';
    PageType = API;
    SourceTable = "Dimension Value";
    Editable = false;
    InsertAllowed = false;
    SourceTableView = WHERE("Dimension Code" = filter('CONTRACT'));

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
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
