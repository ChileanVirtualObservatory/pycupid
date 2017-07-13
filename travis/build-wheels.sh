#!/bin/bash

#Preparing Manylinux
yum update -y
yum groupinstall -y "Development Tools"
yum install -y csh libXext-devel libXau-devel libX11-devel libXt-devel libxml2-devel ncurses-devel texlive-multirow python-devel Cython

#Going to repository and build cupid
cd /workspace
make -j 2.5

#Download and install miniconda
echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.14-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

export PATH=/opt/conda/bin:$PATH

#Create whels
make build_wheels
ls dist
