# Copyright 2013-2020 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack import *


class Nccmp(Package, SourceforgePackage):
    """Compare NetCDF Files"""
    homepage = "http://nccmp.sourceforge.net/"
    url = "https://gitlab.com/remikz/nccmp/-/archive/1.8.7.0/nccmp-1.8.7.0.tar.gz"

    version('1.8.7.0', sha256='a864c4724200d005bf8bc925da717ef7c69b0b0a14730c09540e5a86daad8988')
    version('1.8.2.0', sha256='7f5dad4e8670568a71f79d2bcebb08d95b875506d3d5faefafe1a8b3afa14f18')

    depends_on('netcdf-c')

    def install(self, spec, prefix):
        # Configure says: F90 and F90FLAGS are replaced by FC and
        # FCFLAGS respectively in this configure, please unset
        # F90/F90FLAGS and set FC/FCFLAGS instead and rerun configure
        # again.
        env.pop('F90', None)
        env.pop('F90FLAGS', None)

        configure('--prefix=%s' % prefix)
        make()
        #make("check")
        make("install")
