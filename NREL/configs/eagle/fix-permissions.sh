#!/bin/bash

cmd() {
  echo "+ $@"
  eval "$@"
}

cmd "nice -n 19 ionice -c 3 chmod -R a+rX,go-w /nopt/nrel/ecom/hpacf"
cmd "nice -n 19 ionice -c 3 chgrp -R n-ecom /nopt/nrel/ecom/hpacf"
