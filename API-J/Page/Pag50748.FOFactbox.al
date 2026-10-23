page 50748 "FnO Exp Attachment FactBox"
{
    PageType = CardPart;
    ApplicationArea = All;
    Caption = 'Attachment Details';
    SourceTable = "F&OTable";

    layout
    {
        area(content)
        {
            group(General)
            {
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
                field("Content Type"; Rec."Content Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'The content type reported by F&O, if any.';
                }
                field("Attachment Size"; Rec."Attachment Size")
                {
                    ApplicationArea = All;
                    Caption = 'Size (bytes)';
                    ToolTip = 'The size of the stored attachment. 0 means no attachment content was captured.';
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
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Notes captured on the document in F&O.';
                }
                field("Captured Receipt"; Rec."Captured Receipt")
                {
                    ApplicationArea = All;
                    ToolTip = 'The captured receipt value from F&O.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DownloadAttachment)
            {
                ApplicationArea = All;
                Caption = 'Download Attachment';
                ToolTip = 'Downloads the stored attachment file to your device.';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    InStr: InStream;
                    DownloadFileName: Text;
                begin
                    Rec.CalcFields(Attachment);
                    if not Rec.Attachment.HasValue() then begin
                        Message('No attachment content is stored for this record.');
                        exit;
                    end;

                    DownloadFileName := Rec."File Name";
                    if DownloadFileName = '' then
                        DownloadFileName := Rec."Document Id";
                    if Rec."File Extension" <> '' then
                        DownloadFileName := DownloadFileName + '.' + Rec."File Extension";

                    Rec.Attachment.CreateInStream(InStr);
                    DownloadFromStream(InStr, '', '', '', DownloadFileName);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Attachment);
    end;
}
