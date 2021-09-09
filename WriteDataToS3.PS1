<#
Pulls AD information and uploads to an S3 Bucket. Requires Amazon's AWS module installed
#>

$CSVPath = "Path to CSV"
$FileName = "name of the CSV"
$Endpoint = "S3 URL"
$BucketName = "Name of S3 bucket"
$AccessKey = ""
$SecretKey = ""

#Import AWS S3 Powershell Module
Import-Module AWSPowerShell

#Gets information about all AD users
Get-AdUser -Filter * -Properties * | Select DisplayName,DistinguishedName,SamAccountName,EmailAddress,Enabled,Created,@{Name="LastLogon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('yyyy-MM-dd_hh:mm:ss')}},badPwdCount,PasswordLastSet,@{Name="MemberOf"; Expression={[string]$_.memberof}} | export-csv $CSVPath -NoTypeInformation


Write-S3Object -BucketName $BucketName -File $CSVPath -Key $FileName -EndpointUrl $Endpoint -AccessKey $AccessKey -SecretKey $SecretKey

Remove-Item $CSVPath -Force
