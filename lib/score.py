#!/usr/bin/env python

from EAT import img_resize
from EAT.AVA import score as ava_score
from EAT.TAD66K import score as tad66k_score
from vila import score as vila_score


def score(bin):
  img = img_resize(bin)
  return ava_score(img), tad66k_score(img), vila_score(bin)
