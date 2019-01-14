@echo off

set dbUser=root
set dbPassword=<PASSWORD FOR ROOT DB USER>
set backupDir="D:\MySQL_Backup"
set mysqldump="C:\Program Files\MySQL\MySQL Server 5.6\bin\mysqldump.exe"
set mysqlDataDir="C:\ProgramData\MySQL\MySQL Server 5.6\Data"
set zip="C:\Program Files\7-Zip\7z.exe"
set db=jiradb
set host=localhost

:: get date
for /F "tokens=2-4 delims=/ " %%i in ('date /t') do (
	set mm=%%i
	set dd=%%j
	set yy=%%k
)

if %mm%==01 set Month="Jan"
if %mm%==02 set Month="Feb"
if %mm%==03 set Month="Mar"
if %mm%==04 set Month="Apr"
if %mm%==05 set Month="May"
if %mm%==06 set Month="Jun"
if %mm%==07 set Month="Jul"
if %mm%==08 set Month="Aug"
if %mm%==09 set Month="Sep"
if %mm%==10 set Month="Oct"
if %mm%==11 set Month="Nov"
if %mm%==12 set Month="Dec"

set fileSuffix=%dd%-%Month%-%yy%

:: switch to the "data" folder
pushd "%mysqlDataDir%"

if not exist %backupDir%   mkdir %backupDir%

echo on
%mysqldump% --host=%host% --user=%dbUser% --password=%dbPassword% --single-transaction --add-drop-table --databases %db% > %backupDir%\%db%.sql
%zip% a -tgzip %backupDir%\%fileSuffix%_%db%.sql.gz %backupDir%\%db%.sql
del %backupDir%\%db%.sql
