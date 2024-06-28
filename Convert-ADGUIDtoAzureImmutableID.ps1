# Function to convert objectGUID (Active Directory unique identifier) to ImmutableID (Azure AD unique identifier).
function Convert-ObjectGUIDToImmutableID {
    # Function Parameters:
    param (
        [Parameter(Mandatory = $true)]  # Make the ObjectGUID parameter mandatory
        [string]$ObjectGUID             # Accepts the ObjectGUID as a string
    )

    # Conversion Logic:
    # 1. Create a new GUID object from the provided ObjectGUID string.
    # 2. Convert the GUID object to a byte array.
    # 3. Base64-encode the byte array to get the ImmutableID.
    $ImmutableID = [Convert]::ToBase64String([guid]::New($ObjectGUID).ToByteArray()) 
    return $ImmutableID
}

# Initialize an empty array to store converted user data.
$NewUsers = @()

# Get all Active Directory users along with their properties (including ObjectGUID).
# NOTE: Be cautious with -Filter * in large environments, as it retrieves ALL users.
$Users = Get-ADUser -Filter * -Properties * 

# Iterate over each user object.
foreach ($User in $Users) {
    # Create a custom object for each user with specific attributes.
    $NewUser = [PSCustomObject]@{
        DisplayName    = $User.DisplayName     # Display name of the user
        SamAccountName = $User.SamAccountName  # User's login name
        EmailAddress   = $User.EmailAddress    # Primary email address
        ObjectGUID     = $User.ObjectGUID      # Original ObjectGUID
        ImmutableID    = Convert-ObjectGUIDToImmutableID -ObjectGUID $User.ObjectGUID # Converted ImmutableID
    }

    # Add the new user object to the array.
    $NewUsers += $NewUser
}

# Export the array of user objects with ImmutableIDs to a CSV file.
$NewUsers | Export-Csv -Path "C:\Temp\UsersImmutableID.csv" -NoTypeInformation
