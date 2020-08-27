# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#Pure modules sans Spack
export MODULE_PREFIX=/opt/utilities/modules_prefix
export PATH=${MODULE_PREFIX}/bin:${PATH}
module() { eval $(${MODULE_PREFIX}/bin/modulecmd $(basename ${SHELL}) $*); }

#Load some base modules
MODULES=modules
COMPILER=gcc-7.4.0
#COMPILER=intel-18.0.4
module purge
module unuse ${MODULEPATH}
module use /opt/compilers/${MODULES}
module use /opt/utilities/${MODULES}
module use /opt/software/${MODULES}/gcc-7.4.0
module load unzip
module load patch
module load bzip2
module load cmake
module load git
module load flex
module load bison
module load wget
module load bc
module load binutils
module load python
