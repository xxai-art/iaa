#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

./init.sh &

rm -rf .env
cp /kaggle/input/config/.env .

source $DIR/sh/_setup.sh

wait
