#!/usr/bin/env bash

# This is a wrapper script for `spack_versions_test.py`
# It handles I/O redirection


test_file=spack_versions_test.py
log=develop-versions.txt

spack python $test_file | tee $log
