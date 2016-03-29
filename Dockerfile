# Base image already has cuda + cudnn
FROM kaixhin/cuda-caffe
MAINTAINER Tingting Lu


# Install git, python-dev, pip and other dependencies
RUN apt-get update && apt-get install -y \
  libopenblas-dev \
  python-nose \
  python-scipy \
  subversion \
  bc \
  cmake \
  libatlas-dev \
  libboost-all-dev \
  libprotobuf-dev \
  libgoogle-glog-dev \
  libgflags-dev \
  protobuf-compiler \
  libhdf5-dev \
  libleveldb-dev \
  liblmdb-dev \
  libsnappy-dev \
  python-pip \
  python-setuptools \
  emacs24-nox \
  graphviz \
  gfortran > /dev/null  


# Theano
# ------

# Set CUDA_ROOT
ENV CUDA_ROOT /usr/local/cuda/bin
# Install bleeding-edge Theano
RUN pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git
# Set up .theanorc for CUDA; ncnmem=0 because otherwise does not work
RUN echo "[global]\ndevice=gpu\nfloatX=float32\n[lib]\ncnmem=0\n[nvcc]\nfastmath=True" > /root/.theanorc

# Install scikit-learn, jupyter, pydotplus for caffe visualization, seaborn
RUN pip install scikit-learn jupyter lasagne keras pydotplus seaborn


# MXNet
# -----

# Install mxnet
RUN cd /root && git clone --recursive https://github.com/dmlc/mxnet && cd mxnet && \
# Copy config.mk
  cp make/config.mk config.mk && \
# Set OpenBLAS
  sed -i 's/USE_BLAS = atlas/USE_BLAS = openblas/g' config.mk && \
# Set CUDA flag
  sed -i 's/USE_CUDA = 0/USE_CUDA = 1/g' config.mk && \
  sed -i 's/USE_CUDA_PATH = NONE/USE_CUDA_PATH = \/usr\/local\/cuda/g' config.mk && \
# Set cuDNN flag
# TODO: Change when cuDNN v4 supported
  sed -i 's/USE_CUDNN = 0/USE_CUDNN = 0/g' config.mk && \
# Make 
  make -j"$(nproc)"

RUN cd /root/mxnet/python && python setup.py install
# Add R to apt sources
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
# Install latest version of R
RUN apt-get update && apt-get install -y --force-yes r-base

# Jupyter
# -------

# Configure jupyter, set up password
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.password = u'sha1:30d3f970641a:ab54d7ab6578d8543778848fe86227534109ba13'" >> ~/.jupyter/jupyter_notebook_config.py

WORKDIR /root
EXPOSE 8888
ENTRYPOINT jupyter notebook --ip=0.0.0.0
