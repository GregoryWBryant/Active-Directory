<#
Creates a list with all AD account that have Password set to never expire
Pipes list out to a text file on the users desktop
#>


#Gets the path to current users desktop folder
$DesktopPath = [Environment]::GetFolderPath("Desktop")

#Gets a list of users with their password set to never expire.
$Users = Get-AdUser -Filter * -Properties * | Where-Object {$_.PasswordNeverExpires -eq $true -and $_.Enabled -eq $true} | Select -ExpandProperty Name

#Outputs users to text file
$Users | Out-File ($DesktopPath + "\PasswordneverExpires.txt")
