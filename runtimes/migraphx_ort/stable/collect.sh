#!/bin/bash

docker build -t scoreboard/migraphx_ort -f `pwd`/runtimes/migraphx_ort/stable/Dockerfile .
docker run --name migraphx_ort --device=/dev/kfd --device=/dev/dri --env-file `pwd`/setup/env.list -v `pwd`/results/migraphx_ort/stable:/root/results -it --rm scoreboard/migraphx_ort
