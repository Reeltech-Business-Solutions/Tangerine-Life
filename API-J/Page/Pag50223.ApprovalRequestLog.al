page 50614 ApprovalRequestLogAPI
{
    APIGroup = 'Advance';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'approvalRequestLogAPI';
    DelayedInsert = true;
    EntityName = 'ApprovalReqTrigger';
    EntitySetName = 'ApprovalReqTrigger';
    PageType = API;
    SourceTable = ApprovalRequestlog;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(tableID; Rec."Table ID")
                {
                    Caption = 'Table ID';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(actionType; Rec."Action Type")
                {
                    Caption = 'Action Type';
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
