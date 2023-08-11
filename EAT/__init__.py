import torch
from PIL import Image
import yaml
from io import BytesIO

from os.path import abspath, dirname, join

PWD = dirname(abspath(__file__))
MODEL = join(dirname(PWD), 'model')

MPS = torch.backends.mps.is_available()
if MPS:
  DEVICE = 'mps'
elif torch.cuda.is_available():
  DEVICE = "cuda"
else:
  DEVICE = 'cpu'

DEVICE = torch.device(DEVICE)


def load_model(model, dat):

  ck = torch.load(join(
      MODEL,
      model + '.pth',
  ), map_location=DEVICE)

  with open(join(PWD, model, 'dat_base.yaml')) as f:
    conf = yaml.load(f, Loader=yaml.FullLoader)['MODEL']['DAT']

  model = dat(**conf)
  model.load_state_dict(ck)
  model.eval()
  model.to(DEVICE)
  if not MPS:
    model = torch.compile(model)
  return model


def img_resize(img):
  img = Image.open(BytesIO(img))
  img = img.resize((224, 224))
  return img


def score_img(img, transform, model):
  # 参数是一个图片的数组， unsqueeze相当于创建一个只有一个图片的数组
  with torch.no_grad():
    img = transform(img)
    img = img.unsqueeze(0)
    img = img.to(DEVICE)
    pred, _, _ = model(img)

  return pred
