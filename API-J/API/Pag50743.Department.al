page 50743 Department
{
    APIGroup = 'department';
    APIPublisher = 'Reeltech';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'department';
    DelayedInsert = true;
    EntityName = 'department';
    EntitySetName = 'departments';
    PageType = API;
    SourceTable = "Dimension Value";
    SourceTableView = WHERE("Global Dimension No." = CONST(2));
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
