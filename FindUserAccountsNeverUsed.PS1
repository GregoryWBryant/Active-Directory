<#
Used to find accounts that have never logged in
#>


$UsersNeverLoggedIn = Get-ADUser -Filter {enabled -eq $true -and lastLogon -eq "0"} -Properties * | Select -ExpandProperty Name

$UsersNeverLoggedIn
