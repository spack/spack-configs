#!/usr/bin/env bash

# Installs every version of a package
#
# Usage:
#     install_all_versions.sh <package>
#

trap 'exit' INT

command=install

package=$1

versions=($(spack python list_versions.py $package))

for version in ${versions[@]}
do
    spack $command $package@$version%gcc
done

