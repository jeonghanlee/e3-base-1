#!/bin/bash

gather_info() {
    echo "----------------------------------------------------------------------"
    /bin/bash --version | head -1
    gather lsb_release --all
    gather /etc/lsb-release
    gather /etc/os-release
    gather /etc/debian_version
    gather /etc/apt/sources.list
    gather /etc/redhat-release
    gather /etc/SuSE-release
    gather /etc/arch-release
    gather /etc/gentoo-release
    echo "----------------------------------------------------------------------"
    exit 0
}

