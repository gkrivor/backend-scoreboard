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
set PYTHONPATH=C:\amd\scoreboard\windows\migraphx\pyton\;%PYTHONPATH%
set RESULTS_DIR=%SCROOT%\results\migraphx_ort_win\stable
set CSVDIR=%SCROOT%\results\migraphx_ort_win\stable
set ONNX_BACKEND=onnxruntime.backend.backend
set ORT_ONNX_BACKEND_EXCLUDE_PROVIDERS=DmlExecutionProvider,CPUExecutionProvider
REM Comment line below if you would use manually built OpenVINO
set MIGRAPHX_WHEELS=%MIGRAPHX_STABLE%
REM Session variables END

REM Environment check START
IF "%MIGRAPHX_STABLE%" == "" (
	@echo Cannot work without ONNXRuntim-MIGraphX wheel
	goto final
) ELSE (
    pip install --no-cache-dir %MIGRAPHX_STABLE%
)
IF NOT EXIST "%RESULTS_DIR%" (
    mkdir "%RESULTS_DIR%
)
REM Environment check END

REM WORKLOAD START
pushd
cd %SCROOT%\windows
pip list --format=json > %RESULTS_DIR%/pip-list.json
pytest %SCROOT%\test\test_backend.py --onnx_backend=%ONNX_BACKEND% -k "not _cuda and not test_sce_NCd1d2d3_sum_weight_high_ii_cpu and not test_sce_NCd1d2d3_sum_weight_high_ii_expanded_cpu and not test_sce_NCd1d2d3_sum_weight_high_ii_log_prob_expanded_cpu and not test_sce_NCd1d2d3_sum_weight_high_ii_log_prob_cpu and not test_nllloss_NCd1d2d3_sum_weight_high_ii_cpu and not test_Conv1d_groups_cpu and not test_Conv3d_groups_cpu and not test_reduce_sum_square_negative_axes_keepdims_example_cpu and not test_reduce_l1_keep_dims_random_cpu and not test_reduce_l1_default_axes_keepdims_random_cpu" -v
REM WORKLOAD END

:final
IF NOT "%MIGRAPHX_STABLE%" == "" (
    pip uninstall --y %MIGRAPHX_STABLE%
)
call %SCROOT%\windows\venv\Scripts\deactivate.bat
endlocal
goto :eof

:changescroot
set SCROOT=%~p0..\..\..
cd %SCROOT%\windows
goto :eof
