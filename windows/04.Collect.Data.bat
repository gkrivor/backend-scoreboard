@echo off
set _SCROOT=%~dp0
REM Removing \windows\ from the end
set SCROOT=%_SCROOT:~0,-9%

REM Run chosen runtime collection
IF NOT "%1" == "" (
    set OV_RUNTIME=%1
    IF EXIST %SCROOT%\runtimes\openvino\%1\collect.bat (
        call %SCROOT%\runtimes\openvino\%1\collect.bat
    )
    goto :eof
)

:RETRY
@echo Found available runtimes:
for /F %%I in ('dir /b /a:d %SCROOT%\runtimes\openvino') do (
    IF EXIST "%SCROOT%\runtimes\openvino\%%I\collect.bat" (
        @echo %%I
    )
)
set /p OV_RUNTIME="Please, enter runtime or Ctrl-C to exit: "
if NOT EXIST %SCROOT%\runtimes\openvino\%OV_RUNTIME%\collect.bat (
    cls
    echo You've entered non-existent runtime, or it doesn't contain collect.bat
    goto RETRY
)

call %SCROOT%\runtimes\openvino\%OV_RUNTIME%\collect.bat

@echo Data collection finished
pause