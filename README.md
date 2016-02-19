# CUDA-enabled Deep Learning Image

This image runs a jupyter notebook server on port 8000.

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

Usually I have a `data` and `workspace` folder that I like to attach.  This can be done using the flags:

```
-v `pwd`/workspace:/root/workspace -v `pwd`/data:/root/data
```

Putting it all together:

```
docker run -it -P --device /dev/nvidia0 --device /dev/nvidia-uvm --device /dev/nvidiactl -v `pwd`/workspace:/root/workspace -v `pwd`/data:/root/data henryzlo/deepdock
```

If you want a shell in the image, run the command above, then use:
```
docker exec -it <image-name> bash
```
Where `<image-name>` can be obtained via `docker ps`.
