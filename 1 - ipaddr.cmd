rem Set IP Address
rem modify 1-ipaddr.ps1

setlocal
pushd "%~dp0"

powershell -NoProfile -ExecutionPolicy Unrestricted .\1-ipaddr.ps1
popd