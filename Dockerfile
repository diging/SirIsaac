FROM ubuntu:latest
RUN apt-get update && apt-get -y update
FROM python:2
ARG DEBIAN_FRONTEND=noninteractive
RUN mkdir app
WORKDIR /app
RUN pip install numpy
RUN pip install jupyter notebook
RUN git clone -b mpi4py-convesion https://github.com/diging/SloppyCell.git
RUN pip install -e SloppyCell/
RUN git clone -b pypar-check  https://github.com/diging/SirIsaac.git
RUN pip install -e SirIsaac/
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
