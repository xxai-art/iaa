#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

./init.sh &

rm .env
cp /kaggle/input/config/.env .

source $DIR/_setup.sh

wait
