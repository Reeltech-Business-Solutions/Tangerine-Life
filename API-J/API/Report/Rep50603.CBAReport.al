report 50603 "CBA Report"
{
    Caption = 'CBA Report';
    ApplicationArea = all;
    DefaultLayout = RDLC;
    RDLCLayout = './CBAReport.rdl';
    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = where("CBA Trans ID" = filter(<> ''));
            RequestFilterFields = "Posting Date";
            column(Posting_Date; "Posting Date")
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(G_L_Account_No_; "G/L Account No.")
            {

            }
            column(Account_Class_Name; "Account Class Name")
            {

            }
            column(Transaction_Class_Name; "Transaction Class Name")
            {

            }
            column(Transaction_Class_Code; "Transaction Class Code")
            {

            }
            column(Cheque_Num; "Cheque Num")
            {

            }
            column(Effective_Date; "Effective Date")
            {

            }
            column(Transaction_Date; "Transaction Date")
            {

            }
            column(Proposal_Number; "Proposal Number")
            {

            }
            column(Policy_Number; "Policy Number")
            {

            }
            column(Policy_Class; "Policy Class")
            {

            }
            column(branch; branch)
            {

            }
            column(agency; agency)
            {

            }
            column(Description; Description)
            {

            }
            column(Debit_Amount; "Debit Amount")
            {

            }
            column(Credit_Amount; "Credit Amount")
            {

            }

            column(picture; companyInfo.Picture)
            {

            }
            column(filter; getfilters())
            {

            }
            column(counter; counter)
            {

            }
            trigger OnPreDataItem()
            begin
                companyinfo.get();
                companyInfo.CalcFields(Picture);

            end;

            TRIGGER OnAfterGetRecord()
            begin
                counter += 1;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        companyInfo: Record "Company Information";
        counter: integer;

}
