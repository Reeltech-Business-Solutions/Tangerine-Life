page 50601 EmployeeAPI
{
    APIGroup = 'Employee';
    APIPublisher = 'CapitalCore';
    APIVersion = 'v1.0';
    Caption = 'employeeAPI';
    DelayedInsert = true;
    EntityName = 'Employee';
    EntitySetName = 'Employees';
    PageType = API;
    SourceTable = Employee;
    ODataKeyFields = SystemId;
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }

                field(jobTitle; Rec."Job Title")
                {
                    Caption = 'Job Title';
                }
                field(lastName; Rec."Last Name")
                {
                    Caption = 'Last Name';
                }
                field(managerNo; Rec."Manager No.")
                {
                    Caption = 'Manager No.';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
