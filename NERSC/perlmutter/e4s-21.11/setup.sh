#!/bin/bash
spack_root=/global/common/software/spackecp/perlmutter/e4s-21.11/spack
source $spack_root/share/spack/setup-env.sh

repo_root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
export SPACK_DISABLE_LOCAL_CONFIG=true
export SPACK_USER_CACHE_PATH=/tmp/spack
spack env activate .
