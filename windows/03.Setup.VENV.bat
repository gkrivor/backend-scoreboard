@echo off
IF NOT EXIST openvino (
    @echo OpenVINO repository isn't found, run %~dp002.Get.Fresh.OpenVINO.bat
    goto :eof
)
IF NOT EXIST venv (
    python -m venv venv
) ELSE (
    @echo VENV folder already exists!
)
call venv\Scripts\activate.bat
pip install -r ../requirements_web.txt
pip install --no-cache-dir -r ../setup/requirements_report.txt 
pip install onnx==1.16.0
call venv\Scripts\deactivate
