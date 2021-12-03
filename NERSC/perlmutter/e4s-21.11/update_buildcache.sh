#!/bin/bash
export SPACK_GNUPGHOME=$HOME/.gnupg
E4S_MIRROR=/global/common/software/spackecp/mirrors/perlmutter-e4s-21.11
rm -rf $E4S_MIRROR
for ii in $(spack find --format "yyy {version} /{hash}" |
	    grep -v -E "^(develop^master)" |
	    grep "yyy" |
	    cut -f3 -d" ")
do
  spack buildcache create -af -d $E4S_MIRROR --only=package $ii
done

spack buildcache update-index -d $E4S_MIRROR
