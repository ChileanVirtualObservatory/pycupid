import os
import sys
import subprocess
try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup
from distutils.extension import Extension
from distutils.command.build_ext import build_ext
try:
    from Cython.Build import cythonize
    USE_CYTHON = True
except ImportError:
    USE_CYTHON = False

WRAPPER_DIR = 'pycupid'
CUPID_DIR = 'cupid'

class custom_build_ext(build_ext):
    def run(self):
        # Build CUPID
        subprocess.call(['make'])
        # Then, build wrapper around it.
        build_ext.run(self)

wrapper_sources = [
    'pycupid',
]

cupid_sources = [
    'cupidcfaddpixel.c',
    'cupidcfdeleteps.c',
    'cupidcferode.c',
    'cupidcffreeps.c',
    'cupidcfidl.c',
    'cupidcflevels.c',
    'cupidcfmakeps.c',
    'cupidcfnebs.c',
    'cupidcfscan.c',
    'cupidcfxfer.c',
    'cupidclumpfind.c',
    'cupidconfigD.c',
    'cupidconfigI.c',
    'cupidconfigrms.c',
    'cupiddefminpix.c',
    'cupidfellwalker.c',
    'cupidfwjoin.c',
    'cupidfwmain.c',
    'cupidfwpixelsets.c',
    'cupidgaussclumps.c',
    'cupidgccalcf.c',
    'cupidgccalcg.c',
    'cupidgcchisq.c',
    'cupidgcdump.c',
    'cupidgcfindmax.c',
    'cupidgcfit.c',
    'cupidgclistclump.c',
    'cupidgcmodel.c',
    'cupidgcndfclump.c',
    'cupidgcprofwidth.c',
    'cupidgcsetinit.c',
    'cupidgcupdatearrays.c',
    'cupidndfclump.c',
    'cupidrca.c',
    'cupidrca2.c',
    'cupidrcheckface.c',
    'cupidrcopyline.c',
    'cupidredges.c',
    'cupidreinhold.c',
    'cupidrfill.c',
    'cupidrfillclumps.c',
    'cupidrfillline.c',
    'cupidrinitedges.c',
    'cupidsumclumps.c',
]

ext = '.pyx' if USE_CYTHON else '.c'

wrapper_sources = [os.path.join(WRAPPER_DIR, s + ext) for s in wrapper_sources]
cupid_sources = [os.path.join(CUPID_DIR, "src", s) for s in cupid_sources]

ext_sources = wrapper_sources + cupid_sources

extensions = [
    Extension(
        "pycupid.pycupid",
        ext_sources,
        include_dirs = [os.path.join(WRAPPER_DIR, "star", "include"), 
                        os.path.join(CUPID_DIR, "include")],
        library_dirs = [os.path.join(WRAPPER_DIR, "star", "lib")],
        extra_link_args = ["-Wl,-rpath," + os.path.join("$ORIGIN", "star", "lib")],
        extra_compile_args = ["-std=c99"],
	libraries = [
            "ast", 
            "err_standalone", 
            "hds", 
            "ndf", 
            "pda",
            # AST
            "ast_pal",
            "ast_grf_2.0",
            "ast_grf_3.2",
            "ast_grf_5.6",
            "ast_grf3d",
            "ast_pass2",
            "ast_err",
            "m",
            # MERS
            "chr",
            "emsf",
            "ems",
            "cnf",
            "starmem",
            "pthread",
            "starutil",
            # HDS
            "hdsf",
            "hds",
            # NDF
            "psx",
            "ary",
            "prm",
            "prm_a",
            "ast_ems",
        ],
    ),
]

if USE_CYTHON:
    extensions = cythonize(extensions)


libs = ["libary.so*",
	"libast_ems.so*",
	"libast_err.so*",
	"libast_grf_2.0.so*",
	"libast_grf_3.2.so*",
	"libast_grf3d.so*",
	"libast_grf_5.6.so*",
	"libast_pal.so*",
	"libast.so*",
	"libchr.so*",
	"libcnf.so*",
	"libemsf.so*",
	"libems.so*",
	"liberr_standalone.so*",
	"libhdsf.so*",
	"libhds.so*",
	"libndf.so*",
	"libpda.so*",
	"libprm_a.so*",
	"libprm.so*",
	"libpsx.so*",
	"libstarmem.so*",
	"libstarutil.so*"]

libs = [os.path.join("star","lib",lib) for lib in libs ]


setup(
    name = 'pycupid',
    version = '0.1.1',
    author = u'LIRAE TEAM',
    author_email = 'consultas@lirae.cl',
    packages = ['pycupid'],
    url = 'https://github.com/ChileanVirtualObservatory/pycupid',
    description = 'Python wrappers for Starlink\'s CUPID package',
    ext_modules = extensions,
    package_data = {'pycupid': libs},
    #cmdclass = { build_ext': custom_build_ext, },
    install_requires = {
        'numpy >= 1.11.2',
    }
)
