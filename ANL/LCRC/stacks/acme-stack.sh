#!/usr/bin/env bash

# ACME Software Stack

trap 'exit' INT

#command=spec
command=install

compilers=(
    %gcc
    %intel
    %pgi
    %nag
)

mpis=(
    ^mvapich2
    ^mpich
    ^openmpi
)

for compiler in "${compilers[@]}"
do
    # Serial installs
    spack $command szip           $compiler
    spack $command hdf            $compiler
    spack $command hdf5           $compiler
    spack $command netcdf         $compiler
    spack $command netcdf-fortran $compiler

    # Parallel installs
    for mpi in "${mpis[@]}"
    do
        spack $command $mpi            $compiler
        spack $command hdf5~cxx+mpi    $compiler $mpi
        spack $command parallel-netcdf $compiler $mpi
        spack $command netcdf+mpi+parallel-netcdf $compiler ^hdf5~cxx+mpi $mpi
        spack $command netcdf-fortran  $compiler ^netcdf+mpi+parallel-netcdf ^hdf5~cxx+mpi $mpi
    done
done

