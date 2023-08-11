#!/usr/bin/env python

import numpy as np
from lib.jpg_iter import jpg_iter, ROOT, DIR_LI
from lib.score import score

li = []

for pos, i in enumerate(DIR_LI):
  for fp in jpg_iter(i):
    with open(fp, "rb") as bin:
      bin = bin.read()
      s = score(bin)
      print(fp[len(ROOT) + 1:], s)
      li.append(s)

li = np.array(li).T

min_vals = np.min(li, axis=1, keepdims=True)
print('min', min_vals)

max_vals = np.max(li, axis=1, keepdims=True)

print('max', max_vals)
