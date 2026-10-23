tableextension 50613 SourceCodeSetupExtn extends "Source Code Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Cash Receipt Voucher"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50001; "Cash Payment Voucher"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50002; "Bank Receipt Voucher"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50003; "Bank Payment Voucher"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50004; "Journal Voucher"; Code[20])
        {
            TableRelation = "Source Code";
        }
        field(50005; "IOU Voucher"; Code[20])
        { TableRelation = "Source Code"; }
        field(50006; "IOU Retirement Voucher"; Code[20]) { TableRelation = "Source Code"; }
        field(50007; "Petty Cash Voucher"; Code[20]) { TableRelation = "Source Code"; }
        field(50008; "Import Purchase"; Code[20]) { TableRelation = "Source Code"; }
        field(50051; "Import File - Charge Invoice"; Code[20]) { TableRelation = "Source Code"; }
        field(50052; "Contra Voucher"; Code[20]) { TableRelation = "Source Code"; }

    }
   
    var
        myInt: Integer;
}