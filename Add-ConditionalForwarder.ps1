$MasterServers = @("127.0.0.1","127.0.0.2")
$Domain = "contoso.com"


$DNSServers = Get-DnsServerResourceRecord -ZoneName $Domain -RRType "NS" -Node


foreach($DNSServer in $DNSServers) {
    
    $DNSServer.RecordData.NameServer
    if($DNSServer.RecordData.NameServer -like "*don't modify*" -or $DNSServer.RecordData.NameServer -like "*don't modify*") {
        Write-Host ("Not adding Forwadred to Azure server: " + $DNSServer.RecordData.NameServer)
    } else { 
        Add-DnsServerConditionalForwarderZone -ComputerName $DNSServer.RecordData.NameServer -Name "file.core.winodws.net" -MasterServers $MasterServers -PassThru
        }

}