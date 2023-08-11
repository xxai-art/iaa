#!/usr/bin/env python

import torch
from torchvision import transforms
import numpy as np
from .models.dat import DAT
from EAT import DEVICE, load_model, score_img


def get_score(y_pred):
  w = torch.from_numpy(np.linspace(1, 10, 10))
  w = w.type(torch.FloatTensor)
  w = w.to(DEVICE)

  w_batch = w.repeat(y_pred.size(0), 1)

  score = (y_pred * w_batch).sum(dim=1)
  score_np = score.data.cpu().numpy()
  return score_np[0]


IMAGE_NET_MEAN = [0.485, 0.456, 0.406]
IMAGE_NET_STD = [0.229, 0.224, 0.225]

transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize(mean=IMAGE_NET_MEAN, std=IMAGE_NET_STD)
])
model = load_model('AVA', DAT)


def score(img):
  return get_score(score_img(img, transform, model))
