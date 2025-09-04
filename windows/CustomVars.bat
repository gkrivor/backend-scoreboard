set ONNX_BACKEND=tests.tests_python.utils.onnx_backend
REM If you want to provide settings for manually built OpenVINO - use next variables...
REM set PATH=%PATH%;e:\openvino\ov_onnx\bin\intel64\RelWithDebInfo;e:\openvino\ov_onnx\temp\tbb\bin;
REM set OPENVINO_LIB_PATHS=e:\openvino\ov_onnx\bin\intel64\RelWithDebInfo;
REM set PYTHONPATH=e:\openvino\ov_onnx\bin\intel64\RelWithDebInfo\python;%PYTHONPATH%
REM If you use pre-built wheels - comment variables above and set versions below
REM You should download a wheels, put here names or full path to it
set OV_STABLE=openvino-2025.3.0-19807-cp311-cp311-win_amd64.whl
set OV_LATEST=openvino-2025.4.0.dev20250903-19898-cp311-cp311-win_amd64.whl
