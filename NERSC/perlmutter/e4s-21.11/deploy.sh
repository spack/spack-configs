#!/bin/bash
python3 -m venv $CI_PROJECT_DIR/spack-pyenv
source $CI_PROJECT_DIR/spack-pyenv/bin/activate
pip install clingo
which python && pip list
rm -rf ~/.spack/
export SPACK_DISABLE_LOCAL_CONFIG=true
cd $CI_PROJECT_DIR
e4s_root=/global/common/software/spackecp/perlmutter/e4s-21.11
spack_root=$e4s_root/spack
rm -rf $e4s_root
mkdir -p $e4s_root
cd $e4s_root
git clone https://github.com/spack/spack.git -b e4s-21.11 $spack_root
export SPACK_PYTHON=$(which python)
. $spack_root/share/spack/setup-env.sh
spack --version
spack-python --path
spack env create e4s $CI_PROJECT_DIR/spack-configs/perlmutter-e4s-21.11/spack.yaml
spack env activate e4s
spack env st
spack install
spack module tcl refresh --delete-tree -y
spack module lmod refresh --delete-tree -y
spack find

tcl_root=/global/common/software/spackecp/perlmutter/e4s-21.11/modules/tcl/cray-sles15-zen2
lmod_root=/global/common/software/spackecp/perlmutter/e4s-21.11/modules/lmod/cray-sles15-x86_64/Core
module use $tcl_root
ml av
module unuse $tcl_root
module use $lmod_root
ml av
ml gcc/9.3.0
ml nvhpc/21.9
module unuse $lmod_root

cp $CI_PROJECT_DIR/spack-configs/perlmutter-e4s-21.11/site_config/*.yaml $SPACK_ROOT/etc/spack/
