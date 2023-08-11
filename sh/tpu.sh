#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

source .direnv/python/bin/activate
pip install torch~=2.0.0 https://storage.googleapis.com/tpu-pytorch/wheels/tpuvm/torch_xla-2.0-cp38-cp38-linux_x86_64.whl
