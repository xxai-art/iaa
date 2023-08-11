#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

if ! [ -x "$(command -v zstd)" ]; then
  apt install -y zstd
fi

DNAME=$(basename $DIR)

cd ..
tar -I "zstd -T0 --auto-threads=logical -19" -cf $DNAME.tar.zstd $DNAME
