
[EAT](https://github.com/xxai-fork/Image-Aesthetics-Assessment)

https://colab.research.google.com

```
from google.colab import drive
drive.mount('/content/gdrive')

!git clone --depth=1 https://github.com/xxai-art/iaa.git
!iaa/colab/setup.sh
!iaa/colab/run.sh
```

https://www.kaggle.com/xxaiart/iaa-img/edit

```
!cd iaa && source "$HOME/.cargo/env" &&\
python -m venv .direnv/python && \
source .direnv/python/bin/activate &&\
pip install -r requirements.txt
!cd iaa;rm .env;cp /kaggle/input/iaa-env/.env .;colab/run.sh
```
