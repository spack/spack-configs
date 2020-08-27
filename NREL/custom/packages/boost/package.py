# Copyright 2013-2020 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack import *
import sys
import os


class Boost(Package):
    """Boost provides free peer-reviewed portable C++ source
       libraries, emphasizing libraries that work well with the C++
       Standard Library.

       Boost libraries are intended to be widely useful, and usable
       across a broad spectrum of applications. The Boost license
       encourages both commercial and non-commercial use.
    """
    homepage = "http://www.boost.org"
    url      = "http://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.bz2"
    git      = "https://github.com/boostorg/boost.git"
    list_url = "http://sourceforge.net/projects/boost/files/boost/"
    list_depth = 1
    maintainers = ['hainest']

    version('develop', branch='develop', submodules=True)
    version('1.73.0', sha256='4eb3b8d442b426dc35346235c8733b5ae35ba431690e38c6a8263dce9fcbb402')
    version('1.72.0', sha256='59c9b274bc451cf91a9ba1dd2c7fdcaf5d60b1b3aa83f2c9fa143417cc660722')
    version('1.71.0', sha256='d73a8da01e8bf8c7eda40b4c84915071a8c8a0df4a6734537ddde4a8580524ee')
    version('1.70.0', sha256='430ae8354789de4fd19ee52f3b1f739e1fba576f0aded0897c3c2bc00fb38778')
    version('1.69.0', sha256='8f32d4617390d1c2d16f26a27ab60d97807b35440d45891fa340fc2648b04406')
    version('1.68.0', sha256='7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7')
    version('1.67.0', sha256='2684c972994ee57fc5632e03bf044746f6eb45d4920c343937a465fd67a5adba')
    version('1.66.0', sha256='5721818253e6a0989583192f96782c4a98eb6204965316df9f5ad75819225ca9')
    version('1.65.1', sha256='9807a5d16566c57fd74fb522764e0b134a8bbe6b6e8967b83afefd30dcd3be81')
    version('1.65.0', sha256='ea26712742e2fb079c2a566a31f3266973b76e38222b9f88b387e3c8b2f9902c')
    # NOTE: 1.64.0 seems fine for *most* applications, but if you need
    #       +python and +mpi, there seem to be errors with out-of-date
    #       API calls from mpi/python.
    #       See: https://github.com/spack/spack/issues/3963
    version('1.64.0', sha256='7bcc5caace97baa948931d712ea5f37038dbb1c5d89b43ad4def4ed7cb683332')
    version('1.63.0', sha256='beae2529f759f6b3bf3f4969a19c2e9d6f0c503edcb2de4a61d1428519fcb3b0')
    version('1.62.0', sha256='36c96b0f6155c98404091d8ceb48319a28279ca0333fba1ad8611eb90afb2ca0')
    version('1.61.0', sha256='a547bd06c2fd9a71ba1d169d9cf0339da7ebf4753849a8f7d6fdb8feee99b640')
    version('1.60.0', sha256='686affff989ac2488f79a97b9479efb9f2abae035b5ed4d8226de6857933fd3b')
    version('1.59.0', sha256='727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca')
    version('1.58.0', sha256='fdfc204fc33ec79c99b9a74944c3e54bd78be4f7f15e260c0e2700a36dc7d3e5')
    version('1.57.0', sha256='910c8c022a33ccec7f088bd65d4f14b466588dda94ba2124e78b8c57db264967')
    version('1.56.0', sha256='134732acaf3a6e7eba85988118d943f0fa6b7f0850f65131fff89823ad30ff1d')
    version('1.55.0', sha256='fff00023dd79486d444c8e29922f4072e1d451fc5a4d2b6075852ead7f2b7b52')
    version('1.54.0', sha256='047e927de336af106a24bceba30069980c191529fd76b8dff8eb9a328b48ae1d')
    version('1.53.0', sha256='f88a041b01882b0c9c5c05b39603ec8383fb881f772f6f9e6e6fd0e0cddb9196')
    version('1.52.0', sha256='222b6afd7723f396f5682c20130314a10196d3999feab5ba920d2a6bf53bac92')
    version('1.51.0', sha256='fb2d2335a29ee7fe040a197292bfce982af84a645c81688a915c84c925b69696')
    version('1.50.0', sha256='c9ace2b8c81fa6703d1d17c7e478de3bc51101c5adbdeb3f6cb72cf3045a8529')
    version('1.49.0', sha256='dd748a7f5507a7e7af74f452e1c52a64e651ed1f7263fce438a06641d2180d3c')
    version('1.48.0', sha256='1bf254b2d69393ccd57a3cdd30a2f80318a005de8883a0792ed2f5e2598e5ada')
    version('1.47.0', sha256='815a5d9faac4dbd523fbcf3fe1065e443c0bbf43427c44aa423422c6ec4c2e31')
    version('1.46.1', sha256='e1dfbf42b16e5015c46b98e9899c423ca4d04469cbeee05e43ea19236416d883')
    version('1.46.0', sha256='2f90f60792fdc25e674b8a857a0bcbb8d01199651719c90d5c4f8c61c08eba59')
    version('1.45.0', sha256='55ed3ec51d5687e8224c988e22bef215dacce04e037d9f689569a80c4377a6d5')
    version('1.44.0', sha256='45c328029d97d1f1dc7ff8c9527cd0c5cc356636084a800bca2ee4bfab1978db')
    version('1.43.0', sha256='344f100b1aa410e812cabf0e4130728a80be042bf346135516b9187853806120')
    version('1.42.0', sha256='4b1eb95bd250ce15ac66435d6167f225b072b0d3a7eb72477a31847a9ca9e609')
    version('1.41.0', sha256='1ef94e6749eaf13318284b4f629be063544c7015b45e38113b975ac1945cc726')
    version('1.40.0', sha256='36cf4a239b587067a4923fdf6e290525a14c3af29829524fa73f3dec6841530c')
    version('1.39.0', sha256='44785eae8c6cce61a29a8a51f9b737e57b34d66baa7c0bcd4af188832b8018fd')
    version('1.38.0', sha256='3ee3a45af4d2fabf343b9e05cfbe033c35d63719b45a6554d5849e4a34216066')
    version('1.37.0', sha256='d52ef49f70b1b9addc4e0d1a3a2a1966227f0d173c3301bac3e6d399eeac5472')
    version('1.36.0', sha256='9a4a0cfbbd227c20a13519a2c41f2e707dc0d89e518a3c7bfcd381f7b7fbcdef')
    version('1.35.0', sha256='f8bf7368a22ccf2e2cf77048ab2129744be4c03f8488c76ad31c0aa229b280da')
    version('1.34.1', sha256='0f866c75b025a4f1340117a106595cc0675f48ba1e5a9b5c221ec7f19e96ec4c')
    version('1.34.0', sha256='455cb8fa41b759272768257c2e7bdc5c47ec113245dfa533f275e787a855efd2')

    default_install_libs = set(['atomic',
                                'chrono',
                                'date_time',
                                'exception',
                                'filesystem',
                                'graph',
                                'iostreams',
                                'locale',
                                'log',
                                'math',
                                'program_options',
                                'random',
                                'regex',
                                'serialization',
                                'signals',
                                'system',
                                'test',
                                'thread',
                                'timer',
                                'wave'])

    # mpi/python are not installed by default because they pull in many
    # dependencies and/or because there is a great deal of customization
    # possible (and it would be difficult to choose sensible defaults)
    #
    # Boost.Container can be both header-only and compiled. '+container'
    # indicates the compiled version which requires Extended Allocator
    # support. The header-only library is installed when no variant is given.
    default_noinstall_libs\
        = set(['container', 'context', 'coroutine', 'fiber', 'mpi', 'python'])

    all_libs = default_install_libs | default_noinstall_libs

    for lib in all_libs:
        variant(lib, default=(lib not in default_noinstall_libs),
                description="Compile with {0} library".format(lib))

    @property
    def libs(self):
        query = self.spec.last_query.extra_parameters
        shared = '+shared' in self.spec

        libnames = query if query else [lib for lib in self.all_libs
                                        if self.spec.satisfies('+%s' % lib)]
        libnames += ['monitor']
        libraries = ['libboost_*%s*' % lib for lib in libnames]

        return find_libraries(
            libraries, root=self.prefix, shared=shared, recursive=True
        )

    variant('cxxstd',
            default='98',
            values=('98', '11', '14', '17', '2a'),
            multi=False,
            description='Use the specified C++ standard when building.')
    variant('debug', default=False,
            description='Switch to the debug version of Boost')
    variant('shared', default=True,
            description="Additionally build shared libraries")
    variant('multithreaded', default=True,
            description="Build multi-threaded versions of libraries")
    variant('singlethreaded', default=False,
            description="Build single-threaded versions of libraries")
    variant('icu', default=False,
            description="Build with Unicode and ICU suport")
    variant('taggedlayout', default=False,
            description="Augment library names with build options")
    variant('versionedlayout', default=False,
            description="Augment library layout with versioned subdirs")
    variant('clanglibcpp', default=False,
            description='Compile with clang libc++ instead of libstdc++')
    variant('numpy', default=False,
            description='Build the Boost NumPy library (requires +python)')
    variant('pic', default=False,
            description='Generate position-independent code (PIC), useful '
                        'for building static libraries')

    # https://boostorg.github.io/build/manual/develop/index.html#bbv2.builtin.features.visibility
    variant('visibility', values=('global', 'protected', 'hidden'),
            default='hidden', multi=False,
            description='Default symbol visibility in compiled libraries '
            '(1.69.0 or later)')

    depends_on('icu4c', when='+icu')
    depends_on('python', when='+python')
    depends_on('mpi', when='+mpi')
    depends_on('bzip2', when='+iostreams')
    depends_on('zlib', when='+iostreams')
    depends_on('py-numpy', when='+numpy', type=('build', 'run'))

    # Coroutine, Context, Fiber, etc., are not straightforward.
    conflicts('+context', when='@:1.50.99')  # Context since 1.51.0.
    conflicts('cxxstd=98', when='+context')  # Context requires >=C++11.
    conflicts('+coroutine', when='@:1.52.99')  # Context since 1.53.0.
    conflicts('~context', when='+coroutine')  # Coroutine requires Context.
    conflicts('+fiber', when='@:1.61.99')  # Fiber since 1.62.0.
    conflicts('cxxstd=98', when='+fiber')  # Fiber requires >=C++11.
    conflicts('~context', when='+fiber')  # Fiber requires Context.

    # C++20/2a is not support by Boost < 1.73.0
    conflicts('cxxstd=2a', when='@:1.72.99')

    # C++17 is not supported by Boost<1.63.0.
    conflicts('cxxstd=17', when='@:1.62.99')

    conflicts('+taggedlayout', when='+versionedlayout')
    conflicts('+numpy', when='~python')

    # boost-python in 1.72.0 broken with cxxstd=98
    conflicts('cxxstd=98', when='+mpi+python @1.72.0')

    # Container's Extended Allocators were not added until 1.56.0
    conflicts('+container', when='@:1.55.99')

    # Patch fix from https://svn.boost.org/trac/boost/ticket/11856
    patch('boost_11856.patch', when='@1.60.0%gcc@4.4.7')

    # Patch fix from https://svn.boost.org/trac/boost/ticket/11120
    patch('python_jam.patch', when='@1.56.0: ^python@3:')
    patch('python_jam_pre156.patch', when='@:1.55.0 ^python@3:')

    # Patch fix for IBM XL compiler
    patch('xl_1_62_0_le.patch', when='@1.62.0%xl_r')
    patch('xl_1_62_0_le.patch', when='@1.62.0%xl')

    # Patch fix from https://svn.boost.org/trac/boost/ticket/10125
    patch('call_once_variadic.patch', when='@1.54.0:1.55.9999%gcc@5.0:')

    # Patch fix for PGI compiler
    patch('boost_1.67.0_pgi.patch', when='@1.67.0:1.68.9999%pgi')
    patch('boost_1.63.0_pgi.patch', when='@1.63.0%pgi')
    patch('boost_1.63.0_pgi_17.4_workaround.patch', when='@1.63.0%pgi@17.4')

    # Fix for version comparison on newer Clang on darwin
    # See: https://github.com/boostorg/build/issues/440
    # See: https://github.com/macports/macports-ports/pull/6726
    patch('darwin_clang_version.patch', level=0,
          when='@1.56.0:1.72.0 platform=darwin')

    # Fix: "Unable to compile code using boost/process.hpp"
    # See: https://github.com/boostorg/process/issues/116
    # Patch: https://github.com/boostorg/process/commit/6a4d2ff72114ef47c7afaf92e1042aca3dfa41b0.patch
    patch('1.72_boost_process.patch', level=2, when='@1.72.0')

    # Fix the bootstrap/bjam build for Cray
    patch('bootstrap-path.patch', when='@1.39.0: platform=cray')

    # Patch fix for warnings from commits 2d37749, af1dc84, c705bab, and
    # 0134441 on http://github.com/boostorg/system.
    patch('system-non-virtual-dtor-include.patch', when='@1.69.0',
          level=2)
    patch('system-non-virtual-dtor-test.patch', when='@1.69.0',
          working_dir='libs/system', level=1)

    # Change the method for version analysis when using Fujitsu compiler.
    patch('fujitsu_version_analysis.patch', when='@1.67.0:%fj')

    # Add option to C/C++ compile commands in clang-linux.jam
    patch('clang-linux_add_option.patch', when='@1.56.0:1.63.0')
    patch('clang-linux_add_option2.patch', when='@1.47.0:1.55.0')

    # C++20 concepts fix for Beast
    # See https://github.com/boostorg/beast/pull/1927 for details
    patch('https://www.boost.org/patches/1_73_0/0002-beast-coroutines.patch',
          sha256='4dd507e1f5a29e3b87b15321a4d8c74afdc8331433edabf7aeab89b3c405d556',
          when='@1.73.0')

    # Cloning a status_code with indirecting_domain leads to segmentation fault
    # See https://github.com/ned14/outcome/issues/223 for details
    patch('https://www.boost.org/patches/1_73_0/0001-outcome-assert.patch',
          sha256='246508e052c44b6f4e8c2542a71c06cacaa72cd1447ab8d2a542b987bc35ace9',
          when='@1.73.0')

    def url_for_version(self, version):
        if version >= Version('1.63.0'):
            url = "https://dl.bintray.com/boostorg/release/{0}/source/boost_{1}.tar.bz2"
        else:
            url = "http://downloads.sourceforge.net/project/boost/boost/{0}/boost_{1}.tar.bz2"

        return url.format(version.dotted, version.underscored)

    def determine_toolset(self, spec):
        toolsets = {'g++': 'gcc',
                    'icpc': 'intel',
                    'clang++': 'clang',
                    'armclang++': 'clang',
                    'xlc++': 'xlcpp',
                    'xlc++_r': 'xlcpp',
                    'pgc++': 'pgi',
                    'FCC': 'clang'}

        if spec.satisfies('@1.47:'):
            toolsets['icpc'] += '-linux'
        for cc, toolset in toolsets.items():
            if cc in self.compiler.cxx_names:
                return toolset

        # fallback to gcc if no toolset found
        return 'gcc'

    def bjam_python_line(self, spec):
        # avoid "ambiguous key" error
        if spec.satisfies('@:1.58'):
            return ''

        return 'using python : {0} : {1} : {2} : {3} ;\n'.format(
            spec['python'].version.up_to(2),
            spec['python'].command.path,
            spec['python'].headers.directories[0],
            spec['python'].libs[0]
        )

    def determine_bootstrap_options(self, spec, with_libs, options):
        boost_toolset_id = self.determine_toolset(spec)

        # Arm compiler bootstraps with 'gcc' (but builds as 'clang')
        if spec.satisfies('%arm') or spec.satisfies('%fj'):
            options.append('--with-toolset=gcc')
        else:
            options.append('--with-toolset=%s' % boost_toolset_id)
        options.append("--with-libraries=%s" % ','.join(with_libs))

        if '+python' in spec:
            options.append('--with-python=%s' % spec['python'].command.path)

        with open('user-config.jam', 'w') as f:
            # Boost may end up using gcc even though clang+gfortran is set in
            # compilers.yaml. Make sure this does not happen:
            if not spec.satisfies('%intel'):
                # using intel-linux : : spack_cxx in user-config.jam leads to
                # error: at project-config.jam:12
                # error: duplicate initialization of intel-linux with the following parameters:  # noqa
                # error: version = <unspecified>
                # error: previous initialization at ./user-config.jam:1
                f.write("using {0} : : {1} ;\n".format(boost_toolset_id,
                                                       spack_cxx))

            if '+mpi' in spec:
                # Use the correct mpi compiler.  If the compiler options are
                # empty or undefined, Boost will attempt to figure out the
                # correct options by running "${mpicxx} -show" or something
                # similar, but that doesn't work with the Cray compiler
                # wrappers.  Since Boost doesn't use the MPI C++ bindings,
                # that can be used as a compiler option instead.
                mpi_line = 'using mpi : %s' % spec['mpi'].mpicc

                if 'platform=cray' in spec:
                    mpi_line += ' : <define>MPICH_SKIP_MPICXX'

                if '^mpt' in spec:
                    mpi_line += ' : <define>MPICH_SKIP_MPICXX'

                f.write(mpi_line + ' ;\n')

            if '+python' in spec:
                f.write(self.bjam_python_line(spec))

    def determine_b2_options(self, spec, options):
        if '+debug' in spec:
            options.append('variant=debug')
        else:
            options.append('variant=release')

        if '+icu_support' in spec:
            options.extend(['-s', 'ICU_PATH=%s' % spec['icu'].prefix])

        if '+iostreams' in spec:
            options.extend([
                '-s', 'BZIP2_INCLUDE=%s' % spec['bzip2'].prefix.include,
                '-s', 'BZIP2_LIBPATH=%s' % spec['bzip2'].prefix.lib,
                '-s', 'ZLIB_INCLUDE=%s' % spec['zlib'].prefix.include,
                '-s', 'ZLIB_LIBPATH=%s' % spec['zlib'].prefix.lib,
                '-s', 'NO_LZMA=1',
                '-s', 'NO_ZSTD=1'])

        link_types = ['static']
        if '+shared' in spec:
            link_types.append('shared')

        threading_opts = []
        if '+multithreaded' in spec:
            threading_opts.append('multi')
        if '+singlethreaded' in spec:
            threading_opts.append('single')
        if not threading_opts:
            raise RuntimeError("At least one of {singlethreaded, " +
                               "multithreaded} must be enabled")

        if '+taggedlayout' in spec:
            layout = 'tagged'
        elif '+versionedlayout' in spec:
            layout = 'versioned'
        else:
            if len(threading_opts) > 1:
                raise RuntimeError("Cannot build both single and " +
                                   "multi-threaded targets with system layout")
            layout = 'system'

        options.extend([
            'link=%s' % ','.join(link_types),
            '--layout=%s' % layout
        ])

        if not spec.satisfies('%intel'):
            options.extend([
                'toolset=%s' % self.determine_toolset(spec)
            ])

        # Other C++ flags.
        cxxflags = []

        # Deal with C++ standard.
        if spec.satisfies('@1.66:'):
            options.append('cxxstd={0}'.format(spec.variants['cxxstd'].value))
        else:  # Add to cxxflags for older Boost.
            cxxstd = spec.variants['cxxstd'].value
            flag = getattr(self.compiler, 'cxx{0}_flag'.format(cxxstd))
            if flag:
                cxxflags.append(flag)

        if '+pic' in self.spec:
            cxxflags.append(self.compiler.cxx_pic_flag)

        # clang is not officially supported for pre-compiled headers
        # and at least in clang 3.9 still fails to build
        #   http://www.boost.org/build/doc/html/bbv2/reference/precompiled_headers.html
        #   https://svn.boost.org/trac/boost/ticket/12496
        if (spec.satisfies('%apple-clang') or
                spec.satisfies('%clang') or
                spec.satisfies('%fj')):
            options.extend(['pch=off'])
            if '+clanglibcpp' in spec:
                cxxflags.append('-stdlib=libc++')
                options.extend(['toolset=clang',
                                'linkflags="-stdlib=libc++"'])
        elif spec.satisfies('%xl') or spec.satisfies('%xl_r'):
            # see also: https://lists.boost.org/boost-users/2019/09/89953.php
            # the cxxstd setting via spack is not sufficient to drive the
            # change into boost compilation
            if spec.variants['cxxstd'].value == '11':
                cxxflags.append('-std=c++11')

        if cxxflags:
            options.append('cxxflags="{0}"'.format(' '.join(cxxflags)))

        # Visibility was added in 1.69.0.
        if spec.satisfies('@1.69.0:'):
            options.append('visibility=%s' % spec.variants['visibility'].value)

        return threading_opts

    def add_buildopt_symlinks(self, prefix):
        with working_dir(prefix.lib):
            for lib in os.listdir(os.curdir):
                if os.path.isfile(lib):
                    prefix, remainder = lib.split('.', 1)
                    symlink(lib, '%s-mt.%s' % (prefix, remainder))

    def install(self, spec, prefix):
        # On Darwin, Boost expects the Darwin libtool. However, one of the
        # dependencies may have pulled in Spack's GNU libtool, and these two
        # are not compatible. We thus create a symlink to Darwin's libtool
        # and add it at the beginning of PATH.
        if sys.platform == 'darwin':
            newdir = os.path.abspath('darwin-libtool')
            mkdirp(newdir)
            force_symlink('/usr/bin/libtool', join_path(newdir, 'libtool'))
            env['PATH'] = newdir + ':' + env['PATH']

        with_libs = list()
        for lib in Boost.all_libs:
            if "+{0}".format(lib) in spec:
                with_libs.append(lib)

        # Remove libraries that the release version does not support
        if spec.satisfies('@1.69.0:') and 'signals' in with_libs:
            with_libs.remove('signals')
        if not spec.satisfies('@1.54.0:') and 'log' in with_libs:
            with_libs.remove('log')
        if not spec.satisfies('@1.53.0:') and 'atomic' in with_libs:
            with_libs.remove('atomic')
        if not spec.satisfies('@1.48.0:') and 'locale' in with_libs:
            with_libs.remove('locale')
        if not spec.satisfies('@1.47.0:') and 'chrono' in with_libs:
            with_libs.remove('chrono')
        if not spec.satisfies('@1.43.0:') and 'random' in with_libs:
            with_libs.remove('random')
        if not spec.satisfies('@1.39.0:') and 'exception' in with_libs:
            with_libs.remove('exception')
        if '+graph' in spec and '+mpi' in spec:
            with_libs.append('graph_parallel')

        if not with_libs:
            # if no libraries are specified for compilation, then you dont have
            # to configure/build anything, just copy over to the prefix
            # directory.
            src = join_path(self.stage.source_path, 'boost')
            mkdirp(join_path(prefix, 'include'))
            dst = join_path(prefix, 'include', 'boost')
            install_tree(src, dst)
            return

        # to make Boost find the user-config.jam
        env['BOOST_BUILD_PATH'] = self.stage.source_path

        bootstrap = Executable('./bootstrap.sh')

        bootstrap_options = ['--prefix=%s' % prefix]
        self.determine_bootstrap_options(spec, with_libs, bootstrap_options)

        bootstrap(*bootstrap_options)

        # b2 used to be called bjam, before 1.47 (sigh)
        b2name = './b2' if spec.satisfies('@1.47:') else './bjam'

        b2 = Executable(b2name)
        jobs = make_jobs
        # in 1.59 max jobs became dynamic
        if jobs > 64 and spec.satisfies('@:1.58'):
            jobs = 64

        b2_options = [
            '-j', '%s' % jobs,
            '--user-config=%s' % os.path.join(
                self.stage.source_path, 'user-config.jam')
        ]

        threading_opts = self.determine_b2_options(spec, b2_options)

        b2('--clean')

        # In theory it could be done on one call but it fails on
        # Boost.MPI if the threading options are not separated.
        for threading_opt in threading_opts:
            b2('install', 'threading=%s' % threading_opt, *b2_options)

        if '+multithreaded' in spec and '~taggedlayout' in spec:
            self.add_buildopt_symlinks(prefix)

        # The shared libraries are not installed correctly
        # on Darwin; correct this
        if (sys.platform == 'darwin') and ('+shared' in spec):
            fix_darwin_install_name(prefix.lib)

    def setup_run_environment(self, env):
        env.set('BOOST_ROOT', self.prefix)
