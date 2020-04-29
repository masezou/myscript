rem Domain join via command line

setlocal
pushd "%~dp0"

set JOINUSER="administrator"
set JOINUSERPW="Password00!"
set DOMAINNAME=ent1.cloudshift.corp
set ACCOUNTOU=OU=EnduserDesktops; DC=ent1; DC=cloudshift; DC=corp

wmic ComputerSystem WHERE "name='%computername%'" CALL JoinDomainOrWorkgroup Name="%DOMAINNAME%" Username=%JOINUSER% Password=%JOINUSERPW% AccountOU="%ACCOUNTOU%" FJoinOptions=3

shutdown /r /t 0

popd