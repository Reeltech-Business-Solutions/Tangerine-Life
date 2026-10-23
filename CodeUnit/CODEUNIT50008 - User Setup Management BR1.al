codeunit 50606 "User Setup Management BR1"
{
    Permissions = TableData Location = r,
                  TableData "Responsibility Center" = r;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'customer';
        Text001: Label 'vendor';
        Text002: Label 'This %1 is related to %2 %3. Your identification is setup to process from %2 %4.';
        Text003: Label 'This document will be processed in your %2.';
        UserSetup: Record "User Setup";
        RespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
        UserLocation: Code[20];
        UserRespCenter: Code[20];
        SalesUserRespCenter: Code[20];
        PurchUserRespCenter: Code[20];
        ServUserRespCenter: Code[20];
        HasGotSalesUserSetup: Boolean;
        HasGotPurchUserSetup: Boolean;
        HasGotServUserSetup: Boolean;
        DimensionVal: Code[20];
        PostLocation: Code[15];
        UserSet: Record "User Setup";

    procedure GetSalesFilter(): Code[20]
    begin
        exit(GetSalesFilter2(UserId));
    end;

    procedure GetPurchasesFilter(): Code[20]
    begin
        exit(GetPurchasesFilter2(UserId));
    end;

    procedure GetServiceFilter(): Code[20]
    begin
        exit(GetServiceFilter2(UserId));
    end;

    procedure GetSalesFilter2(UserCode: Code[50]): Code[20]
    begin
        if not HasGotSalesUserSetup then begin
            CompanyInfo.Get;
            SalesUserRespCenter := CompanyInfo."Responsibility Center";
            UserLocation := CompanyInfo."Location Code";
            if (UserSetup.Get(UserCode)) and (UserCode <> '') then
                if UserSetup."Sales Resp. Ctr. Filter" <> '' then
                    SalesUserRespCenter := UserSetup."Sales Resp. Ctr. Filter";
            HasGotSalesUserSetup := true;
        end;
        exit(SalesUserRespCenter);
    end;

    procedure GetPurchasesFilter2(UserCode: Code[50]): Code[20]
    begin
        if not HasGotPurchUserSetup then begin
            CompanyInfo.Get;
            PurchUserRespCenter := CompanyInfo."Responsibility Center";
            UserLocation := CompanyInfo."Location Code";
            if (UserSetup.Get(UserCode)) and (UserCode <> '') then
                if UserSetup."Purchase Resp. Ctr. Filter" <> '' then
                    PurchUserRespCenter := UserSetup."Purchase Resp. Ctr. Filter";
            HasGotPurchUserSetup := true;
        end;
        exit(PurchUserRespCenter);
    end;

    procedure GetServiceFilter2(UserCode: Code[50]): Code[20]
    begin
        if not HasGotServUserSetup then begin
            CompanyInfo.Get;
            ServUserRespCenter := CompanyInfo."Responsibility Center";
            UserLocation := CompanyInfo."Location Code";
            if (UserSetup.Get(UserCode)) and (UserCode <> '') then
                if UserSetup."Service Resp. Ctr. Filter" <> '' then
                    ServUserRespCenter := UserSetup."Service Resp. Ctr. Filter";
            HasGotServUserSetup := true;
        end;
        exit(ServUserRespCenter);

        /*
       IF NOT HasGotServUserSetup THEN BEGIN
         CompanyInfo.GET;
         PostLocation := UserSet."Shortcut Dimension 3 Code";
         //UserLocation := CompanyInfo."Location Code";
         IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN
           IF UserSetup."Shortcut Dimension 3 Code" <> '' THEN
             PostLocation := UserSetup."Shortcut Dimension 3 Code";
         HasGotServUserSetup := TRUE;
       END;
       EXIT(PostLocation);
                          */

    end;

    procedure GetRespCenter(DocType: Option Sales,Purchase,Service; AccRespCenter: Code[20]): Code[20]
    var
        AccType: Text[50];
    begin
        case DocType of
            DocType::Sales:
                begin
                    AccType := Text000;
                    UserRespCenter := GetSalesFilter;
                end;
            DocType::Purchase:
                begin
                    AccType := Text001;
                    UserRespCenter := GetPurchasesFilter;
                end;
            DocType::Service:
                begin
                    AccType := Text000;
                    UserRespCenter := GetServiceFilter;
                end;
        end;
        if (AccRespCenter <> '') and
           (UserRespCenter <> '') and
           (AccRespCenter <> UserRespCenter)
        then
            Message(
              Text002 +
              Text003,
              AccType, RespCenter.TableCaption, AccRespCenter, UserRespCenter);
        if UserRespCenter = '' then
            exit(AccRespCenter)
        else
            exit(UserRespCenter);
    end;

    procedure CheckRespCenter(DocType: Option Sales,Purchase,Service; AccRespCenter: Code[20]): Boolean
    begin
        exit(CheckRespCenter2(DocType, AccRespCenter, UserId));
    end;

    procedure CheckRespCenter2(DocType: Option Sales,Purchase,Service; AccRespCenter: Code[20]; UserCode: Code[50]): Boolean
    begin
        case DocType of
            DocType::Sales:
                UserRespCenter := GetSalesFilter2(UserCode);
            DocType::Purchase:
                UserRespCenter := GetPurchasesFilter2(UserCode);
            DocType::Service:
                UserRespCenter := GetServiceFilter2(UserCode);
        end;
        if (UserRespCenter <> '') and
           (AccRespCenter <> UserRespCenter)
        then
            exit(false)
        else
            exit(true);
    end;

    procedure GetLocation(DocType: Option Sales,Purchase,Service; AccLocation: Code[20]; RespCenterCode: Code[20]): Code[20]
    begin
        case DocType of
            DocType::Sales:
                UserRespCenter := GetSalesFilter;
            DocType::Purchase:
                UserRespCenter := GetPurchasesFilter;
            DocType::Service:
                UserRespCenter := GetServiceFilter;
        end;
        if UserRespCenter <> '' then
            RespCenterCode := UserRespCenter;
        if RespCenter.Get(RespCenterCode) then
            if RespCenter."Location Code" <> '' then
                UserLocation := RespCenter."Location Code";
        if AccLocation <> '' then
            exit(AccLocation)
        else
            exit(UserLocation);
    end;

    procedure GetSetDimensions(UserCode: Code[50]; DimensionNo: Integer): Code[50]
    begin
        DimensionVal := '';
        case DimensionNo of
            1:
                begin
                    if (UserSetup.Get(UserCode)) and (UserCode <> '') then
                        if UserSetup."Global Dimension 1 Code" <> '' then
                            DimensionVal := UserSetup."Global Dimension 1 Code";
                    exit(DimensionVal);
                end;
            2:
                begin
                    if (UserSetup.Get(UserCode)) and (UserCode <> '') then
                        if UserSetup."Shortcut Dimension 2 Code" <> '' then
                            DimensionVal := UserSetup."Shortcut Dimension 2 Code";
                    exit(DimensionVal);
                end;
            3:
                begin
                    if (UserSetup.Get(UserCode)) and (UserCode <> '') then
                        if UserSetup."Shortcut Dimension 3 Code" <> '' then
                            DimensionVal := UserSetup."Shortcut Dimension 3 Code";
                    exit(DimensionVal);
                end;
            4:
                begin
                    if (UserSetup.Get(UserCode)) and (UserCode <> '') then
                        if UserSetup."Shortcut Dimension 4 Code" <> '' then
                            DimensionVal := UserSetup."Shortcut Dimension 4 Code";
                    exit(DimensionVal);
                end;
        end;
    end;
}

