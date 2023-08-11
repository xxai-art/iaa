#!/usr/bin/env python
import optuna
import random
import numpy as np
from lib.score import score
from lib.jpg_iter import jpg_iter, ROOT, DIR_LI


# 0-1归一化
def li_normalize(arr):
  min_vals = np.min(arr, axis=1, keepdims=True)
  max_vals = np.max(arr, axis=1, keepdims=True)
  return (arr - min_vals) / (max_vals - min_vals)


def normalize(arr):
  min_vals = np.min(arr, keepdims=True)
  max_vals = np.max(arr, keepdims=True)
  return (arr - min_vals) / (max_vals - min_vals)


def good_bad(good, bad, axis=1):
  good = good.mean(axis=axis)
  bad = bad.mean(axis=axis)
  r = 100 * (good / bad - 1)
  return r


def benchmark(score):
  sli = []
  good_len = 0

  for pos, i in enumerate(DIR_LI):
    # n = 0
    for fp in jpg_iter(i):
      if pos == 0:
        good_len += 1
      with open(fp, "rb") as img:
        print(fp)
        s = score(img.read())
        sli.append(s)
        print(fp[len(ROOT) + 5:], s)
      # n += 1
      # if n > 5:
      #   break

  li = li_normalize(np.array(sli).T)

  bad_len = len(li[0]) - good_len

  def objective(trial):
    x = trial.suggest_uniform('x', 0, 1)
    y = trial.suggest_uniform('y', 0, 1)
    z = trial.suggest_uniform('z', 0, 1)
    sli = li.copy()
    for pos, i in enumerate([x, y, z]):
      sli[pos] *= i

    result = 0
    sample = 500

    h_good_len = int(good_len / 2)
    h_bad_len = int(bad_len / 2)

    for i in range(sample):
      gn = random.sample(range(good_len), h_good_len)
      bn = random.sample(range(good_len, good_len + bad_len), h_bad_len)
      t = sli[:, gn + bn]
      t = np.sum(t, axis=0)
      t = normalize(t)
      good, bad = np.hsplit(t, [h_good_len])
      r = good_bad(good, bad, 0)
      result += r
    result /= sample
    print(result)
    return result

  study = optuna.create_study(study_name='iaa', direction='maximize')
  study.optimize(objective, n_trials=5000)
  best_params = study.best_params
  print(best_params)
  print('x = 1')
  for i in ['y', 'z']:
    print(i, '=', best_params[i] / best_params['x'])
  print(study.best_value)

  good, bad = np.hsplit(li, [good_len])
  print('(good / bad - 1) %', good_bad(good, bad))


benchmark(score)
