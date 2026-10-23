codeunit 50630 "FnO Secret Mgt"
{
    procedure SetClientSecret(Secret: Text)
    begin
        IsolatedStorage.Set('FnO_ClientSecret', Secret, DataScope::Module);
    end;

    procedure GetClientSecret(): Text
    var
        Secret: Text;
    begin
        if IsolatedStorage.Get('FnO_ClientSecret', DataScope::Module, Secret) then
            exit(Secret);
        Error('F&O client secret is not configured.');
    end;

}
