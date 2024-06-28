# Import the Active Directory PowerShell module for working with AD objects
Import-Module ActiveDirectory 

# Get all AD user objects that have a UserPrincipalName (UPN) ending in "contoso.local"
# The -Properties parameter specifies that we only need the userPrincipalName property
$Users = Get-ADUser -Filter {UserPrincipalName -like '*contoso.local'} -Properties userPrincipalName

# Iterate through each user object that was retrieved
foreach ($User in $Users) {

    # Check if the UserPrincipalName does NOT contain "Mailbox" or "FederatedEmail"
    # This is likely to exclude specific types of users (e.g., mailboxes, federated accounts) from the update
    if ($User.UserPrincipalName -notlike "*Mailbox*" -and $User.UserPrincipalName -notlike "*FederatedEmail*") {

        # Replace "contoso.local" with "contoso.com" in the UserPrincipalName
        $NewUPN = $User.UserPrincipalName.Replace("contoso.local","contoso.com")
        
        # Update the user's UserPrincipalName in Active Directory
        Set-ADUser -Identity $User -UserPrincipalName $NewUPN
    }
}
