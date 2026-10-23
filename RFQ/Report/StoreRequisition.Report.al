// report 50008 "Store Requisition"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './StoreRequisition.rdlc';

//     dataset
//     {
//         dataitem(DataItem1826; "Store Requistion Header")
//         {
//             DataItemTableView = SORTING("No.");
//             RequestFilterFields = "No.";
//             column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
//             {
//             }
//             column(CurrReport_PAGENO; CurrReport.PAGENO)
//             {
//             }
//             column(USERID; USERID)
//             {
//             }
//             column(Store_Requistion_Header__Required_Date_; FORMAT("Required Date"))
//             {
//             }
//             column(Store_Requistion_Header__Shortcut_Dimension_4_Code_; "Shortcut Dimension 4 Code")
//             {
//             }
//             column(Store_Requistion_Header_Dim4; Dim4)
//             {
//             }
//             column(Store_Requistion_Header__Request_date_; FORMAT("Request date"))
//             {
//             }
//             column(Store_Requistion_Header__Shortcut_Dimension_3_Code_; "Shortcut Dimension 3 Code")
//             {
//             }
//             column(Store_Requistion_Header_Dim3; Dim3)
//             {
//             }
//             column(Store_Requistion_Header__Request_Description_; "Request Description")
//             {
//             }
//             column(Store_Requistion_Header__Shortcut_Dimension_2_Code_; "Shortcut Dimension 2 Code")
//             {
//             }
//             column(Store_Requistion_Header__Budget_Center_Name_; "Budget Center Name")
//             {
//             }
//             column(Store_Requistion_Header__No__; "No.")
//             {
//             }
//             column(Store_Requistion_Header__Global_Dimension_1_Code_; "Global Dimension 1 Code")
//             {
//             }
//             column(Store_Requistion_Header__Function_Name_; "Function Name")
//             {
//             }
//             column(TIME_PRINTED_____FORMAT_TIME_; 'TIME PRINTED:' + FORMAT(TIME))
//             {
//                 AutoFormatType = 1;
//             }
//             column(DATE_PRINTED_____FORMAT_TODAY_0_4_; 'DATE PRINTED:' + FORMAT(TODAY, 0, 4))
//             {
//                 AutoFormatType = 1;
//             }
//             column(USERID_Control1102755048; USERID)
//             {
//             }
//             column(Store_RequistionCaption; Store_RequistionCaptionLbl)
//             {
//             }
//             column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(Store_Requistion_Lines_DescriptionCaption; StoreRequistionLine.FIELDCAPTION(Description))
//             {
//             }
//             column(Store_Requistion_Lines_QuantityCaption; StoreRequistionLine.FIELDCAPTION(Quantity))
//             {
//             }
//             column(UoMCaption; UoMCaptionLbl)
//             {
//             }
//             column(Store_Requistion_Lines__Line_Amount_Caption; StoreRequistionLine.FIELDCAPTION("Line Amount"))
//             {
//             }
//             column(Store_Requistion_Lines__Unit_Cost_Caption; StoreRequistionLine.FIELDCAPTION("Unit Cost"))
//             {
//             }
//             column(Store_Requistion_Header__Required_Date_Caption; FIELDCAPTION("Required Date"))
//             {
//             }
//             column(Store_Requistion_Header__Shortcut_Dimension_4_Code_Caption; FIELDCAPTION("Shortcut Dimension 4 Code"))
//             {
//             }
//             column(Store_Requistion_Lines__No__Caption; FIELDCAPTION("No."))
//             {
//             }
//             column(Store_Requistion_Header__Request_date_Caption; FIELDCAPTION("Request date"))
//             {
//             }
//             column(Store_Requistion_Header__Shortcut_Dimension_3_Code_Caption; FIELDCAPTION("Shortcut Dimension 3 Code"))
//             {
//             }
//             column(Store_Requistion_Header__Request_Description_Caption; FIELDCAPTION("Request Description"))
//             {
//             }
//             column(Store_Requistion_Header__Shortcut_Dimension_2_Code_Caption; FIELDCAPTION("Shortcut Dimension 2 Code"))
//             {
//             }
//             column(Store_Requistion_Header__No__Caption; FIELDCAPTION("No."))
//             {
//             }
//             column(Store_Requistion_Header__Global_Dimension_1_Code_Caption; FIELDCAPTION("Global Dimension 1 Code"))
//             {
//             }
//             column(Date_Caption; Date_CaptionLbl)
//             {
//             }
//             column(Name_Caption; Name_CaptionLbl)
//             {
//             }
//             column(RecipientCaption; RecipientCaptionLbl)
//             {
//             }
//             column(Printed_By_Caption; Printed_By_CaptionLbl)
//             {
//             }
//             column(Name_Caption_Control1102755052; Name_Caption_Control1102755052Lbl)
//             {
//             }
//             column(Date_Caption_Control1102755053; Date_Caption_Control1102755053Lbl)
//             {
//             }
//             column(Signature_Caption; Signature_CaptionLbl)
//             {
//             }
//             column(AuthorisationsCaption; AuthorisationsCaptionLbl)
//             {
//             }
//             column(EmptyStringCaption; EmptyStringCaptionLbl)
//             {
//             }
//             column(Signature_Caption_Control1102755000; Signature_Caption_Control1102755000Lbl)
//             {
//             }
//             dataitem("Store Requistion Line"; "Store Requistion Line")
//             {
//                 DataItemLink = "Requistion No" = FIELD("No.");
//                 DataItemTableView = SORTING("Requistion No", "Line No.")
//                                     ORDER(Ascending);
//                 column(VehicleReg_StoreRequistionLines; "Vehicle Reg")
//                 {
//                 }
//                 column(Store_Requistion_Lines__No__; "No.")
//                 {
//                 }
//                 column(Store_Requistion_Lines_Description; Description)
//                 {
//                 }
//                 column(Store_Requistion_Lines_Quantity; Quantity)
//                 {
//                 }
//                 column(Store_Requistion_Lines__Unit_of_Measure_; "Unit of Measure")
//                 {
//                 }
//                 column(Store_Requistion_Lines__Line_Amount_; "Line Amount")
//                 {
//                 }
//                 column(Store_Requistion_Lines__Unit_Cost_; "Unit Cost")
//                 {
//                 }
//                 column(Store_Requistion_Lines_Requistion_No; "Requistion No")
//                 {
//                 }
//             }
//         }
//     }


//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     var
//         Store_RequistionCaptionLbl: Label 'Store Requistion';
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         UoMCaptionLbl: Label 'UoM';
//         Date_CaptionLbl: Label 'Date:';
//         Name_CaptionLbl: Label 'Name:';
//         RecipientCaptionLbl: Label 'Recipient';
//         Printed_By_CaptionLbl: Label 'Printed By:';
//         Name_Caption_Control1102755052Lbl: Label 'Name:';
//         Date_Caption_Control1102755053Lbl: Label 'Date:';
//         Signature_CaptionLbl: Label 'Signature:';
//         AuthorisationsCaptionLbl: Label 'Authorisations';
//         EmptyStringCaptionLbl: Label '================================================================================================================================================================================================';
//         Signature_Caption_Control1102755000Lbl: Label 'Signature:';
//         StoreRequistionLine: Record "Store Requistion Line";
// }

