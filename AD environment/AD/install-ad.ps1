#Declare variables
$ipaddress = "192.168.11.2" 
$ipprefix = "24" 
$ipgw = "192.168.11.1" 
$ipdns = "192.168.11.1"
$ipdns2 = "8.8.8.8" 

$DomainName = "ent1.cloudshift.corp"
$DomaninNetBIOSName = "ent1"
$DomainMode = "Win2012"
$ForestMode = "Win2012"
#$DomainMode = "WinThreshold"
#$ForestMode = "WinThreshold"

$Password = "Password00!"

$ipif = (Get-NetAdapter).ifIndex 
$addsTools = "RSAT-AD-Tools" 
$DatabasePath = "c:\windows\NTDS"
$LogPath = "c:\windows\NTDS"
$SysVolPath = "c:\windows\SYSVOL"
$SecureString = ConvertTo-SecureString $Password -AsPlainText -Force

#Set static IP address
New-NetIPAddress -IPAddress $ipaddress -PrefixLength $ipprefix -InterfaceIndex $ipif -DefaultGateway $ipgw 
# Set the DNS servers
Set-DnsClientServerAddress -InterfaceIndex $ipif -ServerAddresses ($ipdns, $ipdns2)

#Install features 
Add-WindowsFeature $addsTools 

#Install AD DS, DNS and GPMC 
start-job -Name addFeature -ScriptBlock { 
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools } 
Wait-Job -Name addFeature 

#Create New AD Forest
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath $DatabasePath -DomainMode $DomainMode -DomainName $DomainName -SafeModeAdministratorPassword $SecureString -DomainNetbiosName $DomainNetBIOSName -ForestMode $ForestMode -InstallDns:$true -LogPath $LogPath -NoRebootOnCompletion:$false -SysvolPath $SysVolPath -Force:$true

#Modify DNS forwarder (Option)
#Remove-DnsServerForwarder -IPAddress 168.63.129.16 -PassThru
#Add-DnsServerForwarder -IPAddress 192.168.11.1 -PassThru
