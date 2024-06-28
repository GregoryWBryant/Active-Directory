<#
Creates a new Active Directory user account, copying various attributes and group memberships from an existing user.
#>

# User to copy attributes and group memberships from
$copyUser = Read-Host "Enter username to copy from: "

# Prompt for new user's details
$firstName = Read-Host "Enter the new user's first name: "
$lastName  = Read-Host "Enter the new user's last name: "
$userName  = Read-Host "Enter the new user's logon name: "
$password = Read-Host "Enter the new user's password: " -AsSecureString

# Construct the full name and user principal name (UPN)
$fullName = "$firstName $lastName"
$userPrincipalName = "$userName@test.local"  # Replace "test.local" with your actual domain name


# Get all properties of the source user
$sourceUser = Get-ADUser -Identity $copyUser -Properties *

# Extract specific attributes to copy
$department = $sourceUser.Department
$company    = $sourceUser.Company
$description = $sourceUser.Description
$manager   = $sourceUser.Manager
$office    = $sourceUser.Office
$scriptPath = $sourceUser.ScriptPath
$title     = $sourceUser.Title

# Get the OU path of the source user
$path = $sourceUser.DistinguishedName.Split(',', 2)[1]  # Get the OU portion only

# Create the new user in Active Directory with the copied attributes
New-ADUser `
    -Name $fullName `
    -DisplayName $fullName `
    -GivenName $firstName `
    -Surname $lastName `
    -SamAccountName $userName `
    -UserPrincipalName $userPrincipalName `
    -Path $path `
    -Department $department `
    -Company $company `
    -Description $description `
    -Manager $manager `
    -Office $office `
    -ScriptPath $scriptPath `
    -Title $title `
    -AccountPassword $password `
    -Enabled $true `
    -ChangePasswordAtLogon $true

#  Copy Group Memberships:
Get-ADuser -identity $Copy -properties memberof |
    select-object memberof -expandproperty memberof |
        Add-AdGroupMember -Members $Username
