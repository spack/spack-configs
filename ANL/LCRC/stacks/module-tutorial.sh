#!/usr/bin/env bash

# Packages used in the Modules Tutorial:
# http://spack.readthedocs.io/en/latest/tutorial_modules.html#modules-tutorial

trap 'exit' INT

compilers=(
    %gcc
    %intel
)

mpis=(
    ^mpich
    ^openmpi
)

lapacks=(
    ^openblas
    ^netlib-lapack
)

for compiler in "${compilers[@]}"
do
    for lapack in "${lapacks[@]}"
    do
        # Serial installs
        spack install py-scipy $compiler $lapack

        # Parallel installs
        for mpi in "${mpis[@]}"
        do
            spack install netlib-scalapack $compiler $lapack $mpi
        done
    done
done

