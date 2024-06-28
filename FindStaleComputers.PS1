<#
Finds Computers that have not talked to AD in 120 days.
After 90 days, AD updates the computer's shared password, and it loses trust.
#>

# Sets the number of days of inactivity to consider (120 days in this example).
# Computers that haven't logged on in this timeframe will be targeted.
$DaysInactive = 120

# Calculates a date that is $DaysInactive days in the past from the current date.
$time = (Get-Date).AddDays(-($DaysInactive))

# Queries Active Directory for computer objects matching specific criteria:
#   - LastLogonDate less than the calculated time (meaning inactive for at least $DaysInactive days)
#   - Enabled status is true (meaning the computer account is active)
#   - DistinguishedName does not contain "Disabled" (to avoid matching disabled OU names)
# -Properties * ensures all properties are returned for further filtering/processing
$Computers = Get-ADComputer -Filter {LastLogonDate -lt $time -and Enabled -eq $true} -Properties * | 
             Where-Object {$_.DistinguishedName -notlike "*Disabled*"} |
             Select -ExpandProperty Name  # Extracts only the computer name

# Output the resulting list of inactive computer names.
$Computers
