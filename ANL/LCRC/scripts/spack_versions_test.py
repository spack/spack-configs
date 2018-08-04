#!/usr/bin/env python

# This is a script for testing things like `spack versions`
# for every package in Spack. It should be invoked like:
#
#   $ spack python spack_versions_test.py
#
# This has the advantage of only needing to import and set
# up spack a single time, whereas a Bash script would need
# to do this during every iteration.

from __future__ import print_function

import argparse
import sys

from llnl.util import tty
from spack.cmd.versions import *
from spack.package import VersionFetchError
from spack.url import UndetectableNameError, UndetectableVersionError


parser = argparse.ArgumentParser()
setup_parser(parser)

for pkg in spack.repo.all_packages():
    print(pkg.name)

    args = parser.parse_args([pkg.name])

    try:
        versions(parser, args)
    except (VersionFetchError, UndetectableNameError, UndetectableVersionError) as e:
        print('==> Error:', e)

    sys.stdout.flush()
