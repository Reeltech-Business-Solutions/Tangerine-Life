
/// <summary>
/// Codeunit Journal Post Successful1 (ID 50007).
/// </summary>
codeunit 50605 "Journal Post Successful1"
{

    trigger OnRun()
    begin
    end;

    /// <summary>
    /// PostedSuccessfully.
    /// </summary>
    /// <returns>Return variable Posted of type Boolean.</returns>
    procedure PostedSuccessfully() Posted: Boolean
    var
        ValPost: Record "Value Posting";
    begin
        Posted := false;
        ValPost.SetRange(ValPost.UserID, UserId);
        ValPost.SetRange(ValPost."Value Posting", 1);
        if ValPost.Find('-') then
            Posted := true;
    end;

     procedure AmountInwordUSFormat(Amount: Decimal)
    var
        ReportCheck: Report "Check";
        AmountinWords: array[2] of Text[80];
    begin
       ReportCheck.InitTextVariable();
       ReportCheck.FormatNoText(AmountinWords, Amount, '');
    end;
}

