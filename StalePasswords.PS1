<#
Used for finding Users with passwords over 120 days old
Good to run before chaning Password age policies as these users would instantly have to reset password
Better to give a warning to as many users as possible :)
#>


$MaxAge = 120

$Users = Get-AdUser -Filter * -Properties * | Where-Object { 
     $_.PasswordLastSet -lt [DateTime]::Now.Subtract([TimeSpan]::FromDays($MaxAge)) -and
     $_.Enabled -eq $true -and $_.PasswordExpired -eq $false
} | Select -ExpandProperty Name


$Users
