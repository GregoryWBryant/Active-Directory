<#
Used for finding Users who have not logged in, in over 90 days
#>

#Sets inactivity time
$DaysInactive = 90
$time = (Get-Date).Adddays(-($DaysInactive))
  
#Gets stale users
$StaleUsers = Get-ADUser -Filter {lastLogon -lt $time -and enabled -eq $true -and lastLogon -ne "0"} -Properties * | Select -ExpandProperty Name

$StaleUsers
