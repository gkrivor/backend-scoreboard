@echo off
IF NOT EXIST openvino (
    git clone https://github.com/openvinotoolkit/openvino.git
) ELSE (
    cd openvino
    git fetch origin
    cd ..
)
IF EXIST openvino (
    cd openvino
    git reset --hard
    git checkout origin/master
    IF NOT "%ERRORLEVEL%" == "0" (
        @echo Cannot checkout origin/master, refresh has been stopped.
        cd ..
        goto :eof
    )
    cd ..
) ELSE (
    @echo OpenVINO sources isn't found.
)
