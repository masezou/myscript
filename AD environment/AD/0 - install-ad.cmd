rem Install AD/DNS

setlocal
pushd "%~dp0"

powershell -NoProfile -ExecutionPolicy Unrestricted .\install-ad.ps1
popd