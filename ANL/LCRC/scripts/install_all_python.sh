#!/usr/bin/env bash

# Installs and activates all Python modules.
# Intended for testing changes to PythonPackage base class
# that affect all Python packages.
#
# In order to make sure that all dependencies are present,
# you want to try installing every package without
# activating them. Once installations succeed, you want to
# try activating all of them to make sure there aren't any
# conflicts.

do_install=true
do_activate=false

trap 'exit' INT

packages=($(spack list py-))

if $do_install
then
    for package in ${packages[@]}
    do
        spack install $package %gcc
    done
fi

if $do_activate
then
    for package in ${packages[@]}
    do
        spack activate $package %gcc
    done
fi

