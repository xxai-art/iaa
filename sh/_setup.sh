#!/usr/bin/env bash

if ! [ -x "$(command -v cargo)" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
fi

source "$HOME/.cargo/env"

python -m venv .direnv/python
source .direnv/python/bin/activate
pip install -r requirements.txt
pip uninstall -y nvidia-cudnn-cu11
pip install nvidia-cudnn-cu11==8.6.0.163
