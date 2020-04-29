rem Back to "Private network"

setlocal
pushd "%~dp0"

Powershell Get-NetConnectionProfile
Powershell "Get-NetConnectionProfile | where Name -eq "ネットワーク" | Set-NetConnectionProfile -NetworkCategory Private"
Powershell Get-NetConnectionProfile

popd
