#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

./init.sh &

rm .env
cp /kaggle/input/config/.env .

if ! [ -x "$(command -v cargo)" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
fi

source "$HOME/.cargo/env"

python -m venv .direnv/python &&
  source .direnv/python/bin/activate &&
  pip install -r requirements.txt

wait
