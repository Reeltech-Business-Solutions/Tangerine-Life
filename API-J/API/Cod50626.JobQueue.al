//codeunit 50626 JobQueue
codeunit 50626 JobQueue
{

    procedure RegisterCBADailyJob()
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueMgt: Codeunit "Job Queue Management";
    begin

        JobQueueEntry.Reset();
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::IES2);
        if not JobQueueEntry.IsEmpty() then
            exit;

        // Register the daily job
        JobQueueEntry.Init();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := Codeunit::IES2;
        JobQueueEntry.Description := 'CBA Daily Fetch and Post';
        JobQueueEntry."Parameter String" := '';
        JobQueueEntry."Job Queue Category Code" := 'CBA';
        JobQueueEntry."Maximum No. of Attempts to Run" := 3;
        JobQueueEntry."Rerun Delay (sec.)" := 60;
        JobQueueEntry."Earliest Start Date/Time" := CreateDateTime(Today, 200000T);
        // JobQueueEntry."Error Message"     := Codeunit::EmailNotifier;
        JobQueueEntry."Recurring Job" := true;
        JobQueueEntry."Run on Mondays" := true;
        JobQueueEntry."Run on Tuesdays" := true;
        JobQueueEntry."Run on Wednesdays" := true;
        JobQueueEntry."Run on Thursdays" := true;
        JobQueueEntry."Run on Fridays" := true;
        JobQueueEntry."Run on Saturdays" := true;
        JobQueueEntry."Run on Sundays" := true;
        // JobQueueEntry."Starting Time" := 110400T;
        JobQueueMgt.CreateJobQueueEntry(JobQueueEntry);
        //  JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
        Message('CBA Job Queue registered successfully. It will run every day at 20:00.');
    end;
}