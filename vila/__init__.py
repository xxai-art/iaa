#!/usr/bin/env python

import tensorflow as tf
from .config import predict as _predict
# import pillow_avif  # noqa


def score(bin):
  # byte_io = io.BytesIO()
  # img.save(byte_io, 'PNG')
  # byte_io.seek(0)
  # bin = byte_io.read()
  img = tf.constant(bin)
  predictions = _predict(image_bytes=img)
  score = predictions['predictions']
  return score[0][0].numpy()
