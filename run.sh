#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

nc -z -w 1 127.0.0.1 7890 && export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890
exec direnv exec . ./main.py
