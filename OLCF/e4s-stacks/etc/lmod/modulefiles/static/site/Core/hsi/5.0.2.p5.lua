help([[
HSI Tools
]])

whatis("Description: ", "HSI Tools")

local package = "hsi"
local hsihome = "/sw/sources/hpss"
local hsidir  = pathJoin(hsihome)

-- Environment Globals
prepend_path( "PATH",  pathJoin(hsidir, "bin" ) )
prepend_path( "MANPATH", pathJoin(hsidir, "man" ) )

-- OLCF specific Environment
setenv("OLCF_HSI_ROOT",  hsidir)

