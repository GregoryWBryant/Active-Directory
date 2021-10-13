<#
Finds Computers that have not talked to AD in 120 days
After 90 days AD will upate the Computers Shared password and it will lose trust
#>

#Sets time for inactivity
$DaysInactive = 120

#Gets date minus the days set above
$time = (Get-Date).Adddays(-($DaysInactive))
  
#Gets a list of computers with a lastlogon older than dates set and is not disabled
$Computers = Get-ADComputer -Filter {lastLogon -lt $time -and enabled -eq $true}  -Properties * | Where-Object{$_.DistinguishedName -notlike "*Disabled*"} |Select -ExpandProperty Name

$Computers
