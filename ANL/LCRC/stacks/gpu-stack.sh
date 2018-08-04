#!/usr/bin/env bash

# GPU Node Software Stack

trap 'exit' INT

# Software with Python support
spack install  hoomd-blue
spack activate hoomd-blue

# Visualization software
spack install paraview

