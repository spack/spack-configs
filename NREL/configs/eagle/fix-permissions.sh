#!/bin/bash

print_cmds=true
execute_cmds=true

cmd() {
  if ${print_cmds}; then echo "+ $@"; fi
  if ${execute_cmds}; then eval "$@"; fi
}

cmd "nice -n 19 ionice -c 3 chmod -R a+rX,go-w /nopt/nrel/ecom/hpacf"
cmd "nice -n 19 ionice -c 3 chgrp -R n-ecom /nopt/nrel/ecom/hpacf"
