xmlport 50600 "Purchases Line XML"
{
    Format = VariableText;

    schema
    {
        textelement(PurchaseLines)
        {
            tableelement("Purchase Line"; "Purchase Line")
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'PurchaseLines';
                fieldelement(a; "Purchase Line"."Document Type")
                {
                }
                fieldelement(b; "Purchase Line"."Buy-from Vendor No.")
                {
                }
                fieldelement(c; "Purchase Line"."Document No.")
                {
                }
                fieldelement(d; "Purchase Line"."Line No.")
                {
                }
                fieldelement(e; "Purchase Line".Type)
                {
                }
                fieldelement(f; "Purchase Line"."No.")
                {
                }
                fieldelement(i; "Purchase Line".Description)
                {
                }
                fieldelement(g; "Purchase Line"."Location Code")
                {
                }
                fieldelement(h; "Purchase Line"."Posting Group")
                {
                }
                fieldelement(j; "Purchase Line"."Unit of Measure")
                {
                }
                fieldelement(k; "Purchase Line".Quantity)
                {
                }
                fieldelement(l; "Purchase Line"."Unit Cost (LCY)")
                {
                }
                // fieldelement(m; "Purchase Line"."Shortcut Dimension 5 Code")
                // {
                // }
                fieldelement(n; "Purchase Line"."VAT Bus. Posting Group")
                {
                }
                fieldelement(o; "Purchase Line"."VAT Prod. Posting Group")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

