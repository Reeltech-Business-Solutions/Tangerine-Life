/// <summary>
/// TableExtension VendorExt (ID 50008) extends Record Vendor.
/// </summary>
tableextension 50615 VendorExt extends Vendor
{
    fields
    {

        // Add changes to table fields here
        field(50000; "Vendor Category"; Option)
        {
            Caption = 'Vendor Category';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Foreign",Local,Cash,Import,"Local Staff";
            OptionCaption = ' ,Foreign Vendor,Local Vendor,Cash Vendor,Import Vendor,Local Staff';
            trigger OnValidate()
            begin
                "Vendor Type" := "Vendor Category";
            end;

        }
        field(50001; "Vendor Type"; Option)
        {
            Caption = 'Vendor Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ",Import,Local,"Import File",Cash,IOU,"Local Staff","Expat Staff",Foreign,Broker;
            OptionCaption = ' ,Import,Local,Import File,Cash,IOU,Local Staff,Expat Staff,Foreign,Broker';
        }
        field(50004; "Bank No."; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(50005; "Bank Name"; Text[30])
        {

        }
        field(50006; "Bank Approval Date"; Date)
        {

        }
        field(50007; "G/L Account No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor Posting Group"."Payables Account" WHERE(Code = FIELD("Vendor Posting Group")));
        }
        field(50008; "Proforma Order No."; Code[20])
        { }
        field(50009; "Commission %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }


    }
}

