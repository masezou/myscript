rem Domain join via command line

setlocal
pushd "%~dp0"

set JOINUSER="administrator"
set JOINUSERPW="Password00!"
rem set DOMAINNAME=ent1.cloudshift.corp
set /p DOMAINNAME="FQDNドメインを入力してください>>>"

wmic ComputerSystem WHERE "name='%computername%'" CALL JoinDomainOrWorkgroup Name="%DOMAINNAME%" Username=%JOINUSER% Password=%JOINUSERPW% FJoinOptions=3

shutdown /r /t 0

popd