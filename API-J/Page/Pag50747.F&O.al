page 50747 "FnO Exp Attached Documents"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'FnO Exp Attached Documents';
    SourceTable = "F&OTable";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Id"; Rec."Document Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Document Id from F&O (unique key).';
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The file name of the attachment.';
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    ToolTip = 'The file extension of the attachment.';
                }
                field("Attachment Size"; Rec."Attachment Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'The size, in bytes, of the stored attachment. 0 means no attachment content was captured.';
                }
                field("Ref Company Id"; Rec."Ref Company Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'The company the document references in F&O.';
                }
                field("Document Created By"; Rec."Document Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Who created the document in F&O.';
                }
                field("Document Created Date Time"; Rec."Document Created Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'When the document was created in F&O.';
                }
                field("Exp Trans Number"; Rec."Exp Trans Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'The related expense transaction number, if any.';
                }
                field("Imported DateTime"; Rec."Imported DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'When this record was imported into Business Central.';
                }
            }
        }
        area(factboxes)
        {
            part(AttachmentFactBox; "FnO Exp Attachment FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Document Id" = field("Document Id");
            }
        }
    }
}