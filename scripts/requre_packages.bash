#!/bin/bash
#
#  Copyright (c) 2014 - 2017 Jeong Han Lee
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
#  Author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  Date    : Monday, September 25 22:00:02 CEST 2017
#  version : 0.9.0
#
#   - 0.0.1  December 1 00:01 KST 2014, jhlee
#           * created
#   - 0.9.0  Monday, September 25 22:28:18 CEST 2017, jhlee
#           * completely rewrite... 
#

declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME=${0##*/}
declare -gr SC_TOP="$(dirname "$SC_SCRIPT")"


function os_release() {

    eval $(cat /etc/os-release | grep -E "^(PRETTY_NAME|NAME)=")
    printf "Additional OS Release Information : \n";
    printf ">> PRETTY_NAME    = %s\n" "${PRETTY_NAME}"
    printf ">> NAME           = %s\n" "${NAME}"
}

function redhat-release() {
    cat /etc/redhat-release 
}


function find_dist() {

    local dist_id dist_cn dist_rs
    
    if [[ -f /usb/bin/lsb_release ]] ; then
	dist_id=$(lsb_release -is)
	dist_cn=$(lsb_release -cs)
	dist_rs=$(lsb_release -rs)
    fi
    
}




function pkg_list()
{
    local i
    let i=0
    while IFS= read -r line_data; do
	if [ "$line_data" ]; then
	    # Skip command #
	    [[ "$line_data" =~ ^#.*$ ]] && continue
	    packagelist[i]="${line_data}"
	    ((++i))
	fi
    done < $1
    echo ${packagelist[@]}
}


declare -a pkg_deb
declare -a pkg_rpm

pkg_deb= $(pkg_list ${SC_TOP}/pkg_all_common)
pkg_deb+=$(pkg_list ${SC_TOP}/pkg_deb_epics)

pkg_rpm= $(pkg_list ${SC_TOP}/pkg_all_common)
pkg_rpm+=$(pkg_list ${SC_TOP}/pkg_rpm_common)
pkg_rpm+=$(pkg_list ${SC_TOP}/pkg_rpm_epics)

echo "DEB"
echo $pkg_deb
echo "RPM"
echo $pkg_rpm


