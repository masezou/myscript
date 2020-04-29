rem Initial Script

setlocal
pushd "%~dp0"

SET NTPSERVERHOST=jp.pool.ntp.org
SET PASSWORDSTRINGS=Password00!

rem When you create Windows 10 box, you should disconnect ether connection until executing this script.... 

if not exist %SystemRoot%\System32\systeminfo.exe goto warn
for /F "tokens=2 delims=," %%a in ('%SystemRoot%\System32\systeminfo.exe /FO CSV /NH') do set osvers=%%~a
echo %osvers%|find "Windows 10">nul
if %errorlevel% equ 0 goto win10
goto NOAP
:win10
Schtasks.exe /change /disable /tn "\Microsoft\Windows\AppxDeploymentClient\Pre-staged app cleanup"
reg ADD HKLM\Software\Policies\Microsoft\Windows\CloudContent /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f
reg ADD HKLM\Software\Policies\Microsoft\WindowsStore  /v AutoDownload /t REG_DWORD /d 2 /f
reg ADD HKLM\Software\Policies\Microsoft\WindowsStore  /v DisableOSUpgrade /t REG_DWORD /d 1 /f
gpupdate /force
echo you can connect network.
goto :NOAP
:NOAP
echo It is not Windows 10


rem Disable Windows Update (Suppress showing auto update with full screen.) 
rem    Default: reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f


rem Setting Power "High Performance"
rem    Default: powercfg -S 381b4222-f694-41f0-9685-ff5bb260df2e
powercfg -S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c


rem  Setting timeout 0 in AC (for avoid lock screen)
powercfg -CHANGE /monitor-timeout-ac 0
powercfg -CHANGE /disk-timeout-ac 0
powercfg -CHANGE /standby-timeout-ac 0
powercfg -CHANGE /hibernate-timeout-ac 0


rem Enable RDP
rem    Default: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d "0" /f

rem Open RDP firewall rule
rem    Default: netsh advfirewall firewall set rule group="リモート デスクトップ" new enable=no
netsh advfirewall firewall set rule group="リモート デスクトップ" new enable=yes


rem Disable changing password at client side (Avoid to fail to domain join over 30 day in some situation)
rem    Default:  reg add HKLM\SYSTEM\CurrentControlSet\services\Netlogon\Parameters /v DisablePasswordChange /t REG_DWORD /d 0 /f
reg add HKLM\SYSTEM\CurrentControlSet\services\Netlogon\Parameters /v DisablePasswordChange /t REG_DWORD /d 1 /f

rem Enable local Administrator user with PASSWORDSTRINGS for domain join (Especially for client OS)
net user administrator /active:yes
net user administrator %PASSWORDSTRINGS%

rem Extend local password policy (It is for 2012R2 and before)
net accounts /maxpwage:unlimited

rem Disable CTRL-ALT-DELETE when you logon (Easy to login)
rem    Default: reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableCAD"
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableCAD" /t REG_DWORD /d "1" /f

gpupdate /force

rem Disable IE SEC (For Internet access with Internet Explorer)
rem    Default: reg add "HKLM\Software\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" /v IsInstalled /t REG_DWORD /d 1 /f
rem             reg add "HKLM\Software\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" /v IsInstalled /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" /v IsInstalled /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" /v IsInstalled /t REG_DWORD /d 0 /f


rem NTP (Windows timesync is not accurate)
rem    Default: reg add "HKLM\SYSTEM\CurrentControlSet\Service\W32Time\TimeProviders\NtpClient /v SpecialPollInterval /t REG_DWORD /d 1024 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient" /v "SpecialPollInterval" /t REG_DWORD /d "900" /f

rem    Default: w32tm /config "/manualpeerlist:time.windows.com,0x8"
w32tm /config /update /manualpeerlist:%NTPSERVERHOST% /syncfromflags:manual /localclockdispersion:0 /reliable:YES /largephaseoffset:5000
net stop w32time && net start w32time
w32tm /resync /rediscover
w32tm /query /configuration
w32tm /query /status


rem Specify Organization and Username in Control Panel (Just Infomation!) 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "RegisteredOrganization" /t REG_SZ /d 組織名 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "RegisteredOwner" /t REG_SZ /d ユーザ名 /f

rem Show WSUS Server
rem reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v WUServer

rem Set Private network
Powershell Get-NetConnectionProfile
Powershell "Get-NetConnectionProfile | where Name -eq "ネットワーク" | Set-NetConnectionProfile -NetworkCategory Private"
Powershell Get-NetConnectionProfile

rem Set Computername as this cmd filename. (Special tips!)
set selfname=%~n0
wmic computersystem where name="%computername%" call rename name="%selfname%"
shutdown /r /t 0
popd