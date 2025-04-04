@echo off
title Windows Cache Cleaner - Advanced Version
mode con: cols=60 lines=25
color 0A

:: Permission check
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo [Error] Please run this script as Administrator!
    pause
    exit /b
)

echo ===============================
echo      Windows Cache Cleaner
echo ===============================
echo.

:: Progress bar function
:progress
setlocal EnableDelayedExpansion
set "BAR="
set /A "progress=%1 / 2"
for /L %%A in (1,1,!progress!) do set "BAR=!BAR!#"
set /A "spaces=50 - progress"
for /L %%B in (1,1,!spaces!) do set "BAR=!BAR!."
<nul set /p =Progress: [!BAR!] %1%% 
echo(
timeout /t 1 >nul
endlocal
goto :eof

:: Record disk space before cleaning
for /f "tokens=3" %%a in ('fsutil volume diskfree %SystemDrive%') do set freespace_before=%%a

:: Start cleaning
echo [Step 1] Detecting system...
call :progress 5

echo [Step 2] Cleaning system Temp folder...
del /f /s /q %SystemRoot%\Temp\*.* >nul 2>&1
rd /s /q %SystemRoot%\Temp >nul 2>&1
md %SystemRoot%\Temp
call :progress 15

echo [Step 3] Cleaning user Temp folder...
del /f /s /q "%userprofile%\Local Settings\Temp\*.*" >nul 2>&1
rd /s /q "%userprofile%\Local Settings\Temp" >nul 2>&1
md "%userprofile%\Local Settings\Temp"
call :progress 25

echo [Step 4] Cleaning Prefetch folder...
del /f /s /q %SystemRoot%\Prefetch\*.* >nul 2>&1
call :progress 35

echo [Step 5] Cleaning Recycle Bin...
rd /s /q %SystemDrive%\$Recycle.Bin >nul 2>&1
call :progress 45

echo [Step 6] Deep system junk file cleanup...
del /f /s /q %systemdrive%\*.tmp >nul 2>&1
del /f /s /q %systemdrive%\*._mp >nul 2>&1
del /f /s /q %systemdrive%\*.log >nul 2>&1
del /f /s /q %systemdrive%\*.gid >nul 2>&1
del /f /s /q %systemdrive%\*.chk >nul 2>&1
del /f /s /q %systemdrive%\*.old >nul 2>&1
call :progress 55

echo [Step 7] Cleaning personal junk files...
del /f /q %userprofile%\cookies\*.* >nul 2>&1
del /f /q %userprofile%\recent\*.* >nul 2>&1
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*" >nul 2>&1
del /f /s /q "%userprofile%\recent\*.*" >nul 2>&1
call :progress 65

echo [Step 8] Cleaning system backup and shortcuts...
del /f /s /q %windir%\*.bak >nul 2>&1
DEL /S /F /Q "%AllUsersProfile%\Start Menu\Programs\Windows Messenger.lnk" >nul 2>&1
call :progress 75

echo [Step 9] Cleaning extra folders...
rd /s /q "%systemdrive%\Program Files\Temp" >nul 2>&1
md "%systemdrive%\Program Files\Temp"
rd /s /q "%systemdrive%\d" >nul 2>&1
call :progress 85

echo [Step 10] Deleting ASP.NET user account if exists...
net user aspnet /delete >nul 2>&1
call :progress 90

echo [Step 11] Running Disk Cleanup (cleanmgr)...
cleanmgr /sagerun:99
call :progress 100

:: Record disk space after cleaning
for /f "tokens=3" %%a in ('fsutil volume diskfree %SystemDrive%') do set freespace_after=%%a
set /a saved_space=(%freespace_after%-%freespace_before%)/1024/1024

echo.
echo ===============================
echo        Cleaning Completed!
echo    Freed Space: %saved_space% MB
echo ===============================
timeout /t 3 >nul
exit
