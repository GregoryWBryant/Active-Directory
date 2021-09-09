<#
Checks if the Guest user account in AD is enabled and disable it if it is.
This account is disabled by default
#>

$Guest = Get-Aduser -Identity Guest
If ($Guest.Enabled -eq "True") {

    Set-Aduser -Identity Guest -Enabled $False

}
