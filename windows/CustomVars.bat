set ONNX_BACKEND=tests.tests_python.utils.onnx_backend
REM If you want to provide settings for manually built OpenVINO - use next variables...
REM set PATH=%PATH%;e:\openvino\ov_onnx\bin\intel64\RelWithDebInfo;e:\openvino\ov_onnx\temp\tbb\bin;
REM set OPENVINO_LIB_PATHS=e:\openvino\ov_onnx\bin\intel64\RelWithDebInfo;
REM set PYTHONPATH=e:\openvino\ov_onnx\bin\intel64\RelWithDebInfo\python;%PYTHONPATH%
REM If you use pre-built wheels - comment variables above and set versions below
REM You should download a wheels, put here names or full path to it
set OV_STABLE=openvino-2023.1.0-12169-cp38-cp38-win_amd64.whl
set OV_LATEST=openvino-2023.2.0.dev20231024-12935-cp38-cp38-win_amd64.whl
