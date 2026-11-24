FROM rocm/onnxruntime:rocm10.2.0_ub24.04_ort1.29_torch2.14.0_py3.11

# Copy local directories
COPY ./test /root/test
COPY ./setup /root/setup
COPY ./runtimes/migraphx/backend /root/test/backend

# Install test report dependencies
RUN pip3 install --no-cache-dir -r /root/setup/requirements_report.txt

############## ONNX Backend dependencies ###########
ENV ONNX_BACKEND="backend.backend"
ENV MIGRAPHX_DEVICE="GPU"

RUN pip3 install --upgrade numpy

WORKDIR /migraphx/build
####################################################

CMD . /root/setup/docker-setup.sh && \
    pytest /root/test/test_backend.py --onnx_backend=${ONNX_BACKEND} -k 'not _cuda' -v
