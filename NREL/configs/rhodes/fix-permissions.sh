#!/bin/bash

set -e

print_cmds=true
execute_cmds=true

cmd() {
  if ${print_cmds}; then echo "+ $@"; fi
  if ${execute_cmds}; then eval "$@"; fi
}

set +e

#/projects
cmd "chgrp windsim /projects"
cmd "chgrp -R windsim /projects/ecp"

cmd "chmod a+rX,go-w /projects"
cmd "chmod -R a+rX,go-w /projects/ecp"
cmd "chmod g+w /projects"
cmd "chmod g+w /projects/ecp"
cmd "chmod g+w /projects/ecp/exawind"

#/opt
cmd "chgrp windsim /opt"
cmd "chgrp -R windsim /opt/software"
cmd "chgrp -R windsim /opt/compilers"
cmd "chgrp -R windsim /opt/utilities"
cmd "chgrp -R windsim /opt/binaries"

cmd "chmod a+rX,go-w /opt"
cmd "chmod -R a+rX,go-w /opt/software"
cmd "chmod -R a+rX,go-w /opt/compilers"
cmd "chmod -R a+rX,go-w /opt/utilities"
cmd "chmod -R a+rX,go-w /opt/binaries"
