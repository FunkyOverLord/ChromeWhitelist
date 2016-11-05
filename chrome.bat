@echo off
:: This section is just so we are guarenteed admin


:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
IF '%PROCESSOR_ARCHITECTURE%' EQU 'amd64' (
   >nul 2>&1 "%SYSTEMROOT%\SysWOW64\icacls.exe" "%SYSTEMROOT%\SysWOW64\config"
 ) ELSE (
   >nul 2>&1 "%SYSTEMROOT%\system32\icacls.exe" "%SYSTEMROOT%\system32\config"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------   

:--------------------------------------    
setlocal EnableDelayedExpansion
set myPath=%~DP0
set myPath=%myPath:*\=%
set fullPath=
pushd \
for %%a in ("%myPath:\=" "%") do (
   set thisDir=%%~a
   for /D %%d in ("!thisDir:~0!*") do (
      set fullPath=!fullPath!\%%d
      cd %%d
   )
)
popd
echo Full path: %~D0%fullPath%
:--------------------------------------    

::Now begins the messy registry crap
::To whitelist an extension, go into extensions in Chrome and enable Developer Mode.
::Copy the ID of the extension you want after initially running this script (it will be next to the extension)
::Then copy and paste one of these lines "reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallWhitelist" /v nextnumberinsequence /t REG_SZ /d extensionid /f"
::Replace values nextnumberinsequence and extension ID with what they need.
::(Optional) Use :: above the line for whitelisting and write the Extension name afterwards.
echo Modifying registry components
reg delete "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallBlacklist" /va /f

:: Hangouts
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallWhitelist" /v 1 /t REG_SZ /d nckgahadagoaajjgafhacjanaoiihapd /f

:: AdBlock
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallWhitelist" /v 2 /t REG_SZ /d gighmmpiobklfepjocnamgkkbiglidom /f

:: LastPass
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallWhitelist" /v 3 /t REG_SZ /d hdokiejnpimakedhajhdlcegeplioahd /f

:: Morpheon Dark Theme
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallWhitelist" /v 4 /t REG_SZ /d mafbdhjdkjnoafhfelkjpchpaepjknad /f

:: CRX Viewer
reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallWhitelist" /v 5 /t REG_SZ /d jifpbeccnghkjeaalbbjmodiffmgedin /f

echo Completed :)
pause