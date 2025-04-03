@echo off
title Windows Cache Cleaner
mode con: cols=60 lines=20
color 0A

echo ===============================
echo      Windows Cache Cleaner
echo ===============================
echo.

REM 進度條函數
:progress
setlocal EnableDelayedExpansion
set "BAR="
set /A "progress=%1 / 2"
for /L %%A in (1,1,!progress!) do set "BAR=!BAR!#"
set /A "spaces=50 - progress"
for /L %%B in (1,1,!spaces!) do set "BAR=!BAR!."
<nul set /p =Progress: [!BAR!] %1%%
timeout /t 1 >nul
endlocal
goto :eof

REM 開始清理
echo Detecting Windows system...
call :progress 10

echo Cleaning System Temp...
del /s /q /f %SystemRoot%\Temp\* >nul 2>&1
call :progress 30

echo Cleaning User Temp...
del /s /q /f %TEMP%\* >nul 2>&1
call :progress 50

echo Cleaning Prefetch...
del /s /q /f %SystemRoot%\Prefetch\* >nul 2>&1
call :progress 70

echo Cleaning Recycle Bin...
rd /s /q %SystemDrive%\$Recycle.Bin >nul 2>&1
call :progress 90

echo Finalizing...
call :progress 100

echo.
echo ✅ Cache cleanup completed!
timeout /t 2 >nul
exit
