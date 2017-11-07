#!/bin/bash
#
#  Copyright (c) 2017 - Present European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
#
#   author  : Jeong Han Lee
#   email   : jeonghan.lee@gmail.com
#   date    : Tuesday, November  7 11:57:50 CET 2017
#   version : 0.0.1


declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME=${0##*/}
declare -gr SC_TOP="$(dirname "$SC_SCRIPT")"

function pushd { builtin pushd "$@" > /dev/null; }
function popd  { builtin popd  "$@" > /dev/null; }



declare -ga R315_5_patch_list=()
declare -ga R316_1_patch_list=()

declare -g  R315_5_DIR=${SC_TOP}/R3.15.5
declare -g  R316_1_DIR=${SC_TOP}/R3.16.1


R315_5_PATH="http://www.aps.anl.gov/epics/base/R3-15/5-docs"
R316_1_PATH="http://www.aps.anl.gov/epics/base/R3-16/1-docs"


R315_5_patch_list+=("fix-1678494");
R315_5_patch_list+=("fix-1699445");
R315_5_patch_list+=("dbCa-warning");
R315_5_patch_list+=("osiSockOptMcastLoop");


R316_1_patch_list+=("msg503");
R316_1_patch_list+=("cvtFast");


printf "\nMoving into %s\n" "${R315_5_DIR}"
pushd ${R315_5_DIR}
rm -f *.patch
for a_list in "${R315_5_patch_list[@]}"; do
    wget -c ${R315_5_PATH}/${a_list}.patch -O ${a_list}_p0.patch
done
popd


printf "\nWe will change R3.16.1 Patch files from -p1 to -p0\n"
printf "\nMoving into %s\n" "${R316_1_DIR}"
pushd ${R316_1_DIR}
rm -f *.patch
for a_list in "${R316_1_patch_list[@]}"; do
    wget -c ${R316_1_PATH}/${a_list}.patch
    sed -e 's/a\/src/src/' ${a_list}.patch > ${a_list}_p0.tmp
    sed -e 's/b\/src/src/' ${a_list}_p0.tmp > ${a_list}_p0.patch
    rm -f *.tmp
done
popd

