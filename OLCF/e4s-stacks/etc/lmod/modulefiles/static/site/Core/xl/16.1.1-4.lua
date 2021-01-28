-- Internal variables
local swroot  = "/sw/peak/xl/16.1.1-4"
local xlfbase    = pathJoin(swroot, "xlf", "16.1.1")
local xlcbase    = pathJoin(swroot, "xlC", "16.1.1")
local xlmassbase = pathJoin(swroot, "xlmass", "9.1.1")
local xlsmpbase  = pathJoin(swroot, "xlsmp", "5.1.1")


-- Package family
family("compiler")

-- Setup Modulepath for packages built by this compiler
---- use only one version sublevel
local moduleroot = myFileName():sub(1,myFileName():find(myModuleFullName(),1,true)-7)
prepend_path( "MODULEPATH",  pathJoin(moduleroot, 'xl', '16.1.1-4' ) )


-- Setup center variables
setenv("OLCF_XL_ROOT",     swroot)
setenv("OLCF_XLF_ROOT",    xlfbase)
setenv("OLCF_XLC_ROOT",    xlcbase)
setenv("OLCF_XLMASS_ROOT", xlmassbase)
setenv("OLCF_XLSMP_ROOT",  xlsmpbase)


-- Alter existing variables
prepend_path( "LD_LIBRARY_PATH", pathJoin (swroot, "lib") )
prepend_path( "NLSPATH",         pathJoin (swroot, "msg/en_US/%N") )

prepend_path( "PATH",            pathJoin(xlfbase, "bin") )
prepend_path( "MANPATH",         pathJoin(xlfbase, "man/en_US" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(xlfbase, "lib") )
prepend_path( "NLSPATH",         pathJoin(xlfbase, "msg/en_US/%N") )

prepend_path( "PATH",            pathJoin(xlcbase, "bin") )
prepend_path( "MANPATH",         pathJoin(xlcbase, "man/en_US" ) )
prepend_path( "LD_LIBRARY_PATH", pathJoin(xlcbase, "lib") )
prepend_path( "NLSPATH",         pathJoin(xlcbase, "msg/en_US/%N") )

prepend_path( "LD_LIBRARY_PATH", pathJoin(xlmassbase, "lib") )
prepend_path( "LD_LIBRARY_PATH", pathJoin(xlsmpbase,  "lib") )

prepend_path( "NLSPATH", pathJoin( swroot, "msg", "en_US", "%N"  ) )

-- Info
help([[
xlc version: 16.1.1
xlf version: 16.1.1
xlmass version: 9.1.1
xlsmp version: 5.1.1
]])

whatis("Description: xlc 16.1.1, xlf 16.1.1, xlmass 9.1.1, xlsmp 5.1.1")


