# ANL - LCRC Example Spack Configurations

Maintained by Adam J. Stewart ([@adamjstewart](https://github.com/adamjstewart))

These configuration files were used up until 2017 and may be outdated. Consult your LCRC staff for newer copies.

Machines managed by [LCRC](http://www.lcrc.anl.gov/systems/resources/):

1. Bebop (2017 - present)
2. Blues (2012 - present)

This repository includes Spack configuration files and several scripts that can be run to build a particular software stack.

## Configuration Files

These are the typical Spack configuration files we override.

### [linux/compilers.yaml](http://spack.readthedocs.io/en/latest/getting_started.html#compiler-config)

This file contains a list of all compilers that Spack is aware of. Whenever a new compiler is installed, you can add it to this file by running `spack compiler add /path/to/compiler/directory/` or by adding the compiler to your PATH and running `spack compiler find`. `spack add` and `spack find` are actually aliases; both optionally accept a path or search your PATH if none is provided.

#### Intel

For the Intel compilers, we always want to set the following `CFLAGS` and friends:
```yaml
- compiler:
   flags:
      cflags: -axCORE-AVX512,CORE-AVX2,AVX
      cxxflags: -axCORE-AVX512,CORE-AVX2,AVX
      fflags: -axCORE-AVX512,CORE-AVX2,AVX
```
This allows us to build a single executable that can run on our Sandy Bridge, Haswell, and KNL nodes. Make sure you add this to every Intel compiler you add.

#### PGI

The PGI compilers have a similar flag:
```yaml
- compiler:
    flags:
      cflags: -tp=haswell,sandybridge
      cxxflags: -tp=haswell,sandybridge
      fflags: -tp=haswell,sandybridge
```
Unfortunately there isn't one for the KNL nodes yet, so it is recommended to build everything with Intel whenever possible.

#### NAG

The NAG compilers do not include a C/C++ compiler, so you will need to use gcc/g++ instead. In order to use them properly, you should run `spack config edit compilers` and replace `cc: null` and `cxx: null` with the appropriate paths to the GCC compilers.

We also want to set the following flags `FFLAGS`:
```yaml
- compiler:
    flags:
      fflags: -mismatch -dusty
```
The NAG Fortran compilers are very picky about using proper Fortran code. These flags tell them to be less strict and allow us to build more software.

The last setting for NAG is to tell it where its license is. You can set environment variables like so:
```yaml
- compiler:
    environment:
      set:
        NAG_KUSARI_FILE: 'licman1.mcs.anl.gov:'
```

### [config.yaml](http://spack.readthedocs.io/en/latest/config_yaml.html#config-yaml)

This file contains generic Spack settings, such as the root of the installation directory and build directory, the root of the module directories, and whether or not to verify checksums.

### [packages.yaml](http://spack.readthedocs.io/en/latest/build_settings.html#build-settings)

This file contains package-specific settings. You can change the variants that are on by default, the version of a package to install, or the preferred compilers to use. Let's look at an example:

```yaml
packages:
  all:
    providers:
      mpi: [mvapich2, mpich, openmpi]
  hdf5:
    variants: +szip
```

This packages.yaml tells Spack that unless we specify otherwise, the default MPI implementation to use is mvapich2. It also says that we want HDF5's szip variant to default to True. We can of course override these settings on the command line like so:
```
$ spack spec hdf5 -szip +mpi ^openmpi
```

## Software Stacks

The `stacks` directory contains several scripts for installing various software stacks. There is one for the ACME stack, which can be run any time the ACME group asks for the latest and greatest versions of all of their software dependencies. Just make sure to add any new versions to the packages themselves and check if any of the variants have changed. There is also a script for installing all of our Python modules. This can be ran any time a new version of Python is released.

## Testing Scripts

This is where I throw random scripts I wrote for testing and debugging Spack internals. Unless you start modifying internal Spack code, you can probably ignore these.
