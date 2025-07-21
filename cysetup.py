from setuptools import setup
from Cython.Build import cythonize

setup(
    name="cyfunctions",
    ext_modules=cythonize("cyfunctions.pyx", compiler_directives={"language_level": "3"}),
)