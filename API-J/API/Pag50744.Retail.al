page 50744 Retail
{
    APIGroup = 'retail';
    APIPublisher = 'Reeltech';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'retail';
    DelayedInsert = true;
    EntityName = 'retail';
    EntitySetName = 'retails';
    PageType = API;
    SourceTable = "Dimension Value";
    SourceTableView = WHERE("Global Dimension No." = CONST(5));
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {


                }
                field(Name; Rec.Name)
                {

                }

                field(SystemId; Rec.SystemId)
                {

                }

            }
        }
    }
}
