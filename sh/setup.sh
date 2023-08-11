#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

if ! [ -x "$(command -v cargo)" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
fi

pyver=$(python --version | sed 's/Python //' | awk -F. '{print $1"."$2""}')

apt install -y python${pyver}-venv

source "$HOME/.cargo/env"

gdrive=$(dirname $DIR)/gdrive/MyDrive/art

if [ -d "$gdrive" ]; then
  rm -rf .env
  cp $gdrive/conf/api/.env .
  rm -rf model
  cp -R $gdrive/iaa/model . &
fi

python -m venv .direnv/python
source .direnv/python/bin/activate
pip install -r requirements.txt

pip uninstall -y nvidia-cudnn-cu11
pip install nvidia-cudnn-cu11==8.6.0.163

wait
