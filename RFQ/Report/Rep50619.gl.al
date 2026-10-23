REPORT 50619 "Delete  GL Entries"
{
    ProcessingOnly = true;


    // dataset
    // {
    //     dataitem(GLEntry; "G/L Entry")
    //     {
    //         DataItemTableView = SORTING("Entry No.")
    //                             WHERE("Document Type" = FILTER(' '));

    //         trigger OnPreDataItem()
    //         BEGIN
    //             IF NOT CONFIRM('This will permanently delete all G/L Entries with a blank Document Type.\nDo you want to continue?', FALSE) THEN
    //                 CurrReport.QUIT;
    //         END;

    //         trigger OnAfterGetRecord()
    //         BEGIN
    //             GLEntry.DELETE;
    //             Counter := Counter + 1;
    //         END;

    //         trigger OnPostDataItem()
    //         BEGIN
    //             IF Counter = 0 THEN
    //                 MESSAGE('No G/L Entries found with blank Document Type.')
    //             ELSE
    //                 MESSAGE('%1 G/L Entries with blank Document Type deleted successfully.', Counter);
    //         END;
    //     }
    // }

    // var
    //     Counter: Integer;
}