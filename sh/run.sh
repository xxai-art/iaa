#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

source .direnv/python/bin/activate
set -o allexport
source .env
set +o allexport
./main.py
