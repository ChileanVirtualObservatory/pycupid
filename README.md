# [**PyCupid**](http://pycupid.readthedocs.io/en/latest/) - Python wrappers for Starlink's CUPID package


<p align="center">
  <img src="https://www.chivo.cl/media/service-images/Pycupid_v3.png" width="300">
</p>


CUPID is part of the [**Starlink Software Collection**](http://www.starlink.ac.uk/),
it provides a set of commands that identify and analyse clumps of emission within 1-,
2- and 3-dimensional data arrays.

This module aims to serve as an interface between CUPID implementation (C and
Fortran) and Python. As such, users can simply import the module and use CUPID
functions as if they were implemented in Python. 

# Documentation 

The lastest documentation can be found in [here](http://pycupid.readthedocs.io/en/latest/).

# Installation

To install PyCupid just run:

```
pip install pycupid
```
Wheels for PyCupid are only available for python 2.7, 3.4, 3.5 and 3.6. Installation on newer version (3.7, 3.8) [fails](https://github.com/ChileanVirtualObservatory/pycupid/issues/16#issue-503170953)!  
Create a virtual environment with an older python version if necessary.

For developers we have a wiki to compile pycupid in [*Manylinux*](https://github.com/ChileanVirtualObservatory/pycupid/wiki)
