#!/bin/bash

echo "Creating python virtual environment in ${HOME}/.spack-pyenv"
python3 -m venv $HOME/.spack-pyenv
source $HOME/.spack-pyenv/bin/activate
pip install clingo 1>/dev/null 
pip list
export SPACK_PYTHON=$(which python)
echo "Your python interpreter used by spack is ${SPACK_PYTHON}"
