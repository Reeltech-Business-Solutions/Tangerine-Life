page 50625 "Profit Centre"
{

    Caption = 'Profit Centre';
    PageType = List;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "Dimension Value";
    SourceTableView = WHERE("Dimension Code" = filter('REVENUE CENTRE'));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

}
