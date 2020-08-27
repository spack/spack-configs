#!/bin/bash

DIR=2018-11-21

cd /opt/utilities && \
unlink modules && \
unlink module_prefix && \
ln -s ${DIR}/spack/share/spack/modules/linux-centos7-x86_64/gcc-4.8.5 modules && \
ln -s ${DIR}/spack/opt/spack/linux-centos7-x86_64/gcc-4.8.5/environment-modules-3.2.10-c5xiwsdznporezjx7cgtvzsh3as576d3 module_prefix

cd /opt/compilers && \
unlink modules && \
ln -s ${DIR}/spack/share/spack/modules/linux-centos7-x86_64/gcc-4.8.5 modules

cd /opt/software && \
unlink modules && \
ln -s ${DIR}/spack/share/spack/modules/linux-centos7-x86_64 modules
