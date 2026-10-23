page 50742 product
{
    APIGroup = 'product';
    APIPublisher = 'Reeltech';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'branch';
    DelayedInsert = true;
    EntityName = 'product';
    EntitySetName = 'products';
    PageType = API;
    SourceTable = "Dimension Value";
    SourceTableView = WHERE("Global Dimension No." = CONST(1));
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
