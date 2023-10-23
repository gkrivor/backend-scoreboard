FROM ubuntu:20.04

# Disable interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

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
ENV ONNX_BACKEND="tests.tests_python.utils.onnx_backend"

ARG OV_DIST_DIR=/openvino/dist

RUN apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    libtool \
    build-essential \
    cmake \
    curl \
    cython3 \
    git \
    wget && \
    apt-get clean autoclean && apt-get autoremove -y

# Obtain OpenVINO release info
WORKDIR /openvino.latest
RUN curl -s https://api.github.com/repos/openvinotoolkit/openvino/releases/latest > latest.json
RUN cat latest.json | \
    python3 -c "import sys; import json; latest = json.loads(sys.stdin.read()); print(latest['name'])" > version
RUN cat latest.json | \
    python3 -c "import sys; import json; latest = json.loads(sys.stdin.read()); print(latest['tag_name'])" > tag
WORKDIR /

# Build OpenVINO
RUN git clone --branch `cat /openvino.latest/tag` --recurse-submodules --depth 1 https://github.com/openvinotoolkit/openvino.git
WORKDIR /openvino/build
RUN cmake .. \
    -DENABLE_CLDNN=OFF \
    -DENABLE_GNA=OFF \
    -DENABLE_OPENCV=OFF \
    -DENABLE_VPU=OFF \
    -DNGRAPH_DEBUG_ENABLE=OFF \
    -DENABLE_TESTS=OFF \
    -DENABLE_BEH_TESTS=OFF \
    -DENABLE_FUNCTIONAL_TESTS=OFF \
    -DENABLE_PROFILING_ITT=OFF \
    -DENABLE_SAMPLES=OFF \
    -DENABLE_SPEECH_DEMO=OFF \
    -DENABLE_MKL_DNN=ON \
    -DENABLE_PYTHON=ON \
    -DNGRAPH_PYTHON_BUILD_ENABLE=ON \
    -DPYTHON_EXECUTABLE=/usr/bin/python3 \
    -DNGRAPH_ONNX_IMPORT_ENABLE=ON \
    -DCMAKE_INSTALL_PREFIX=${OV_DIST_DIR}
RUN make -j $(nproc)

# Install ngraph wheel
WORKDIR /openvino/ngraph/python
# Below hack is needed because OpenVINO conftest.py, which sets up backand name variables,
# is not called while running onnx backend tests.
RUN sed -i 's/BACKEND_NAME = None/BACKEND_NAME = "CPU"/' /openvino/src/frontends/onnx/tests/__init__.py
# End of hack

ENV PYTHONPATH=/openvino/bin/intel64/Release/lib/python_api/python3.8:/openvino/src/frontends/onnx/:${PYTHONPATH}
RUN pip3 install -r requirements.txt
RUN pip3 install onnx
####################################################

CMD . /root/setup/docker-setup.sh && \
    pytest /root/test/test_backend.py --onnx_backend=${ONNX_BACKEND} -k 'not _cuda' -v
