#!/bin/sh
set -e -x

# Build Base for use with https://travis-ci.org
#

die() {
  echo "$1" >&2
  exit 1
}



cat  > configure/CONFIG_CC.local << EOF
E3_CROSS_COMPILER_TARGET_ARCHS=
EOF


make init
make env
make patch


