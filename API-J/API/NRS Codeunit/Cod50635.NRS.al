codeunit 50635 NRS
{
    procedure getIRN(): boolean
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        URL: Text;
        Response: Text;
        RequestMessage: HttpRequestMessage;
        RequestHeaders: HttpHeaders;
        GetInvoice: code[20];


    begin

        GetInvoice := 'INV0005';
        URL := StrSubstNo('https://dev.mbs.hoptool.co/hoptoolaccesspoint/api/v1/invoice/generate-irn?reference=%1', GetInvoice);

        //Get Headers
        HttpClient.DefaultRequestHeaders.Add('x-api-key', x_api_key);
        HttpClient.DefaultRequestHeaders.Add('x-api-secret', x_api_secret);

        if not HttpClient.Get(URL, HttpResponseMessage) then begin
            error('Http Get method failed');
            exit(false);
        end;

        HttpResponseMessage.Content.ReadAs(Response);

        if HttpResponseMessage.IsSuccessStatusCode then begin
            Message('Request successful! Response: %1', Response);
        end else
            Message('Request failed!: %1', Response);
    end;

    procedure ValidateInvoices()
    var
        HeaderJsonObject: JsonObject;
        LineJsonObject: JsonObject;
        JsonArray: JsonArray;
        DeliveryJsonObject: JsonObject;
        BillingJsonObject: JsonObject;
        BillingJsonArray: JsonArray;
        DispatchJsonObject: JsonObject;
        ReceiptJsonObject: JsonObject;
        OriginatorJsonObject: JsonObject;
        ContractJsonObject: JsonObject;
        AdditionalJsonArray: JsonArray;
        AdditionalJsonObject: JsonObject;
        AccountingJsonObject: JsonObject;
        PostalJson: JsonObject;
        CustomerPartyJsonObject: JsonObject;
        PaymentObject: JsonObject;
        PaymentArray: JsonArray;
        AllowanceObject: JsonObject;
        AllowanceArray: JsonArray;
        TaxObject: JsonObject;
        TaxArray: JsonArray;
        TaxSubObject1: JsonObject;
        TaxSubObject2: JsonObject;
        TaxSubObject3: JsonObject;
        TaxSubArray: JsonArray;
        TaxCatJsonObject: JsonObject;
        TaxSubJsonArray: JsonArray;
        LegalJsonObject: JsonObject;
        InvoiceLineJsonObject: JsonObject;
        InvoiceLineJsonArray: JsonArray;
        ItemJsonObject: JsonObject;
        PriceJsonObject: JsonObject;
        ProductJsonObject: JsonObject;
        ServiceJsonObject: JsonObject;
        PostalAddressJson: JsonObject;
        TaxCatsJsonObject: JsonObject;
        ItemsJsonObject: JsonObject;
        PricesJsonObject: JsonObject;
        AllowancesObject: JsonObject;
        TaxSubsObject: JsonObject;


    begin
        HeaderJsonObject.Add('businessId', 'current_businessId');
        HeaderJsonObject.Add('irn', 'current_irn');
        HeaderJsonObject.Add('issueDate', '2026-06-12');
        HeaderJsonObject.Add('dueDate', '2026-07-12');
        HeaderJsonObject.Add('issueTime', '17:59:04');
        HeaderJsonObject.Add('invoiceTypeCode', '396');
        HeaderJsonObject.Add('paymentStatus', 'PENDING');
        HeaderJsonObject.Add('note', 'dummy_note (will be encrypted in storage)');
        HeaderJsonObject.Add('taxPointDate', '2026-06-12');
        HeaderJsonObject.Add('documentCurrencyCode', 'NGN');
        HeaderJsonObject.Add('taxCurrencyCode', 'NGN');
        HeaderJsonObject.Add('accountingCost', '100000 NGN');
        HeaderJsonObject.Add('buyerReference', 'buyer REF IRN?');
        HeaderJsonObject.Add('invoiceKind', 'B2B');
        DeliveryJsonObject.Add('startDate', '2026-06-12');
        DeliveryJsonObject.Add('endDate', '2026-06-15');
        HeaderJsonObject.Add('orderReference', 'order REF IRN?');
        //invoice delivery period
        HeaderJsonObject.Add('invoiceDeliveryPeriod', DeliveryJsonObject);

        // billing reference
        BillingJsonObject.Add('irn', 'ITW001-E9E0C0D3-20260619');
        BillingJsonObject.Add('issueDate', '2026-06-12');
        BillingJsonArray.Add(BillingJsonObject);
        HeaderJsonObject.Add('billingReference', BillingJsonArray);

        //dispatch document reference
        DispatchJsonObject.Add('irn', 'ITW001-E9E0C0D3-20260619');
        DispatchJsonObject.Add('issueDate', '2026-06-12');
        HeaderJsonObject.Add('dispatchDocumentReference', DispatchJsonObject);

        //receipt document reference
        ReceiptJsonObject.Add('irn', 'ITW001-E9E0C0D3-20260619');
        ReceiptJsonObject.Add('issueDate', '2026-06-12');
        HeaderJsonObject.Add('receiptDocumentReference', ReceiptJsonObject);

        //originator document reference
        OriginatorJsonObject.Add('irn', 'ITW001-E9E0C0D3-20260619');
        OriginatorJsonObject.Add('issueDate', '2026-06-12');
        HeaderJsonObject.Add('originatorDocumentReference', OriginatorJsonObject);

        //contract document reference
        ContractJsonObject.Add('irn', 'ITW001-E9E0C0D3-20260619');
        ContractJsonObject.Add('issueDate', '2026-06-12');
        HeaderJsonObject.Add('contractDocumentReference', ContractJsonObject);

        //additional document reference
        AdditionalJsonObject.Add('irn', 'ITW001-E9E0C0D3-20260619');
        AdditionalJsonObject.Add('issueDate', '2026-06-12');
        AdditionalJsonArray.Add(AdditionalJsonObject);
        HeaderJsonObject.Add('additionalDocumentReference', AdditionalJsonArray);

        //accounting supplier party
        AccountingJsonObject.Add('partyName', 'Dangote Group');
        AccountingJsonObject.Add('tin', 'businessTin');
        AccountingJsonObject.Add('email', 'supplier_business@email.com');
        AccountingJsonObject.Add('telephone', '+23480254099000');
        AccountingJsonObject.Add('businessDescription', 'Entity specialized in sales of Cement and building materials');
        //postal address
        PostalJson.Add('streetName', '32, owonikoko street');
        PostalJson.Add('cityName', 'Gwarikpa');
        PostalJson.Add('postalZone', '023401');
        PostalJson.Add('country', 'NG');
        AccountingJsonObject.Add('postalAddress', PostalJson);
        HeaderJsonObject.Add('accountingSupplierParty', AccountingJsonObject);

        //accounting customer party
        CustomerPartyJsonObject.Add('partyName', 'Customer Business PLC');
        CustomerPartyJsonObject.Add('tin', 'TIN-000001');
        CustomerPartyJsonObject.Add('email', 'customer_business@email.com');
        CustomerPartyJsonObject.Add('telephone', '+23480254000000');
        CustomerPartyJsonObject.Add('businessDescription', 'Procurement entity');
        //postal address
        PostalAddressJson.Add('streetName', '45, commercial avenue');
        PostalAddressJson.Add('cityName', 'Ikoyi');
        PostalAddressJson.Add('postalZone', '012345');
        PostalAddressJson.Add('country', 'NG');
        CustomerPartyJsonObject.Add('postalAddress', PostalAddressJson);
        HeaderJsonObject.Add('accountingCustomerParty', CustomerPartyJsonObject);

        HeaderJsonObject.Add('actualDeliveryDate', '2026-06-12');

        //payment means
        PaymentObject.Add('paymentMeansCode', '10');
        PaymentObject.Add('paymentDueDate', '2026-07-12');
        PaymentArray.Add(PaymentObject);
        HeaderJsonObject.Add('paymentMeans', JsonArray);

        HeaderJsonObject.Add('paymentTermsNote', 'Standard corporate payment terms');

        //allowance charge
        AllowanceObject.Add('chargeIndicator', true);
        AllowanceObject.Add('amount', 800.60);

        AllowancesObject.Add('chargeIndicator', false);
        AllowancesObject.Add('amount', 10);
        AllowanceArray.Add(AllowanceObject);
        AllowanceArray.Add(AllowancesObject);
        HeaderJsonObject.Add('allowanceCharge', AllowanceArray);

        //tax total
        TaxSubObject1.Add('taxableAmount', 100000.00);
        TaxSubObject1.Add('taxAmount', 7500.00);
        TaxCatJsonObject.Add('id', 'STANDARD_VAT');
        TaxCatJsonObject.Add('percent', 7.5);
        TaxSubObject1.Add('taxCategory', TaxCatJsonObject);


        TaxSubObject2.Add('taxableAmount', 100000.00);
        TaxSubObject2.Add('taxAmount', 5000.00);
        TaxCatsJsonObject.Add('id', 'WITHHOLDING_TAX');
        TaxCatsJsonObject.Add('percent', 5.0);
        TaxSubObject2.Add('taxCategory', TaxCatsJsonObject);
        TaxSubJsonArray.Add(TaxSubObject1);
        TaxSubJsonArray.Add(TaxSubObject2);

        TaxObject.Add('taxAmount', 12500.00);
        TaxObject.Add('taxSubtotal', TaxSubJsonArray);
        TaxArray.Add(TaxObject);
        HeaderJsonObject.Add('taxTotal', TaxArray);

        // legal monetary total
        LegalJsonObject.Add('lineExtensionAmount', 100000.00);
        LegalJsonObject.Add('taxExclusiveAmount', 100000.00);
        LegalJsonObject.Add('taxInclusiveAmount', 112500.00);
        LegalJsonObject.Add('payableAmount', 112500.00);
        HeaderJsonObject.Add('legalMonetaryTotal', LegalJsonObject);

        //invoice line (Products or goods)
        ProductJsonObject.Add('hsnCode', 1006.30);
        ProductJsonObject.Add('productCategory', 'Cereals; rice');
        ProductJsonObject.Add('discountRate', 0.0);
        ProductJsonObject.Add('discountAmount', 0.0);
        ProductJsonObject.Add('feeRate', 0.0);
        ProductJsonObject.Add('feeAmount', 0.0);
        ProductJsonObject.Add('invoicedQuantity', 15);
        ProductJsonObject.Add('lineExtensionAmount', 60000.00);
        ItemJsonObject.Add('name', 'Premium Rice');
        ItemJsonObject.Add('description', 'Bulk delivery of polished rice');
        ItemJsonObject.Add('sellersItemIdentification', 'RICE-001');
        ProductJsonObject.Add('item', ItemJsonObject);
        PriceJsonObject.Add('priceAmount', 4000.00);
        PriceJsonObject.Add('baseQuantity', 1);
        PriceJsonObject.Add('priceUnit', 'XBG');
        ProductJsonObject.Add('price', PriceJsonObject);


        //invoice line (services)
        ServiceJsonObject.Add('isicCode', 0112);
        ServiceJsonObject.Add('serviceCategory', 'Growing of rice');
        ServiceJsonObject.Add('discountRate', 0.0);
        ServiceJsonObject.Add('discountAmount', 0.0);
        ServiceJsonObject.Add('feeRate', 0.0);
        ServiceJsonObject.Add('feeAmount', 0.0);
        ServiceJsonObject.Add('invoicedQuantity', 5);
        ServiceJsonObject.Add('lineExtensionAmount', 40000.00);
        ItemsJsonObject.Add('name', 'Agricultural Cultivation Services');
        ItemsJsonObject.Add('description', 'Cultivation optimization service');
        ItemsJsonObject.Add('sellersItemIdentification', 'SRV-0112');
        ServiceJsonObject.Add('item', ItemJsonObject);
        PricesJsonObject.Add('priceAmount', 8000.00);
        PricesJsonObject.Add('baseQuantity', 1);
        PricesJsonObject.Add('priceUnit', 'XBG');
        ServiceJsonObject.Add('price', PriceJsonObject);

        InvoiceLineJsonArray.Add(ProductJsonObject);
        InvoiceLineJsonArray.Add(ServiceJsonObject);

        HeaderJsonObject.Add('invoiceLine', InvoiceLineJsonArray);



        Message(Format(HeaderJsonObject));




    end;

    procedure createJSON()
    var
        HeaderJsonObject: JsonObject;
        LineJsonObjject: JsonObject;
        JsonArray: JsonArray;
        DeliveryJsonObject: JsonObject;
        BillingFirstJsonObject: JsonObject;
        BillingSecondJsonObject: JsonObject;
        BillingJsonArray: JsonArray;
        DispatchJsonObject: JsonObject;
        ReceiptJsonObject: JsonObject;
        OriginatorJsonObject: JsonObject;
        ContractJsonObject: JsonObject;
        AdditionalJsonObject: JsonObject;
        AccountingJsonObject: JsonObject;
        PostalJsonObject: JsonObject;
        CustomerJsonObject: JsonObject;
        PostalsJsonObject: JsonObject;
        PaymentFirstJsonObject: JsonObject;
        PaymentSecondJsonObject: JsonObject;
        PaymentJsonArray: JsonArray;
        AllowanceFirstJsonObject: JsonObject;
        AllowanceSecondJsonObject: JsonObject;
        AllowanceArray: JsonArray;
        TaxJsonObject: JsonObject;
        TaxSubArray: JsonArray;
        TaxTotalArray: JsonArray;
        TaxCatJsonObject: JsonObject;
        TaxSubJsonObject: JsonObject;
        LegalJsonObject: JsonObject;
        ProductJsonObject: JsonObject;
        ItemProductJsonObject: JsonObject;
        PriceProductJsonObject: JsonObject;
        ServiceJsonObject: JsonObject;
        ItemServiceJsonObject: JsonObject;
        PriceServiceJsonObject: JsonObject;
        InvoiceJsonArray: JsonArray;

    begin
        HeaderJsonObject.Add('business_id', 'TEST_BUSINESS_ID');
        HeaderJsonObject.Add('irn', 'IRN_GENERATED');
        HeaderJsonObject.Add('issue_date', '2024-05-14');
        HeaderJsonObject.Add('due_date', '2024-06-14');
        HeaderJsonObject.Add('issue_time', '17:59:04');
        HeaderJsonObject.Add('invoice_type_code', '396');
        HeaderJsonObject.Add('payment_status', 'PENDING');
        HeaderJsonObject.Add('note', 'dummy_note (will be encryted in storage)');
        HeaderJsonObject.Add('tax_point_date', '2024-05-14');
        HeaderJsonObject.Add('document_currency_code', 'NGN');
        HeaderJsonObject.Add('tax_currency_code', 'NGN');
        HeaderJsonObject.Add('accounting_cost', '2000 NGN');
        HeaderJsonObject.Add('buyer_reference', 'buyer REF IRN?');
        HeaderJsonObject.Add('invoice_kind', 'B2B');

        // invoice delivery priod
        DeliveryJsonObject.Add('start_date', '2024-06-14');
        DeliveryJsonObject.Add('end_date', '2024-06-16');
        HeaderJsonObject.Add('invoice_delivery_period', DeliveryJsonObject);

        HeaderJsonObject.Add('order_reference', 'order REF IRN?');

        //billing reference
        BillingFirstJsonObject.Add('irn', 'ITW001-E9E0C0D3-20240619');
        BillingFirstJsonObject.Add('issue_date', '2024-05-14');
        BillingSecondJsonObject.Add('irn', 'ITW001-E9E0C0D3-20240619');
        BillingSecondJsonObject.Add('issue_date', '2024-05-14');
        BillingJsonArray.Add(BillingFirstJsonObject);
        BillingJsonArray.Add(BillingSecondJsonObject);
        HeaderJsonObject.Add('billing_reference', BillingJsonArray);

        //dispatch document reference
        DispatchJsonObject.Add('irn', 'ITW001-E9E0C0D3-20240619');
        DispatchJsonObject.Add('issue_date', '2024-05-14');
        HeaderJsonObject.Add('dispatch_document_reference', DispatchJsonObject);

        //receipt document reference
        ReceiptJsonObject.Add('irn', 'ITW001-E9E0C0D3-20240619');
        ReceiptJsonObject.Add('issue_date', '2024-05-14');
        HeaderJsonObject.Add('receipt_document_reference', ReceiptJsonObject);

        //originator document reference
        OriginatorJsonObject.Add('irn', 'ITW001-E9E0C0D3-20240619');
        OriginatorJsonObject.Add('issue_date', '2024-05-14');
        HeaderJsonObject.Add('originator_document_reference', OriginatorJsonObject);

        //contract document reference
        ContractJsonObject.Add('irn', 'ITW001-E9E0C0D3-20240619');
        ContractJsonObject.Add('issue_date', '2024-05-14');
        HeaderJsonObject.Add('contract_document_reference', ContractJsonObject);

        //additional document reference
        AdditionalJsonObject.Add('irn', 'ITW001-E9E0C0D3-20240619');
        AdditionalJsonObject.Add('issue_date', '2024-05-14');
        HeaderJsonObject.Add('additional_document_reference', AdditionalJsonObject);

        //accounting supplier party
        AccountingJsonObject.Add('party_name', 'Dangote Group');
        AccountingJsonObject.Add('tin', 'TIN-0099990001');
        AccountingJsonObject.Add('email', 'supplier_business@email.com');
        AccountingJsonObject.Add('telephone', '+23480254099000');
        AccountingJsonObject.Add('business_description', 'this entity is into sales of Cement and building materials');
        PostalJsonObject.Add('street_name', '32, owonikoko street');
        PostalJsonObject.Add('city_name', 'Gwarikpa');
        PostalJsonObject.Add('postal_zone', '023401');
        PostalJsonObject.Add('country', 'NG');
        AccountingJsonObject.Add('postal_address', PostalJsonObject);
        HeaderJsonObject.Add('accounting_supplier_party', AccountingJsonObject);

        //accounting customer party
        CustomerJsonObject.Add('party_name', 'Dangote Group');
        CustomerJsonObject.Add('tin', 'TIN-000001');
        CustomerJsonObject.Add('email', 'business@email.com');
        CustomerJsonObject.Add('telephone', '+23480254000000');
        CustomerJsonObject.Add('business_description', 'this entity is into sales of Cement and building materials');
        PostalsJsonObject.Add('street_name', '32, owonikoko street');
        PostalsJsonObject.Add('city_name', 'Gwarikpa');
        PostalsJsonObject.Add('postal_zone', '023401');
        PostalsJsonObject.Add('country', 'NG');
        CustomerJsonObject.Add('postal_address', PostalsJsonObject);
        HeaderJsonObject.Add('accounting_customer_party', CustomerJsonObject);

        HeaderJsonObject.Add('actual_delivery_date', '2024-05-14');

        //payment means 
        PaymentFirstJsonObject.Add('payment_means_code', 10);
        PaymentFirstJsonObject.Add('payment_due_date', '2024-05-14');
        PaymentSecondJsonObject.Add('payment_means_code', 43);
        PaymentSecondJsonObject.Add('payment_due_date', '2024-05-14');
        PaymentJsonArray.Add(PaymentFirstJsonObject);
        PaymentJsonArray.Add(PaymentSecondJsonObject);
        HeaderJsonObject.Add('payment_means', PaymentJsonArray);

        HeaderJsonObject.Add('payment_terms_note', 'dummy payment terms note (will be encryted in storage)');

        //allowance charge 
        AllowanceFirstJsonObject.Add('charge_indicator', 'true');
        AllowanceFirstJsonObject.Add('amount', 800.60);
        AllowanceSecondJsonObject.Add('charge_indicator', 'false');
        AllowanceSecondJsonObject.Add('amount', 10);
        AllowanceArray.Add(AllowanceFirstJsonObject);
        AllowanceArray.Add(AllowanceSecondJsonObject);
        HeaderJsonObject.Add('allowance_charge', AllowanceArray);

        //tax total
        TaxJsonObject.Add('tax_amount', 56.07);

        //tax sub total
        TaxSubJsonObject.Add('taxable_amount', 800);
        TaxSubJsonObject.Add('tax_amount', 8);
        TaxCatJsonObject.Add('id', 'STANDARD_VAT');
        TaxCatJsonObject.Add('percent', 7.5);
        TaxSubJsonObject.Add('tax_category', TaxCatJsonObject);
        TaxSubArray.Add(TaxSubJsonObject);
        TaxJsonObject.Add('tax_subtotal', TaxSubArray);


        TaxTotalArray.Add(TaxJsonObject);
        HeaderJsonObject.Add('tax_total', TaxTotalArray);

        //legal monetary total
        LegalJsonObject.Add('line_extension_amount', 340.50);
        LegalJsonObject.Add('tax_exclusive_amount', 400);
        LegalJsonObject.Add('tax_inclusive_amount', 430);
        LegalJsonObject.Add('payable_amount', 30);
        HeaderJsonObject.Add('legal_monetary_total', LegalJsonObject);

        //invoice line (for products)
        ProductJsonObject.Add('hsn_code', 1006.30);
        ProductJsonObject.Add('product_category', 'Cereals; rice, semi-milled or wholly milled, whether or not polished or glazed');
        ProductJsonObject.Add('discount_rate', 2.01);
        ProductJsonObject.Add('discount_amount', 0.603);
        ProductJsonObject.Add('fee_rate', 1.01);
        ProductJsonObject.Add('fee_amount', 50);
        ProductJsonObject.Add('invoiced_quantity', 15);
        ProductJsonObject.Add('line_extension_amount', 30);
        ItemProductJsonObject.Add('name', 'item name');
        ItemProductJsonObject.Add('description', 'item description');
        ItemProductJsonObject.Add('sellers_item_identification', 'identified as spoon by the seller');
        ProductJsonObject.Add('item', ItemProductJsonObject);
        PriceProductJsonObject.Add('price_amount', 10);
        PriceProductJsonObject.Add('base_quantity', 3);
        PriceProductJsonObject.Add('price_unit', 'XBG');
        ProductJsonObject.Add('price', PriceProductJsonObject);

        //invoice line (for services)
        ServiceJsonObject.Add('isic_code', 0112);
        ServiceJsonObject.Add('service_category', 'Growing of rice');
        ServiceJsonObject.Add('discount_rate', 2.01);
        ServiceJsonObject.Add('discount_amount', 0.603);
        ServiceJsonObject.Add('fee_rate', 1.01);
        ServiceJsonObject.Add('fee_amount', 50);
        ServiceJsonObject.Add('invoiced_quantity', 15);
        ServiceJsonObject.Add('line_extension_amount', 30);
        ItemServiceJsonObject.Add('name', 'item nam 2');
        ItemServiceJsonObject.Add('description', 'item description 2');
        ItemServiceJsonObject.Add('sellers_item_identification', 'identified as shovel by the seller');
        ServiceJsonObject.Add('item', ItemServiceJsonObject);
        PriceServiceJsonObject.Add('price_amount', 20);
        PriceServiceJsonObject.Add('base_quantity', 5);
        PriceServiceJsonObject.Add('price_unit', 'XBG');
        ServiceJsonObject.Add('price', PriceServiceJsonObject);

        InvoiceJsonArray.Add(ProductJsonObject);
        InvoiceJsonArray.Add(ServiceJsonObject);

        HeaderJsonObject.Add('invoice_line', InvoiceJsonArray);


        Message(Format(HeaderJsonObject));



    end;









    var
        x_api_key: Label 'SyoAiKGGnqYkd1vrkIe2o7XfVKZXOo';
        x_api_secret: Label 'CuST4nxJFmUA83Sujv1adAGXrqwrPOFnINt85NHHEMrZpYjA8hnsXaRlcihx';
}
