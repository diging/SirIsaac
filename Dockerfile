FROM ubuntu:latest
RUN apt-get update && apt-get -y update
FROM python:2
ARG DEBIAN_FRONTEND=noninteractive
RUN mkdir app
RUN apt-get -q update \
    && apt-get install -y \
    gcc gfortran binutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /app
RUN useradd --create-home --home-dir /home/docker --shell /bin/bash docker
RUN usermod -a -G sudo docker
RUN echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
COPY o.tar.bz2 /app
RUN wget http://www.open-mpi.org/software/ompi/v4.1/downloads/openmpi-4.1.1.tar.gz
RUN tar xzvf openmpi-4.1.1.tar.gz
WORKDIR openmpi-4.1.1
RUN ./configure --prefix=/usr/local/openmpi
RUN make all
RUN make install
RUN MPI_DIR=/usr/local/openmpi
RUN export LD_LIBRARY_PATH=$MPI_DIR/lib:$LD_LIBRARY_PATH
WORKDIR /app
RUN apt-get -y update &&  apt -y install libopenmpi-dev
RUN pip install mpi4py
RUN pip install numpy
RUN pip install jupyter notebook
RUN git clone -b mpi4py-convesion https://github.com/diging/SloppyCell.git
RUN pip install -e SloppyCell/
RUN git clone -b pypar-check  https://github.com/diging/SirIsaac.git
RUN pip install -e SirIsaac/
USER docker
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
