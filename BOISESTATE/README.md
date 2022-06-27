# Spack configurations used to stand up stacks at Boise State University 

(C) 2022 Frank Willmore, et. al. Boise State Univesity Reseach Computing
frankwillmore@boisestate.edu

Note that the environment (spack.yaml) files as checked in are named \_spack.yaml, since spack rewrites and reorders spack.yaml as it digests the environment. \_spack.yaml can be regarded as the master, and copied to spack.yaml when processing an environment. There is a .gitignore under BOISESTATE set to ignore spack.yaml's under this tree.

Base configurations provided gcc and oneapi compilers, cuda built with these compilers, mpich, openmpi, and intel-oneapi-mpi MPI stacks built with these compilers, and modules that will load the correct cuda build and compiler when loading the MPI.

Copies of modules are checked in as well, as these needed to be modified considerably from the original generated modules. 


