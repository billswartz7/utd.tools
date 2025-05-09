# syntax = docker/dockerfile:1.0-experimental
FROM centos:centos6 as build
MAINTAINER Tutu Ajayi "ajayi@umich.edu"


# install gcc 7
RUN yum -y install centos-release-scl && \
    yum -y install devtoolset-7 devtoolset-7-libatomic-devel
ENV CC=/opt/rh/devtoolset-7/root/usr/bin/gcc \
    CPP=/opt/rh/devtoolset-7/root/usr/bin/cpp \
    CXX=/opt/rh/devtoolset-7/root/usr/bin/g++ \
    PATH=/opt/rh/devtoolset-7/root/usr/bin:$PATH \
    LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/usr/lib64:/opt/rh/devtoolset-7/root/usr/lib:/opt/rh/devtoolset-7/root/usr/lib64/dyninst:/opt/rh/devtoolset-7/root/usr/lib/dyninst:/opt/rh/devtoolset-7/root/usr/lib64:/opt/rh/devtoolset-7/root/usr/lib:$LD_LIBRARY_PATH

# python 3.6
RUN yum -y install rh-python36
ENV PATH=/opt/rh/rh-python36/root/usr/bin:$PATH


# install other yosys dependencies
RUN yum install -y flex tcl tcl-devel libffi-devel git graphviz readline-devel

# Updating new bison 3+
# https://github.com/YosysHQ/yosys/issues/332
RUN yum install -y wget autoconf && \
    wget https://ftp.gnu.org/gnu/bison/bison-3.0.1.tar.gz && \
    tar -xvzf bison-3.0.1.tar.gz && \
    cd bison-3.0.1 && \
    ./configure && \
    make -j$(nproc) && \
    make install

# download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# git clone yosys
RUN --mount=type=ssh \
    git clone -b standalone git@github.com:The-OpenROAD-Project/BROWN-yosys-abc.git yosys

# build yosys
WORKDIR yosys

RUN sed -i 's/tcl\/tcl.h/tcl.h/g' abc/src/map/scl/sclUtil.c

RUN make PREFIX=/build config-gcc
RUN make PREFIX=/build -j$(nproc)
RUN make PREFIX=/build install

RUN date +"Build Timestamp: %Y-%m-%d_%H-%M-%S" > /build/yosys.version
RUN git rev-parse HEAD >> /build/yosys.version
RUN tar -czf /build.tar.gz /build

# create final yosys image
FROM centos:centos6
RUN yum install -y tcl

COPY --from=build /build /usr/local
COPY --from=build /build.tar.gz /build.tar.gz
