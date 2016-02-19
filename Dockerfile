# Base image already has cuda + cudnn
FROM kaixhin/cuda-caffe
MAINTAINER Henry Lo <henryzlo@cs.umb.edu>


# Install git, python-dev, pip and other dependencies
RUN apt-get update && apt-get install -y \
  libopenblas-dev \
  python-nose \
  python-scipy \
  subversion

# Set CUDA_ROOT
ENV CUDA_ROOT /usr/local/cuda/bin
# Install bleeding-edge Theano
RUN pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git
# Set up .theanorc for CUDA; ncnmem=0 because otherwise does not work
RUN echo "[global]\ndevice=gpu\nfloatX=float32\n[lib]\ncnmem=0\n[nvcc]\nfastmath=True" > /root/.theanorc

# Install scikit-learn, jupyter
RUN pip install scikit-learn jupyter lasagne keras

# Configure jupyter, set up password
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.password = u'sha1:30d3f970641a:ab54d7ab6578d8543778848fe86227534109ba13'" >> ~/.jupyter/jupyter_notebook_config.py

WORKDIR /root
EXPOSE 8888
ENTRYPOINT jupyter notebook --ip=0.0.0.0
