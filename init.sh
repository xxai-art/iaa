#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

source ./tar/file.sh

mkdir -p model
cd model
for file in ${FILE[@]}; do
  if [ ! -s "$file" ]; then
    echo $file
    f=$file.tar.zstd
    wget --retry-connrefused=on --tries=999 -c https://huggingface.co/xxai-art/tar/resolve/main/$f
    tar -I "zstd -T0" -xf $f
    rm $f
  fi
done
