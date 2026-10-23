page 50647 "Additional Email Input"
{
    PageType = StandardDialog;
    Caption = 'Enter Additional Email';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(AdditionalEmail; AdditionalEmail)
            {
                Caption = 'Additional Email';
                ToolTip = 'Enter additional email addresses separated by commas.';
            }
        }
    }

    var
        AdditionalEmail: Text;

    procedure GetAdditionalEmail(): Text
    begin
        exit(AdditionalEmail);
    end;
}