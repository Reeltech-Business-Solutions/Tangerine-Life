page 50617 ResponcibilityCenter
{
    APIGroup = 'Center';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'responcibilityCenter';
    DelayedInsert = true;
    EntityName = 'RespCenter';
    EntitySetName = 'RespCenterAPI';
    PageType = API;
    SourceTable = "Responsibility Center";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
