page 50624 chart
{
    APIGroup = 'chart';
    APIPublisher = 'Reeltech';
    APIVersion = 'v1.0';
    Caption = 'chart';
    DelayedInsert = true;
    EntityName = 'chart';
    EntitySetName = 'charts';
    PageType = API;
    SourceTable = "G/L Account";
    SourceTableView = where("Account Type" = const(Posting));
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                }

                field(name; Rec.Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
            }
        }
    }


}
