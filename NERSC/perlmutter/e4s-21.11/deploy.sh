#!/bin/bash
source $CI_PROJECT_DIR/setup-env.sh
e4s_root=/global/common/software/spackecp/perlmutter/e4s-21.11
spack_root=$e4s_root/spack
rm -rf $e4s_root
mkdir -p $e4s_root
cd $e4s_root
git clone https://github.com/spack/spack.git -b e4s-21.11 $spack_root
export SPACK_PYTHON=$(which python)
cd $spack_root
git config user.name "e4s"
git config user.email "e4s@nersc.gov"
git cherry-pick 5d6a9a7
. share/spack/setup-env.sh
spack --version
spack-python --path
spack env create e4s $CI_PROJECT_DIR/spack-configs/perlmutter-e4s-21.11/spack.yaml
spack env activate e4s
spack env st
spack install
spack module tcl refresh --delete-tree -y
spack module lmod refresh --delete-tree -y
spack find

tcl_root=/global/common/software/spackecp/perlmutter/e4s-21.11/modules/tcl/$(spack arch)
lmod_root=/global/common/software/spackecp/perlmutter/e4s-21.11/modules/lmod/cray-sles15-x86_64/Core
module use $tcl_root
ml av
module unuse $tcl_root
module use $lmod_root
ml av
ml gcc/11.2.0
ml nvhpc/21.11
module unuse $lmod_root

spack config get compilers > $SPACK_ROOT/etc/spack/compilers.yaml
spack config get packages > $SPACK_ROOT/etc/spack/packages.yaml
cp $CI_PROJECT_DIR/spack_site_scope/perlmutter/config.yaml $SPACK_ROOT/etc/spack/config.yaml
cp $CI_PROJECT_DIR/spack-configs/perlmutter-e4s-21.11/spack-setup.sh $SPACK_ROOT/bin/spack-setup.sh
cp $CI_PROJECT_DIR/spack-configs/perlmutter-e4s-21.11/spack-setup.csh $SPACK_ROOT/bin/spack-setup.csh
