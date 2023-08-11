#!/usr/bin/env python

from os.path import abspath, dirname, join
import tensorflow as tf

DIR = dirname(dirname(abspath(__file__)))

DIR_MODEL = join(DIR, 'model/vila')

MODEL = tf.saved_model.load(DIR_MODEL)

predict = MODEL.signatures['serving_default']
#predict = tf.function(MODEL.signatures['serving_default'],jit_compile=True)
