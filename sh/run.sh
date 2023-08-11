#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

source .direnv/python/bin/activate
set -o allexport
source .env
set +o allexport
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda-$(nvcc -V | grep -o -E '[0-9]+\.[0-9]+' | head -1)/lib64
./main.py
