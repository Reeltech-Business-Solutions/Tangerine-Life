page 50664 "Staff Advan Surrender Details5"
{
    Caption = 'Staff Advance Retirement Lines';
    PageType = ListPart;
    SourceTable = "Staff Advan Surrender Details";

    layout
    {
        area(content)
        {
            repeater(Control1000000014)
            {
                ShowCaption = false;
                field("Imprest Type"; Rec."Imprest Type")
                {
                    Caption = 'Advance Type';
                    ApplicationArea = All;
                }
                field("Account No:"; Rec."Account No:")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Actual Spent"; Rec."Actual Spent")
                {
                    ApplicationArea = All;
                }
                field("Cash Receipt Amount"; Rec."Cash Receipt Amount")
                {
                    Caption = 'Deposit Amount';
                    ApplicationArea = All;
                    //Visible = false;
                }
                field("Apply to"; Rec."Apply to")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec."Apply to" := '';
                        Rec."Apply to ID" := '';

                        //Amt:=0;

                        EmployeeLedgerEntry.Reset;
                        EmployeeLedgerEntry.SetCurrentKey(EmployeeLedgerEntry."Employee No.", Open, "Document No.");
                        EmployeeLedgerEntry.SetRange(EmployeeLedgerEntry."Employee No.", Rec."Advance Holder");
                        EmployeeLedgerEntry.SetRange(Open, true);
                        //CustLedger.SETRANGE(CustLedger."Transaction Type",CustLedger."Transaction Type"::"Down Payment");
                        EmployeeLedgerEntry.CalcFields(EmployeeLedgerEntry.Amount);
                        if PAGE.RunModal(5237, EmployeeLedgerEntry) = ACTION::LookupOK then begin

                            if EmployeeLedgerEntry."Applies-to ID" <> '' then begin
                                EmployeeLedgerEntry1.Reset;
                                EmployeeLedgerEntry1.SetCurrentKey(EmployeeLedgerEntry1."Employee No.", Open, "Applies-to ID");
                                EmployeeLedgerEntry1.SetRange(EmployeeLedgerEntry1."Employee No.", Rec."Advance Holder");
                                EmployeeLedgerEntry1.SetRange(Open, true);
                                //CustLedger1.SETRANGE("Transaction Type",CustLedger1."Transaction Type"::"Down Payment");
                                EmployeeLedgerEntry1.SetRange("Applies-to ID", EmployeeLedgerEntry."Applies-to ID");
                                if EmployeeLedgerEntry1.Find('-') then begin
                                    repeat
                                        EmployeeLedgerEntry1.CalcFields(EmployeeLedgerEntry1.Amount);
                                        Amt := Amt + Abs(EmployeeLedgerEntry1.Amount);
                                    until EmployeeLedgerEntry1.Next = 0;
                                end;

                                if Amt <> Amt then
                                    //ERROR('Amount is not equal to the amount applied on the application form');
                                    /*Amount:=Amt;
                                    VALIDATE(Amount);*/
                           Rec."Apply to" := EmployeeLedgerEntry."Document No.";
                                Rec."Apply to ID" := EmployeeLedgerEntry."Applies-to ID";
                            end else begin
                                if Rec.Amount <> Abs(EmployeeLedgerEntry.Amount) then
                                    EmployeeLedgerEntry.CalcFields(EmployeeLedgerEntry."Remaining Amount");

                                /*Amount:=ABS(CustLedger."Remaining Amount");
                                 VALIDATE(Amount);*/
                                //ERROR('Amount is not equal to the amount applied on the application form');

                                Rec."Apply to" := EmployeeLedgerEntry."Document No.";
                                Rec."Apply to ID" := EmployeeLedgerEntry."Applies-to ID";

                            end;
                        end;

                        if Rec."Apply to ID" <> '' then
                            Rec."Apply to" := '';

                        Rec.Validate(Amount);

                        /*
                        IF (Rec."Account Type"<>Rec."Account Type"::Employee) THEN
                            ERROR('You cannot apply to %1',"Account Type");
                        IF "Account Type" = "Account Type"::Employee THEN BEGIN
                        WITH Rec DO BEGIN
                          //Amount:=0;
                          //VALIDATE(Amount);
                          PayToVendorNo := "Account No." ;
                          VendLedgEntry.SETCURRENTKEY("Vendor No.",Open);
                          VendLedgEntry.SETRANGE("Vendor No.",PayToVendorNo);
                          VendLedgEntry.SETRANGE(Open,TRUE);
                          IF "Applies-to ID" = '' THEN
                            "Applies-to ID" := No;
                          IF "Applies-to ID" = '' THEN
                            ERROR(
                              Text000,
                              FIELDCAPTION(No),FIELDCAPTION("Applies-to ID"));
                          //ApplyVendEntries."SetPVLine-Delete"(PVLine,PVLine.FIELDNO("Applies-to ID"));
                          ApplyVendEntries.SetPVLine(Rec,VendLedgEntry,Rec.FIELDNO("Applies-to ID"));
                          ApplyVendEntries.SETRECORD(VendLedgEntry);
                            ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
                          ApplyVendEntries.LOOKUPMODE(TRUE);
                          OK := ApplyVendEntries.RUNMODAL = ACTION::LookupOK;
                          CLEAR(ApplyVendEntries);
                          IF NOT OK THEN
                            EXIT;
                          VendLedgEntry.RESET;
                          VendLedgEntry.SETCURRENTKEY("Vendor No.",Open);
                          VendLedgEntry.SETRANGE("Vendor No.",PayToVendorNo);
                          VendLedgEntry.SETRANGE(Open,TRUE);
                          VendLedgEntry.SETRANGE(VendLedgEntry."Applies-to ID","Applies-to ID");
                          IF VendLedgEntry.FIND('-') THEN BEGIN
                            "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                            "Applies-to Doc. No." := VendLedgEntry."Document No.";
                        
                          END ELSE
                            "Applies-to ID" := '';
                        END;
                        //Calculate  Total To Apply
                          VendLedgEntry.RESET;
                          VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,"Applies-to ID");
                          VendLedgEntry.SETRANGE("Vendor No.",PayToVendorNo);
                          VendLedgEntry.SETRANGE(Open,TRUE);
                          VendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
                          IF VendLedgEntry.FIND('-') THEN BEGIN
                                VendLedgEntry.CALCSUMS("Amount to Apply");
                                Amount:=ABS(VendLedgEntry."Amount to Apply");
                                VALIDATE(Amount);
                                //Total Invoice Amount
                                "Total Invoice Amount":=ABS(VendLedgEntry."Amount to Apply");
                                //Total Invoice Amount
                          END;
                         END;
                         */

                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = true;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Caption = 'ECU Code';
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Advance Holder"; Rec."Advance Holder")
                {
                    ApplicationArea = All;
                }
                field("Surrender Doc No."; Rec."Surrender Doc No.")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = All;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = All;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        StaffSurHeader.SetRange("No.", StaffRetreLine."Surrender Doc No.");
        if StaffSurHeader.Find('-') then begin
            if StaffSurHeader.Status = StaffSurHeader.Status::Open then
                EditDoc := false;

        end;
    end;

    trigger OnOpenPage()
    begin
        EditDoc := true;
    end;

    var
        Custledger: Record "Cust. Ledger Entry";
        Custledger1: Record "Cust. Ledger Entry";
        Amt: Decimal;
        UserSetup: Record "User Setup";
        StaffSurHeader: Record "Staff Advanc Surrender Header";
        PayToVendorNo: Integer;
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        EmployeeLedgerEntry1: Record "Employee Ledger Entry";
        EditDoc: Boolean;
        StaffRetreLine: Record "Staff Advan Surrender Details";

}

