@echo off
title Windows Cache Cleaner - Advanced Version
mode con: cols=60 lines=25
color 0A

:: 權限檢查
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo [Error] 請以系統管理員身份執行此程式！
    pause
    exit /b
)

echo ===============================
echo      Windows Cache Cleaner
echo ===============================
echo.

:: 進度條函數
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

:: 紀錄磁碟空間 (清理前)
for /f "tokens=3" %%a in ('fsutil volume diskfree %SystemDrive%') do set freespace_before=%%a

:: 開始清理
echo [Step 1] 偵測系統...
call :progress 5

echo [Step 2] 清除系統 Temp 資料夾...
del /f /s /q %SystemRoot%\Temp\*.* >nul 2>&1
rd /s /q %SystemRoot%\Temp >nul 2>&1
md %SystemRoot%\Temp
call :progress 15

echo [Step 3] 清除使用者 Temp 資料夾...
del /f /s /q "%userprofile%\Local Settings\Temp\*.*" >nul 2>&1
rd /s /q "%userprofile%\Local Settings\Temp" >nul 2>&1
md "%userprofile%\Local Settings\Temp"
call :progress 25

echo [Step 4] 清除 Prefetch 資料夾...
del /f /s /q %SystemRoot%\Prefetch\*.* >nul 2>&1
call :progress 35

echo [Step 5] 清除回收桶...
rd /s /q %SystemDrive%\$Recycle.Bin >nul 2>&1
call :progress 45

echo [Step 6] 深度清理系統垃圾檔...
del /f /s /q %systemdrive%\*.tmp >nul 2>&1
del /f /s /q %systemdrive%\*._mp >nul 2>&1
del /f /s /q %systemdrive%\*.log >nul 2>&1
del /f /s /q %systemdrive%\*.gid >nul 2>&1
del /f /s /q %systemdrive%\*.chk >nul 2>&1
del /f /s /q %systemdrive%\*.old >nul 2>&1
call :progress 55

echo [Step 7] 清除個人設定垃圾...
del /f /q %userprofile%\cookies\*.* >nul 2>&1
del /f /q %userprofile%\recent\*.* >nul 2>&1
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*" >nul 2>&1
del /f /s /q "%userprofile%\recent\*.*" >nul 2>&1
call :progress 65

echo [Step 8] 清除系統備份與短切...
del /f /s /q %windir%\*.bak >nul 2>&1
DEL /S /F /Q "%AllUsersProfile%\「開始」功能表\程式集\Windows Messenger.lnk" >nul 2>&1
call :progress 75

echo [Step 9] 清除多餘資料夾...
rd /s /q "%systemdrive%\Program Files\Temp" >nul 2>&1
md "%systemdrive%\Program Files\Temp"
rd /s /q "%systemdrive%\d" >nul 2>&1
call :progress 85

echo [Step 10] 刪除 ASP.NET 帳號 (如果存在)...
net user aspnet /delete >nul 2>&1
call :progress 90

echo [Step 11] 執行磁碟清理工具 (cleanmgr)...
cleanmgr /sagerun:99
call :progress 100

:: 紀錄磁碟空間 (清理後)
for /f "tokens=3" %%a in ('fsutil volume diskfree %SystemDrive%') do set freespace_after=%%a
set /a saved_space=(%freespace_after%-%freespace_before%)/1024/1024

echo.
echo ===============================
echo        清理完成！
echo 釋放空間: %saved_space% MB
echo ===============================
timeout /t 3 >nul
exit
