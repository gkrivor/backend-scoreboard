#!/bin/bash

# SPDX-License-Identifier: Apache-2.0


set -e  # Exit on error
set -x  # Command echo on

ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
git remote set-url origin git@github.com:tomdol/backend-scoreboard.git

git config --global user.email "onnx_scoreboard_bot@azure"
git config --global user.name "ONNX Scoreboard Bot @ Azure Pipelines"

git pull origin master
git checkout master
