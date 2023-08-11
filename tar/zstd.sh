#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

source file.sh

cd ../model

for file in ${FILE[@]}; do
  tar -I "zstd -T0 --auto-threads=logical -19" -cf $DIR/${file}.tar.zstd ${file}
done
