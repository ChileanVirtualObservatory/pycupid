import numpy as np
import numpy.ma as ma
cimport cupid
from libc.stdio cimport printf
from cpython.mem cimport PyMem_Malloc, PyMem_Free

cdef double[::1] gc(double[::1] data, double[::1] variance,
                    int[::1] shape, cupid.AstKeyMap *config, 
                    double rms, int velax):
    cdef:
        int[::1] _slbnd = np.zeros(shape.size, dtype=np.int32)

    cdef:
        int dtype = cupid.CUPID__DOUBLE
        int ndim = shape.size
        int *slbnd = &_slbnd[0]
        int *subnd = <int *> &shape[0]
        void *ipd = &data[0]
        double *ipv = &variance[0]
        double beamcorr[3]
        int status = 0

    cdef:
        cupid.HDSLoc *ndfs
        double *ipo
        int el

    ndfs = cupid.cupidGaussClumps(dtype, ndim, slbnd, subnd,
                                  ipd, ipv, rms, config, velax,
                                  beamcorr, &status)

    if ndfs is NULL:
        return None
    
    el = data.size
    ipo = <double *> PyMem_Malloc(el * sizeof(double))
    cupid.cupidSumClumps(dtype, ipd, ndim, slbnd, subnd, el, ndfs,
                         NULL, <void *> ipo, "GAUSSCLUMPS", &status)

    return <double[:el]> ipo

cdef int[::1] rh(double[::1] data, double[::1] variance,
                 int[::1] shape, cupid.AstKeyMap *config, 
                 double rms, int velax):
    cdef:
        int[::1] _slbnd = np.zeros(shape.size, dtype=np.int32)

    cdef:
        int dtype = cupid.CUPID__DOUBLE
        int ndim = shape.size
        int *slbnd = &_slbnd[0]
        int *subnd = <int *> &shape[0]
        void *ipd = &data[0]
        double *ipv = &variance[0]
        double beamcorr[3]
        int status = 0

    cdef:
        cupid.HDSLoc *ndfs
        int *ipo
        int el

    ndfs = cupid.cupidReinhold(dtype, ndim, slbnd, subnd,
                               ipd, ipv, rms, config, velax,
                               beamcorr, &status)
    
    if ndfs is NULL:
        return None
    
    el = data.size
    ipo = <int *> PyMem_Malloc(el * sizeof(int))
    cupid.cupidSumClumps(dtype, ipd, ndim, slbnd, subnd, el, ndfs,
                         NULL, <void *> ipo, "REINHOLD", &status)

    return <int[:el]> ipo


cdef int[::1] cf(double[::1] data, double[::1] variance,
                 int[::1] shape, cupid.AstKeyMap *config, 
                 double rms, int velax, int perspectrum):
    cdef:
        int[::1] _slbnd = np.zeros(shape.size, dtype=np.int32)

    cdef:
        int dtype = cupid.CUPID__DOUBLE
        int ndim = shape.size
        int *slbnd = &_slbnd[0]
        int *subnd = <int *> &shape[0]
        void *ipd = &data[0]
        double *ipv = &variance[0]
        double beamcorr[3]
        int backoff
        int status = 0

    cdef:
        cupid.HDSLoc *ndfs
        int *ipo
        int el

    ndfs = cupid.cupidClumpFind(dtype, ndim, slbnd, subnd,
                                ipd, ipv, rms, config, velax,
                                perspectrum, beamcorr, 
                                &backoff, &status)
    
    if ndfs is NULL:
        return None
    
    el = data.size
    ipo = <int *> PyMem_Malloc(el * sizeof(int))
    cupid.cupidSumClumps(dtype, ipd, ndim, slbnd, subnd, el, ndfs,
                         NULL, <void *> ipo, "CLUMPFIND", &status)

    return <int[:el]> ipo


cdef int[::1] fw(double[::1] data, double[::1] variance,
                 int[::1] shape, cupid.AstKeyMap *config, 
                 double rms, int velax, int perspectrum):
    cdef:
        int[::1] _slbnd = np.zeros(shape.size, dtype=np.int32)

    cdef:
        int dtype = cupid.CUPID__DOUBLE
        int ndim = shape.size
        int *slbnd = &_slbnd[0]
        int *subnd = <int *> &shape[0]
        void *ipd = &data[0]
        double *ipv = &variance[0]
        double beamcorr[3]
        int status = 0

    cdef:
        cupid.HDSLoc *ndfs
        int *ipo
        int el

    ndfs = cupid.cupidFellWalker(dtype, ndim, slbnd, subnd,
                                 ipd, ipv, rms, config, velax,
                                 perspectrum, beamcorr, &status)
    
    if ndfs is NULL:
        return None
    
    el = data.size
    ipo = <int *> PyMem_Malloc(el * sizeof(int))
    cupid.cupidSumClumps(dtype, ipd, ndim, slbnd, subnd, el, ndfs,
                         NULL, <void *> ipo, "FELLWALKER", &status)

    return <int[:el]> ipo

