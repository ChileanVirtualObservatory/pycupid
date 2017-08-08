#!/bin/bash
OS=`uname`
if [ "$OS" = "Linux" ]; then
  #Preparing Manylinux
  yum update -y
  yum groupinstall -y "Development Tools"
  yum install -y csh libXext-devel libXau-devel libX11-devel libXt-devel libxml2-devel ncurses-devel texlive-multirow python-devel Cython

  #Going to repository download cupid libs
  cd /workspace
  wget http://repo.csrg.cl/pycupid-libs/pycupid-lib-linux.zip
  unzip -od pycupid pycupid-lib-linux.zip
  rm pycupid-lib-linux.zip

  #Download and install miniconda
  echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
      wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
      /bin/bash ~/miniconda.sh -b -p /opt/conda && \
      rm ~/miniconda.sh
  export PATH=/opt/conda/bin:$PATH

else
  #Going to repository download cupid libs
  cd /workspace
  sudo brew install gcc
  wget http://repo.csrg.cl/pycupid-libs/pycupid-lib-mac.zip
  unzip -od pycupid pycupid-lib-mac.zip
  rm pycupid-lib-mac.zip
  export PATH=/opt/conda/bin:$PATH
  #Download and install miniconda
  wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O ~/miniconda.sh && \
  sudo /bin/bash ~/miniconda.sh -b -p /opt/conda && \
  rm ~/miniconda.sh
fi


#Create whels
make build_wheels
