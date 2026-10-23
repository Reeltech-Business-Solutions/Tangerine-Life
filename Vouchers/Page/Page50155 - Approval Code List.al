page 50731 "Approval CodeList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Group Head Approval";

    layout
    {
        area(Content)
        {
            // repeater(GroupName)
            //  {
            field(Code; Rec.Code)
            {
                    ApplicationArea = All;
            }

            field(Description; Rec.Description)
            {
                ApplicationArea = All;

            }
        }
    }

}


