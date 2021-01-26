## Spack Configuration Files

This files included in this directory are:

`config.yaml`
`compilers.yaml`
`packagesl.yaml`
`upstreams.yaml.nersc`

This will have the same configuration as the `swowner` instance so that you
can mimic the same configuration environment as `swowner`. Note this does
not make the environment (ie - environment variables) the same as swowner, so
some care must be taken with that. 

A note about `upstreams.yaml.nersc`: This configuration file is meant to allow
consultants to use what is already installed in the production site of 
`/global/common/sw` to avoid having to rebuild everything. You will have to
delete the `.nersc` file in order for spack to recognize this file.
