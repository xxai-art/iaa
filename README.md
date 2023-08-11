
[EAT](https://github.com/xxai-fork/Image-Aesthetics-Assessment)

https://colab.research.google.com

```
from google.colab import drive
drive.mount('/content/gdrive')

!apt remove -y libcudnn8 && apt install -y libcudnn8=8.6.0.163-1+cuda11.8
!git clone --depth=1 https://github.com/xxai-art/iaa.git
!iaa/sh/setup.sh
!iaa/sh/run.sh
```

https://www.kaggle.com/xxaiart/iaa-img/edit

```
!git clone --depth=1 https://github.com/xxai-art/iaa.git
!iaa/sh/kaggle.sh
!iaa/sh/run.sh
```
