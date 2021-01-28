family("compiler")

-- Required internal variables
local package = "llvm"
local version = "9.0.0"
local package_spack = "clang"
local version_spack = "9.0.0-2"
local prefix = "/sw/peak/llvm/9.0.0/9.0.0.patch001.cuda-10.1.168"

local moduleroot = myFileName():sub(1,myFileName():find(myModuleFullName(),1,true)-7)
prepend_path( "MODULEPATH",  pathJoin(moduleroot, package_spack, version_spack ) )

-- The path to the gcc toolchain must be passed to clang either as
-- 1. export COMPILER_PATH=${gcc_toolchain}
-- 2. --gcc-toolchain=${gcc_toolchain}
-- Check with clang -v
local gcc_toolchain = "/usr"
local c_include_path = "/sw/peak/llvm/9.0.0/9.0.0.patch001.cuda-10.1.168/include"
local cplus_include_path = "/sw/peak/llvm/9.0.0/9.0.0.patch001.cuda-10.1.168/include"
local library_path = "/sw/peak/llvm/9.0.0/9.0.0.patch001.cuda-10.1.168/lib:/sw/peak/llvm/9.0.0/9.0.0.patch001.cuda-10.1.168/lib/clang/9.0.0/lib/linux:/usr/lib64:/sw/peak/cuda/10.1.168/lib64"

--- List prerequisite modules here

prereq('cuda/10.1.168')

-- Required for "module help ..."

help([[
Description - LLVM is a compiler infrastructure designed for compile-time, link-time, runtime, and idle-time optimization of programs from arbitrary programming languages.
Docs - https://llvm.org

"clang -Ofast test.c -o test"
]])

-- Required for "module display ..."
whatis("Description: ", "LLVM is a compiler infrastructure designed for compile-time, link-time, runtime, and idle-time optimization of programs from arbitrary programming languages.")

-- Software-specific settings exported to user environment
prepend_path("PATH", pathJoin(prefix, "bin"))
prepend_path("MANPATH", pathJoin(prefix, "share", "man"))
prepend_path("LIBRARY_PATH", library_path)
prepend_path("LD_LIBRARY_PATH", library_path)
prepend_path("CMAKE_PREFIX_PATH", prefix)
prepend_path("C_INCLUDE_PATH", c_include_path)
prepend_path("CPLUS_INCLUDE_PATH", cplus_include_path)

setenv("COMPILER_PATH", gcc_toolchain)
setenv("LLVM_ROOT", prefix)
setenv("LLVM_VERSION", version)
setenv("OLCF_LLVM_ROOT", prefix)
