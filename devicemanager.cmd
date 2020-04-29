rem Showing hidden device in device manager

setlocal
pushd "%~dp0"

set DEVMGR_SHOW_NONPRESENT_DEVICES=1 && start devmgmt.msc