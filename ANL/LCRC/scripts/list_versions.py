#!/usr/bin/env python

# This scripts allows you to list every version of a package
#
# Usage:
#     spack python list_versions.py <package>
#

import sys

pkg_name = sys.argv[1]
pkg = spack.repo.get(pkg_name)

for v in sorted(pkg.versions, reverse=True):
    print(str(v))

