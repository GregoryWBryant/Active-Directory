<#
Used to disable AD user and On-Prem Exchange account
#>

#Request User name you want to disable and assigns the value to $User
$User = Read-Host "Please enter the Username you wish to Disable: "


#Gets the Full Path of the user you are disabling
$UsertoMove = (Get-ADUser -Identity $User).distinguishedName

#Export Memberships for furutre reference
Get-ADPrincipalGroupMembership $User | Select Name | Export-CSV -NoTypeInformation -path C:\UserExports\$User.csv

#Moves the user using its full path to the new location
Move-ADObject -Identity $UsertoMove -TargetPath "OU=Disabled Users,OU=Users OU,DC=Domain,DC=local"


#Gets all groups the uer is aprat of and passes them to the Remove command
Get-ADuser -identity $User -properties memberof | select-object memberof -expandproperty memberof | Remove-ADGroupMember -Member $User -Confirm:$False


#Disables the users account
Disable-ADAccount -Identity $User


#Enter Exchange Managment Shell
Import-Module 'C:\Program Files\Microsoft\Exchange Server\V14\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto -ClientApplication:ManagementShell


#Disables the Users mailbox
Disable-Mailbox -Identity $User -Confirm:$false
