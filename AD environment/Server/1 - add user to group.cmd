rem Adding user to local administrators

setlocal
pushd "%~dp0"
set /p NETBIOSDOMAIN="NETBIOSドメインを入力してください>>>"
net localgroup Administrators %NETBIOSDOMAIN%\taniumsvc /add

popd