winget install Python 3
python3 -m venv venv/Scripts/activate
pip install pygame-ce
pip install cython
pip install setuptools
python cysetup.py build_ext --inplace
python cysetupworldgen.py build_ext --inplace
python main.py