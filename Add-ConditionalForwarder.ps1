# Define a list of DNS servers that you want to add as Condtional forwaders to other DNS servers. 
# Replace this list with your actual DNS servers
$MasterServers = @("127.0.0.1", "127.0.0.2") 

# Specify the domain for which you want to manage DNS settings
$Domain = "contoso.com" 

# Retrieve all DNS servers (Name Servers) that are responsible for the specified domain. These are the servers that will have conditional forwarders added to them.
$DNSServers = Get-DnsServerResourceRecord -ZoneName $Domain -RRType "NS" -Node 

# Process each DNS server individually
foreach ($DNSServer in $DNSServers) {

    # Print out the name of the DNS server currently being processed for logging and troubleshooting purposes
    $DNSServer.RecordData.NameServer 

    # Check if the DNS server should be excluded from having the conditional forwarder added
    if ($DNSServer.RecordData.NameServer -like "*don't modify*" -or $DNSServer.RecordData.NameServer -like "*don't modify*") {
        # If the DNS server's name matches the exclusion pattern, output a message indicating that the conditional forwarder won't be added to this server
        Write-Host ("Not adding Forwarded to server: " + $DNSServer.RecordData.NameServer)
    } else {
        # Add a conditional forwarder to the DNS server for the specified zone (in this case, "file.core.windows.net").  
        # This means that any DNS queries for that zone will be forwarded to the specified MasterServers ($MasterServers in this script).
        Add-DnsServerConditionalForwarderZone -ComputerName $DNSServer.RecordData.NameServer -Name "file.core.windows.net" -MasterServers $MasterServers -PassThru 
    }
}
