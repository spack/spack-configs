family("compiler")

help([[
System GCC Compiler
]])

whatis("Description: ", "GCC compiler 4.8.5")

local package = "gcc"
local version = "4.8.5"

local moduleroot = myFileName():sub(1,myFileName():find(myModuleFullName(),1,true)-7) 


-- Setup Modulepath for packages built by this compiler
prepend_path( "MODULEPATH",  pathJoin(moduleroot, package, version ) )

-- Environment Globals
--prepend_path( "PATH",  pathJoin(pgidir, "bin" ) )
--prepend_path( "MANPATH", pathJoin(pgidir, "man" ) )
--prepend_path( "LD_LIBRARY_PATH", pathJoin(pgidir, "lib") )

-- OLCF specific Environment
setenv("OLCF_GCC_ROOT",  "/usr")
