<#
Creates a new user, copying everything from another user
#>


#User you want to copy everything from
$Copy = Read-host "Enter username to copy from: "
#First name of the new suer
$FirstName  = Read-host "Enter the New users First Name: "
#Last name of the new user
$Lastname   = Read-host "Enter the New users Last Name: "
#The username the will use to login with
$UserName   = Read-host "Enter the New users logon Name: "
#New suers Password
$Password = Read-Host "Enter users password: " -AsSecureString
#This will be used to create the Display name and Name attributes
$FullName = $FirstName + " " + $Lastname



#Pulling all the Properties from the account we are coying
$User = Get-ADUser -Identity $Copy -Properties *
#Setting up a varibale for the Department attribute
$Department = $User.Department
#Setting up a varibale for the Company attribute
$Company = $User.Company
#Setting up a varibale for the Description attribute
$Description = $User.Description
#Setting up a varibale for the Manager attribute
$Manager = $User.Manager
#Setting up a varibale for the Office attribute
$Office = $User.Office
#Copying the Logon Script
$ScriptPath = $User.ScriptPath
#Copying the Title
$Title = $User.Title
#Get the users OU
$Path = $User.distinguishedName.Split(',',2)[1]


#Using everything we have setup to create the new user, update test.local to domain or use Powershell to grab the Domain
New-ADUser -Name $Fullname -DisplayName $FullName -GivenName $FirstName -Surname $LastName -SamAccountName $UserName -UserPrincipalName ($username + '@' + "test.local") -Path $Path -Department $Department -Company $Company -Description $Description -Manager $Manager -Office $Office -ScriptPath $ScriptPath -Title $Title -AccountPassword $Password -Enabled $true -ChangePasswordAtLogon $true

#Copying Gropu memberships from the existing user to our new user
Get-ADuser -identity $Copy -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $Username
