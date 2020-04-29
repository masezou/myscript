#Declare variables
$ipaddress = "192.168.11.10" 
$ipprefix = "24" 
$ipgw = "192.168.11.1" 
$ipdns = "192.168.11.1"
$ipdns2 = "192.168.10.1" 
$ipif = (Get-NetAdapter).ifIndex 


#Set static IP address
New-NetIPAddress -IPAddress $ipaddress -PrefixLength $ipprefix -InterfaceIndex $ipif -DefaultGateway $ipgw 
# Set the DNS servers
Set-DnsClientServerAddress -InterfaceIndex $ipif -ServerAddresses ($ipdns, $ipdns2)
