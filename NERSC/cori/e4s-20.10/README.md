# E4S Facility Pipeline 20.10 release

The E4S Facility Pipeline is based on release 20.10 from https://github.com/E4S-Project/e4s. The spack commit, and constraint specs + versions 
were adopted when building this pipeline. 


# Files

- [spack.yaml](https://software.nersc.gov/NERSC/nersc-e4s/-/blob/spackpipeline/spack.yaml) is used to build E4S stack
- [prod/spack.yaml](https://software.nersc.gov/NERSC/nersc-e4s/-/blob/spackpipeline/prod/spack.yaml) is used to configure E4S for deployment. The `specs`, `packages` and `compiler` section must be copied from [spack.yaml](https://software.nersc.gov/NERSC/nersc-e4s/-/blob/spackpipeline/spack.yaml) 
- [e4s2010.pub](https://software.nersc.gov/NERSC/nersc-e4s/-/blob/spackpipeline/e4s2010.pub) GPG Public Key required for installing packages from buildcache 
- [setclonepath.sh](https://software.nersc.gov/NERSC/nersc-e4s/-/blob/spackpipeline/setclonepath.sh) Creates a random spack directory in $SCRATCH, this was used to get a shorter path length in order to avoid hitting system path length issue. In order to build spack packages into buildcache we need to pad the length so that binaries are relocatable.

# Variables
In https://software.nersc.gov/NERSC/nersc-e4s/-/settings/ci_cd there are few variables that are worth noting

- SPACK_CDASH_AUTH_TOKEN: is a token used to push spack builds to CDASH server at  https://cdash.spack.io/
- SPACK_BUILD_E4S: is a boolean used to invoke spack pipeline. (Default: True)
- DEPLOY_STACK: is a boolean used to control if E4S stack is deployed to production. (Default: False)
- POST_TEST: is a boolean used to run E4S tests after deployment of spack E4S stack. (Default: True)
- REMOVE_BUILDCACHE: is a boolean used to remove buildcache. This is useful if you want to build E4S from source. (Default: False)

If you plan to run pipeline manually using `Run Pipeline` button in https://software.nersc.gov/NERSC/nersc-e4s/-/pipelines/new please consider the following conditions

- Full Rebuild from Source: ``REMOVE_BUILDCACHE = True``
- Deploy Only: ``SPACK_BUILD_E4S = False``, ``DEPLOY_STACK = True``
- Full Rebuild and Deploy: ``REMOVE_BUILDCACHE = True``, ``DEPLOY_STACK = True``
- Build and Deploy and skip Post Tests: ``DEPLOY_STACK = True``, ``POST_TEST = False``


Full Rebuild from source is often desirable to ensure we can rebuild E4S stack from source. This operation can be done once in a while as needed. The deployment operation `DEPLOY_STACK = True` should only be invoked if one needs to redeploy entire stack to production due to change in specs or regeneration of modulefiles. This operation should be done in accordance to maintainance outage as it may affect user if done during normal business hours. 

The gitlab jobs `generate-spack-pipeline` and `build-e4s` need to run together one after the other. The `generate-spack-pipeline` will use `spack ci generate` to generate a gitlab pipeline that is used by `build-e4s` job to spawn off child jobs for concurrent gitlab jobs in multi stages. The `build-e4s` job is responsible for building E4S stack which can be upwards of 100+ child jobs each of them go through job scheduler. By default SPACK_BUILD_E4S is set to `True`, however this pipeline is only triggered if there are changes to `spack.yaml`. According to https://docs.gitlab.com/ee/ci/yaml/#onlyexcept-basic the `only` condition will evaluate if all conditions in `variables` and `changes` are met. Since `build-e4s` job is time-consuming and is a waste of compute resource if all specs are built in build-cache we only trigger this if there is change to `spack.yaml`. If you make change to any other file, the `generate-spack-pipeline` and `build-e4s` will not be triggered. If you click the `Run Pipeline` button https://software.nersc.gov/NERSC/nersc-e4s/-/pipelines/new to trigger pipeline, according to gitlab https://docs.gitlab.com/ee/ci/yaml/#using-onlychanges-with-scheduled-pipelines the `changes` section evaluates to `True` on scheduled pipeline, thus gitlab will run the spack pipeline because `SPACK_BUILD_E4S` is True and `only` section evaluates both conditions to True.

```
generate-spack-pipeline:
  stage: generate
  tags: [cori]
  only:
    variables:
      - $SPACK_BUILD_E4S == "True"
    changes:
      - spack.yaml


build-e4s:
  stage: build
  only:
    variables:
      - $SPACK_BUILD_E4S == "True"
    changes:
      - "spack.yaml"
```

The `deploy-e4s` job won't be triggered by default because `DEPLOY_STACK` is set to False in https://software.nersc.gov/NERSC/nersc-e4s/-/settings/ci_cd under `Variables` section. The only way to trigger `deploy-e4s` is to set `DEPLOY_STACK` variable to `True` when running pipeline manually from https://software.nersc.gov/NERSC/nersc-e4s/-/pipelines/new. 

**Please do not run `deploy-e4s` manually or change `$DEPLOY_STACK == "False"` in the .gitlab-ci.yml, this operation should be done with careful consideration.**

```
deploy-e4s:
  stage: deploy
  tags: [cori]
  only:
    variables:
      - $DEPLOY_STACK == "True"
```


# Access Spack Environment

To access spack environment run the following commands

```
cd /global/common/software/spackecp/e4s-20.10/spack
source share/spack/setup-env.sh
spack env activate e4s-2010
```

Once you are in, you should see spack packages installed when running ``spack find``. 

You can add the module tree to `MODULEPATH` by running the following::

```
module use /global/common/software/spackecp/e4s-20.10/modules/cray-cnl7-haswell/
```

# Access via Modules

The e4s modules are located in `/global/common/software/spackecp/modfile`, if its not in MODULEPATH you can run the following:

```
module use /global/common/software/spackecp/modfile
```

You should see `e4s/20.10` module which will setup a spack environment, and activate spack environment `e4s-2010`


```
siddiq90@cori12:~> module load e4s/20.10
siddiq90@cori12:~> spack env list
==> 1 environments
    e4s-2010  
siddiq90@cori12:~> spack env st
==> In environment e4s-2010
```

You can run `spack find` to see available stack.


```
siddiq90@cori12:~> spack find
==> In environment e4s-2010
==> Root specs
-- cray-cnl7-haswell / intel@19.1.2.254 -------------------------
adios2@2.6.0%intel@19.1.2.254 
aml@0.1.0%intel@19.1.2.254 
arborx@0.9-beta%intel@19.1.2.254 +openmp
bolt@1.0%intel@19.1.2.254 
caliper@2.4.0%intel@19.1.2.254 
darshan-runtime@3.2.1%intel@19.1.2.254 +slurm
darshan-util@3.2.1%intel@19.1.2.254 +bzip2
flit@2.1.0%intel@19.1.2.254 
gasnet@2020.3.0%intel@19.1.2.254 +udp
ginkgo@1.2.0%intel@19.1.2.254 
globalarrays@5.7%intel@19.1.2.254 +blas+lapack+scalapack
gotcha@1.0.3%intel@19.1.2.254 +test
hdf5@1.10.6%intel@19.1.2.254 +cxx+debug+fortran+hl+szip+threadsafe
hypre@2.20.0%intel@19.1.2.254 +mixedint
kokkos@3.2.00%intel@19.1.2.254 +compiler_warnings+debug+debug_dualview_modify_check+examples+hwloc+memkind+numactl+openmp+pic+tests
kokkos-kernels@3.2.00%intel@19.1.2.254 +mkl+openmp
libnrm@0.1.0%intel@19.1.2.254 
libquo@1.3.1%intel@19.1.2.254 
mercury@1.0.1%intel@19.1.2.254 +udreg
mfem@4.1.0%intel@19.1.2.254 +examples+gnutls+gslib+lapack+libunwind+openmp+pumi+threadsafe+umpire
ninja@1.10.1%intel@19.1.2.254 
openpmd-api@0.12.0%intel@19.1.2.254 
papi@6.0.0.1%intel@19.1.2.254 +example+static_tools
parallel-netcdf@1.12.1%intel@19.1.2.254 
pdt@3.25.1%intel@19.1.2.254 +pic
petsc@3.14.0%intel@19.1.2.254 
pumi@2.2.2%intel@19.1.2.254 +fortran
py-libensemble@0.7.0%intel@19.1.2.254 +mpi+nlopt+scipy
py-petsc4py@3.13.0%intel@19.1.2.254 
qthreads@1.14%intel@19.1.2.254 ~hwloc
raja@0.12.1%intel@19.1.2.254 
slepc@3.14.0%intel@19.1.2.254 
stc@0.8.3%intel@19.1.2.254 
sundials@5.4.0%intel@19.1.2.254 +examples-cxx+examples-f2003~examples-f77+f2003+hypre+klu+lapack+openmp
superlu@5.2.1%intel@19.1.2.254 
superlu-dist@6.3.1%intel@19.1.2.254 
swig@4.0.2%intel@19.1.2.254 
sz@2.1.10%intel@19.1.2.254 +fortran+hdf5+netcdf+pastri+python+random_access+time_compression
tasmanian@7.3%intel@19.1.2.254 +blas+fortran+mpi+python+xsdkflags
turbine@1.2.3%intel@19.1.2.254 +hdf5+python
umap@2.1.0%intel@19.1.2.254 +tests
umpire@4.0.1%intel@19.1.2.254 +fortran+numa+openmp
upcxx@2020.3.0%intel@19.1.2.254 
veloc@1.4%intel@19.1.2.254 
zfp@0.5.5%intel@19.1.2.254 

==> 135 installed packages
-- cray-cnl7-haswell / intel@19.1.2.254 -------------------------
adiak@0.1.1      c-blosc@1.17.0         globalarrays@5.7      kokkos@3.2.00          libszip@2.1.1        netcdf-c@4.7.4          pdt@3.25.1            py-scipy@1.5.3        suite-sparse@5.7.2  umpire@4.0.1
adios2@2.6.0     caliper@2.4.0          gmake@4.2.1           kokkos@3.2.00          libtool@2.4.6        nettle@3.4.1            perl@5.30.3           py-setuptools@50.1.0  sundials@5.4.0      umpire@4.0.1
adlbx@0.9.2      cmake@3.16.5           gmp@6.1.2             kokkos-kernels@3.2.00  libunwind@1.4.0      ninja@1.10.1            petsc@3.13.6          py-toml@0.10.0        superlu@5.2.1       upcxx@2020.3.0
aml@0.1.0        darshan-runtime@3.2.1  gnutls@3.6.14         kvtree@1.0.2           libuuid@1.0.3        nlohmann-json@3.9.1     petsc@3.14.0          python@3.8.6          superlu-dist@6.3.0  veloc@1.4
ant@1.10.7       darshan-util@3.2.1     gotcha@1.0.3          libbsd@0.10.0          libzmq@4.3.2         nlopt@2.6.1             pkg-config@0.29.2     qthreads@1.14         superlu-dist@6.3.1  xz@5.2.5
arborx@0.9-beta  diffutils@3.7          gslib@1.0.6           libfabric@1.11.0       lz4@1.9.2            numactl@2.0.12          pumi@2.2.2            raja@0.12.1           swig@4.0.2          zfp@0.5.5
argobots@1.0     er@0.0.3               hdf5@1.10.6           libffi@3.3             m4@1.4.18            openjdk@11.0.2          pumi@2.2.2            rankstr@0.0.2         sz@2.0.2.0          zlib@1.2.11
arpack-ng@3.7.0  exmcutils@0.5.7        hdf5@1.10.7           libiconv@1.16          memkind@1.7.0        openpmd-api@0.12.0      py-cython@0.29.21     readline@8.0          sz@2.1.10           zsh@5.8
autoconf@2.69    expat@2.2.9            hdf5@1.10.7           libnrm@0.1.0           mercury@1.0.1        openssl@1.1.1g          py-libensemble@0.7.0  redset@0.0.3          tasmanian@7.3       zstd@1.4.5
automake@1.16.2  flit@2.1.0             hwloc@2.2.0           libpfm4@4.11.0         metis@5.1.0          papi@6.0.0.1            py-mpi4py@3.0.3       shuffile@0.0.3        tcl@8.6.10
axl@0.3.0        gasnet@2020.3.0        hypre@2.18.2          libpng@1.6.37          mfem@4.1.0           papi@6.0.0.1            py-numpy@1.19.2       slepc@3.14.0          texinfo@6.5
bolt@1.0         gdbm@1.18.1            hypre@2.20.0          libpthread-stubs@0.4   mpark-variant@1.4.0  parallel-netcdf@1.12.1  py-petsc4py@3.13.0    snappy@1.1.8          turbine@1.2.3
boost@1.74.0     gettext@0.21           hypre@2.20.0          libquo@1.3.1           mpich@3.1            parmetis@4.0.3          py-pybind11@2.5.0     sqlite@3.31.1         turbine@1.2.3
bzip2@1.0.8      ginkgo@1.2.0           intel-mkl@19.1.2.254  libsodium@1.0.18       ncurses@6.2          pcre@8.44               py-pyelftools@0.26    stc@0.8.3             umap@2.1.0
```

One can use `module` or `spack load` to load the spack environment. Shown below is the modulefiles that correspond to the spack packages

```

--------------------------------------------------------------------- /global/common/software/spackecp/e4s-20.10/modules/cray-cnl7-haswell/ ----------------------------------------------------------------------
adiak/0.1.1-intel-19.1.2.254-mthjgtd2            hdf5/1.10.6-intel-19.1.2.254-rsmkvdoy            mpich/3.1-intel-19.1.2.254-wcezuimd              qthreads/1.14-intel-19.1.2.254-txp7dp43
adios2/2.6.0-intel-19.1.2.254-n4dtk4qs           hdf5/1.10.7-intel-19.1.2.254-eiobyugs            ncurses/6.2-intel-19.1.2.254-g46l7apt            raja/0.12.1-intel-19.1.2.254-clqqli2d
adlbx/0.9.2-intel-19.1.2.254-xlbmanu5            hdf5/1.10.7-intel-19.1.2.254-pak7dug3            netcdf-c/4.7.4-intel-19.1.2.254-rhqjykkt         rankstr/0.0.2-intel-19.1.2.254-vcnlhhbr
aml/0.1.0-intel-19.1.2.254-plk72jlf              hwloc/2.2.0-intel-19.1.2.254-2gyzs5sq            nettle/3.4.1-intel-19.1.2.254-2jcug5xh           readline/8.0-intel-19.1.2.254-ngqzpr6g
ant/1.10.7-intel-19.1.2.254-l4thkax6             hypre/2.18.2-intel-19.1.2.254-bsglrarm           ninja/1.10.1-intel-19.1.2.254-r72lgss7           redset/0.0.3-intel-19.1.2.254-bscvmphb
arborx/0.9-beta-intel-19.1.2.254-dyxgypgb        hypre/2.20.0-intel-19.1.2.254-pok5xpdu           nlohmann-json/3.9.1-intel-19.1.2.254-a4rrsbub    shuffile/0.0.3-intel-19.1.2.254-mibevhqg
argobots/1.0-intel-19.1.2.254-attdurbf           hypre/2.20.0-intel-19.1.2.254-rexbzxrs           nlopt/2.6.1-intel-19.1.2.254-wpao7epm            slepc/3.14.0-intel-19.1.2.254-vvdrsxyf
arpack-ng/3.7.0-intel-19.1.2.254-mgnqvw4p        intel-mkl/19.1.2.254-intel-19.1.2.254-3qgi4fgi   numactl/2.0.12-intel-19.1.2.254-fnfircl5         snappy/1.1.8-intel-19.1.2.254-24xez3cd
autoconf/2.69-intel-19.1.2.254-a4qx443y          kokkos/3.2.00-intel-19.1.2.254-4ofwm6dx          openjdk/11.0.2-intel-19.1.2.254-qil7jsta         sqlite/3.31.1-intel-19.1.2.254-iuxytzwg
automake/1.16.2-intel-19.1.2.254-n45gaypf        kokkos/3.2.00-intel-19.1.2.254-jamijalq          openpmd-api/0.12.0-intel-19.1.2.254-udgolvev     stc/0.8.3-intel-19.1.2.254-bz4n47ji
axl/0.3.0-intel-19.1.2.254-r2fck4xo              kokkos-kernels/3.2.00-intel-19.1.2.254-p2araoex  openssl/1.1.1g-intel-19.1.2.254-we2bo3po         suite-sparse/5.7.2-intel-19.1.2.254-3x5kozds
bolt/1.0-intel-19.1.2.254-ymgdfuke               kvtree/1.0.2-intel-19.1.2.254-ob5jw5ci           papi/6.0.0.1-intel-19.1.2.254-3hfse4rg           sundials/5.4.0-intel-19.1.2.254-242wjqcw
boost/1.74.0-intel-19.1.2.254-e7zdgsa2           libbsd/0.10.0-intel-19.1.2.254-w4tvpvc2          papi/6.0.0.1-intel-19.1.2.254-u4n73q6y           superlu/5.2.1-intel-19.1.2.254-lmqmz7ov
bzip2/1.0.8-intel-19.1.2.254-5uwgsvyl            libfabric/1.11.0-intel-19.1.2.254-rilhzysw       parallel-netcdf/1.12.1-intel-19.1.2.254-tzhf2347 superlu-dist/6.3.0-intel-19.1.2.254-ws2nqrqd
c-blosc/1.17.0-intel-19.1.2.254-426olrob         libffi/3.3-intel-19.1.2.254-plapxdrp             parmetis/4.0.3-intel-19.1.2.254-pjltphmg         superlu-dist/6.3.1-intel-19.1.2.254-flp5bkyt
caliper/2.4.0-intel-19.1.2.254-msrwlvgo          libiconv/1.16-intel-19.1.2.254-hidqyej2          pcre/8.44-intel-19.1.2.254-eozxjzaz              swig/4.0.2-intel-19.1.2.254-xdqcts7d
cmake/3.16.5-intel-19.1.2.254-zmyp2sa4           libnrm/0.1.0-intel-19.1.2.254-lqmtrfxi           pdt/3.25.1-intel-19.1.2.254-snfwngyt             sz/2.0.2.0-intel-19.1.2.254-xqpf6msr
darshan-runtime/3.2.1-intel-19.1.2.254-pxw7io3x  libpfm4/4.11.0-intel-19.1.2.254-53jyek3i         perl/5.30.3-intel-19.1.2.254-e7wxeve6            sz/2.1.10-intel-19.1.2.254-c2juglm6
darshan-util/3.2.1-intel-19.1.2.254-zcw5xq6e     libpng/1.6.37-intel-19.1.2.254-emjubioq          petsc/3.13.6-intel-19.1.2.254-expurd2b           tasmanian/7.3-intel-19.1.2.254-7rmkges7
diffutils/3.7-intel-19.1.2.254-6gqao3ig          libpthread-stubs/0.4-intel-19.1.2.254-azmwahqt   petsc/3.14.0-intel-19.1.2.254-3sfdqh37           tcl/8.6.10-intel-19.1.2.254-4oofcvju
er/0.0.3-intel-19.1.2.254-fcfjscln               libquo/1.3.1-intel-19.1.2.254-znhzfnct           pkg-config/0.29.2-intel-19.1.2.254-nxb62ywk      texinfo/6.5-intel-19.1.2.254-snawrbph
exmcutils/0.5.7-intel-19.1.2.254-bpoijynb        libsodium/1.0.18-intel-19.1.2.254-l4lmt4z2       pumi/2.2.2-intel-19.1.2.254-nrkupeqc             turbine/1.2.3-intel-19.1.2.254-pfwk2pgn
expat/2.2.9-intel-19.1.2.254-7zsw6ohk            libszip/2.1.1-intel-19.1.2.254-pqwulucm          pumi/2.2.2-intel-19.1.2.254-u7ra5bw2             turbine/1.2.3-intel-19.1.2.254-w4oqxhaj
flit/2.1.0-intel-19.1.2.254-6ufrb2kb             libtool/2.4.6-intel-19.1.2.254-w2kuzsym          py-cython/0.29.21-intel-19.1.2.254-yjdamuq7      umap/2.1.0-intel-19.1.2.254-edgoxhxd
gasnet/2020.3.0-intel-19.1.2.254-5nbbm7ww        libunwind/1.4.0-intel-19.1.2.254-dycdrifr        py-libensemble/0.7.0-intel-19.1.2.254-bn6b6rft   umpire/4.0.1-intel-19.1.2.254-fzo7wz7a
gdbm/1.18.1-intel-19.1.2.254-yzrxncmk            libuuid/1.0.3-intel-19.1.2.254-o532npji          py-mpi4py/3.0.3-intel-19.1.2.254-uprarn3p        umpire/4.0.1-intel-19.1.2.254-jxoi4b3o
gettext/0.21-intel-19.1.2.254-bqwcqalw           libzmq/4.3.2-intel-19.1.2.254-y4oux2w3           py-numpy/1.19.2-intel-19.1.2.254-yb6jdj2c        upcxx/2020.3.0-intel-19.1.2.254-fy3g3xtz
ginkgo/1.2.0-intel-19.1.2.254-i47x2ykg           lz4/1.9.2-intel-19.1.2.254-hiecokwj              py-petsc4py/3.13.0-intel-19.1.2.254-kkpcajdr     veloc/1.4-intel-19.1.2.254-rqqesf7e
globalarrays/5.7-intel-19.1.2.254-r3tzykgy       m4/1.4.18-intel-19.1.2.254-ws5y7ojc              py-pybind11/2.5.0-intel-19.1.2.254-pqflmoh4      xz/5.2.5-intel-19.1.2.254-5wcxpivv
gmake/4.2.1-intel-19.1.2.254-btxjbfbo            memkind/1.7.0-intel-19.1.2.254-gepq4n7u          py-pyelftools/0.26-intel-19.1.2.254-dpismpc4     zfp/0.5.5-intel-19.1.2.254-j5jmvakn
gmp/6.1.2-intel-19.1.2.254-tpii7i4j              mercury/1.0.1-intel-19.1.2.254-uetearts          py-scipy/1.5.3-intel-19.1.2.254-fi7tpgqt         zlib/1.2.11-intel-19.1.2.254-54rpg6zv
gnutls/3.6.14-intel-19.1.2.254-7hewruks          metis/5.1.0-intel-19.1.2.254-lzrewviy            py-setuptools/50.1.0-intel-19.1.2.254-psdd3j7c   zsh/5.8-intel-19.1.2.254-65ncemzz
gotcha/1.0.3-intel-19.1.2.254-nrye7psr           mfem/4.1.0-intel-19.1.2.254-ddu6klv6             py-toml/0.10.0-intel-19.1.2.254-sufxlrxs         zstd/1.4.5-intel-19.1.2.254-r27ln7zo
gslib/1.0.6-intel-19.1.2.254-gw3cc5gu            mpark-variant/1.4.0-intel-19.1.2.254-q2drubnz    python/3.8.6-intel-19.1.2.254-7b664mwe
```

# Configuring GPG Keys

By default spack stores gpg key within `$SPACK_ROOT/opt/spack/gpg` which is not ideal location and normal user won't have
ability to write to this location. Instead we recommend you set `SPACK_GNUPGHOME` to some alternate path preferably default location where 
GPG keys are stored `$HOME/.gnupg`, this way spack can trust gpg key. To get started one can run

```
# bash/sh/zsh users
export SPACK_GNUPGHOME=$HOME/.gnupg

# tcsh/csh users
setenv SPACK_GNUPGHOME $HOME/.gnupg
```

To get started you will need to trust the public key `e4s2010.pub` by running

```
siddiq90@cori03:~> spack gpg trust /global/common/software/spackecp/gpgkeys/e4s2010.pub   
gpgconf: socketdir is '/run/user/92503/gnupg'
gpg: key 0140A256659E0CBD: public key "Spack GPG Key (Spack E4S GPG Key) <shahzebsiddiqui@lbl.gov>" imported
gpg: Total number processed: 1
gpg:               imported: 1
```

You can confirm if gpg key is imported by running the following
```
siddiq90@cori03:~> spack gpg list
gpgconf: socketdir is '/run/user/92503/gnupg'
/global/cscratch1/sd/siddiq90/spack/opt/spack/gpg/pubring.kbx
-------------------------------------------------------------
pub   rsa2048 2020-09-22 [SCEA]
      EA172EB6343D30750A56522F0140A256659E0CBD
uid           [ unknown] Spack GPG Key (Spack E4S GPG Key) <shahzebsiddiqui@lbl.gov>
sub   rsa2048 2020-09-22 [SEA]
```

# Installing from buildcache

Next we create a spack environment named `myproject`

```
$ spack env create myproject
$ spack env activate myproject
```


Next, we add a mirror name `e4s2010` with path to e4s 20.10 buildcache.

```
spack mirror add e4s2010 /global/common/software/spackecp/mirrors/e4s-2020-10/
```

You can run `spack buildcache list` to view packages from buildcache

```
siddiq90@cori12:~> spack buildcache list -L
==> 137 cached builds.
-- cray-cnl7-haswell / intel@19.1.2.254 -------------------------
mthjgtd2r5oe4krozxxunudzuar2anmi adiak@0.1.1            ob5jw5ciq3xqe4xfe275yldusfilrdxq kvtree@1.0.2            u7ra5bw2qent7sedrtmctiqprqtxlt5x pumi@2.2.2
n4dtk4qstwl4v7oc5ue62fbwicooac6q adios2@2.6.0           w4tvpvc2rw54a6iynqtpnqf6tdrjlpxl libbsd@0.10.0           yjdamuq7ygb4oeck2pudey4herxmbra5 py-cython@0.29.21
xlbmanu5q7yivjkfgs3orhhnfqzx532j adlbx@0.9.2            rilhzysw3nqmzmne4t35fmq75zljizgk libfabric@1.11.0        bn6b6rftd5yorkdvy673owsj23g45qic py-libensemble@0.7.0
plk72jlfzm24adcv5kh5ug2a34d2h7nt aml@0.1.0              plapxdrpyavisllsrc7y3xhbxe2vajho libffi@3.3              uprarn3pgxjnxberl4wnneawad3g5r4a py-mpi4py@3.0.3
l4thkax6hkvqfy4um27xie53uxgdnrhp ant@1.10.7             hidqyej2bzcftqdqdrnjzz4t34gmxum6 libiconv@1.16           yb6jdj2catxbebiwgu2sofmwce52g3rj py-numpy@1.19.2
dyxgypgbbjm6rwrhgumds4khev4mhjo7 arborx@0.9-beta        lqmtrfxif4nwpy73v2uaroy5wlbvwu3w libnrm@0.1.0            kkpcajdr2ymqtdzk26nwdmqrlk6qp6nj py-petsc4py@3.13.0
attdurbf4ceww56w5jtgkfbwbngz3pz2 argobots@1.0           53jyek3i3e67rxcqecnrnyu7kspgm6wd libpfm4@4.11.0          pqflmoh4hifi7vlkqtidyd7jxuui4fr7 py-pybind11@2.5.0
mgnqvw4pmcbkfnq6thutgsb4f6fvibe4 arpack-ng@3.7.0        emjubioqplnngdqissvmdinqwxyz7flo libpng@1.6.37           dpismpc4s4vlxhioqo63hgx37rki2knp py-pyelftools@0.26
a4qx443yv4du364g4ygzmugcucy4apmn autoconf@2.69          azmwahqtgcqzolnmd6xcicwp63vghckx libpthread-stubs@0.4    fi7tpgqtimvvstfcfmtg5zszx2fhje7u py-scipy@1.5.3
n45gaypfog4o4atznzyugqu5jssrtkmv automake@1.16.2        znhzfnct6ii3x6b6aqsdp7gtpczilzhr libquo@1.3.1            psdd3j7c4zxwjhq34fviwxeo2fepbynl py-setuptools@50.1.0
r2fck4xokrmpds6yaz4rndh4mkwjngyj axl@0.3.0              l4lmt4z22mqs3l5snnx5sj5kyv3s2mc7 libsodium@1.0.18        sufxlrxsenpikwiazbui4ruu4axyoffo py-toml@0.10.0
ymgdfukem3nj3ysuww7zzx4l6cl2ubif bolt@1.0               pqwulucm4y36tc65mhfrdb7qvou6s66l libszip@2.1.1           7b664mwebrc4inuhwq2uuqvtdaby7nsu python@3.8.6
e7zdgsa2llxdqg3tljxgmeqlsno65xiy boost@1.74.0           w2kuzsymikoq6rwz5gijzu2rcerwohde libtool@2.4.6           txp7dp43nsms4hao2zmiammjgnmli4oc qthreads@1.14
5uwgsvylpch4ae33yjluueeiap5gn5p5 bzip2@1.0.8            dycdrifr4ectiyqvs7zqa357dw2smolx libunwind@1.4.0         clqqli2dirozlsu7ubjuzja5lfqbavgj raja@0.12.1
426olrobicy5gcu5elsaj5rj3a22ft4d c-blosc@1.17.0         o532npjihn3ig6lvsj5srlwc4j26nacq libuuid@1.0.3           vcnlhhbrasabnvigfrriyp7aco4ivdxb rankstr@0.0.2
msrwlvgojsfbvnfbkcqa2gc36b2mvrnr caliper@2.4.0          kotiswvymhhx3jclifqfxxkbdhe5sihz libxml2@2.9.10          ngqzpr6gfkzrdmlx4inufsrelx55sqkd readline@8.0
zmyp2sa4rgaccfjjs5o6atzakxvzxsrk cmake@3.16.5           y4oux2w3vyoihcol4rvtbrwwzajvlrab libzmq@4.3.2            bscvmphb4l32jdtd5yqgeu2i2uejtexd redset@0.0.3
pxw7io3xz4d2vgdvt7mhykq6ii75yrtp darshan-runtime@3.2.1  hiecokwjcrfbt3ogror6zck2fi77wntj lz4@1.9.2               mibevhqgefh5ksmei774q44k4mnvccf7 shuffile@0.0.3
zcw5xq6evw72dmwzlsaenfhkeezs6dkn darshan-util@3.2.1     ws5y7ojcmter3ir37kcdrnr7keldnmzh m4@1.4.18               vvdrsxyfyosxar57wyr3skbdph3gxeyj slepc@3.14.0
6gqao3iglzgchx27qwxuia2agzaujohs diffutils@3.7          gepq4n7u7qsp7upotzq4oakubwv6ouez memkind@1.7.0           24xez3cd42hed7p4se5auwo43s4czdxw snappy@1.1.8
unhmdge6uh3u7nzkujqvp27htqiwodti eigen@3.3.8            uetearts3d6fdj3kplkcsbyqcvk27zzs mercury@1.0.1           iuxytzwgem4nktvd3lxze2rdxyr37hxl sqlite@3.31.1
fcfjsclntniszautt4tviryiwuwcciqo er@0.0.3               lzrewviyrmwpfcrev74g2b6jarhxxaqq metis@5.1.0             bz4n47jid5nuzxkcsipyujxndz7c5esj stc@0.8.3
bpoijynby3kyxovt27ewpargqzwebcup exmcutils@0.5.7        ddu6klv6ts2bx3reox65v5nla7vi4iil mfem@4.1.0              3x5kozdsvgqedfhvsiw6atrts2344bt3 suite-sparse@5.7.2
7zsw6ohkq2bimkji66het26yiyvbpemy expat@2.2.9            q2drubnzjj43ycb7skk5cmwv3rdsdxfi mpark-variant@1.4.0     242wjqcwb7cyoouy4kec4g6pe4vlgupt sundials@5.4.0
6ufrb2kb5wxx6izvmvilafva3hoded6n flit@2.1.0             wcezuimdcknwqlbyqqntc34hsjyew2vz mpich@3.1               lmqmz7ovpqdsntcjj45ndgphkjid3szk superlu@5.2.1
5nbbm7ww5yjhbfe3jso53gsdy6tvnznx gasnet@2020.3.0        g46l7aptxnryyny5rae3it5yseothaev ncurses@6.2             ws2nqrqdku4gwdn5nouffkcd2fy3bdzd superlu-dist@6.3.0
yzrxncmktxb7acb4cxwwrxhywndc73ra gdbm@1.18.1            rhqjykkto5j56hjl6kawyi6axacducoi netcdf-c@4.7.4          flp5bkytnq3z3bsrxqptidceqil6vzxj superlu-dist@6.3.1
bqwcqalwjlfxq7komcwccwy72xyzmpeb gettext@0.21           2jcug5xhi5otyjs627vpmpicwwcbr2ee nettle@3.4.1            xdqcts7dij5r27ws3qkycr7mu7aqhmnf swig@4.0.2
i47x2ykgoorpldb6dx7vnm4hj4zvqtmw ginkgo@1.2.0           r72lgss7g5feu4vc3tievaxvejvcmmfm ninja@1.10.1            xqpf6msr55zlsdj3ypjnt4a3vsmsxzmj sz@2.0.2.0
r3tzykgya2s3trgstzbhk5xdkmv5pkd5 globalarrays@5.7       a4rrsbubtk6vifxbo5wa44dyeaejqw6m nlohmann-json@3.9.1     c2juglm6crs4mwwktos3kwlfq6izyxeb sz@2.1.10
btxjbfboc6nea6uvfobqc6vmkas6a2wa gmake@4.2.1            wpao7epmco7las2tozk3ctjo6w5ztvx2 nlopt@2.6.1             7rmkges7mhab2k2dhg5ofhcpzb2g6wij tasmanian@7.3
tpii7i4j2qja3td2fhezsfxpunilp6lx gmp@6.1.2              fnfircl5wz6imh22fjpiiqx4b4xsgs5x numactl@2.0.12          4oofcvju7y2sho5au7j4hagicjegfyfr tcl@8.6.10
7hewruksanm7mcgwr6uhmpctsufh47c2 gnutls@3.6.14          qil7jstajybz4ymjwowtntdc2dhp6y4l openjdk@11.0.2          snawrbphukf2dqoxsv2hcwljxtwoklr3 texinfo@6.5
nrye7psrhmzalk4lk6ydpuae5xtj7n6j gotcha@1.0.3           udgolvev5smvospkpfecsvfxrher46z3 openpmd-api@0.12.0      pfwk2pgnfmhvypexc25fhaqokqpv6n24 turbine@1.2.3
gw3cc5gufr7y3qbnweorrkjwjha5sdzo gslib@1.0.6            we2bo3pow34zfuwuf73zxl66wvnibjms openssl@1.1.1g          w4oqxhajbyvrzu6q3mwxm46mq6llv6zw turbine@1.2.3
rsmkvdoyj3h4nnjbldlk3ec7cxlmvwex hdf5@1.10.6            u4n73q6ylpazpwshmq46dlnhbjsnyy65 papi@6.0.0.1            edgoxhxd64gablfcvr2cgqvppmsy2o7u umap@2.1.0
eiobyugsflgdwmtgtjegm57ezdltqgnu hdf5@1.10.7            3hfse4rg73jwipmhj7nfn6vxrfdy3tdd papi@6.0.0.1            fzo7wz7aohwhaonqv6u6wqdnahd2jec4 umpire@4.0.1
pak7dug3knqvgfpx2wwqzyctuwl47flw hdf5@1.10.7            tzhf23473u5ny7qcpinebz4trulowohd parallel-netcdf@1.12.1  jxoi4b3orvs25zjymsbq7ooofr4lz37h umpire@4.0.1
2gyzs5sqd2kl2wirh43q7pteatw7eueo hwloc@2.2.0            pjltphmg53dwtdhjs2cdhimruxzu2iwv parmetis@4.0.3          fy3g3xtzfhmkfaowsmtsdp2e26pdaqkq upcxx@2020.3.0
bsglrarmn6s6kfzmymior37ycfo3gsua hypre@2.18.2           eozxjzaz3pa2zz4ifhpppozsdq3s3yph pcre@8.44               rqqesf7epdcp6f5x5a4ushv2p37443om veloc@1.4
rexbzxrsrdz5qhchqgl3lpkk2zd5cniu hypre@2.20.0           snfwngytl3ek5t3v3o2qp6xjp6ibq65y pdt@3.25.1              5wcxpivvgejdkkfw7nmznsy7wxcq4tr7 xz@5.2.5
pok5xpdux5gjoz4kg7dvuzvc2scgrtby hypre@2.20.0           e7wxeve6qjhs72klyazuaexf5tc5suio perl@5.30.3             j5jmvaknihvm434gtuc3yaicey4rvdb4 zfp@0.5.5
3qgi4fgijra6ccedyekkk4svehcdp32g intel-mkl@19.1.2.254   expurd2bglglpsqc5rh4eunmfjvrjokp petsc@3.13.6            54rpg6zvck3wygq7ic3igd5hovdmge2m zlib@1.2.11
jamijalqhe6v6kty5y7l6mbsjnqg7drd kokkos@3.2.00          3sfdqh374ozfjdgqsgdm4gruhmup646o petsc@3.14.0            65ncemzzw2abpn6p4cc4hdltzeazxozq zsh@5.8
4ofwm6dx72icokyd6w3njdacz4elry4m kokkos@3.2.00          nxb62ywk4iczdqllnksvmsgxjseojedk pkg-config@0.29.2       r27ln7zozg4dylairayztkhax57mzvdb zstd@1.4.5
p2araoexmpgveovymuatjm5echl5ewpu kokkos-kernels@3.2.00  nrkupeqcmpci2xslltxy36dfomk6qx6m pumi@2.2.2
```

Next we will install `darshan-runtime` from the buildcache using the hash

```
siddiq90@cori03:~> spack install --cache-only /pxw7io3xz4d2vgdvt7mhykq6ii75yrtp
==> mpich@3.1 : has external module in ['cray-mpich/7.7.10']
[+] /opt/cray/pe/mpt/7.7.10/gni/mpich-intel/16.0
[+] /global/cscratch1/sd/siddiq90/spack/opt/spack/cray-cnl7-haswell/intel-19.1.2.254/zlib-1.2.11-54rpg6zvck3wygq7ic3igd5hovdmge2m
[+] /global/cscratch1/sd/siddiq90/spack/opt/spack/cray-cnl7-haswell/intel-19.1.2.254/darshan-runtime-3.2.1-pxw7io3xz4d2vgdvt7mhykq6ii75yrtp
==> Updating view at /global/cscratch1/sd/siddiq90/spack/var/spack/environments/myproject/.spack-env/view
==> Warning: [/global/cscratch1/sd/siddiq90/spack/var/spack/environments/myproject/.spack-env/view] Skipping external package: mpich@3.1%intel@19.1.2.254~argobots+fortran+hwloc+hydra+libxml2+pci+romio~slurm~verbs+wrapperrpath device=ch3 netmod=tcp pmi=pmi arch=cray-cnl7-haswell/wcezuim

siddiq90@cori03:~> spack find
==> In environment myproject
==> Root specs
darshan-runtime@3.2.1 

-- cray-cnl7-haswell / intel@19.1.2.254 -------------------------
darshan-runtime@3.2.1%intel@19.1.2.254 ~cobalt+mpi~pbs+slurm

==> 3 installed packages
-- cray-cnl7-haswell / intel@19.1.2.254 -------------------------
darshan-runtime@3.2.1  mpich@3.1  zlib@1.2.11
```

# Redeploy stack

As a user, you may want to use the e4s stack to build extra packages. This can be done by recreating spack environment via `spack.lock` file. For this example we will create a spack environment in our home directory since you won't have permission to create an environment in the spack instance. First we navigate to e4s-2010 environment and create an environment using spack.lock

```
spack cd -e e4s-2010
spack env create -d $HOME/e4s-2010-user spack.lock
```

Next let's navigate to the directory and activate environment

```
siddiq90@cori12:/global/common/software/spackecp/e4s-20.10/spack/var/spack/environments/e4s-2010> cd $HOME/e4s-2010-user
siddiq90@cori12:~/e4s-2010-user> ls
spack.lock  spack.yaml
siddiq90@cori12:~/e4s-2010-user> spack env activate .
siddiq90@cori12:~/e4s-2010-user> spack env st
==> Using spack.yaml in current directory: /global/u1/s/siddiq90/e4s-2010-user
```

We should add the buildcache mirror so we can install from buildcache by running

```
siddiq90@cori12:~/e4s-2010-user> spack mirror add e4s2010 /global/common/software/spackecp/mirrors/e4s-2020-10/
```

Let's confirm our active mirrors

```
siddiq90@cori12:~/e4s-2010-user> spack mirror list
spack-public    https://spack-llnl-mirror.s3-us-west-2.amazonaws.com/
e4s2010         file:///global/common/software/spackecp/mirrors/e4s-2020-10
```

Next we install from buildcache by running, this operation will take some time.

```
spack install --cache-only
```


```
siddiq90@cori12:~/e4s-2010-user> spack find
==> In environment /global/u1/s/siddiq90/e4s-2010-user
==> Root specs
-- cray-cnl7-haswell / intel@19.1.2.254 -------------------------
adios2@2.6.0%intel@19.1.2.254 
aml@0.1.0%intel@19.1.2.254 
arborx@0.9-beta%intel@19.1.2.254 +openmp
bolt@1.0%intel@19.1.2.254 
caliper@2.4.0%intel@19.1.2.254 
darshan-runtime@3.2.1%intel@19.1.2.254 +slurm
darshan-util@3.2.1%intel@19.1.2.254 +bzip2
flit@2.1.0%intel@19.1.2.254 
gasnet@2020.3.0%intel@19.1.2.254 +udp
ginkgo@1.2.0%intel@19.1.2.254 
globalarrays@5.7%intel@19.1.2.254 +blas+lapack+scalapack
gotcha@1.0.3%intel@19.1.2.254 +test
hdf5@1.10.6%intel@19.1.2.254 +cxx+debug+fortran+hl+szip+threadsafe
hypre@2.20.0%intel@19.1.2.254 +mixedint
kokkos@3.2.00%intel@19.1.2.254 +compiler_warnings+debug+debug_dualview_modify_check+examples+hwloc+memkind+numactl+openmp+pic+tests
kokkos-kernels@3.2.00%intel@19.1.2.254 +mkl+openmp
libnrm@0.1.0%intel@19.1.2.254 
libquo@1.3.1%intel@19.1.2.254 
mercury@1.0.1%intel@19.1.2.254 +udreg
mfem@4.1.0%intel@19.1.2.254 +examples+gnutls+gslib+lapack+libunwind+openmp+pumi+threadsafe+umpire
ninja@1.10.1%intel@19.1.2.254 
openpmd-api@0.12.0%intel@19.1.2.254 
papi@6.0.0.1%intel@19.1.2.254 +example+static_tools
parallel-netcdf@1.12.1%intel@19.1.2.254 
pdt@3.25.1%intel@19.1.2.254 +pic
petsc@3.14.0%intel@19.1.2.254 
pumi@2.2.2%intel@19.1.2.254 +fortran
py-libensemble@0.7.0%intel@19.1.2.254 +mpi+nlopt+scipy
py-petsc4py@3.13.0%intel@19.1.2.254 
qthreads@1.14%intel@19.1.2.254 ~hwloc
raja@0.12.1%intel@19.1.2.254 
slepc@3.14.0%intel@19.1.2.254 
stc@0.8.3%intel@19.1.2.254 
sundials@5.4.0%intel@19.1.2.254 +examples-cxx+examples-f2003~examples-f77+f2003+hypre+klu+lapack+openmp
superlu@5.2.1%intel@19.1.2.254 
superlu-dist@6.3.1%intel@19.1.2.254 
swig@4.0.2%intel@19.1.2.254 
sz@2.1.10%intel@19.1.2.254 +fortran+hdf5+netcdf+pastri+python+random_access+time_compression
tasmanian@7.3%intel@19.1.2.254 +blas+fortran+mpi+python+xsdkflags
turbine@1.2.3%intel@19.1.2.254 +hdf5+python
umap@2.1.0%intel@19.1.2.254 +tests
umpire@4.0.1%intel@19.1.2.254 +fortran+numa+openmp
upcxx@2020.3.0%intel@19.1.2.254 
veloc@1.4%intel@19.1.2.254 
zfp@0.5.5%intel@19.1.2.254 

==> 135 installed packages
-- cray-cnl7-haswell / intel@19.1.2.254 -------------------------
adiak@0.1.1      darshan-runtime@3.2.1  hdf5@1.10.6            libpfm4@4.11.0        mpich@3.1               perl@5.30.3           qthreads@1.14       sz@2.1.10
adios2@2.6.0     darshan-util@3.2.1     hdf5@1.10.7            libpng@1.6.37         ncurses@6.2             petsc@3.13.6          raja@0.12.1         tasmanian@7.3
adlbx@0.9.2      diffutils@3.7          hdf5@1.10.7            libpthread-stubs@0.4  netcdf-c@4.7.4          petsc@3.14.0          rankstr@0.0.2       tcl@8.6.10
aml@0.1.0        er@0.0.3               hwloc@2.2.0            libquo@1.3.1          nettle@3.4.1            pkg-config@0.29.2     readline@8.0        texinfo@6.5
ant@1.10.7       exmcutils@0.5.7        hypre@2.18.2           libsodium@1.0.18      ninja@1.10.1            pumi@2.2.2            redset@0.0.3        turbine@1.2.3
arborx@0.9-beta  expat@2.2.9            hypre@2.20.0           libszip@2.1.1         nlohmann-json@3.9.1     pumi@2.2.2            shuffile@0.0.3      turbine@1.2.3
argobots@1.0     flit@2.1.0             hypre@2.20.0           libtool@2.4.6         nlopt@2.6.1             py-cython@0.29.21     slepc@3.14.0        umap@2.1.0
arpack-ng@3.7.0  gasnet@2020.3.0        intel-mkl@19.1.2.254   libunwind@1.4.0       numactl@2.0.12          py-libensemble@0.7.0  snappy@1.1.8        umpire@4.0.1
autoconf@2.69    gdbm@1.18.1            kokkos@3.2.00          libuuid@1.0.3         openjdk@11.0.2          py-mpi4py@3.0.3       sqlite@3.31.1       umpire@4.0.1
automake@1.16.2  gettext@0.21           kokkos@3.2.00          libzmq@4.3.2          openpmd-api@0.12.0      py-numpy@1.19.2       stc@0.8.3           upcxx@2020.3.0
axl@0.3.0        ginkgo@1.2.0           kokkos-kernels@3.2.00  lz4@1.9.2             openssl@1.1.1g          py-petsc4py@3.13.0    suite-sparse@5.7.2  veloc@1.4
bolt@1.0         globalarrays@5.7       kvtree@1.0.2           m4@1.4.18             papi@6.0.0.1            py-pybind11@2.5.0     sundials@5.4.0      xz@5.2.5
boost@1.74.0     gmake@4.2.1            libbsd@0.10.0          memkind@1.7.0         papi@6.0.0.1            py-pyelftools@0.26    superlu@5.2.1       zfp@0.5.5
bzip2@1.0.8      gmp@6.1.2              libfabric@1.11.0       mercury@1.0.1         parallel-netcdf@1.12.1  py-scipy@1.5.3        superlu-dist@6.3.0  zlib@1.2.11
c-blosc@1.17.0   gnutls@3.6.14          libffi@3.3             metis@5.1.0           parmetis@4.0.3          py-setuptools@50.1.0  superlu-dist@6.3.1  zsh@5.8
caliper@2.4.0    gotcha@1.0.3           libiconv@1.16          mfem@4.1.0            pcre@8.44               py-toml@0.10.0        swig@4.0.2          zstd@1.4.5
cmake@3.16.5     gslib@1.0.6            libnrm@0.1.0           mpark-variant@1.4.0   pdt@3.25.1              python@3.8.6          sz@2.0.2.0
```


