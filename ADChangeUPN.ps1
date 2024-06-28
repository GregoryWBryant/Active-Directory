Import-Module ActiveDirectory
$Users = Get-ADUser -Filter {UserPrincipalName -like '*contoso.local'} -Properties userPrincipalName

foreach ($User in $Users) {
    if ($User.UserPrincipalName -notlike "*Mailbox*" -and $User.UserPrincipalName -notlike "*FederatedEmail*") {
            $NewUPN = $User.UserPrincipalName.Replace("contoso.local","contoso.com")
            Set-ADUser -Identity $User -UserPrincipalName $NewUPN
        }
}