-- Internal variables
local base  = "/sw/sources/lsf-tools/"

-- Alter existing variables
prepend_path {"PATH", pathJoin(base, "peak", "bin"), priority=9999}

-- Info
help([[
LSF helper tools
]])

whatis("LSF helper tools")


