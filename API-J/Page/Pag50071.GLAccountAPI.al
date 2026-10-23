page 50604 "GL Account API"
{
    APIGroup = 'GLA';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'glAccountAPI';
    DelayedInsert = true;
    EntityName = 'GLAccountAPI';
    EntitySetName = 'GLAccount';
    PageType = API;
    SourceTable = "G/L Account";
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
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
