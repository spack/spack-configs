# Spack configurations used to stand up stacks at Boise State University 

(C) 2022 Frank Willmore, et. al. Boise State Univesity Reseach Computing
frankwillmore@boisestate.edu

Release notes:

2022-05-13:

- MPICH wrappers do not get the correct value of 'wl' set (it's empty) and needs to be edited and set manually to "Wl" when building with OneAPI
- There were PR's merged to spack/develop { https://github.com/spack/spack/pull/28504 https://github.com/spack/spack/issues/30557 } that broke functionality needed for iterating over install configurations, and which required reverting to a previous commit and cherry-picking updated packages when working through this installation. 
- There was an erroneous/missing path in the intel-oneapi-compiler wrappers that required manuallly adding a path: 

```
    熊俊傑@borah-login:/cm/shared/software/opt/linux-centos7-x86_64/oneapi-2022.1.0/intel-oneapi-mpi-2021.6.0-qbicvxguxm2j3xaowxu3ogddo3ghh3zk/mpi/2021.6.0$ mkcd mpi
    熊俊傑@borah-login:/cm/shared/software/opt/linux-centos7-x86_64/oneapi-2022.1.0/intel-oneapi-mpi-2021.6.0-qbicvxguxm2j3xaowxu3ogddo3ghh3zk/mpi/2021.6.0/mpi$ ln -s .. 2021.4.0 
```

  This may be related to the installer having an older version of intel-oneapi-compilers due to the previous issue above, but this was not investigated. 



