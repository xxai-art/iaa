#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

git clone --depth=1 git@github.com:xxai-dev/iaa-img.git img
