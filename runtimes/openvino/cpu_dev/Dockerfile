FROM ubuntu:20.04

# Disable interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# Install Python dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-dev \
    python3-pip && \
    apt-get clean autoclean && apt-get autoremove -y

RUN pip3 install --upgrade pip setuptools wheel

# Copy local directories
COPY ./test /root/test
COPY ./setup /root/setup

# Install test report dependencies
RUN pip3 install --no-cache-dir -r /root/setup/requirements_report.txt

############## ONNX Backend dependencies ###########

RUN apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    libtool \
    build-essential \
    ninja-build \
    cmake \
    curl \
    cython3 \
    git \
    wget && \
    apt-get clean autoclean && apt-get autoremove -y

# Build OpenVINO
RUN git clone --recurse-submodules --depth 1 https://github.com/openvinotoolkit/openvino.git
WORKDIR /openvino/build
RUN cmake .. \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_INTEL_CPU=ON \
    -DENABLE_INTEL_GPU=OFF \
    -DENABLE_INTEL_GNA=OFF \
    -DENABLE_INTEL_MYRIAD=OFF \
    -DENABLE_OPENCV=OFF \
    -DENABLE_TESTS=OFF \
    -DENABLE_BEH_TESTS=OFF \
    -DENABLE_FUNCTIONAL_TESTS=OFF \
    -DENABLE_PROFILING_ITT=OFF \
    -DENABLE_SAMPLES=OFF \
    -DENABLE_PYTHON=ON \
    -DPYTHON_EXECUTABLE=/usr/bin/python3 \
    -DENABLE_CPPLINT=OFF \
    -DENABLE_NCC_STYLE=OFF \
    -DENABLE_OV_PADDLE_FRONTEND=OFF \
    -DENABLE_OV_TF_FRONTEND=OFF \
    -DCMAKE_INSTALL_PREFIX=/openvino/dist
RUN ninja install

# This hack is needed because OpenVINO conftest.py, which sets up backand name variables,
# is not called while running onnx backend tests.
RUN sed -i 's/BACKEND_NAME = None/BACKEND_NAME = "CPU"/' /openvino/src/frontends/onnx/tests/__init__.py
# End of hack

WORKDIR /openvino/src/frontends/onnx/
RUN pip3 install -r requirements.txt
# workaround to fix onnx test runner
RUN pip3 install numpy==1.23.0 --force-reinstall
RUN pip3 install onnx

ENV ONNX_BACKEND="tests.tests_python.utils.onnx_backend"
# ####################################################

CMD source /root/setup/docker-setup.sh && \
    source /openvino/dist/setupvars.sh && \
    pytest /root/test/test_backend.py --onnx_backend=${ONNX_BACKEND} -k 'not _cuda and not test_sce_NCd1d2d3d4d5_mean_weight_cpu and not test_sce_NCd1d2d3d4d5_mean_weight_log_prob_cpu and not test_sce_NCd1d2d3d4d5_none_no_weight_cpu and not test_sce_NCd1d2d3d4d5_none_no_weight_log_prob_cpu and not test_layer_normalization_2d_axis0_cpu and not test_layer_normalization_2d_axis1_cpu and not test_layer_normalization_2d_axis_negative_1_cpu and not test_layer_normalization_2d_axis_negative_2_cpu and not test_layer_normalization_3d_axis0_epsilon_cpu and not test_layer_normalization_3d_axis1_epsilon_cpu and not test_layer_normalization_3d_axis2_epsilon_cpu and not test_layer_normalization_3d_axis_negative_1_epsilon_cpu and not test_layer_normalization_3d_axis_negative_2_epsilon_cpu and not test_layer_normalization_3d_axis_negative_3_epsilon_cpu and not test_layer_normalization_4d_axis0_cpu and not test_layer_normalization_4d_axis1_cpu and not test_layer_normalization_4d_axis2_cpu and not test_layer_normalization_4d_axis3_cpu and not test_layer_normalization_4d_axis_negative_1_cpu and not test_layer_normalization_4d_axis_negative_2_cpu and not test_layer_normalization_4d_axis_negative_3_cpu and not test_layer_normalization_4d_axis_negative_4_cpu and not test_layer_normalization_default_axis_cpu' -v
