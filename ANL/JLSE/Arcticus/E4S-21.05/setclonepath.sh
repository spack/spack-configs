#!/bin/bash

export RAND=$(python -c "import string; import random; print(''.join(random.choice(string.ascii_uppercase+string.ascii_lowercase) for _ in range(8)))")
#export SPACK_CLONE_PATH=$CFS/m3503/spack-${RAND}
#export SPACK_CLONE_PATH=/run/user/20661/spack-${RAND}
export SPACK_CLONE_PATH=/tmp/spack-${RAND}
