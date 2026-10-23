tableextension 50617 RespCenterExt extends "Responsibility Center"
{
    fields
    {
        // Add changes to table fields here
        field(50004; "CPV Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50005; "BPV Nos."; Code[20]) { TableRelation = "No. Series"; }
        field(50006; "CRV Nos."; Code[20]) { TableRelation = "No. Series"; }
        field(50007; "BRV Nos."; Code[20]) { TableRelation = "No. Series"; }
        field(50008; "JV Nos."; Code[20]) { TableRelation = "No. Series"; }
        field(50009; "Posted CPV Nos."; Code[20]) { TableRelation = "No. Series"; }
        field(50010; "Posted BPV Nos."; Code[20]) { TableRelation = "No. Series"; }
        field(50011; "Posted CRV Nos."; Code[20]) { TableRelation = "No. Series"; }
        field(50012; "Posted BRV Nos."; Code[20]) { TableRelation = "No. Series"; }
        field(50013; "Posted JV Nos."; Code[20]) { TableRelation = "No. Series"; }
        field(50015; "Posted Contra Voucher Nos."; Code[20]) { TableRelation = "No. Series"; }
        field(50016; "Petty Cash Nos"; Code[20]) { TableRelation = "No. Series"; }
        field(50017; "Posted Petty Cash Nos"; Code[20]) { TableRelation = "No. Series"; }
        field(50018; "Contra Voucher Nos."; Code[20]) { TableRelation = "No. Series"; }

    }

    var
        myInt: Integer;
}