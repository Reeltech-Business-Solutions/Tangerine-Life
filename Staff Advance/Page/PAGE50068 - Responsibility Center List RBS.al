page 50689 "Responsibility Center List RBS"
{
    Caption = 'Responsibility Center List';
    CardPageID = "Responsibility Center Card RBS";
    Editable = false;
    PageType = List;
    SourceTable = "Responsibility Center";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Resp. Ctr.")
            {
                Caption = '&Resp. Ctr.';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ApplicationArea = All;
                    RunObject = Page "Responsibility Center Card RBS";
                    RunPageLink = Code = FIELD(Code);
                    ShortCutKey = 'Shift+F7';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action("Dimensions-Single")
                    {
                        ApplicationArea = All;
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(5714),
                                      "No." = FIELD(Code);
                        ShortCutKey = 'Shift+Ctrl+D';

                    }
                    action("Dimensions-&Multiple")
                    {
                        Caption = 'Dimensions-&Multiple';
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            RespCenter: Record "Responsibility Center";
                        begin
                            /*CurrPage.SETSELECTIONFILTER(RespCenter);
                            DefaultDimMultiple.SetMultiRespCenter(RespCenter);
                            DefaultDimMultiple.RUNMODAL;  */

                        end;
                    }
                }
            }
        }
    }
}

