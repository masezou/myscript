rem Clean up script

setlocal
pushd "%~dp0"

rem Delete Windows event logs
wevtutil cl Application
wevtutil cl Security
wevtutil cl Setup
wevtutil cl System
wevtutil cl "ThinPrint Diagnostics"
wevtutil cl "Windows Powershell"

rem *** Delete shadows and Disable the Volume Shadow Copy Service and the Shadow Copy Protection Service if not using Persona Mgmt 
rem (Optimize: Option)
vssadmin delete shadows /All /Quiet

rem Shrink WinSxS
dism /online /Cleanup-Image /StartComponentCleanup /ResetBase
rem Delete Service Pack
dism /online /cleanup-image /spsuperseded


rem For Windows Server 2008
FOR /F "tokens=*" %%A IN ('WMIC OS Get ServicePackMajorVersion^,BuildNumber^,Caption /Value ^| find "="') DO (SET OS.%%A)
FOR /F "tokens=*" %%A IN ('WMIC CPU Get AddressWidth /Value ^| find "="') DO (SET CPU.%%A)
echo %OS.Caption%|find "Windows Server 2008">NUL
if %ERRORLEVEL% equ 0 (
	if %CPU.AddressWidth% equ 64 (
		goto win2008x64
	) else (
		goto win2008x86
	)
)
echo %OS.Caption%|find "Windows Server 2012">NUL
if %ERRORLEVEL% equ 0 (
	goto win2012x64
)
echo %OS.Caption%|find "Windows Server 2016">NUL
if %ERRORLEVEL% equ 0 (
	goto win2016x64
)
:win2008x64
rem Delete Service Pack
compcln /quiet
Net Stop WUAUSERV
del %windir%\softwaredistribution\downloads\*
Net Start WUAUSERV

copy C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.0.6001.18000_none_c962d1e515e94269\cleanmgr.exe C:\Windows\System32\
copy C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.0.6001.18000_ja-jp_e8c553a80e4a3652\cleanmgr.exe.mui C:\Windows\System32\ja-JP\
copy C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.1.7600.16385_none_c9392808773cd7da\cleanmgr.exe C:\Windows\System32\
copy C:\Windows\winsxs\x86_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.1.7600.16385_ja-jp_8c7d0e47b7405a8d\cleanmgr.exe.mui C:\Windows\System32\ja-JP\

REM Run cleanup
IF EXIST %SystemRoot%\SYSTEM32\cleanmgr.exe START /WAIT cleanmgr /sagerun:100

del C:\Windows\System32\cleanmgr.exe
del C:\Windows\System32\ja-JP\cleanmgr.exe.mui
goto :eof

:win2008x86
rem Delete Service Pack
compcln /quiet
Net Stop WUAUSERV
del %windir%\softwaredistribution\downloads\*
Net Start WUAUSERV

copy C:\Windows\winsxs\x86_microsoft-windows-cleanmgr_31bf3856ad364e35_6.0.6001.18000_none_6d4436615d8bd133\cleanmgr.exe C:\Windows\System32\
copy C:\Windows\winsxs\x86_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.0.6001.18000_ja-jp_8ca6b82455ecc51c\cleanmgr.exe.mui C:\Windows\System32\ja-JP\
REM Run cleanup
IF EXIST %SystemRoot%\SYSTEM32\cleanmgr.exe START /WAIT cleanmgr /sagerun:100

del C:\Windows\System32\cleanmgr.exe
del C:\Windows\System32\ja-JP\cleanmgr.exe.mui
goto :eof
REM Run cleanup
IF EXIST %SystemRoot%\SYSTEM32\cleanmgr.exe START /WAIT cleanmgr /sagerun:100

Rem defrag
defrag C: /U /V /X /H

rem WinSAT Prepop (Avoid to taking long time in sysprep
WinSAT prepop

rem For ESX
reg add "HKCU\Software\Sysinternals\SDelete" /v EulaAccepted /t REG_DWORD /d 1 /f
if "%PROCESSOR_ARCHITECTURE%" EQU "x86" (
sdelete -z c:
)
if "%PROCESSOR_ARCHITECTURE%" NEQ "x86" (
sdelete64 -z c:
)
reg delete "HKCU\Software\Sysinternals\SDelete" /v EulaAccepted /f

rem For Fusion / Workstation Compress
rem "C:\Program Files\VMware\VMware Tools\VMwareToolboxCmd.exe" disk list
rem "C:\Program Files\VMware\VMware Tools\VMwareToolboxCmd.exe" disk shrink C:\

popd

