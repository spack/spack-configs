This git repository contains all local settings for spack at ALCF. It is versioned separately from spack and is maintained as a separate repository.

The Makefile contains targets for installation and testing:

Targets: 

 - install: yamls and modules 
 - install-yamls: just configuration 
 - install-modules: just modules 
 - multiuser-test: requires sudo, will build and install the multiuser test
 - check: runs all installation tests

Makefile targets accept the following settings (default values shown):

SPACK_ROOT=/soft/spack/spack-dev
MODULE_DIR=/soft/environment/modules/modulefiles
MODULE_FILE=latest
ALCF_SYSTEM_NAME ?= theta
CURATED_MODULES_DIR=/soft/spack/alcf/theta/modulefiles/spack-curated

Note that the multiuser-test target contains a suid executable to run as the installationtest user and must be installed as root. All other targets should be run as the spack service user. 

Loading the 'spack' module is the supported way to use ALCF spack. 
Loading the 'spack-curated' module is the supported way to access curated spack-built software. 

Contributions, particularly to package.py files for ALCF-specific build issues, are encouraged and should be submitted as pull requests to the spack package repo(s) contained within this git repo at alcf/repos. 

Example install workflow:

spack$ SPACK_ROOT=/path/to/my/spack make install-yamls 

spack$ SPACK_ROOT=/path/to/my/spack make install-modules 

spack$ sudo make multiuser-test 

spack$ SPACK_ROOT=/path/to/my/spack make check

