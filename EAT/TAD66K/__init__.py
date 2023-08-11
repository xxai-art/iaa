#!/usr/bin/env python

from torchvision import transforms
from .models.dat import DAT
from EAT import load_model, score_img

transform = transforms.Compose([
    transforms.ToTensor(),
])
model = load_model('TAD66K', DAT)


def score(img):
  return float(score_img(img, transform, model)[0][0])
