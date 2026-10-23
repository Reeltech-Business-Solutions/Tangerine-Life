page 50739 banks
{
    APIGroup = 'bank';
    APIPublisher = 'Reeltech';
    APIVersion = 'v1.0';
    Caption = 'bank';
    DelayedInsert = true;
    EntityName = 'bank_account';
    EntitySetName = 'bank_accounts';
    PageType = API;
    SourceTable = "Bank Account";
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(bank_no; Rec."No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                }

                field(bank_name; Rec.Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
            }
        }
    }


}
