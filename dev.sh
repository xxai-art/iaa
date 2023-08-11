#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

cd $DIR

exec watchexec --shell=none \
  --project-origin . -w . \
  --exts py,sh \
  -r \
  -- ./run.sh
