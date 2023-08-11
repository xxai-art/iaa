#!/usr/bin/env python

from os.path import dirname, abspath, join
from os import walk

DIR_LI = ['good', 'bad']

ROOT = dirname(dirname(abspath(__file__)))


def jpg_iter(suffix):
  for root, _, files in walk(join(ROOT, 'img', suffix)):
    # 遍历当前目录下所有文件
    for filename in files:
      # 检查文件名是否以'.jpg'结尾
      if filename.endswith('.jpg'):
        # 拼接完整路径
        jpg_path = join(root, filename)
        yield jpg_path
