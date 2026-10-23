page 50659 "RFQ Header"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,Print/Send,Navigate';
    SourceTable = "Purchase Quote Header";


    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                }
                field("Expected Opening Date"; Rec."Expected Opening Date")
                {
                    ApplicationArea = All;
                    Caption = 'RFQ Date';
                }
                field("Expected Closing Date"; Rec."Expected Closing Date")
                {
                    ApplicationArea = All;
                    Caption = 'RFQ Deadline Date';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }


                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {

                    ApplicationArea = All;
                    Editable = false;
                }
                field("created Date"; Rec."created Date")
                {

                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part("RFQ Subform"; "RFQ Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;

                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50030),
                              "No." = FIELD("No.");
                // , "Document Type" = FIELD("Document Type");
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {

                ApplicationArea = Suite;
                ShowFilter = false;
                Visible = false;
            }

            part("Quotation Req. Vendors Fact"; "Quotation Req. Vendors")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
                //  "Date Filter" = FIELD("Date Filter");
                Visible = true;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(New)
            {
                action("Get Document Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Get Document Lines';
                    Image = GetLines;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.UPDATE(TRUE);
                        InsertRFQLines;
                    end;
                }
                action("Assign Vendor(s)")
                {
                    ApplicationArea = All;
                    Caption = 'Assign Vendor(s)';
                    Image = Vendor;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Vends: Record "Quotation Request Vendors";
                    begin

                        Vends.RESET;
                        Vends.SETRANGE(Vends."Document Type", Rec."Document Type");
                        Vends.SETRANGE(Vends."Document No.", Rec."No.");

                        PAGE.RUN(PAGE::"Quotation Request Vendors", Vends);
                    end;
                }
                action("Print/Preview")
                {
                    ApplicationArea = All;
                    Caption = 'Print/Preview';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";


                    trigger OnAction()
                    begin

                        PQH.SETRECFILTER;
                        PQH.SETFILTER(PQH."Document Type", '%1', Rec."Document Type");
                        PQH.SETFILTER("No.", Rec."No.");
                        repvend.SETTABLEVIEW(PQH);
                        repvend.RUN;
                    end;
                }
                action(Quotes)
                {
                    ApplicationArea = All;
                    Caption = 'View Quotes';
                    Image = Quote;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Purchase Quotes";
                    RunPageLink = "RFQ No." = field("No.");
                }
                action(Orders)
                {
                    ApplicationArea = All;
                    Caption = 'View Orders';
                    Image = Order;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Purchase Order List";
                    RunPageLink = "RFQ No." = field("No.");
                }
                action("Create Quotes")
                {
                    ApplicationArea = All;
                    Caption = 'Create Vendor Quotes';
                    Image = VendorPayment;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    var
                        RFQLines: Record "Purchase Quote Line";
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLines: Record "Purchase Line";
                        Vends: Record "Quotation Request Vendors";
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                    begin
                        Vends.SETRANGE(Vends."Document No.", Rec."No.");

                        IF Vends.FINDSET THEN
                            REPEAT
                                //create header
                                PurchaseHeader.INIT;
                                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Quote;
                                //PurchaseHeader."Purchase Type" := PurchaseHeader."Purchase Type"::Quote;
                                PurchaseHeader."No." := NoSeriesMgt.GetNextNo('P-QUO', TODAY, TRUE);
                                PurchaseHeader."Responsibility Center" := Rec."Responsibility Center";
                                PurchaseHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                                PurchaseHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                PurchaseHeader.INSERT(TRUE);
                                PurchaseHeader.VALIDATE("Buy-from Vendor No.", Vends."Vendor No.");
                                PurchaseHeader."Responsibility Center" := Rec."Responsibility Center";
                                PurchaseHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                                PurchaseHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                                //PurchaseHeader.validate("RFQ No.","No.");
                                PurchaseHeader.MODIFY;
                                PurchaseHeader.INSERT(TRUE);

                                //create lines

                                RFQLines.SETRANGE(RFQLines."Document No.", Rec."No.");
                                RFQLines.DeleteAll();
                                IF RFQLines.FINDSET THEN
                                    REPEAT
                                        PurchaseLines.INIT;
                                        PurchaseLines.TRANSFERFIELDS(RFQLines);
                                        PurchaseLines."Document Type" := PurchaseLines."Document Type"::Quote;
                                        PurchaseLines."Document No." := Rec."No.";
                                        PurchaseLines.INSERT;
                                    /*
                                      ReqLines.VALIDATE(ReqLines."No.");
                                      ReqLines.VALIDATE(ReqLines.Quantity);
                                      ReqLines.VALIDATE(ReqLines."Direct Unit Cost");
                                      ReqLines.MODIFY;
                                    */
                                    UNTIL RFQLines.NEXT = 0;
                            UNTIL Vends.NEXT = 0;

                    end;
                }

                // action("Bid Analysis")
                // {
                //     Caption = 'Bid Analysis';
                //     Image = Worksheet;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     RunObject = Page "Bid Analysis Worksheet";
                //     RunPageLink = "RFQ No." = FIELD("No.");
                //     ApplicationArea = All;
                //     Visible = false;

                //     trigger OnAction()
                //     var
                //         PurchaseHeader: Record "Purchase Header";
                //         PurchaseLines: Record "Purchase Line";
                //         ItemNoFilter: Text[250];
                //         RFQNoFilter: Text[250];
                //         InsertCount: Integer;
                //         BidAnalysis: Record "Bid Analysis";
                //     begin
                //         //deletebidanalysis for this vendor
                //         BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", "No.");
                //         BidAnalysis.DELETEALL;


                //         //insert the quotes from vendors

                //         PurchaseHeader.SETRANGE("RFQ No.", "No.");
                //         PurchaseHeader.FINDSET;
                //         REPEAT
                //             PurchaseLines.RESET;
                //             PurchaseLines.SETRANGE("Document No.", PurchaseHeader."No.");
                //             IF PurchaseLines.FINDSET THEN
                //                 REPEAT
                //                     BidAnalysis.INIT;
                //                     BidAnalysis."RFQ No." := "No.";
                //                     BidAnalysis."RFQ Line No." := PurchaseLines."Line No.";
                //                     BidAnalysis."Quote No." := PurchaseLines."Document No.";
                //                     BidAnalysis."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                //                     BidAnalysis."Item No." := PurchaseLines."No.";
                //                     BidAnalysis.Description := PurchaseLines.Description;
                //                     BidAnalysis.Quantity := PurchaseLines.Quantity;
                //                     BidAnalysis."Unit Of Measure" := PurchaseLines."Unit of Measure";
                //                     BidAnalysis.Amount := PurchaseLines."Direct Unit Cost";
                //                     BidAnalysis."Line Amount" := BidAnalysis.Quantity * BidAnalysis.Amount;
                //                     BidAnalysis.INSERT(TRUE);
                //                     InsertCount += 1;
                //                 UNTIL PurchaseLines.NEXT = 0;
                //         UNTIL PurchaseHeader.NEXT = 0;
                //         MESSAGE('%1 records have been inserted to the bid analysis', InsertCount);
                //     end;
                // }
            }
            group("Send Mail")
            {
                action("Send As Mail")
                {
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        SendEmail(Rec);
                        //Message('Email Sent.');  //Biyi 290422
                    end;
                }
            }


            group(Status1)
            {
                Caption = 'Status';

                action(Release)
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        IF CONFIRM('Release document?', FALSE) = FALSE THEN BEGIN EXIT END;
                        //check if the document has any lines
                        Lines.RESET;
                        Lines.SETRANGE(Lines."Document Type", Rec."Document Type");
                        Lines.SETRANGE(Lines."Document No.", Rec."No.");
                        IF Lines.FINDFIRST THEN BEGIN
                            REPEAT
                                Lines.TESTFIELD(Lines.Quantity);
                                //Lines.TESTFIELD(Lines."Direct Unit Cost");
                                Lines.TESTFIELD("No.");
                            UNTIL Lines.NEXT = 0;
                        END
                        ELSE BEGIN
                            ERROR('Document has no lines');
                        END;
                        Rec.Status := Rec.Status::Released;
                        Rec."Released By" := USERID;
                        Rec."Release Date" := TODAY;
                        Rec.MODIFY;
                    end;
                }
                action(Reopen)
                {
                    Caption = 'Reopen';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        //check if the quotation for request number has already been used
                        PurchHeader.RESET;
                        //PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Quote);
                        PurchHeader.SETRANGE("RFQ No.", Rec."No.");
                        IF PurchHeader.FINDFIRST THEN BEGIN
                            ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                        END;

                        IF CONFIRM('Reopen Document?', FALSE) = FALSE THEN BEGIN EXIT END;
                        Rec.Status := Rec.Status::Open;
                        Rec.MODIFY;
                    end;
                }
                action(Close)
                {
                    Caption = 'Close';
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        //check if the quotation for request number has already been used
                        /*
                        PurchHeader.RESET;
                        PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                        PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                        IF PurchHeader.FINDFIRST THEN
                          BEGIN
                            ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                          END;
                        */
                        IF CONFIRM('Close Document?', FALSE) = FALSE THEN BEGIN EXIT END;
                        Rec.Status := Rec.Status::Closed;
                        Rec.MODIFY;

                    end;
                }

                action(Cancel)
                {
                    Caption = 'Cancel';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;
                    Visible = false; //jj290522

                    trigger OnAction()
                    begin

                        //check if the quotation for request number has already been used
                        /*
                        PurchHeader.RESET;
                        PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                        PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                        IF PurchHeader.FINDFIRST THEN
                          BEGIN
                            ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                          END;
                        */
                        IF CONFIRM('Cancel Document?', FALSE) = FALSE THEN BEGIN EXIT END;
                        Rec.Status := Rec.Status::Cancelled;
                        Rec.MODIFY;

                    end;
                }
                action(Stop)
                {
                    Caption = 'Stop';
                    Image = Stop;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;
                    Visible = false; //jj290522

                    trigger OnAction()
                    begin

                        //check if the quotation for request number has already been used

                        PurchHeader.RESET;
                        PurchHeader.SETRANGE(PurchHeader."Document Type", PurchHeader."Document Type"::Quote);
                        PurchHeader.SETRANGE(PurchHeader."RFQ No.", Rec."No.");
                        IF PurchHeader.FINDFIRST THEN BEGIN
                            ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                        END;

                        IF CONFIRM('Close Document?', FALSE) = FALSE THEN BEGIN EXIT END;
                        Rec.Status := Rec.Status::Closed;
                        Rec.MODIFY;

                    end;
                }

            }

        }
    }

    trigger OnOpenPage()
    begin

        // rec.SetFilter("Created By", '%1', UserId);

    end;

    var
        PurchHeader: Record 38;
        PParams: Record "Purchase Quote Params";
        Lines: Record "Purchase Quote Line";
        PQH: Record "Purchase Quote Header";
        repvend: Report "RFQ Report";
        DocPrint: Codeunit "Document-Print";
        EmailObj: Codeunit Email;
        EmailMsg: Codeunit "Email Message";

    [Scope('Cloud')]
    procedure InsertRFQLines()
    var
        Counter: Integer;
        Collection: Record "Purchase Line";
        //CollectionList: Page "PRF Lists"; Dennis
        CollectionList: Page "Approved PRF Lists"; //Dennis
    begin
        //Collection.CalcFields("Purchase Type");
        //Collection.CalcFields(Status);
        CollectionList.LOOKUPMODE(TRUE);
        IF CollectionList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            Collection.Setfilter("Document No.", '%1', Rec."PRF No");
            Collection.SetFilter("Purchase Type", '%1', Rec."Purchase Type"::Requisition);
            CollectionList.SetSelection(Collection);
            Counter := Collection.COUNT;
            IF Counter > 0 THEN BEGIN
                IF Collection.FINDSET then begin
                    Lines.SetRange("PRF No", Collection."Document No.");
                    Lines.SetRange("No.", Collection."No.");
                    Lines.Deleteall;
                    REPEAT
                        Lines.INIT;
                        Lines.TRANSFERFIELDS(Collection);
                        Lines."Document Type" := Rec."Document Type";
                        Lines.VALIDATE("Shortcut Dimension 1 Code", Collection."Shortcut Dimension 1 Code");
                        Lines.Validate("Shortcut Dimension 2 Code", Collection."Shortcut Dimension 2 Code");
                        // Lines.Validate("Shortcut Dimension 3 Code", Collection."Shortcut Dimension 3 Code");
                        // Lines.Validate("Shortcut Dimension 4 Code", Collection."Shortcut Dimension 4 Code");
                        // Lines.Validate("Shortcut Dimension 5 Code", Collection."Shortcut Dimension 5 Code");
                        // lines.Validate("Shortcut Dimension 6 Code", Collection."Shortcut Dimension 6 Code");
                        // Lines.Validate("Shortcut Dimension 7 Code", Collection."Shortcut Dimension 7 Code");
                        // Lines.Validate("Shortcut Dimension 8 Code", Collection."Shortcut Dimension 8 Code");
                        // Lines.Validate("Shortcut Dimension 8 Code" , Collection."Shortcut Dimension 8 Code");
                        Lines."Document No." := Rec."No.";
                        Lines."Line No." := 0;
                        Lines."PRF No" := Collection."Document No.";
                        Lines."PRF Line No." := Collection."Line No.";
                        //    Lines."Expense No." := Collection."Expense No.";
                        Lines.Amount := Collection.Amount;
                        Lines.INSERT(TRUE);
                        Collection.Copied := TRUE;
                        Collection.MODIFY;
                    UNTIL Collection.NEXT = 0;
                end;
            end;
        end;
    end;


    procedure SendEmail(var RFQ: Record "Purchase Quote Header")

    var

        TxtReceipientsList: List of [Text];
        AdditionalEmails: Text;
        Qvendors: Record "Quotation Request Vendors";
        vendor: Record vendor;
        EmailMsg: Codeunit "Email Message";
        EmailObj: Codeunit Email;
        TempBlob: Codeunit "Temp Blob";
        AttachmentInStream: Instream;
        AttachmentOutStream: OutStream;
        AdditionalEmailPage: Page "Additional Email Input";
        TxtDefaultCCMailList: List of [Text];
        TxtDefaultBCCMailList: List of [Text];



    begin

        clear(AdditionalEmailPage);

        if AdditionalEmailPage.RunModal() = Action::OK then begin

            AdditionalEmails := AdditionalEmailPage.GetAdditionalEmail();
            if AdditionalEmails <> '' then
                TxtReceipientsList.AddRange(AdditionalEmails.Split(','));
        end;


        Qvendors.Reset();
        Qvendors.SetFilter("Document Type", '%1', RFQ."Document Type");
        Qvendors.SetFilter("Document No.", '%1', RFQ."No.");

        if Qvendors.FindFirst() then
            repeat
                Vendor.Reset();
                Vendor.SetFilter("No.", Qvendors."Vendor No.");
                if vendor.FindFirst() then
                    if vendor."E-Mail" <> '' then
                        TxtReceipientsList.Add(vendor."E-Mail");
            until Qvendors.Next() = 0;

        GenerateRFQReport(RFQ, TempBlob);
        if TxtReceipientsList.count > 0 then begin
            EmailMsg.Create(TxtReceipientsList, 'Request For Quotations', 'Kindly find the attached document', false);
            TempBlob.CreateInStream(AttachmentInStream);
            EmailMsg.AddAttachment('RFQReport.pdf', 'PDF', AttachmentInStream);

            // Send Email
            EmailObj.Send(EmailMsg, Enum::"Email Scenario"::Default);
            Message('Message sent successfully');

        end

        else
            Message('No recipients found.');


    end;

    procedure GenerateRFQReport(var RFQ: Record "Purchase Quote Header"; var TempBlob: Codeunit "Temp Blob")
    var
        InStr: InStream;
        OutStr: OutStream;
        recRef: RecordRef;
        purchaseLine: Record "Purchase Quote Line";
    begin
        RFQ.Reset();
        RFQ.SetRange("Document Type", RFQ."Document Type");
        RFQ.SetRange("No.", RFQ."No.");
        // PurchaseLine.SetRange

        if RFQ.FindSet() then begin
            recRef.GetTable(RFQ);
            TempBlob.CreateOutStream(OutStr);
            Report.SaveAs(Report::"RFQ Report", ' ', Reportformat::pdf, OutStr, recRef);
        end;


    end;

}

