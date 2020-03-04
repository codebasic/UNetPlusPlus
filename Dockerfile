FROM tensorflow/tensorflow:1.4.1-py3

RUN apt-get update
RUN apt-get install -y git
# UNetPlusPlus 
RUN git clone https://github.com/MrGiovanni/UNetPlusPlus.git
WORKDIR /UNetPlusPlus

# CMAKE install
WORKDIR /
ENV CMAKE_FILE=cmake-3.16.4-Linux-x86_64.tar
COPY ${CMAKE_FILE} /
RUN tar -xvf ${CMAKE_FILE}
ENV CMAKE_DIR=cmake-3.16.4-Linux-x86_64
WORKDIR /${CMAKE_DIR}
RUN cp -r bin /usr/
RUN cp -r share /usr/
RUN cp -r doc /usr/share/
RUN cp -r man /usr/share/
WORKDIR /
RUN rm -r ${CMAKE_DIR}
RUN rm ${CMAKE_FILE}
RUN unset CMAKE_DIR
RUN unset CMAKE_FILE

RUN apt-get install -y build-essential python3-dev \
    cython3 python3-setuptools python3-pip python3-wheel \
    python3-numpy python3-pytest python3-brotli \
    python3-lz4 \
    libz-dev libblosc-dev liblzma-dev liblz4-dev libzstd-dev \
    libpng-dev libwebp-dev libbz2-dev libopenjp2-7-dev libjpeg-turbo8-dev \
    libjxr-dev liblcms2-dev libcharls-dev libaec-dev libbrotli-dev \
    libsnappy-dev libzopfli-dev libgif-dev libtiff-dev libopenjpeg-dev \
    ninja-build

# blosc
WORKDIR /
RUN git clone https://github.com/Blosc/c-blosc.git
WORKDIR /c-blosc
RUN mkdir build
WORKDIR /c-blosc/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..

# python-blosc
WORKDIR /
RUN git clone https://github.com/Blosc/python-blosc.git
WORKDIR /python-blosc
RUN pip install scikit-build
ENV BLOSC_DIR=/usr/local
RUN python setup.py build_clib
RUN python setup.py build_ext --inplace
 
RUN pip install snappy
RUN pip install imagecodecs==2018.12.16
RUN pip install keras==2.2.2 scikit-image pydot simpleitk photutils tifffile libtiff
RUN git submodule update --init --recursive
