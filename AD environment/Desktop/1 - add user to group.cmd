rem Adding user to local administrators

setlocal
pushd "%~dp0"
set /p NETBIOSDOMAIN="NETBIOSドメインを入力してください>>>"

net localgroup Administrators %NETBIOSDOMAIN%\user1 /add
net localgroup Administrators %NETBIOSDOMAIN%\user2 /add
net localgroup Administrators %NETBIOSDOMAIN%\user3 /add

popd