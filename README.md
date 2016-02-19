# CUDA-enabled Deep Learning Image

Contents
--------

Installed in this image are:

- Caffe + CUDNN
- Theano (no CUDNN)
- Keras
- Lasagne
- Scikit-learn
- Jupyter notebook.

The github repo and docker image are both `henryzlo/deepdock`

Requirements
------------

You will need CUDA 7.5 installed and a GPU.  Then you need to attach the GPU to the image with the flags:

```
--device /dev/nvidia0 --device /dev/nvidia-uvm --/device /dev/nvidiactl
```

Cheatsheet
----------

In order to mount data onto the container, attach volumes:

```
--device /dev/nvidia0 --device /dev/nvidia-uvm --/device /dev/nvidiactl
```


