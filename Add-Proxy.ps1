<#
CSV should inclue email,and aliases
Aliases can be left blank and if more than one aliases in included it should be seperated by commas.


#>

$Users = Import-Csv -Path "CSV Location"

foreach ($User in $Users) {

    $SamAccount = ($User.Email -split "@")[0].Trim()
    $ProxyAddress = ("SMTP:" + $User.Email)
    if ($User.Aliases -ne "") {
        $ProxyAddress = ($ProxyAddress + "," + $User.Aliases)
        Set-ADUser -Identity $SamAccount -add @{‘proxyAddresses’=$ProxyAddress -split ","}
    }else {
        Set-ADUser -Identity -add @{‘proxyAddresses’=$ProxyAddress
            }
      }
}

# Import user data from a CSV file. The CSV should have columns for at least:
#   - Email (required for SamAccountName and proxyAddresses)
#   - Aliases (optional, additional email addresses for the user)
$Users = Import-Csv -Path "CSV Location"  # Replace with the actual path

foreach ($User in $Users) {
    # --- Extract and Clean User Data ---

    # Create the SamAccountName (login name) from the part of the email before the "@" symbol.
    # Trim removes leading/trailing spaces.
    $SamAccountName = ($User.Email -split "@")[0].Trim()

    # Create the primary proxyAddresses entry.
    $ProxyAddress = "SMTP:" + $User.Email

    # --- Set Proxy Addresses in Active Directory ---

    # Check if the user has aliases (additional email addresses) in the CSV.
    if ($User.Aliases -ne "") {
        # If so, combine all proxy addresses (primary + aliases) into a comma-separated string.
        $ProxyAddress = $ProxyAddress + "," + $User.Aliases  # Alternatively, use -join ','

        # Update the user's proxyAddresses attribute in Active Directory.
        Set-ADUser -Identity $SamAccountName -Add @{proxyAddresses = $ProxyAddress -split ","} 
    } else {
        # If no aliases, simply set the primary proxy address.
        Set-ADUser -Identity $SamAccountName -Add @{proxyAddresses = $ProxyAddress} 
    }
}
