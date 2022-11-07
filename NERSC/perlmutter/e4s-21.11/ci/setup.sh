#!/bin/bash
python3 -m venv $CI_PROJECT_DIR/spack-pyenv
source $CI_PROJECT_DIR/spack-pyenv/bin/activate    
pip install clingo  
python3 -c "import clingo; print(clingo.__file__)"
export SPACK_PYTHON=$(which python3)
which python3 && pip list      
rm -rf ~/.spack/
export SPACK_DISABLE_LOCAL_CONFIG=true
git clone -b e4s-21.11 $SPACK_REPO 
spack/share/spack/setup-env.sh
spack-python --path
cd $CI_PROJECT_DIR
spack env activate -d spack-configs/perlmutter-e4s-21.11/ci
