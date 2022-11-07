#!/bin/csh

echo "Creating python virtual environment in ${HOME}/.spack-pyenv"
python3 -m venv $HOME/.spack-pyenv
source $HOME/.spack-pyenv/bin/activate.csh
pip install clingo 
pip list
setenv SPACK_PYTHON `which python`
echo "Your python interpreter used by spack is ${SPACK_PYTHON}"
