codeunit 50629 "FnO OAuth Token Mgt"
{
    procedure GetAccesToken(): Text
    var
        Setup: Record "FnO Integration Setup";
        SecretMgt: Codeunit "FnO Secret Mgt";
        OAuth2: Codeunit OAuth2;
        Scopes: List of [Text];
        AccessToken: Text;
        RedirectURL: Text;
        AuthorityUrl: Text;

    begin

        Setup.Get();
        Setup.TestField("Tenant Id");
        Setup.TestField("Client Id");
        Setup.TestField("F&O Environment URL");

        AuthorityUrl := 'https://login.microsoftonline.com/' + Setup."Tenant Id";

        Scopes.Add(Setup."F&O Environment URL" + '/.default');

        if not OAuth2.AcquireTokenWithClientCredentials(
                Setup."Client Id",
                SecretMgt.GetClientSecret(),
                AuthorityUrl,
                RedirectURL,
                Scopes,
                AccessToken)
        then
            Error('Failed to acquire OAuth2 token for F&O.');

        exit(AccessToken);
    end;
}
