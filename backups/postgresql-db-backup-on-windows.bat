@echo off
for /f "tokens=1-4 delims=/ " %%i in ("%date%") do (
    set dow=%%i
    set month=%%j
    set day=%%k
    set year=%%l
  )
 
set datestr=%month%_%day%_%year%
set db=confluence
set BACKUP_FILE=%db%_%datestr%.backup
set BACKUP_DIR=E:\PostgersqlBackup
set zip="C:\Program Files\7-Zip\7z.exe"
set host=127.0.0.1
set pg_dump="D:\Program Files\PostgreSQL\9.6\bin\pg_dump.exe"
set PGPASSWORD=<PASSWORD FOR POSTGRES USER>

if not exist %BACKUP_DIR%   mkdir %BACKUP_DIR%

echo on
%pg_dump% -h %host% -p 5432 -U postgres -F c -b -v -f %BACKUP_DIR%\%BACKUP_FILE% %db%
%zip% a -tgzip %BACKUP_DIR%\%BACKUP_FILE%.gz %BACKUP_DIR%\%BACKUP_FILE%
del %BACKUP_DIR%\%BACKUP_FILE%
