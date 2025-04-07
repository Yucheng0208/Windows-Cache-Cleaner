@echo off
title Windows Cache Cleaner - Full Silent Auto Version
mode con: cols=80 lines=30
color 0A

:: Permission Check
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [Error] Please run this script as Administrator!
    pause
    exit /b
)

:: Pre-configure cleanmgr settings silently
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Internet Files" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul 2>&1

cls
echo ===============================
echo      Windows Cache Cleaner
echo ===============================
echo.

:: Record freespace before cleaning
set "freespace_before=0"
for /f "tokens=3" %%a in ('fsutil volume diskfree %SystemDrive% ^| findstr "Available free bytes"') do set freespace_before=%%a
if "%freespace_before%"=="" set "freespace_before=0"

call :progress 5

:: Cleaning commands
del /f /s /q %systemdrive%\*.tmp >nul 2>&1
del /f /s /q %systemdrive%\*.log >nul 2>&1
del /f /s /q %systemdrive%\*.bak >nul 2>&1
if exist %systemdrive%\$Recycle.Bin rd /s /q %systemdrive%\$Recycle.Bin >nul 2>&1
if exist %windir%\Prefetch del /f /s /q %windir%\Prefetch\*.* >nul 2>&1
call :progress 25

if exist "%SystemRoot%\Temp" (
    del /f /s /q "%SystemRoot%\Temp\*.*" >nul 2>&1
    rd /s /q "%SystemRoot%\Temp" >nul 2>&1
    md "%SystemRoot%\Temp" >nul 2>&1
)
if exist "%userprofile%\AppData\Local\Temp" (
    del /f /s /q "%userprofile%\AppData\Local\Temp\*.*" >nul 2>&1
    rd /s /q "%userprofile%\AppData\Local\Temp" >nul 2>&1
    md "%userprofile%\AppData\Local\Temp" >nul 2>&1
)
call :progress 50

if exist "%userprofile%\Cookies" del /f /q "%userprofile%\Cookies\*.*" >nul 2>&1
if exist "%userprofile%\Recent" del /f /q "%userprofile%\Recent\*.*" >nul 2>&1
if exist "%userprofile%\AppData\Local\Microsoft\Windows\INetCache" (
    del /f /s /q "%userprofile%\AppData\Local\Microsoft\Windows\INetCache\*.*" >nul 2>&1
)
call :progress 75

:: Run silent disk cleanup
cleanmgr /sagerun:99 >nul 2>&1

:: Restart explorer
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
call :progress 100

:: Calculate freespace after cleaning
set "freespace_after=0"
for /f "tokens=3" %%a in ('fsutil volume diskfree %SystemDrive% ^| findstr "Available free bytes"') do set freespace_after=%%a
if "%freespace_after%"=="" set "freespace_after=0"

set /a saved_space=0
if not "%freespace_before%"=="0" if not "%freespace_after%"=="0" (
    set /a saved_space=(%freespace_after% - %freespace_before%) / 1024 / 1024
)

echo.
echo ===============================
echo       Cleaning Completed!
if "%saved_space%"=="0" (
    echo   Freed Space: Unknown
) else (
    echo   Freed Space: %saved_space% MB
)
echo ===============================
timeout /t 3 >nul
exit

:progress
setlocal EnableDelayedExpansion
if "%~1"=="" set "input=0" & goto :safe_progress
set /a input=%~1
:safe_progress
set "BAR="
set /A "progress=input / 2"
for /L %%A in (1,1,!progress!) do set "BAR=!BAR!#"
set /A "spaces=50 - progress"
for /L %%B in (1,1,!spaces!) do set "BAR=!BAR!."
<nul set /p =Progress: [!BAR!] %input%%% 
echo(
timeout /t 1 >nul
endlocal
goto :eof
