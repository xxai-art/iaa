#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

source .direnv/python/bin/activate
set -o allexport
source .env
set +o allexport

if [ -x "$(command -v nvcc)" ]; then
  CUDA_LIB=/usr/local/cuda-$(nvcc -V | grep -o -E '[0-9]+\.[0-9]+' | head -1)
  export LIBRARY_PATH=$LIBRARY_PATH:$CUDA_LIB/lib64:$CUDA_LIB/compat
fi

./main.py
