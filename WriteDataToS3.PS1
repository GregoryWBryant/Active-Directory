<#
Pulls AD information and uploads to an S3 Bucket.
Requires Amazon's AWS Tools for PowerShell installed.
#>

# Set up variables for CSV and S3 configuration
$CSVPath    = "Path to CSV"     # Replace with the actual path where you want to save the CSV file
$FileName   = "name of the CSV"  # Replace with the desired filename (e.g., "ADUsers.csv")
$Endpoint   = "S3 URL"          # Replace with your S3 endpoint URL (e.g., "https://s3.us-west-2.amazonaws.com")
$BucketName = "Name of S3 bucket" # Replace with your S3 bucket name
$AccessKey  = ""                 # Your AWS Access Key ID
$SecretKey  = ""                 # Your AWS Secret Access Key

# Import the AWS PowerShell module to work with S3
Import-Module AWSPowerShell

# Get information about all AD users and export it to a CSV file
Get-AdUser -Filter * -Properties * |
    Select-Object DisplayName, DistinguishedName, SamAccountName, EmailAddress, Enabled, Created, 
                  @{Name="LastLogon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('yyyy-MM-dd_hh:mm:ss')}}, 
                  badPwdCount, PasswordLastSet, 
                  @{Name="MemberOf"; Expression={[string]$_.memberof}} | 
    Export-Csv $CSVPath -NoTypeInformation

# Upload the CSV file to your S3 bucket
Write-S3Object -BucketName $BucketName -File $CSVPath -Key $FileName -EndpointUrl $Endpoint -AccessKey $AccessKey -SecretKey $SecretKey

# Remove the local CSV file after it's been uploaded to S3
Remove-Item $CSVPath -Force
