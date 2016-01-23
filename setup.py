from setuptools import setup
from distutils.extension import Extension
import os

if os.environ.get('ERRORIST_DEVELOPMENT_MODE', None) == 'libpuzzle':
    from Cython.Build import cythonize
    extensions = cythonize('libpuzzle.pyx')
else:
    extensions = [Extension("libpuzzle", ["libpuzzle.c"])]

setup(
    name='libpuzzle',
    ext_modules=extensions
)
