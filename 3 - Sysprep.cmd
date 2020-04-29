rem Sysprep without rearm count up Script

setlocal
pushd "%~dp0"

echo Reset WSUS config
net stop wuauserv
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate /v SusClientId /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate /v SusClientIdValidation /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate /v AccountDomainSid /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate /v PingID /f
WinSAT prepop

if not exist %SystemRoot%\System32\systeminfo.exe goto warn
for /F "tokens=2 delims=," %%a in ('%SystemRoot%\System32\systeminfo.exe /FO CSV /NH') do set osvers=%%~a
echo %osvers%|find "Windows 10">nul
if %errorlevel% equ 0 goto win10
goto NOAP
:win10
rem reg delete HKLM\Software\Policies\Microsoft\Windows\CloudContent /f
rem reg delete HKLM\Software\Policies\Microsoft\WindowsStore /f

if "%PROCESSOR_ARCHITECTURE%" EQU "x86" (
%systemroot%\system32\sysprep\sysprep.exe  /generalize /oobe /shutdown /unattend:"sysprep-win10-x86.xml"
)
if "%PROCESSOR_ARCHITECTURE%" NEQ "x86" (
%systemroot%\system32\sysprep\sysprep.exe  /generalize /oobe /shutdown /unattend:"sysprep-win10-x64.xml"
)

goto :eof
:NOAP
echo It is not Windows 10


if "%PROCESSOR_ARCHITECTURE%" EQU "x86" (
%systemroot%\system32\sysprep\sysprep.exe  /generalize /oobe /shutdown /unattend:"sysprep-general-x86.xml"
)
if "%PROCESSOR_ARCHITECTURE%" NEQ "x86" (
%systemroot%\system32\sysprep\sysprep.exe  /generalize /oobe /shutdown /unattend:"sysprep-general-x64.xml"
)
