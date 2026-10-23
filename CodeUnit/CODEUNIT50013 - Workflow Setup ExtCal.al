codeunit 50611 "Workflow Setup ExtCal"
{

    trigger OnRun()
    begin
    end;

    var
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingCust: Codeunit "Workflow Event Handling ExtCal";
        NoworkflowEnabledErr: Label 'No approval workflow for this record type is enabled';
        VoucherWorkflowCategoryDescTxt: Label 'Voucher Documents';
        VoucherWorkflowCategoryTxt: Label 'VOUCHERDOC';
        PHeaderWorkflowCategoryDescTxt: Label 'Payment Documents';
        PHeaderWorkflowCategoryTxt: Label 'PPAYMENTDOC';
        VoucherApprWorkflowCodeTxt: Label 'VIEW';
        PHeaderApprWorkflowCodeTxt: Label 'PHAPW';
        //BRV
        // BRVApprWorkflowCodeTxt: Label 'BRVAppro Work';
        // BRVWorkflowCategoryDescTxt: Label 'BRV Approval Workflow';
        // //BPV
        // BPVApprWorkflowCodeTxt: Label 'BPVAppro Work';
        // BPVWorkflowCategoryDescTxt: Label 'BPV Approval Workflow';
        // //CPV
        // CPVApprWorkflowCodeTxt: Label 'CPVAppro Work';
        // CPVWorkflowCategoryDescTxt: Label 'CPv Approval Workflow';
        // //CRV
        // CRVApprWorkflowCodeTxt: Label 'CRV Approval Work';
        // CRVWorkflowCategoryDescTxt: Label 'CRV Approval Workflow';
        //PettyCash
        //PettyCashApprWorkflowCodeTxt: Label 'PettyCash';
        // PettyCashWorkflowCategoryDescTxt: Label 'PettyCash Approval WorkfloW';
        //JV
        //JVApprWorkflowCodeTxt: Label 'JVA pproval Work';
        //JVWorkflowCategoryDescTxt: Label 'JV App. Workflow';
        //PaymentTypeCondnTxt: Label 'Payment Approval Workflow Type';
        VoucherTypeCondnTxt: Label 'Voucher Approval Workflow Type';
        PHeaderTypeCondnTxt: Label 'Payment Approval Workflow Type';
        StaffAdvanceWorkflowCategoryDescTxt: Label 'StaffAdvance Document';
        StaffAdvanceWorkflowCategoryTxt: Label 'StaffAdvance Doc';
        StaffAdvanceApprWorkflowCodeTxt: Label 'StaffAdv AppWork';
        StaffAdvanceTypeCondnTxt: Label 'StaffAdvance Approval Workflow Type';
        AdvanceSurrenderWorkflowCategoryDescTxt: Label 'Retirement';
        AdvanceSurrenderWorkflowCategoryTxt: Label 'Retirement Document';
        AdvanceSurrenderApprWorkflowCodeTxt: Label 'AdvanSurApp Work';
        AdvanceSurrenderTypeCondnTxt: Label 'AdvanceSurrender Approval Workflow Type';
        GLAccountWorkflowCategoryDescTxt: Label 'GL Account';
        GLAccountWorkflowCategoryTxt: Label 'GL Account';
        GLAccountApprWorkflowCodeTxt: Label 'GLAcc Appro Work';
        GLAccountTypeCondnTxt: Label 'GL Account Approval Workflow Type';
        StaffClaimWorkflowCategoryDescTxt: Label 'StaffClaim';
        StaffClaimWorkflowCategoryTxt: Label 'StaffClaim';
        StaffClaimApprWorkflowCodeTxt: Label 'StaffClaiApp Work';
        StaffClaimTypeCondnTxt: Label 'StaffClaim Approval Workflow Type';

    [EventSubscriber(ObjectType::Codeunit, 1502, 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(VoucherWorkflowCategoryTxt, VoucherWorkflowCategoryDescTxt);
        WorkflowSetup.InsertWorkflowCategory(PHeaderWorkflowCategoryTxt, PHeaderWorkflowCategoryDescTxt);
        WorkflowSetup.InsertWorkflowCategory(GLAccountWorkflowCategoryTxt, GLAccountWorkflowCategoryDescTxt);
        WorkflowSetup.InsertWorkflowCategory(StaffClaimWorkflowCategoryTxt, StaffClaimWorkflowCategoryDescTxt);

        WorkflowSetup.InsertWorkflowCategory(StaffAdvanceWorkflowCategoryTxt, StaffAdvanceWorkflowCategoryDescTxt);
        WorkflowSetup.InsertWorkflowCategory(AdvanceSurrenderWorkflowCategoryTxt, AdvanceSurrenderWorkflowCategoryDescTxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, 1502, 'OnAfterInsertApprovalsTableRelations', '', false, false)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WorkflowSetup.InsertTableRelation(DATABASE::"Voucher Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        WorkflowSetup.InsertTableRelation(DATABASE::"Payments Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));

        WorkflowSetup.InsertTableRelation(DATABASE::"Staff Advance Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        WorkflowSetup.InsertTableRelation(DATABASE::"Staff Advanc Surrender Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        WorkflowSetup.InsertTableRelation(DATABASE::"G/L Account", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        WorkflowSetup.InsertTableRelation(DATABASE::"Staff Claims Header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, 1502, 'OnInsertWorkflowTemplates', '', false, false)]
    local procedure OnInsertWorkflowTemplates()
    begin
        //InsertPaymentApprovalWorkflowTemplate();
        InsertStaffAdvanceApprovalWorkflowTemplate();
        InsertAdvanceSurrenderApprovalWorkflowTemplate();
        InsertGLAccountApprovalWorkflowTemplate();
        InsertStaffClaimApprovalWorkflowTemplate();
        InsertPheaderApprovalWorkflowTemplate();
        /*
                //Vouchers Types
                InsertBRVApprovalWorkflowTemplate();
                InsertBPVApprovalWorkflowTemplate();
                InsertCRVApprovalWorkflowTemplate();
                InsertCPVApprovalWorkflowTemplate();
                InsertJVApprovalWorkflowTemplate();
                InsertPettyCashApprovalWorkflowTemplate();

        */
    end;

    //payement workflow begin
    local procedure InsertVoucherApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, VoucherApprWorkflowCodeTxt, VoucherWorkflowCategoryDescTxt, VoucherWorkflowCategoryTxt);
        InsertVoucherApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertVoucherApprovalWorkflowDetails(Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkflowEventHandlingCust: Codeunit "Workflow Event Handling ExtCal";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        VoucherLine: Record "Voucher Line";
        VoucherHeader: Record "Voucher Header";
    begin
        //
        WorkflowSetup.InsertTableRelation(DATABASE::"Voucher Header", VoucherHeader.FIELDNO("Voucher Type"),
          DATABASE::"Voucher Line", VoucherLine.FIELDNO("Voucher Type"));
        WorkflowSetup.InsertTableRelation(DATABASE::"Voucher Header", VoucherHeader.FIELDNO("No."),
          DATABASE::"Voucher Line", VoucherLine.FIELDNO("Document No."));
        //
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
                   WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
                    0, '', BlankDateFormula, true);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            BuildVoucherTypeConditions(VoucherHeader.Status::Open),
            WorkflowEventHandlingCust.RunWorkflowOnSendPaymentHeaderForApprovalCode,
            BuildVoucherTypeConditions(VoucherHeader.Status::"Pending Approval"),
            WorkflowEventHandlingCust.RunWorkflowOnCanceledPaymentHeaderForApprovalCode,
            WorkflowStepArgument,
        true);
    end;

    local procedure BuildVoucherTypeConditions(Status: Integer): Text
    var
        VoucherHeader: Record "Voucher Header";
    begin
        VoucherHeader.SetRange(Status, Status);
        exit(StrSubstNo(VoucherTypeCondnTxt, WorkflowSetup.Encode(VoucherHeader.GetView(false))));
    end;
    //Payment header Begin New

    local procedure InsertPHeaderApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, PHeaderApprWorkflowCodeTxt, PHeaderWorkflowCategoryDescTxt, PHeaderWorkflowCategoryTxt);
        InsertPHeaderApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertPHeaderApprovalWorkflowDetails(Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkflowEventHandlingCust: Codeunit "Workflow Event Handling ExtCal";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        PLine: Record "Payments Line";
        PHeader: Record "Payments Header";
    begin
        //
        WorkflowSetup.InsertTableRelation(DATABASE::"Payments Header", PHeader.FIELDNO("Payment Type"),
          DATABASE::"Payments Line", PLine.FIELDNO("Payment Type"));
        WorkflowSetup.InsertTableRelation(DATABASE::"Payments Header", PHeader.FIELDNO("No."),
          DATABASE::"Payments Line", PLine.FIELDNO("No."));
        //
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
                   WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
                    0, '', BlankDateFormula, true);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            BuildPHeaderTypeConditions(PHeader.Status::Open), WorkflowEventHandlingCust.RunWorkflowOnSendPHeaderForApprovalCode,
            BuildPHeaderTypeConditions(PHeader.Status::"Pending Approval"),
            WorkflowEventHandlingCust.RunWorkflowOnCanceledPHeaderForApprovalCode,
            WorkflowStepArgument, true);
    end;

    local procedure BuildPHeaderTypeConditions(Status: Enum Status): Text
    var
        PHeader: Record "Payments Header";
    begin
        PHeader.SetRange(Status, Status);
        exit(StrSubstNo(PHeaderTypeCondnTxt, WorkflowSetup.Encode(PHeader.GetView(false))));
    end;

    //
    local procedure InsertStaffAdvanceApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, StaffAdvanceApprWorkflowCodeTxt, StaffAdvanceWorkflowCategoryDescTxt, StaffAdvanceWorkflowCategoryTxt);
        InsertStaffAdvanceApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertStaffAdvanceApprovalWorkflowDetails(Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkflowEventHandlingCust: Codeunit "Workflow Event Handling ExtCal";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        StaffAdvance: Record "Staff Advance Header";
        StaffAdvLine: Record "Staff Advance Lines";
    //AdvanceSurrender: Record "Staff Advanc Surrender Header";
    begin
        //
        WorkflowSetup.InsertTableRelation(DATABASE::"Staff Advance Header", StaffAdvance.FIELDNO("Type of Advance"),
          DATABASE::"Voucher Line", StaffAdvLine.FIELDNO("Type of Advance"));
        WorkflowSetup.InsertTableRelation(DATABASE::"Voucher Header", StaffAdvance.FIELDNO("No."),
          DATABASE::"Voucher Line", StaffAdvLine.FIELDNO("No."));
        //
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
                   WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
                    0, '', BlankDateFormula, true);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            BuildStaffAdvanceTypeConditions(StaffAdvance.Status::Open),
            WorkflowEventHandlingCust.RunWorkflowOnSendStaffAdvanceForApprovalCode,
            BuildStaffAdvanceTypeConditions(StaffAdvance.Status::"Pending Approval"),
            WorkflowEventHandlingCust.RunWorkflowOnCanceledStaffAdvanceForApprovalCode,
            WorkflowStepArgument,
        true);
    end;

    local procedure BuildStaffAdvanceTypeConditions(Status: Integer): Text
    var
        StaffAdvance: Record "Staff Advance Header";
    begin
        StaffAdvance.SetRange(Status, Status);
        exit(StrSubstNo(StaffAdvanceTypeCondnTxt, WorkflowSetup.Encode(StaffAdvance.GetView(false))));
    end;

    //Staff advance workflow end
    //Advance surrender workflow begin

    local procedure InsertAdvanceSurrenderApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, AdvanceSurrenderApprWorkflowCodeTxt, AdvanceSurrenderWorkflowCategoryDescTxt, AdvanceSurrenderWorkflowCategoryTxt);
        InsertAdvanceSurrenderApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertAdvanceSurrenderApprovalWorkflowDetails(Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkflowEventHandlingCust: Codeunit "Workflow Event Handling ExtCal";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        PaymentHeader: Record "Voucher Header";
        StaffAdvance: Record "Staff Advance Header";
        AdvanceSurrender: Record "Staff Advanc Surrender Header";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
                   WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
                    0, '', BlankDateFormula, true);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            BuildAdvanceSurrenderTypeConditions(AdvanceSurrender.Status::Open),
            WorkflowEventHandlingCust.RunWorkflowOnSendAdvanceSurrenderForApprovalCode,
            BuildAdvanceSurrenderTypeConditions(AdvanceSurrender.Status::"Pending Approval"),
            WorkflowEventHandlingCust.RunWorkflowOnCanceledAdvanceSurrenderForApprovalCode,
            WorkflowStepArgument,
        true);
    end;

    local procedure BuildAdvanceSurrenderTypeConditions(Status: enum Status): Text
    var
        AdvanceSurrender: Record "Staff Advanc Surrender Header";
    begin
        AdvanceSurrender.SetRange(Status, Status);
        exit(StrSubstNo(AdvanceSurrenderTypeCondnTxt, WorkflowSetup.Encode(AdvanceSurrender.GetView(false))));
    end;
    //Advance surrender workflow end


    //GLAccount worflow begin
    local procedure InsertGLAccountApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, GLAccountApprWorkflowCodeTxt, GLAccountWorkflowCategoryDescTxt, GLAccountWorkflowCategoryTxt);
        InsertGLAccountApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertGLAccountApprovalWorkflowDetails(Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkflowEventHandlingCust: Codeunit "Workflow Event Handling ExtCal";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        PaymentHeader: Record "Voucher Header";
        StaffAdvance: Record "Staff Advance Header";
        AdvanceSurrender: Record "Staff Advanc Surrender Header";
        GLAccount: Record "G/L Account";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
                   WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
                    0, '', BlankDateFormula, true);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            BuildGLAccountTypeConditions(GLAccount.Status::Open),
            WorkflowEventHandlingCust.RunWorkflowOnSendGLAccountForApprovalCode,
            BuildGLAccountTypeConditions(GLAccount.Status::"Pending Approval"),
            WorkflowEventHandlingCust.RunWorkflowOnCanceledGLAccountForApprovalCode,
            WorkflowStepArgument,
        true);
    end;

    local procedure BuildGLAccountTypeConditions(Status: Integer): Text
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.SetRange(Status, Status);
        exit(StrSubstNo(GLAccountTypeCondnTxt, WorkflowSetup.Encode(GLAccount.GetView(false))));
    end;
    //GLAccount worflow End

    //StaffClaim worflow begin
    local procedure InsertStaffClaimApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, StaffClaimApprWorkflowCodeTxt, StaffClaimWorkflowCategoryDescTxt, StaffClaimWorkflowCategoryTxt);
        InsertStaffClaimApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertStaffClaimApprovalWorkflowDetails(Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkflowEventHandlingCust: Codeunit "Workflow Event Handling ExtCal";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        PaymentHeader: Record "Voucher Header";
        StaffAdvance: Record "Staff Advance Header";
        AdvanceSurrender: Record "Staff Advanc Surrender Header";
        GLAccount: Record "G/L Account";
        StaffClaim: Record "Staff Claims Header";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
                   WorkflowStepArgument."Approver Type"::"Workflow User Group", WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver",
                    0, '', BlankDateFormula, true);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            '',
            WorkflowEventHandlingCust.RunWorkflowOnSendStaffClaimForApprovalCode,
            '',
            WorkflowEventHandlingCust.RunWorkflowOnCanceledStaffClaimForApprovalCode,
            WorkflowStepArgument,
        true);
    end;

    // local procedure BuildStaffClaimTypeConditions(Status: Integer): Text
    // var
    //     StaffClaim: Record "Staff Claims Header";
    // begin
    //     StaffClaim.SetRange(Status, Status);
    //     exit(StrSubstNo(StaffClaimTypeCondnTxt, WorkflowSetup.Encode(StaffClaim.GetView(false))));
    // end;
    //Staffclaim worflow End
}

