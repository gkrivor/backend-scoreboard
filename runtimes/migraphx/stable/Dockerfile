# Docker below doesn't contain migraphx for py3.12, only for py3.10
#FROM rocm/onnxruntime:rocm7.1.1_ub24.04_ort1.23_torch2.8.0
FROM rocm/pytorch:rocm7.1_ubuntu24.04_py3.12_pytorch_release_2.7.1

# Copy local directories
COPY ./test /root/test
COPY ./setup /root/setup

# Install test report dependencies
RUN pip3 install --no-cache-dir -r /root/setup/requirements_report.txt

############## ONNX Backend dependencies ###########
ENV ONNX_BACKEND="onnx_migraphx.backend"

# Set locale which is required for StringNormalizer
#RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# Install dependencies
RUN pip3 install \
    onnx \
    protobuf==3.20.2
#    numpy==1.22.4
####################################################

RUN apt-get update && apt-get install -y --no-install-recommends \
    git cmake

WORKDIR /root

# MIGraphX dependencies
RUN apt-get install -y --no-install-recommends \
    libmsgpack-cxx-dev pybind11-dev
# MIGraphX build
RUN git clone https://github.com/ROCm/AMDMIGraphX.git migraphxsrc \
    && mkdir /root/test/onnx_migraphx \
    && cp -r /root/migraphxsrc/src/py/backend/* /root/test/onnx_migraphx \
    && cd migraphxsrc \
    && git checkout 8919637 \
    && pip install https://github.com/RadeonOpenCompute/rbuild/archive/master.tar.gz \
    && rbuild build -d depend -B build -DGPU_TARGETS=gfx942 --cxx=/opt/rocm/bin/amdclang++ --cc=/opt/rocm/bin/amdclang -DMIGRAPHX_STRIP_SYMBOLS=ON \
    && cd build \
    && make install

ENV PYTHONPATH=/opt/rocm/lib:/root/test

CMD . /root/setup/docker-setup.sh && \
    pytest /root/test/test_backend.py --onnx_backend=${ONNX_BACKEND} -k 'not _cuda' -v

