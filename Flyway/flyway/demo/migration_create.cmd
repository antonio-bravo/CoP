@echo off
setlocal enabledelayedexpansion

:: Get DateTime in  UTC
for /f "tokens=2 delims==" %%A in ('wmic path win32_utctime get Year /format:list') do set YYYY=%%A
for /f "tokens=2 delims==" %%A in ('wmic path win32_utctime get Month /format:list') do set MM=%%A
for /f "tokens=2 delims==" %%A in ('wmic path win32_utctime get Day /format:list') do set DD=%%A
for /f "tokens=2 delims==" %%A in ('wmic path win32_utctime get Hour /format:list') do set HH=%%A
for /f "tokens=2 delims==" %%A in ('wmic path win32_utctime get Minute /format:list') do set MI=%%A
for /f "tokens=2 delims==" %%A in ('wmic path win32_utctime get Second /format:list') do set SS=%%A

:: Add 100 and get the last two digits
set /a MM=100+MM
set /a DD=100+DD
set /a HH=100+HH
set /a MI=100+MI
set /a SS=100+SS

:: Get only the last two digits
set MM=!MM:~-2!
set DD=!DD:~-2!
set HH=!HH:~-2!
set MI=!MI:~-2!
set SS=!SS:~-2!

:: echo Year !YYYY!
:: echo month !MM!
:: echo day !DD! 
:: echo hour !HH!
:: echo minute !MI!
:: echo second !SS!

::echo %YYYY%-%MM%-%DD% %HH%:%MI%:%SS% UTC

:: Ask for migration name
set /p migration_name=Enter the name of the migration (without spaces): 

:: Validate that the name does not have spaces
echo %migration_name% | findstr " " >nul
if %errorlevel% equ 0 (
    echo The migration name cannot contain spaces.
    exit /b 1
)

:: Create subfolders if they do not exist
if not exist "migrations" mkdir migrations
if not exist "migrations-undo" mkdir migrations-undo

:: Format the file name
set timestamp=%YYYY%%MM%%DD%.%HH%%MI%%SS%
set filename=V%timestamp%__%migration_name%
set migrations-undo=U%timestamp%__%migration_name%

:: Create the files
echo. > "migrations\\%filename%.sql"
echo. > "migrations-undo\\%migrations-undo%.sql"

echo Files created:
echo migrations\\%filename%.sql
echo migrations-undo\\%migrations-undo%.sql


endlocal