def gaussclumps(data, rms, config=None, variance=None, velax=0):
    """
    Gauss Clumping Algorithm
    
    Parameters
    ----------
    data: numpy.array
        Input data with the 2 or 3 dimensional image to analyze.

    rms: float
        Estimation of the RMS of noise in data. It is used to configure
        other parameters of the algorithm.

    config: dict (default=None)
        Python dictionary containing the parameters of the algorithm:
        config["PARAMETER_NAME"] = PARAMETER_VALUE. If set to None, 
        then default values of the algorithm will be used. 

    variance: float
        Variance of the data.

    velax: int
        Integer value indicate which is the speed/frequency axis in the cube.

    Returns
    -------
    numpy.array with integer values (numpy.int32) containing the Clump Assignment Array (CAA).
    """
    clumps = _findclumps("GAUSSCLUMPS", data, variance, config, rms, velax)
    return clumps

def reinhold(data, rms, config=None, variance=None, velax=0):
    """
    Reinhold Clumping Algorithm
    
    Parameters
    ----------
    data: numpy.array
        Input data with the 2 or 3 dimensional image to analyze.

    rms: float
        Estimation of the RMS of noise in data. It is used to configure
        other parameters of the algorithm.

    config: dict (default=None)
        Python dictionary containing the parameters of the algorithm:
        config["PARAMETER_NAME"] = PARAMETER_VALUE. If set to None, 
        then default values of the algorithm will be used. 

    variance: float
        Variance of the data.

    velax: int
        Integer value indicate which is the speed/frequency axis in the cube.

    Returns
    -------
    numpy.array with integer values (numpy.int32) containing the Clump Assignment Array (CAA).
    """
    clumps = _findclumps("REINHOLD", data, variance, config, rms, velax)
    return clumps

def clumpfind(data, rms, config=None, variance=None, velax=0, perspectrum=0):
    """
    Clumping Clumping Algorithm
    
    Parameters
    ----------
    data: numpy.array
        Input data with the 2 or 3 dimensional image to analyze.

    rms: float
        Estimation of the RMS of noise in data. It is used to configure
        other parameters of the algorithm.

    config: dict (default=None)
        Python dictionary containing the parameters of the algorithm:
        config["PARAMETER_NAME"] = PARAMETER_VALUE. If set to None, 
        then default values of the algorithm will be used. 

    variance: float
        Variance of the data.

    velax: int
        Integer value indicate which is the speed/frequency axis in the cube.

    Returns
    -------
    numpy.array with integer values (numpy.int32) containing the Clump Assignment Array (CAA).
    """
    clumps = _findclumps("CLUMPFIND", data, variance, config, rms, velax, perspectrum)
    return clumps

def fellwalker(data, rms, config=None, variance=None, velax=0, perspectrum=0):
    """
    FellWalker Clumping Algorithm
    
    Parameters
    ----------
    data: numpy.array
        Input data with the 2 or 3 dimensional image to analyze.

    rms: float
        Estimation of the RMS of noise in data. It is used to configure
        other parameters of the algorithm.

    config: dict (default=None)
        Python dictionary containing the parameters of the algorithm:
        config["PARAMETER_NAME"] = PARAMETER_VALUE. If set to None, 
        then default values of the algorithm will be used. 

    variance: float
        Variance of the data.

    velax: int
        Integer value indicate which is the speed/frequency axis in the cube.

    Returns
    -------
    numpy.array with integer values (numpy.int32) containing the Clump Assignment Array (CAA).
    """
    clumps = _findclumps("FELLWALKER", data, variance, config, rms, velax, perspectrum)
    return clumps

def _findclumps(method, data, variance, config, rms, velax=0, perspectrum=0):
    cdef:
        cupid.AstKeyMap *aconfig = cupid.astKeyMap(" ")

    if config:
        for key, value in config.items():
            key = bytes(key, "ascii")
            if type(value) is int:
                cupid.astMapPut0I(aconfig, key, value, NULL)
            elif type(value) is float:
                cupid.astMapPut0D(aconfig, key, value, NULL)
            elif type(value) is str:
                cupid.astMapPut0C(aconfig, key, bytes(value, "ascii"), NULL)
            else:
                raise ValueError("Value for key " + repr(key.decode()) 
                                 + " should be of type int, float or str")

    shape = np.asarray(data.shape, dtype=np.int32)
    ubound = shape - 1
    if variance:
        if not np.array_equal(variance.shape, shape):
            raise ValueError("""Variance array must have the same 
                                shape as data array""")
        variance = variance.flatten(order='F')
    else:
        variance = np.zeros(data.size, dtype=np.float64)

    if isinstance(data, ma.MaskedArray):
        data = data.filled(fill_value=0) #maybe fill_value should be a parameter
    if data.dtype != np.dtype('float64'):
        data = data.astype(np.float64)
    data = data.flatten(order='F')

    if method == "GAUSSCLUMPS":
        clumps = gc(data, variance, ubound, aconfig, rms, velax)
    elif method == "REINHOLD":
        clumps = rh(data, variance, ubound, aconfig, rms, velax)
    elif method == "CLUMPFIND":
        clumps = cf(data, variance, ubound, aconfig, rms, velax, perspectrum)
    elif method == "FELLWALKER":
        clumps = fw(data, variance, ubound, aconfig, rms, velax, perspectrum)
    else:
        raise ValueError("Clumping method " + repr(method) + "is not defined")

    return np.reshape(clumps, shape, order='C') if clumps else None
