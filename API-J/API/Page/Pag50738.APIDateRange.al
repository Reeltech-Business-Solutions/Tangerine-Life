

page 50738 dialog
{
    PageType = StandardDialog;
    ApplicationArea = All;
    Caption = 'Import Options';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(startDate; startDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    trigger onvalidate()
                    begin
                        ValidateDates();
                    end;
                }

                field(endDate; endDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';

                    trigger onvalidate()
                    begin
                        ValidateDates();
                    end;
                }
            }
        }


    }

    procedure GetstartDate(): date
    begin
        exit(startDate);
    end;

    procedure GetEndDate(): date
    begin
        exit(EndDate);
    end;

    local procedure ValidateDates()
    begin
        if (StartDate <> 0D) and (EndDate <> 0D) then begin
            if EndDate < StartDate then
                Error('End Date cannot be before Start Date.');
            if EndDate > CalcDate('<1M>', StartDate) then
                Error('Date range cannot exceed one month.');
        end;
    end;

    var
        startDate: Date;
        endDate: Date;
}