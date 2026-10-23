page 50733 WorkflowEvent
{
    Caption = 'WorkflowEvent';
    PageType = List;
    SourceTable = "workflow Event";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the workflow event that comes before the workflow event in the workflow sequence.';
                }
                field("Dynamic Req. Page Entity Name"; Rec."Dynamic Req. Page Entity Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dynamic Req. Page Entity Name field.';
                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field(Independent; Rec.Independent)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Independent field.';
                }
                field("Request Page ID"; Rec."Request Page ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Request Page ID field.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                field("Used for Record Change"; Rec."Used for Record Change")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Used for Record Change field.';
                }
            }
        }
    }
}
