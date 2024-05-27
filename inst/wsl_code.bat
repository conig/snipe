@echo off
setlocal

:: Change directory to the directory of the script
cd /d "%~dp0"

:: Check if the getadmin.vbs file exists in the temp directory and delete it if it does
if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs"

:: Query the dirty bit on the system drive, redirecting output to null
:: If fsutil fails, the command will run as an elevated administrator
fsutil dirty query %systemdrive% 1>nul 2>nul || (
    
    :: Create a VBScript to elevate the current script
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/c cd ""%~sdp0"" && ""%~s0"" %params% && exit", "", "runas", 1 >> "%temp%\getadmin.vbs"
    
    :: Execute the VBScript to request administrator privileges
    "%temp%\getadmin.vbs"
    
    :: Exit the batch script to avoid continuing without elevation
    exit /B
)

:: Get the current directory
set "currentDir=%cd%"
echo Current Directory: %currentDir%

:: Extract the drive letter and convert to lowercase using PowerShell
for /f "delims=" %%i in ('powershell -NoProfile -Command "[char]([string]::new('%currentDir:~0,1%')).ToLower()"') do set "driveLetter=%%i"

:: Convert the Windows path to WSL path
set "remainingPath=%currentDir:~2%"
set "wslPath=/mnt/%driveLetter%%remainingPath%"
set "wslPath=%wslPath:\=/%"
echo WSL Path: %wslPath%

:: Open the directory in Visual Studio Code in WSL
wsl.exe -e bash -c "cd \"%wslPath%\" && code ."
if %errorlevel% neq 0 (
    echo Error: Failed to open WSL path in Visual Studio Code.
)

endlocal
