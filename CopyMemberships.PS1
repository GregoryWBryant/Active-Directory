<#
Add members of one user to another (i.e., copy group memberships)
#>

# Get the username to copy group memberships from
$copy = Read-Host "Enter username to copy from: "

# Get the username to paste the group memberships to
$paste = Read-Host "Enter username to copy to: "

# Retrieve group memberships of the source user
$groupsToCopy = Get-ADUser -Identity $copy -Properties MemberOf |
    Select-Object -ExpandProperty MemberOf 

# Add the target user to each of the retrieved groups
foreach ($group in $groupsToCopy) {
    try {
        Add-ADGroupMember -Identity $group -Members $paste -ErrorAction Stop
        Write-Verbose "Added '$paste' to group '$group'"
    } catch {
        Write-Warning "Failed to add '$paste' to group '$group': $($_.Exception.Message)"
    }
}
