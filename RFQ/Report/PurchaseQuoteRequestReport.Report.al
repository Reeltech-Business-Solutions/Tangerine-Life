report 50601 "Purchase Quote Request Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PurchaseQuoteRequestReport.rdl';

    dataset
    {
        dataitem("Purchase Quote Header"; "Purchase Quote Header")
        {
            column(Purchase_Quote_Header_Document_Type; "Document Type")
            {
            }
            column(Purchase_Quote_Header_No_; "No.")
            {
            }
            dataitem("Quotation Request Vendors"; "Quotation Request Vendors")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                column(Quotation_Request_Vendors__Quotation_Request_Vendors___Document_No__; "Quotation Request Vendors"."Document No.")
                {
                }
                column(TODAY; TODAY)
                {
                }
                column(Quotation_Request_Vendors__Quotation_Request_Vendors___Vendor_Name_; "Quotation Request Vendors"."Vendor Name")
                {
                }
                column(companyinfo_Picture; companyinfo.Picture)
                {
                }
                column(vendAddress; vendAddress)
                {
                }
                column(Purchase_Quote_Header___Expected_Closing_Date_; "Purchase Quote Header"."Expected Closing Date")
                {
                }
                column(Purchase_Quote_Header___Expected_Closing_Date__Control1102755076; "Purchase Quote Header"."Expected Closing Date")
                {
                }
                column(Quotation_Request_Vendors__Quotation_Request_Vendors___Document_No___Control1000000001; "Quotation Request Vendors"."Document No.")
                {
                }
                column(Purchase_Quote_Header___Posting_Description_; "Purchase Quote Header"."Posting Description")
                {
                }
                column(P_o_Box_30746__Tel__254_020_247277__Fax__254020_310223Caption; PO_Box_Tel_Fax_CaptionLbl)
                {
                }
                column(THE_KENYATTA_INTERNATIONAL_CONFERENCE_CENTRECaption; THE_KENYATTA_INTERNATIONAL_CONFERENCE_CENTRECaptionLbl)
                {
                }
                column(for_supply_of___________________________________Caption; for_supply_of___________________________________CaptionLbl)
                {
                }
                column(ORIGINALCaption; ORIGINALCaptionLbl)
                {
                }
                column(DataItem1102755005; and_be_addressed_to_reach_the_buyer_on_or_before____________________________or_be_placed_in_thLbl)
                {
                }
                column(DataItem1102755007; Quotation_CaptionLbl)
                {
                }
                column(REQUEST_FOR_QUOTATIONCaption; REQUEST_FOR_QUOTATIONCaptionLbl)
                {
                }
                column(Fill__Sign_And_Return_The_Original_To_Simlaw_Seed_Company_Limited__Even_If_You_Have_Not_Quoted_Caption; Fill__Sign_And_Return_The_Original_To_Simlaw_Seed_Company_Limited__Even_If_You_Have_Not_Quoted_CaptionLbl)
                {
                }
                column(Days_to_DeliverCaption; Days_to_DeliverCaptionLbl)
                {
                }
                column(RemarksCaption; RemarksCaptionLbl)
                {
                }
                column(Country_of_OriginCaption; Country_of_OriginCaptionLbl)
                {
                }
                column(BrandCaption; BrandCaptionLbl)
                {
                }
                column(Quotation_No_____________________________________________________Caption; Quotation_No_____________________________________________________CaptionLbl)
                {
                }
                column(Unit_PriceCaption; Unit_PriceCaptionLbl)
                {
                }
                column(a__THIS_IS_NOT_AN_ORDER__Read_the_conditions_and_instructions_on_reverse_before_quoting_Caption; a__THIS_IS_NOT_AN_ORDER__Read_the_conditions_and_instructions_on_reverse_before_quoting_CaptionLbl)
                {
                }
                column(Quantity_RequiredCaption; Quantity_RequiredCaptionLbl)
                {
                }
                column(b__This_Quotation_should_be_submitted_in_a_plain_wax_sealed_envelope_markedCaption; b__This_Quotation_should_be_submitted_in_a_plain_wax_sealed_envelope_markedCaptionLbl)
                {
                }
                column(d___Return_the_Original_copy_and_retain_the_duplicate_for_your_records_Caption; d___Return_the_Original_copy_and_retain_the_duplicate_for_your_records_CaptionLbl)
                {
                }
                column(Quotation_No__Caption; Quotation_No__CaptionLbl)
                {
                }
                column(You_are_invited_to_submit_Quotation_on_materials_listed_below_Caption; You_are_invited_to_submit_Quotation_on_materials_listed_below_CaptionLbl)
                {
                }
                column(UnitCaption; UnitCaptionLbl)
                {
                }
                column(Date_Caption; Date_CaptionLbl)
                {
                }
                column(Item_DescriptionCaption; Item_DescriptionCaptionLbl)
                {
                }
                column(Seller_s_Name_and_Address_Caption; Seller_s_Name_and_Address_CaptionLbl)
                {
                }
                column(CodeCaption; CodeCaptionLbl)
                {
                }
                column(NOTE_Caption; NOTE_CaptionLbl)
                {
                }
                column(To_Caption; To_CaptionLbl)
                {
                }
                column(Quotation_Request_Vendors_Vendor_No_; "Vendor No.")
                {
                }
                column(Quotation_Request_Vendors_Document_Type; "Document Type")
                {
                }
                dataitem(DataItem3368; "Purchase Quote Line")
                {
                    DataItemLink = "Document No." = FIELD("Document No.");
                    column(Purchase_Quote_Line__Unit_of_Measure_; "Unit of Measure")
                    {
                    }
                    column(Purchase_Quote_Line_Quantity; Quantity)
                    {
                    }
                    column(Purchase_Quote_Line_Description; Description)
                    {
                    }
                    column(Purchase_Quote_Line__Purchase_Quote_Line___No__; "No.")
                    {
                    }
                    column(Purchase_Quote_Line__Extended_Order_Description_; "Extended Order Description")
                    {
                    }
                    column(Date_____________________________________________________________________________________________________________Caption; Date________________________________________________________________________CaptionLbl)
                    {
                    }
                    column(DataItem1102755059; V3____________________________________Designation__________________________________Signature_________________________Lbl)
                    {
                    }
                    column(DataItem1102755060; Date_____________________________________________________________________Time________________________________________Lbl)
                    {
                    }
                    column(DataItem1102755061; V2____________________________________Designation__________________________________Signature________________________Lbl)
                    {
                    }
                    column(Seller_s_Signature___________________________________________________________________________________________Caption; Seller_s_Signature___________________________________________________________________________________________CaptionLbl)
                    {
                    }
                    column(Opened_By_Caption; Opened_By_CaptionLbl)
                    {
                    }
                    column(DataItem1102755064; V1____________________________________Designation__________________________________Signature_________________________Lbl)
                    {
                    }
                    column(FOR_OFFICIAL_USE_ONLYCaption; FOR_OFFICIAL_USE_ONLYCaptionLbl)
                    {
                    }
                    column(Purchase_Quote_Line_Document_Type; "Document Type")
                    {
                    }
                    column(Purchase_Quote_Line_Document_No_; "Document No.")
                    {
                    }
                    column(Purchase_Quote_Line_Line_No_; "Line No.")
                    {
                    }
                }
                dataitem("Quotation Request Vendors2"; "Quotation Request Vendors")
                {
                    DataItemLink = "Vendor No." = FIELD("Vendor No."),
                                   "Document No." = FIELD("Document No.");
                    column(DataItem1102755019; V1_submittLbl)
                    {
                    }
                    column(V2_The_offer_shall_remain_firm_for_30_days_from_the_closing_date_unless_otherwise_stipulated_by_the_seller_Caption; V2_CaptionLbl)
                    {
                    }
                    column(DataItem1102755066; V3_CaptionLbl)
                    {
                    }
                    column(DataItem1102755067; V4_CaptionLbl)
                    {
                    }
                    column(CONDITIONSCaption; CONDITIONSCaptionLbl)
                    {
                    }
                    column(INSTRUCTIONSCaption; INSTRUCTIONSCaptionLbl)
                    {
                    }
                    column(DataItem1102755070; V1_Lbl)
                    {
                    }
                    column(V2_Quote_on_each_item_separately__and_in_units_as_specified_Caption; V2_Quote_on_each_item_separately__and_in_units_as_specified_CaptionLbl)
                    {
                    }
                    column(V3_This_form_must_be_signed_by_a_competent_person_and_preferably_it_should_be_rubber_stamped_Caption; V3_This_form_must_be_signed_by_a_competent_person_and_preferably_it_should_be_rubber_stamped_CaptionLbl)
                    {
                    }
                    column(DataItem1102755073; V4_liLbl)
                    {
                    }
                    column(DataItem1102755074; V5_Lbl)
                    {
                    }
                    column(Quotation_Request_Vendors2_Document_No_; "Document No.")
                    {
                    }
                    column(Quotation_Request_Vendors2_Vendor_No_; "Vendor No.")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin

                    vendor.RESET;
                    vendor.SETRANGE(vendor."No.", "Quotation Request Vendors"."Vendor No.");
                    IF vendor.FIND('-') THEN
                        vendAddress := vendor.Address;

                    Quote.RESET;
                    Quote.SETRANGE(Quote."No.", "Quotation Request Vendors"."Document No.");
                    Quote.SETRANGE(Quote."Document Type", Quote."Document Type"::"Quotation Request");
                    IF Quote.FIND('-') THEN
                        DocDesc := Quote."Posting Description";
                    //    DocDesc:=
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        companyinfo.RESET;
        companyinfo.GET;
        companyinfo.CALCFIELDS(Picture);
    end;

    var
        DocDesc: Text[50];
        DocDate: Date;
        DocNo: Integer;
        vendAddress: Text[50];
        Quote: Record "Purchase Quote Header";
        vendor: Record Vendor;
        companyinfo: Record "Company Information";
        PrintSec: Boolean;
        PO_Box_Tel_Fax_CaptionLbl: Label 'P.o Box ........., Tel.+224-...-..., Fax: +234...........';
        THE_KENYATTA_INTERNATIONAL_CONFERENCE_CENTRECaptionLbl: Label 'NILE UNIVERSITY';
        for_supply_of___________________________________CaptionLbl: Label 'for supply of:..................................';
        ORIGINALCaptionLbl: Label 'ORIGINAL';
        and_be_addressed_to_reach_the_buyer_on_or_before____________________________or_be_placed_in_thLbl: Label 'and be addressed to reach the buyer on or before ..........................................................or be placed in the Quotation/Tender box not later than ........................................................';
        Quotation_CaptionLbl: Label '(c) Your Quotation should indicate final unit price which includes all costs for Delivery, discounts,duty and V.A.T.';
        REQUEST_FOR_QUOTATIONCaptionLbl: Label 'REQUEST FOR QUOTATION';
        Fill__Sign_And_Return_The_Original_To_Simlaw_Seed_Company_Limited__Even_If_You_Have_Not_Quoted_CaptionLbl: Label '(Fill, Sign And Return The Original To Simlaw Seed Company Limited. Even If You Have Not Quoted)';
        Days_to_DeliverCaptionLbl: Label 'Days to Deliver';
        RemarksCaptionLbl: Label 'Remarks';
        Country_of_OriginCaptionLbl: Label 'Country of Origin';
        BrandCaptionLbl: Label 'Brand';
        Quotation_No_____________________________________________________CaptionLbl: Label '"Quotation No...                                      ............';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        a__THIS_IS_NOT_AN_ORDER__Read_the_conditions_and_instructions_on_reverse_before_quoting_CaptionLbl: Label '(a) THIS IS NOT AN ORDER. Read the conditions and instructions on reverse before quoting.';
        Quantity_RequiredCaptionLbl: Label 'Quantity Required';
        b__This_Quotation_should_be_submitted_in_a_plain_wax_sealed_envelope_markedCaptionLbl: Label '(b) This Quotation should be submitted in a plain wax sealed envelope marked';
        d___Return_the_Original_copy_and_retain_the_duplicate_for_your_records_CaptionLbl: Label '(d)  Return the Original copy and retain the duplicate for your records.';
        Quotation_No__CaptionLbl: Label 'Quotation No.:';
        You_are_invited_to_submit_Quotation_on_materials_listed_below_CaptionLbl: Label 'You are invited to submit Quotation on materials listed below:';
        UnitCaptionLbl: Label 'Unit';
        Date_CaptionLbl: Label 'Date:';
        Item_DescriptionCaptionLbl: Label 'Item Description';
        Seller_s_Name_and_Address_CaptionLbl: Label 'Seller''s Name and Address:';
        CodeCaptionLbl: Label 'Code';
        NOTE_CaptionLbl: Label 'NOTE:';
        To_CaptionLbl: Label 'To:';
        Date________________________________________________________________________CaptionLbl: Label 'Date:............................................................................................................';
        V3____________________________________Designation__________________________________Signature_________________________Lbl: Label ' (3)..................................... Designation:..................................  Signature:....................................';
        Date_____________________________________________________________________Time________________________________________Lbl: Label 'Date: ...................................................................... Time: .....................................................................';
        V2____________________________________Designation__________________________________Signature________________________Lbl: Label ' (2)..................................... Designation:..................................  Signature:....................................';
        Seller_s_Signature___________________________________________________________________________________________CaptionLbl: Label 'Seller''s Signature:..........................................................................................';
        Opened_By_CaptionLbl: Label 'Opened By:';
        V1____________________________________Designation__________________________________Signature_________________________Lbl: Label ' (1)..................................... Designation:..................................  Signature:....................................';
        FOR_OFFICIAL_USE_ONLYCaptionLbl: Label 'FOR OFFICIAL USE ONLY';
        V1_submittLbl: Label '1. The general conditions of contract with the Simlaw Seed Company Ltd. apply to this transaction. This Form properly submitted constitutes the entire agreement.';
        V2_CaptionLbl: Label '2. The offer shall remain firm for 30 days from the closing date unless otherwise stipulated by the seller.';
        V3_CaptionLbl: Label '3. The buyer shall not be bound to accept the lowest or any other offer, and reserves the right to accept any offer in part unless the contrary is stipulated by the seller.';
        V4_CaptionLbl: Label '4. Samples of offers when required will be provided free, and if not destroyed during tests will, upon request, be returned at the seller''s expenses.';
        CONDITIONSCaptionLbl: Label 'CONDITIONS';
        INSTRUCTIONSCaptionLbl: Label 'INSTRUCTIONS';
        V1_Lbl: Label '1. All entries must be typed or written ink. Mistakes must not be erased but should be crossed out and corrections be made and initiated by the person signing the quotation.';
        V2_Quote_on_each_item_separately__and_in_units_as_specified_CaptionLbl: Label '2.Quote on each item separately, and in units as specified.';
        V3_This_form_must_be_signed_by_a_competent_person_and_preferably_it_should_be_rubber_stamped_CaptionLbl: Label '3.This form must be signed by a competent person and preferably it should be rubber stamped.';
        V4_liLbl: Label '4.Each quotation should be separately in a sealed envelope with the quotation Number endorsed on the outside. Descriptive literature or sample of the items offered may be forwarded with Quotation.';
        V5_Lbl: Label '5.If you do not wish to quote, please endorse the reason on this form and return it, otherwise your name may be deleted from the buyers'' mailing list for the items listed here on.';

    [Scope('Cloud')]
    procedure SetRportFilt(DocType: Option "Quotation Request","Open Tender","Restricted Tender"; "DocNo.": Code[20])
    begin
        "Quotation Request Vendors".SETFILTER("Document Type", FORMAT(DocType));
        "Quotation Request Vendors".SETFILTER("Document No.", "DocNo.");
    end;
}

