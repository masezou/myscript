rem Startup BGinfo Script

setlocal
pushd "%~dp0"

if "%PROCESSOR_ARCHITECTURE%" EQU "x86" (
C:\MyScript\BGinfo\bginfo64.exe C:\MyScript\BGinfo\OSconfig.bgi /silent /accepteula /timer:0
)
if "%PROCESSOR_ARCHITECTURE%" NEQ "x86" (
C:\MyScript\BGinfo\bginfo.exe C:\MyScript\BGinfo\OSconfig.bgi /silent /accepteula /timer:0
)