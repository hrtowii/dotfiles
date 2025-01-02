@echo off
@REM This file is placed in a stable (version-independent) location
@REM and forwards to the currently installed version

setlocal
SET DEVCONTAINER_CLI_PATH=%~f0
SET VSCODE_PATH=

:vscode_path
@REM Load the Code.exe path
IF NOT exist "%~dp0vscode-path%" goto fail_vscode_path
set /p VSCODE_PATH=<"%~dp0vscode-path%"
IF exist "%VSCODE_PATH%" goto remote_container_path

:fail_vscode_path
echo Failed to determine VS Code path
exit 1

:remote_container_path

SET REMOTE_CONTAINERS_PATH=

@REM Check the remote-containers-path file 
@REM This is a cache (and enables Dev Containers development)
IF NOT exist "%~dp0remote-containers-path%" goto fail_remote_container_path
set /p REMOTE_CONTAINERS_PATH=<"%~dp0remote-containers-path%"
IF exist "%REMOTE_CONTAINERS_PATH%\dev-containers-user-cli\cli.js" goto forwardcall

:fail_remote_container_path
echo Failed to determine Dev Containers path
exit 1

:forwardcall
set ELECTRON_RUN_AS_NODE=1
"%VSCODE_PATH%" "%REMOTE_CONTAINERS_PATH%\dev-containers-user-cli\\cli.js" %*

endlocal