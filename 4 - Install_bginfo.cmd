rem install BGinfo Script

setlocal
pushd "%~dp0"

rem BGINFO
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /V "BGinfo" /t REG_SZ /F /D "C:\MyScript\BGinfo\bginfolaunch.cmd"

popd
