# Get all user accounts within the specified Organizational Unit (OU)
#   - Filter *: This will retrieve ALL user accounts in the OU (you can modify the filter for more specific criteria)
#   - SearchBase: This targets the "Users" OU within the "Richmond" OU in the "contoso.com" domain
$Users = Get-ADUser -Filter * -SearchBase "OU=Users,OU=Richmond,DC=contoso,DC=com"

# Process each user found in the specified OU
foreach ($User in $Users) {
    # Clear the proxyAddresses attribute for the current user
    # This will remove all email addresses (including aliases) associated with the user in Active Directory
    Set-ADUser $User -Clear proxyAddresses
}
