.. PyCupid documentation master file, created by
   sphinx-quickstart on Fri May 19 21:16:03 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to PyCupid's documentation!
===================================

Welcome to **PyCupid** proyect: Python wrappers for Starlink's CUPID package.  CUPID is part of the Starlink Software Collection
<http://www.starlink.ac.uk/>, it provides a set of commands that identify and analyse clumps of emission within 2- and 3-dimensional data arrays.

This module aims to be a clean interface between CUPID implementation (C and Fortran) and Python. As such, users can simply import the module and use CUPID functions as if they were implemented in Python.

For examples look into our `Ipython Notebook Repository`_.

.. _Ipython Notebook Repository: https://github.com/ChileanVirtualObservatory/pycupid/tree/master/notebooks


Contents
========

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   pycupid
   pycupid_usage

Installation
============

To use PyCupid Wrappers you can install it directly from **PyPI** (recommended):

.. code-block:: bash      

        pip install pycupid

or clone the `project repository`_ and run:

.. _project repository: https://github.com/ChileanVirtualObservatory/pycupid

.. code-block:: bash
        
        python setup.py build install

which is not recommended since it requires to clone the whole Starlink project and compile CUPID. 


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
