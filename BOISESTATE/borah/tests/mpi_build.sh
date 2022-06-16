#!/bin/sh

echo "loading base"

module purge
module load borah-base

echo "build oneapi-mpi/gcc test:"

module load intel-oneapi-mpi/2021.6.0/gcc/12.1.0 
mpicc mpi_hello.c -o /tmp/mpi_hello
mpirun -n 2 /tmp/mpi_hello
rm /tmp/mpi_hello
module unload intel-oneapi-mpi/2021.6.0/gcc/12.1.0 

echo

echo "build oneapi-mpi/oneapi test:"

module load intel-oneapi-mpi/2021.6.0/oneapi/2022.1.0
mpicc mpi_hello.c -o /tmp/mpi_hello
mpirun -n 2 /tmp/mpi_hello
rm /tmp/mpi_hello
module unload intel-oneapi-mpi/2021.6.0/oneapi/2022.1.0

echo

echo "build mpich/gcc test:"

module load mpich/3.4.3/gcc/12.1.0
mpicc mpi_hello.c -o /tmp/mpi_hello
mpirun -n 2 /tmp/mpi_hello
rm /tmp/mpi_hello
module unload mpich/3.4.3/gcc/12.1.0

echo

echo "build mpich/oneapi test:"

module load mpich/3.4.3/oneapi/2022.1.0
mpicc mpi_hello.c -o /tmp/mpi_hello
mpirun -n 2 /tmp/mpi_hello
rm /tmp/mpi_hello
module unload mpich/3.4.3/oneapi/2022.1.0

echo

echo "build openmpi/4.1.3/gcc test:"

module load openmpi/4.1.3/gcc/12.1.0
mpicc mpi_hello.c -o /tmp/mpi_hello
mpirun -n 2 /tmp/mpi_hello
rm /tmp/mpi_hello
module unload openmpi/4.1.3/gcc/12.1.0

echo

echo "build openmpi/4.1.3/oneapi test:"

module load openmpi/4.1.3/oneapi/2022.1.0
mpicc mpi_hello.c -o /tmp/mpi_hello
mpirun -n 2 /tmp/mpi_hello
rm /tmp/mpi_hello
module unload openmpi/4.1.3/oneapi/2022.1.0

echo 

echo "Finished mpi_build.sh"
