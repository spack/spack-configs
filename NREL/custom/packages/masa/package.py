# Copyright 2013-2020 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack import *


class Masa(AutotoolsPackage):
    """MASA (Manufactured Analytical Solution Abstraction) is a library
       written in C++ (with C, python and Fortran90 interfaces) which
       provides a suite of manufactured solutions for the software
       verification of partial differential equation solvers in multiple
       dimensions."""

    homepage = "https://github.com/manufactured-solutions/MASA"
    git      = "https://github.com/manufactured-solutions/MASA.git"

    version('master', branch='master')

    variant('fortran', default=True,
            description='Compile with Fortran interfaces')
    variant('python',  default=True,
            description='Compile with Python interfaces')

    depends_on('autoconf', type='build')
    depends_on('automake', type='build')
    depends_on('libtool',  type='build')
    depends_on('swig',     type='build')
    depends_on('python', when='+python')
    depends_on('metaphysicl')

    patch('stdcpp11.patch', sha256='ce612115e2493b1884a01e8ba660b49dd60cb7b1aefeb7c21d1fdab1f925f60b')

    def configure_args(self):
        options = []

        options.extend([
            'CXXFLAGS="-std=c++11"',
            '--with-metaphysicl=%s' % self.spec['metaphysicl'].prefix
        ])

        if '+fortran' in self.spec:
            options.extend(['--enable-fortran-interfaces'])

        if '+python' in self.spec:
            options.extend(['--enable-python-interfaces'])

        return options
