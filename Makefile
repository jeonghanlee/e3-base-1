#
#  Copyright (c) 2107 - Present  Jeong Han Lee
#  Copyright (c) 2017 - Present  European Spallation Source ERIC
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
# Author  : Jeong Han Lee
# email   : han.lee@esss.se
# Date    : Wednesday, November  8 09:43:40 CET 2017
# version : 0.1.4

TOP:=$(CURDIR)

include $(TOP)/configure/CONFIG.EPICS
include $(TOP)/configure/CONFIG.MODULES

#-include $(TOP)/$(E3_ENV_NAME)/$(E3_ENV_NAME)
-include $(TOP)/$(E3_ENV_NAME)/e3-global-env

# In case, this variable is undefined
CROSS_COMPILER_TARGET_ARCHS ?=

define git_update =
@git submodule deinit -f $@/
git submodule deinit -f $@/
sed -i '/submodule/,$$d'  $(TOP)/.git/config	
git submodule init $@/
git submodule update --init --recursive --recursive $@/
git submodule update --remote --merge $@/
endef

define git_base_update =
@git submodule deinit -f $@/
git submodule deinit -f $@/
sed -i '/submodule/,$$d'  $(TOP)/.git/config	
git submodule init $@/
git submodule update --init --recursive $@/
endef

define set_base
$(QUIET) cd $(EPICS_BASE_SRC_PATH) && sudo -E make clean && git checkout -- * && git checkout tags/R$@
endef

define site_base
$(QUIET) m4 -D_CROSS_COMPILER_TARGET_ARCHS="$(CROSS_COMPILER_TARGET_ARCHS)" -D_EPICS_SITE_VERSION="EEE-$@-patch" \
-D_INSTALL_LOCATION="$(ESS_EPICS_PATH)/base-$@" $(TOP)/configure/config_site.m4 \
> $(EPICS_BASE)/configure/CONFIG_SITE;
$(QUIET) install -m 644 $(TOP)/configure/CONFIG_SITE_ENV  $(EPICS_BASE)/configure/;
endef


define patch_base
for i in $(wildcard $(TOP)/patch/R$@/*p0.patch); do\
	printf "\nPatching %s %s with the file : %s\n" "$(EPICS_BASE_SRC_PATH)" "$@" "$$i"; \
	patch -d $(EPICS_BASE_SRC_PATH) -p0 < $$i;\
done
endef


ifndef VERBOSE
  QUIET := @
endif

ifdef DEBUG_SHELL
  SHELL = /bin/sh -x
endif




# help is defined in 
# https://gist.github.com/rcmachado/af3db315e31383502660
help:
	$(info --------------------------------------- )	
	$(info Available targets)
	$(info --------------------------------------- )
	$(QUIET) awk '/^[a-zA-Z\-\_0-9]+:/ {            \
	  nb = sub( /^## /, "", helpMsg );              \
	  if(nb == 0) {                                 \
	    helpMsg = $$0;                              \
	    nb = sub( /^[^:]*:.* ## /, "", helpMsg );   \
	  }                                             \
	  if (nb)                                       \
	    print  $$1 "\t" helpMsg;                    \
	}                                               \
	{ helpMsg = $$0 }'                              \
	$(MAKEFILE_LIST) | column -ts:	


default: help


## Print and Reload ENV variables
env:
	$(QUIET) echo ""

	$(QUIET) echo "----- >>>> EPICS BASE Information <<<< -----"
	$(QUIET) echo ""
	$(QUIET) echo "EPICS_BASE                  : "$(EPICS_BASE)
	$(QUIET) echo "EPICS_BASE_TAG              : "$(EPICS_BASE_TAG)
	$(QUIET) echo "EPICS_HOST_ARCH             : "$(EPICS_HOST_ARCH)
	$(QUIET) echo "EPICS_BASE_NAME             : "$(EPICS_BASE_NAME)
	$(QUIET) echo "CROSS_COMPILER_TARGET_ARCHS : "$(CROSS_COMPILER_TARGET_ARCHS)
	$(QUIET) echo ""
	$(QUIET) echo ""
	$(QUIET) echo "----- >>>> ESS EPICS Environment  <<<< -----"
	$(QUIET) echo ""

	$(QUIET) echo "ESS_EPICS_PATH              : "$(ESS_EPICS_PATH)
	$(QUIET) echo "DEFAULT_EPICS_VERSIONS      : "$(DEFAULT_EPICS_VERSIONS)
	$(QUIET) echo "BASE_INSTALL_LOCATIONS      : "$(BASE_INSTALL_LOCATIONS)
	$(QUIET) echo ""


git-submodule-sync:
	$(QUIET) git submodule sync

#
## Initialize EPICS BASE and E3 ENVIRONMENT Module
init: git-submodule-sync $(EPICS_BASE_SRC_PATH) $(E3_ENV_NAME)

#
#
pkgs: $(PKG_AUTOMATION_NAME)

$(PKG_AUTOMATION_NAME): git-submodule-sync
	$(QUIET)$(git_update)
	bash $@/pkg_automation.bash

# EPICS Base doesn't have MASTER branch,
# 3.16 branch is selected for a 'virtual' master
#
$(EPICS_BASE_SRC_PATH): git-submodule-sync
	$(QUIET) $(git_base_update)
	cd $@ && git checkout 3.16

$(E3_ENV_NAME): git-submodule-sync
	$(QUIET) $(git_update)
	cd $@ && git checkout $(E3_ENV_TAG)

#
## Clean installed EPICS BASE(s) according to  $(DEFAULT_EPICS_VERSIONS)
clean: $(BASE_INSTALL_LOCATIONS)

$(BASE_INSTALL_LOCATIONS):
	$(QUIET) sudo rm -rf $@

#
## Build EPICS BASE(s) according to $(DEFAULT_EPICS_VERSIONS)
build: $(DEFAULT_EPICS_VERSIONS)


$(DEFAULT_EPICS_VERSIONS): 
	$(QUIET) echo $@;
	$(QUIET) $(set_base)
	$(QUIET) $(site_base)
ifneq (,$(findstring linux-ppc64e6500,$(CROSS_COMPILER_TARGET_ARCHS)))
	$(QUIET) install -m 644 $(TOP)/configure/os/CONFIG_SITE.Common.linux-ppc64e6500  $(EPICS_BASE)/configure/os/
endif
	$(QUIET) $(patch_base)
	$(QUIET) sudo -E $(MAKE) -C $(EPICS_BASE_NAME)
	$(QUIET) sudo install -m 755 -d "$(ESS_EPICS_PATH)/base-$@"/startup
	$(QUIET) sudo install -m 755 $(EPICS_BASE)/startup/EpicsHostArch.pl "$(ESS_EPICS_PATH)/base-$@"/startup/


.PHONY: help env git-submodule-sync build $(DEFAULT_EPICS_VERSIONS) clean $(BASE_INSTALL_LOCATIONS) init $(PKG_AUTOMATION_NAME) $(EPICS_BASE_SRC_PATH)  $(E3_ENV_NAME) 
