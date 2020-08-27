# Copyright 2013-2020 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack import *
import os


class Paraview(CMakePackage, CudaPackage):
    """ParaView is an open-source, multi-platform data analysis and
    visualization application."""

    homepage = 'https://www.paraview.org'
    url      = "https://www.paraview.org/files/v5.7/ParaView-v5.7.0.tar.xz"
    list_url = "https://www.paraview.org/files"
    list_depth = 1
    git      = "https://gitlab.kitware.com/paraview/paraview.git"

    maintainers = ['chuckatkins', 'danlipsa']

    version('develop', branch='master', submodules=True)
    version('5.8.1', sha256='7653950392a0d7c0287c26f1d3a25cdbaa11baa7524b0af0e6a1a0d7d487d034')
    version('5.8.0', sha256='219e4107abf40317ce054408e9c3b22fb935d464238c1c00c0161f1c8697a3f9')
    version('5.7.0', sha256='e41e597e1be462974a03031380d9e5ba9a7efcdb22e4ca2f3fec50361f310874')
    version('5.6.2', sha256='1f3710b77c58a46891808dbe23dc59a1259d9c6b7bb123aaaeaa6ddf2be882ea')
    version('5.6.0', sha256='cb8c4d752ad9805c74b4a08f8ae6e83402c3f11e38b274dba171b99bb6ac2460')
    version('5.5.2', sha256='64561f34c4402b88f3cb20a956842394dde5838efd7ebb301157a837114a0e2d')
    version('5.5.1', sha256='a6e67a95a7a5711a2b5f95f38ccbff4912262b3e1b1af7d6b9afe8185aa85c0d')
    version('5.5.0', sha256='1b619e326ff574de808732ca9a7447e4cd14e94ae6568f55b6581896cd569dff')
    version('5.4.1', sha256='390d0f5dc66bf432e202a39b1f34193af4bf8aad2355338fa5e2778ea07a80e4')
    version('5.4.0', sha256='f488d84a53b1286d2ee1967e386626c8ad05a6fe4e6cbdaa8d5e042f519f94a9')
    version('5.3.0', sha256='046631bbf00775edc927314a3db207509666c9c6aadc7079e5159440fd2f88a0')
    version('5.2.0', sha256='894e42ef8475bb49e4e7e64f4ee2c37c714facd18bfbb1d6de7f69676b062c96')
    version('5.1.2', sha256='ff02b7307a256b7c6e8ad900dee5796297494df7f9a0804fe801eb2f66e6a187')
    version('5.0.1', sha256='caddec83ec284162a2cbc46877b0e5a9d2cca59fb4ab0ea35b0948d2492950bb')
    version('4.4.0', sha256='c2dc334a89df24ce5233b81b74740fc9f10bc181cd604109fd13f6ad2381fc73')

    variant('plugins', default=True,
            description='Install include files for plugins support')
    variant('python', default=False, description='Enable Python support')
    variant('python3', default=False, description='Enable Python3 support')
    variant('mpi', default=True, description='Enable MPI support')
    variant('osmesa', default=False, description='Enable OSMesa support')
    variant('qt', default=False, description='Enable Qt (gui) support')
    variant('opengl2', default=True, description='Enable OpenGL2 backend')
    variant('examples', default=False, description="Build examples")
    variant('hdf5', default=False, description="Use external HDF5")
    variant('shared', default=True,
            description='Builds a shared version of the library')
    variant('kits', default=True,
            description='Use module kits')

    conflicts('+python', when='+python3')
    # Python 2 support dropped with 5.9.0
    conflicts('+python', when='@5.9:')
    conflicts('+python3', when='@:5.5')
    conflicts('+shared', when='+cuda')
    # Legacy rendering dropped in 5.5
    # See commit: https://gitlab.kitware.com/paraview/paraview/-/commit/798d328c
    conflicts('~opengl2', when='@5.5:')

    # Workaround for
    # adding the following to your packages.yaml
    # packages:
    #   python:
    #     version: [3, 2]
    # without this you'll get:
    # paraview requires python version 3:, but spec asked for 2.7.16
    # for `spack spec paraview+python+osmesa`
    # see spack pull request #11539
    extends('python', when='+python')
    extends('python', when='+python3')

    depends_on('python@2.7:2.8', when='+python', type=('build', 'run'))
    depends_on('python@3:', when='+python3', type=('build', 'run'))

    depends_on('py-numpy@:1.15.4', when='+python', type=('build', 'run'))
    depends_on('py-numpy', when='+python3', type=('build', 'run'))
    depends_on('py-mpi4py', when='+python+mpi', type=('build', 'run'))
    depends_on('py-mpi4py', when='+python3+mpi', type=('build', 'run'))

    depends_on('py-matplotlib@:2', when='+python', type='run')
    depends_on('py-matplotlib', when='+python3', type='run')

    depends_on('mpi', when='+mpi')
    depends_on('qt+opengl', when='@5.3.0:+qt+opengl2')
    depends_on('qt~opengl', when='@5.3.0:+qt~opengl2')
    depends_on('qt@:4', when='@:5.2.0+qt')

    depends_on('mesa+osmesa', when='+osmesa')
    depends_on('gl@3.2:', when='+opengl2')
    depends_on('gl@1.2:', when='~opengl2')
    depends_on('libxt', when='~osmesa platform=linux')
    conflicts('+qt', when='+osmesa')

    depends_on('bzip2')
    depends_on('freetype')
    # depends_on('hdf5+mpi', when='+mpi')
    # depends_on('hdf5~mpi', when='~mpi')
    depends_on('hdf5+hl+mpi', when='+hdf5+mpi')
    depends_on('hdf5+hl~mpi', when='+hdf5~mpi')
    depends_on('jpeg')
    depends_on('libpng')
    depends_on('libtiff')
    depends_on('libxml2')
    depends_on('netcdf-c')
    depends_on('expat')
    # depends_on('netcdf-cxx')
    # depends_on('protobuf') # version mismatches?
    # depends_on('sqlite') # external version not supported
    depends_on('zlib')
    depends_on('cmake@3.3:', type='build')

    # Can't contretize with python2 and py-setuptools@45.0.0:
    depends_on('py-setuptools@:44.99.99', when='+python')
    # Can't contretize with python2 and py-pillow@7.0.0:
    depends_on('py-pillow@:6', when='+python')

    patch('stl-reader-pv440.patch', when='@4.4.0')

    # Broken gcc-detection - improved in 5.1.0, redundant later
    patch('gcc-compiler-pv501.patch', when='@:5.0.1')

    # Broken installation (ui_pqExportStateWizard.h) - fixed in 5.2.0
    patch('ui_pqExportStateWizard.patch', when='@:5.1.2')

    # Broken vtk-m config. Upstream catalyst changes
    patch('vtkm-catalyst-pv551.patch', when='@5.5.0:5.5.2')

    def url_for_version(self, version):
        _urlfmt  = 'http://www.paraview.org/files/v{0}/ParaView-v{1}{2}.tar.{3}'
        """Handle ParaView version-based custom URLs."""
        if version < Version('5.1.0'):
            return _urlfmt.format(version.up_to(2), version, '-source', 'gz')
        elif version < Version('5.6.1'):
            return _urlfmt.format(version.up_to(2), version, '', 'gz')
        else:
            return _urlfmt.format(version.up_to(2), version, '', 'xz')

    @property
    def paraview_subdir(self):
        """The paraview subdirectory name as paraview-major.minor"""
        return 'paraview-{0}'.format(self.spec.version.up_to(2))

    def setup_dependent_build_environment(self, env, dependent_spec):
        if os.path.isdir(self.prefix.lib64):
            lib_dir = self.prefix.lib64
        else:
            lib_dir = self.prefix.lib
        env.set('ParaView_DIR', self.prefix)
        env.set('PARAVIEW_VTK_DIR',
                join_path(lib_dir, 'cmake', self.paraview_subdir))

    def setup_run_environment(self, env):
        # paraview 5.5 and later
        # - cmake under lib/cmake/paraview-5.5
        # - libs  under lib
        # - python bits under lib/python2.8/site-packages
        if os.path.isdir(self.prefix.lib64):
            lib_dir = self.prefix.lib64
        else:
            lib_dir = self.prefix.lib

        env.set('ParaView_DIR', self.prefix)
        env.set('PARAVIEW_VTK_DIR',
                join_path(lib_dir, 'cmake', self.paraview_subdir))

        if self.spec.version <= Version('5.4.1'):
            lib_dir = join_path(lib_dir, self.paraview_subdir)

        env.prepend_path('LIBRARY_PATH', lib_dir)
        env.prepend_path('LD_LIBRARY_PATH', lib_dir)

        if '+python' in self.spec or '+python3' in self.spec:
            if self.spec.version <= Version('5.4.1'):
                pv_pydir = join_path(lib_dir, 'site-packages')
                env.prepend_path('PYTHONPATH', pv_pydir)
                env.prepend_path('PYTHONPATH', join_path(pv_pydir, 'vtk'))
            else:
                python_version = self.spec['python'].version.up_to(2)
                pv_pydir = join_path(lib_dir,
                                     'python{0}'.format(python_version),
                                     'site-packages')
                if '+shared' in self.spec or \
                   self.spec.version <= Version('5.7.0'):
                    env.prepend_path('PYTHONPATH', pv_pydir)
                    # The Trilinos Catalyst adapter requires
                    # the vtkmodules directory in PYTHONPATH
                    env.prepend_path('PYTHONPATH', join_path(pv_pydir,
                                                             'vtkmodules'))
                else:
                    env.prepend_path('PYTHONPATH', join_path(pv_pydir,
                                                             '_paraview.zip'))
                    env.prepend_path('PYTHONPATH', join_path(pv_pydir,
                                                             '_vtk.zip'))

    def cmake_args(self):
        """Populate cmake arguments for ParaView."""
        spec = self.spec

        def variant_bool(feature, on='ON', off='OFF'):
            """Ternary for spec variant to ON/OFF string"""
            if feature in spec:
                return on
            return off

        def nvariant_bool(feature):
            """Negated ternary for spec variant to OFF/ON string"""
            return variant_bool(feature, on='OFF', off='ON')

        rendering = variant_bool('+opengl2', 'OpenGL2', 'OpenGL')
        includes  = variant_bool('+plugins')

        cmake_args = [
            '-DPARAVIEW_BUILD_QT_GUI:BOOL=%s' % variant_bool('+qt'),
            '-DVTK_OPENGL_HAS_OSMESA:BOOL=%s' % variant_bool('+osmesa'),
            '-DVTK_USE_X:BOOL=%s' % nvariant_bool('+osmesa'),
            '-DVTK_RENDERING_BACKEND:STRING=%s' % rendering,
            '-DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=%s' % includes,
            '-DBUILD_TESTING:BOOL=OFF',
            '-DBUILD_EXAMPLES:BOOL=%s' % variant_bool('+examples'),
            '-DVTK_USE_SYSTEM_FREETYPE:BOOL=ON',
            '-DVTK_USE_SYSTEM_HDF5:BOOL=%s' % variant_bool('+hdf5'),
            '-DVTK_USE_SYSTEM_JPEG:BOOL=ON',
            '-DVTK_USE_SYSTEM_LIBXML2:BOOL=ON',
            '-DVTK_USE_SYSTEM_NETCDF:BOOL=ON',
            '-DVTK_USE_SYSTEM_EXPAT:BOOL=ON',
            '-DVTK_USE_SYSTEM_TIFF:BOOL=ON',
            '-DVTK_USE_SYSTEM_ZLIB:BOOL=ON',
            '-DVTK_USE_SYSTEM_PNG:BOOL=ON',
            '-DOpenGL_GL_PREFERENCE:STRING=LEGACY'
        ]

        # The assumed qt version changed to QT5 (as of paraview 5.2.1),
        # so explicitly specify which QT major version is actually being used
        if '+qt' in spec:
            cmake_args.extend([
                '-DPARAVIEW_QT_VERSION=%s' % spec['qt'].version[0],
            ])

        # CMake flags for python have changed with newer ParaView versions
        # Make sure Spack uses the right cmake flags
        if '+python' in spec or '+python3' in spec:
            py_use_opt = 'USE' if spec.satisfies('@5.8:') else 'ENABLE'
            py_ver_opt = 'PARAVIEW' if spec.satisfies('@5.7:') else 'VTK'
            py_ver_val = 3 if '+python3' in spec else 2
            cmake_args.extend([
                '-DPARAVIEW_%s_PYTHON:BOOL=ON' % py_use_opt,
                '-DPYTHON_EXECUTABLE:FILEPATH=%s' %
                spec['python'].command.path,
                '-DVTK_USE_SYSTEM_MPI4PY:BOOL=%s' % variant_bool('+mpi'),
                '-D%s_PYTHON_VERSION:STRING=%d' % (py_ver_opt, py_ver_val)
            ])

        else:
            cmake_args.append('-DPARAVIEW_ENABLE_PYTHON:BOOL=OFF')

        if '+mpi' in spec:
            cmake_args.extend([
                '-DPARAVIEW_USE_MPI:BOOL=ON',
                '-DMPIEXEC:FILEPATH=%s/bin/mpiexec' % spec['mpi'].prefix,
                '-DCMAKE_CXX_COMPILER:PATH=%s' % spec['mpi'].mpicxx,
                '-DCMAKE_C_COMPILER:PATH=%s' % spec['mpi'].mpicc,
                '-DCMAKE_Fortran_COMPILER:PATH=%s' % spec['mpi'].mpifc
            ])

        if '+shared' in spec:
            cmake_args.append(
                '-DPARAVIEW_BUILD_SHARED_LIBS:BOOL=ON'
            )
        else:
            cmake_args.append(
                '-DPARAVIEW_BUILD_SHARED_LIBS:BOOL=OFF'
            )

        if '+cuda' in spec:
            cmake_args.extend([
                '-DPARAVIEW_USE_CUDA:BOOL=ON',
                '-DPARAVIEW_BUILD_SHARED_LIBS:BOOL=OFF'
            ])
        else:
            cmake_args.extend([
                '-DPARAVIEW_USE_CUDA:BOOL=OFF',
            ])

        if 'darwin' in spec.architecture:
            cmake_args.extend([
                '-DVTK_USE_X:BOOL=OFF',
                '-DPARAVIEW_DO_UNIX_STYLE_INSTALLS:BOOL=ON',
            ])

        if '+kits' in spec:
            if spec.satisfies('@5.0:5.6'):
                cmake_args.append(
                    '-DVTK_ENABLE_KITS:BOOL=ON')
            elif spec.satisfies('@5.7'):
                cmake_args.append(
                    '-DPARAVIEW_ENABLE_KITS:BOOL=ON')
            else:
                cmake_args.append(
                    '-DPARAVIEW_BUILD_WITH_KITS:BOOL=ON')

        # Hide git from Paraview so it will not use `git describe`
        # to find its own version number
        if spec.satisfies('@5.4.0:5.4.1'):
            cmake_args.extend([
                '-DGIT_EXECUTABLE=FALSE'
            ])

        # A bug that has been found in vtk causes an error for
        # intel builds for version 5.6.  This should be revisited
        # with later versions of Paraview to see if the issues still
        # arises.
        if '%intel' in spec and spec.version >= Version('5.6'):
            cmake_args.append('-DPARAVIEW_ENABLE_MOTIONFX:BOOL=OFF')

        return cmake_args
