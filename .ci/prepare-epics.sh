#!/bin/sh
set -e -x

# Build Base for use with https://travis-ci.org
#

die() {
  echo "$1" >&2
  exit 1
}


function checkout_e3_plus
{
    git checkout target_path_test
}

checkout_e3_plus
make init
bash pkg_automation.bash -y
make env
make patch


