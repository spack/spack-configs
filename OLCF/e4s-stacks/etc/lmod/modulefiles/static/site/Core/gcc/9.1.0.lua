family("compiler")

help([[
GCC Compiler
]])

local package = "gcc"
local version = "9.1.0"
local moduleroot = myFileName():sub(1,myFileName():find(myModuleFullName(),1,true)-7)
local gccdir = "/sw/peak/gcc/9.1.0-alpha+20190716"

whatis("Description: ", "GCC compiler " .. version)

-- Setup Modulepath for packages built by this compiler
prepend_path( "MODULEPATH",  pathJoin(moduleroot, package, version ) )

-- Environment Globals
prepend_path( "PATH",  pathJoin(gccdir, "bin" ) )
prepend_path( "MANPATH", pathJoin(gccdir, "share/man" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(gccdir, "lib64") )

-- OLCF specific Environment
setenv("OLCF_GCC_ROOT",  gccdir)
