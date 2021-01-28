family("compiler")

help([[
GCC Compiler
]])

whatis("Description: ", "GCC compiler 8.1.0")

local package = "gcc"
local version = "8.1.0"
local moduleroot = myFileName():sub(1,myFileName():find(myModuleFullName(),1,true)-7)
local gccdir = "/sw/peak/gcc/8.1.0"

-- Setup Modulepath for packages built by this compiler
prepend_path( "MODULEPATH",  pathJoin(moduleroot, package, version ) )

-- Environment Globals
prepend_path( "PATH",  pathJoin(gccdir, "bin" ) )
prepend_path( "MANPATH", pathJoin(gccdir, "share/man" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(gccdir, "lib64") )

-- OLCF specific Environment
setenv("OLCF_GCC_ROOT",  gccdir)
