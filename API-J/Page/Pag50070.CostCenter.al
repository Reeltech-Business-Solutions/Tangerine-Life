page 50603 "Cost Center"
{
    APIGroup = 'Dimension2';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'costCenter';
    DelayedInsert = true;
    EntityName = 'CostCenterAPI';
    EntitySetName = 'CostCenter';
    PageType = API;
    SourceTable = "Dimension Value";
    SourceTableView = WHERE("Dimension Code" = filter('COST CENTRE'));
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
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(dimensionCode; Rec."Dimension Code")
                {
                    Caption = 'Dimension Code';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
