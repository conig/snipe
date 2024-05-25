@echo off
setlocal

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

pause
endlocal
