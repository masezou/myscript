rem Stopping Hyper-V Service

setlocal
pushd "%~dp0"

rem (VMB)Hyper-V Data Exchange Service - Provides a mechanism to exchange data between the virtual machine and the operating system rem running on the physical computer.
rem (Optimize: Recommend)
Powershell Set-Service 'vmickvpexchange' -startuptype "disabled"
rem (VMB)Hyper-V Guest Shutdown Service - Provides a mechanism to shut down the operating system of this virtual machine from the rem management interfaces on the physical computer.
rem (Optimize: Recommend)
Powershell Set-Service 'vmicshutdown' -startuptype "disabled"
rem (VMB)Hyper-V Heartbeat Service -  Monitors the state of this virtual machine by reporting a heartbeat at regular intervals.
rem (Optimize: Recommend)
Powershell Set-Service 'vmicheartbeat' -startuptype "disabled"
rem (VMB)Hyper-V Remote Desktop Virtualization Service - Provides a platform for communication between the virtual machine and the rem operating system running on the physical computer.
rem (Optimize: Recommend)
Powershell Set-Service 'vmicrdv' -startuptype "disabled"
rem (VMB)Hyper-V Time Synchronization Service - Synchronizes the system time of this virtual machine with the system time of the rem physical computer.
rem (Optimize: Recommend)
Powershell Set-Service 'vmictimesync' -startuptype "disabled"
rem (VMB)Hyper-V Volume Shadow Copy Requestor - Coordinates the communications that are required to use Volume Shadow Copy Service to rem back up applications and data on this virtual machine from the operating system on the physical computer.
rem (Optimize: Recommend)
Powershell Set-Service 'vmicvss' -startuptype "disabled"
