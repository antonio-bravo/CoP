@echo off
setlocal enabledelayedexpansion

@REM REM --- NEW: Loading variables from the .env file ---
@REM if exist .env (
@REM     for /f "usebackq delims=" %%x in (".env") do (
@REM         set "%%x"
@REM     )
@REM ) else (
@REM     echo ERROR: File '.env' not found.
@REM     exit /b 1
@REM )

REM Define the variable for the configuration file
set CONFIG_FILE=flyway.conf

REM Display the contents of the configuration file
type "%CONFIG_FILE%" 2>nul
if errorlevel 1 (
    echo ERROR: Configuration file '%CONFIG_FILE%' not found.
    exit /b 1
)


REM Double carriage return
echo.
echo.

REM Show pending migrations with checksum and filepath
echo ========================================
echo PENDING MIGRATIONS TO BE APPLIED:
echo ========================================

flyway info -outOfOrder=true -configFiles="./%CONFIG_FILE%" | findstr "Pending"

REM Double carriage return
echo.
echo.

REM Ask the user if they are sure to continue
set /p confirmation=Are you sure you want to proceed with the migration? (Y=yes or N=no*): 

REM Convert the answer to uppercase for easier comparison
set confirmation=%confirmation:~0,1%

if /i "%confirmation%"=="Y" goto RUN_MIGRATIONS
goto ABORT

:RUN_MIGRATIONS
echo.
echo Executing Flyway migration(s)...
flyway -configFiles="./%CONFIG_FILE%" migrate -outOfOrder=true
goto END

:ABORT
echo Migration aborted.

:END
endlocal
