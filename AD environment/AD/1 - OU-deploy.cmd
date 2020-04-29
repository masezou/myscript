rem create user/object

setlocal
pushd "%~dp0"

rem Usage:  this_command "baseDN"
rem example: this_comannd "DC=ent1,DC=cloudshift,DC=corp"

rem Building OU
dsadd ou "OU=Tanium,%~1"
dsadd ou "OU=EnduserDesktops,%~1"
dsadd ou "OU=EnduserUsers,%~1"

rem Creating service user and admin
dsadd user "cn=taniumsvc,OU=Tanium,%~1" -samid taniumsvc -upn taniumsvc@%USERDNSDOMAIN% -fn %USERDOMAIN% -ln taniumsvc -display "taniumsvc" -pwdneverexpires yes -pwd Tanium123!
dsadd user "cn=taniumadmin,OU=Tanium,%~1" -samid taniumadmin -upn taniumadmin@%USERDNSDOMAIN% -fn %USERDOMAIN% -ln taniumadmin -display "taniumadmin" -pwdneverexpires yes -pwd Tanium123!

rem Creating enduser
dsadd user "cn=user1,OU=EnduserUsers,%~1" -samid user1 -upn user1@%USERDNSDOMAIN% -fn %USERDOMAIN% -ln user1 -display "user1" -pwdneverexpires yes -pwd Tanium123!
dsadd user "cn=user2,OU=EnduserUsers,%~1" -samid user2 -upn user2@%USERDNSDOMAIN% -fn %USERDOMAIN% -ln user2 -display "user2" -pwdneverexpires yes -pwd Tanium123!
dsadd user "cn=user3,OU=EnduserUsers,%~1" -samid user3 -upn user3@%USERDNSDOMAIN% -fn %USERDOMAIN% -ln user3 -display "user3" -pwdneverexpires yes -pwd Tanium123!

popd
