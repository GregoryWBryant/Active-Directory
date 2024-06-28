<#
    Script is to be used after demoting a Domain Controller
    Requries DHCP Role still be installed
    Used for removing old Domain Controller from NS list of all DNS Zones.
#>

# Get the fully qualified domain name (FQDN) of the current Server.
$DnsName = ([System.Net.Dns]::GetHostByName($env:computerName)).HostName

# Find and retrieve information about the Primary Domain Controller (PDC) in the domain.
$PDC = Get-ADDomainController -Discover -Service PrimaryDC

# Get a list of all DNS zones that are hosted on the PDC.
$DNSZones = Get-DnsServerZone -ComputerName $PDC

# Remove this Domain Controller as a DHCP server in Active Directory.
Remove-DhcpServerInDC -DnsName $DnsName

# Iterate through each DNS zone found on the PDC.
foreach ($DnsZone in $DNSZones) {
    # Remove any DNS records (specifically, NS records) that point to the current computer (its FQDN) from each of the DNS zones.
    # This ensures the DC is no longer listed as an authoritative name server for these zones.
    # The -Force flag is used to suppress confirmation prompts, assuming you want to run this automatically.
    Remove-DNSServerResourceRecord -Name $DnsZone.ZoneName -ZoneName $DnsZone.ZoneName -RRType NS -RecordData $DnsName -ComputerName $PDC -Force
}
