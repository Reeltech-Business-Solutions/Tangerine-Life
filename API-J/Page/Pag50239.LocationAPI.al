page 50618 "Location API"
{
    APIGroup = 'Location';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'locationAPI';
    DelayedInsert = true;
    EntityName = 'Location';
    EntitySetName = 'LocationAPI';
    PageType = API;
    SourceTable = Location;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                    ApplicationArea = All;
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
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
