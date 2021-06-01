# Run this script in the directory where you wish to clone Spack
# This is just an example of how you can install E4S 21.05 Cori Adaptation
# You may want to customize variants, compilers, and externals, in which case...
# ... some packages will require building from source.

#!/bin/bash

if [[ ! -f spack.yaml ]] ; then
  echo Error: No spack.yaml detected in the current directory
  exit 1
fi

if [[ -d ~/.spack ]] ; then
  echo
  echo Warning: existing Spack configuration directory found in $HOME/.spack
  echo Warning: if package preferences are set in other scopes, it can prevent proper concretization
  echo Warning: existing mirrors may cause incorrect binaries to be pulled
  echo
fi

git clone https://github.com/spack/spack --branch e4s-21.05 --depth=1

. spack/share/spack/setup-env.sh

spack mirror list | grep E4S || spack mirror add E4S https://cache.e4s.io/21.05
spack buildcache keys -it

time spack -e . concretize -f | tee dag

time spack -e . install --cache-only