@echo off
IF EXIST "..\.git" (
    git fetch origin
    git reset --hard
    git checkout origin/master
    IF NOT "%ERRORLEVEL%" == "0" (
        @echo Cannot checkout origin/master, refresh has been stopped.
        goto :eof
    )
) ELSE (
    @echo Scoreboard sources isn't found.
)
