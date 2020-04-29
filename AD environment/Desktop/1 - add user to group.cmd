rem Adding user to local administrators

setlocal
pushd "%~dp0"
set /p NETBIOSDOMAIN="NETBIOSƒhƒƒCƒ“‚ð“ü—Í‚µ‚Ä‚­‚¾‚³‚¢>>>"

net localgroup Administrators %NETBIOSDOMAIN%\user1 /add
net localgroup Administrators %NETBIOSDOMAIN%\user2 /add
net localgroup Administrators %NETBIOSDOMAIN%\user3 /add

popd