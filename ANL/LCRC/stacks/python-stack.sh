#!/usr/bin/env bash

# Python Software Stack

trap 'exit' INT

packages=(
    # Common python modules
    py-numpy
    py-scipy
    py-matplotlib

    # Various other python modules
    py-mpi4py
    py-phonopy
    py-meep
    py-sncosmo
    py-openpyxl

    # Spack testing dependencies
    py-flake8
    py-sphinx
    py-coverage

    # Software with python support
    cantera
    pagmo
    psi4
)

for package in "${packages[@]}"
do
    spack install  $package
done

