#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

# PREFIX=/opt/openvino
# mkdir -p $PREFIX
# cd $PREFIX

# VERSION=2023.0.1.11005
#
# wget -c https://downloadmirror.intel.com/783086/l_openvino_toolkit_ubuntu22_$VERSION.fa1c41994f3_x86_64.tgz -O $VERSION.tgz
#
# tar -xvf $VERSION.tgz
#
# rm -rf $VERSION.tgz
#
# mv *_$VERSION.* $VERSION
#
# ln -s $VERSION now

# $PREFIX/now/install_dependencies/install_openvino_dependencies.sh

direnv exec . pip install -U pip numpy wheel
direnv exec . pip install -U keras_preprocessing --no-deps

if [ ! -d "tensorflow" ]; then
  git clone --depth=1 https://github.com/tensorflow/tensorflow.git
  #git clone -b v2.13.0 --depth=1 https://github.com/tensorflow/tensorflow.git
fi

cd tensorflow

if ! [ -x "$(command -v bazel)" ]; then
  apt install apt-transport-https curl gnupg -y
  curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg

  mv bazel-archive-keyring.gpg /usr/share/keyrings
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list

  apt-get update || true
  apt-get install -y bazel
fi

apkauto() {
  if ! [ -x "$(command -v $1)" ]; then
    apt-get install -y $1
  fi
}
apkauto clang
apkauto patchelf

export CC_OPT_FLAGS="-march=native"
export TF_NEED_CUDA=0
export PYTHON_BIN_PATH=$(direnv exec . which python3)

bazel version | grep "Build label" | sed 's/.*: \+//g' >.bazelversion
direnv exec . ./configure

# 从源代码构建 TensorFlow 以获取 SSE/AVX/FMA 指令：值得付出努力吗？
# https://medium.com/@sometimescasey/building-tensorflow-from-source-for-sse-avx-fma-instructions-worth-the-effort-fbda4e30eec3

bazel build --verbose_failures --config=opt \
  --copt=-msse4.1 \
  --copt=-msse4.2 \
  --copt=-mavx --copt=-mavx2 --copt=-mfma \
  -k //tensorflow/tools/pip_package:build_pip_package

#bazel-bin/tensorflow/tools/pip_package/build_pip_package
outdir=/tmp/tensorflow
rm -rf $outdir
mkdir -p $outdir
bazel-bin/tensorflow/tools/pip_package/build_pip_package --dst $outdir
direnv exec . pip install --force-reinstall $outdir/*.whl

rm -rf ~/.cache/bazel
