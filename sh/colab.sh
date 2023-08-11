#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

pyver=$(python --version | sed 's/Python //' | awk -F. '{print $1"."$2""}')

apt install -y python${pyver}-venv

gdrive=$(dirname $DIR)/gdrive/MyDrive/art

if [ -d "$gdrive" ]; then
  rm -rf .env
  cp $gdrive/conf/api/.env .
  rm -rf model
  cp -R $gdrive/iaa/model . &
fi

source $DIR/sh/_setup.sh
wait
