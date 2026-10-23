page 50741 BRANCH
{
    APIGroup = 'branch';
    APIPublisher = 'Reeltech';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'branch';
    DelayedInsert = true;
    EntityName = 'branch';
    EntitySetName = 'branchs';
    PageType = API;
    SourceTable = "Dimension Value";
    SourceTableView = WHERE("Global Dimension No." = CONST(3));
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
