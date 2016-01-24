from setuptools import setup
from distutils.extension import Extension
import os

if os.environ.get('ERRORIST_DEVELOPMENT_MODE', None) == 'libpuzzle':
    from Cython.Build import cythonize
    extensions = cythonize('libpuzzle.pyx')
    print('caca')
else:
    extensions = [Extension("libpuzzle", ["libpuzzle.c"])]
    print('pipi')

setup(
    name='libpuzzle',
    version='0.0.1',
    description='Quickly find visually similar images',
    ext_modules=extensions,
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: Implementation :: CPython',
        'Topic :: Software Development :: Libraries :: Python Modules',
    ],
    url='https://lab.errorist.xyz/aio/pyrepo',
    license='MIT'
)
