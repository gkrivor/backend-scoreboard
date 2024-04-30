setlocal
IF "%SCROOT%" == "" (
    call :changescroot
)
IF NOT EXIST %SCROOT%\windows\venv\Scripts\activate.bat (
    @echo Python's VirtualENV isn't found, run %SCROOT%\windows\03.Setup.VENV.bat first
    goto :eof
)
call %SCROOT%\windows\venv\Scripts\activate.bat

IF EXIST %SCROOT%\windows\CustomVars.bat (
    call %SCROOT%\windows\CustomVars.bat
)

REM Session variables START
set TEST_DEVICE=NPU
set PYTHONPATH=%SCROOT%\windows\openvino\src\frontends\onnx\;%PYTHONPATH%
set RESULTS_DIR=%SCROOT%\results\openvino\npu_dev
set CSVDIR=%SCROOT%\results\openvino\npu_dev
REM Comment line below if you would use manually built OpenVINO
set OV_WHEELS=%OV_LATEST%
REM Session variables END

REM Environment check START
IF "%OV_WHEELS%" == "" (
    where openvino.dll
    IF NOT "%ERRORLEVEL%" == "0" (
        @echo Check availability of openvino.dll using PATH environment variable
        @echo Check CustomVars.bat
        goto final
    )
) ELSE (
    pip install --no-cache-dir %OV_WHEELS%
)
python -c "import openvino;print(openvino.runtime.get_version());"
IF NOT "%ERRORLEVEL%" == "0" (
    @echo Cannot import OpenVINO Python module, check PYTHONPATH in %0
    goto final
)
IF NOT EXIST "%RESULTS_DIR%" (
    mkdir "%RESULTS_DIR%
)
REM Environment check END

REM WORKLOAD START
pushd
cd %SCROOT%\windows
python -c "import re;txt='';f=open('openvino/src/frontends/onnx/tests/__init__.py','r');txt=re.sub(r'BACKEND_NAME = ""?[0-9A-Za-z\.]+""?','BACKEND_NAME = ""%TEST_DEVICE%""',f.read());f.close();f=open('openvino/src/frontends/onnx/tests/__init__.py','w');f.write(txt);f.close()"
popd
pip list --format=json > %RESULTS_DIR%/pip-list.json
pytest %SCROOT%\test\test_backend.py --onnx_backend=%ONNX_BACKEND% -k "not _cuda and not test_sce_NCd1d2d3d4d5_mean_weight_cpu and not test_sce_NCd1d2d3d4d5_mean_weight_log_prob_cpu and not test_sce_NCd1d2d3d4d5_none_no_weight_cpu and not test_sce_NCd1d2d3d4d5_none_no_weight_log_prob_cpu and not test_argmax_default_axis_example_cpu and not test_argmin_default_axis_example_cpu and not test_dynamicquantizelinear_expanded_cpu and not test_dynamicquantizelinear_max_adjusted_expanded_cpu and not test_dynamicquantizelinear_min_adjusted_expanded_cpu and not test_prelu_broadcast_cpu and not test_qlinearconv_cpu and not test_qlinearmatmul_2D_cpu and not test_qlinearmatmul_3D_cpu and not test_quantizelinear_axis_cpu and not test_quantizelinear_cpu and not test_reduce_l1_empty_set_cpu and not test_reduce_log_sum_exp_empty_set_cpu and not test_reduce_prod_empty_set_cpu and not test_reduce_sum_square_empty_set_cpu" -v
REM WORKLOAD END

:final
IF NOT "%OV_WHEELS%" == "" (
    pip uninstall --y %OV_WHEELS%
)
call %SCROOT%\windows\venv\Scripts\deactivate.bat
endlocal
goto :eof

:changescroot
set SCROOT=%~p0..\..\..
cd %SCROOT%\windows
goto :eof
