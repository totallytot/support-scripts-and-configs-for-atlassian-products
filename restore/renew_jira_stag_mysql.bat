@echo off
set mysql="C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe"
set zip="C:\Program Files\7-Zip\7z.exe"
set backupDir=D:\MySQL_Backup
set dbroot=root
set dbrootpass=PASSWORD
set dump=jiradb.sql
set DB=jiradb
set USER=root

net stop "Atlassian JIRA"

if %errorlevel% == 2 (
	echo Access Denied - Could not stop service
	goto :exit
) else if %errorlevel% == 0 ( 
	goto :error0
) else (
	echo no actions were perfomed
	goto :exit
)

:error0
echo Service stopped successfully
echo on
%zip% e %backupDir%\%1%
%mysql% -u %dbroot% -p%dbrootpass% -e "drop database %DB%";
%mysql% -u %dbroot% -p%dbrootpass% -e "CREATE DATABASE %DB% CHARACTER SET utf8 COLLATE utf8_bin";
%mysql% -u %dbroot% -p%dbrootpass% %DB% < %backupDir%\%dump%
%mysql% -u %dbroot% -p%dbrootpass% -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,INDEX ON %DB%.* TO '%USER%'@'localhost'";
%mysql% -u %dbroot% -p%dbrootpass% -e "flush privileges";
%mysql% -u %dbroot% -p%dbrootpass% %DB% -e "truncate table mailserver";
%mysql% -u %dbroot% -p%dbrootpass% %DB% -e "truncate table serviceconfig";
%mysql% -u %dbroot% -p%dbrootpass% %DB% -e "truncate table filtersubscription";
XCOPY "\\VM-AMJIRAPR\Atlassian\Application Data\JIRA\*" "c:\Program Files\Atlassian\Application Data\JIRA\" /s /i /y
net start "Atlassian JIRA"
@echo off
del %backupDir%\%dump%
goto exit

:exit
