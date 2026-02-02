#!/bin/bash

docker build -t scoreboard/migraphx -f `pwd`/runtimes/migraphx/stable/Dockerfile .
docker run --name migraphx --device=/dev/kfd --device=/dev/dri --env-file `pwd`/setup/env.list -v `pwd`/results/migraphx/stable:/root/results -it --rm scoreboard/migraphx
