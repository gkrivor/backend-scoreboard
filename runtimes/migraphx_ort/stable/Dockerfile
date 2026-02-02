FROM rocm/onnxruntime:rocm7.1.1_ub24.04_ort1.23_torch2.8.0

# Copy local directories
COPY ./test /root/test
COPY ./setup /root/setup

# Install test report dependencies
RUN pip3 install --no-cache-dir -r /root/setup/requirements_report.txt

############## ONNX Backend dependencies ###########
ENV ONNX_BACKEND="onnxruntime.backend.backend"

# Set locale which is required for StringNormalizer
#RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# Install dependencies
RUN pip3 install \
    onnx \
    protobuf==3.20.2
#    numpy==1.22.4
####################################################

ENV ORT_ONNX_BACKEND_EXCLUDE_PROVIDERS=CPUExecutionProvider

CMD . /root/setup/docker-setup.sh && \
    pytest /root/test/test_backend.py --onnx_backend=${ONNX_BACKEND} -k 'not _cuda' -v

