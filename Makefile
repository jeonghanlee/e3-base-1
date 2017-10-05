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
# Date    : Thursday, October  5 22:23:33 CEST 2017
# version : 0.1.0

TOP = $(CURDIR)

include $(TOP)/configure/CONFIG.EPICS
include $(TOP)/configure/CONFIG.MODULES

-include $(TOP)/$(E3_ENV_NAME)/$(E3_ENV_NAME)

define git_update =
@git submodule deinit -f $@/
git submodule deinit -f $@/
sed -i '/submodule/,$$d'  $(TOP)/.git/config	
git submodule init $@/
git submodule update --init --recursive $@/
git submodule update --remote --merge $@/
endef

define git_base_update =
@git submodule deinit -f $@/
git submodule deinit -f $@/
sed -i '/submodule/,$$d'  $(TOP)/.git/config	
git submodule init $@/
git submodule update --init --recursive $@/
endef

# In case, this variable is undefined
CROSS_COMPILER_TARGET_ARCHS ?=


# help is defined in 
# https://gist.github.com/rcmachado/af3db315e31383502660
help:
	$(info --------------------------------------- )	
	$(info Available targets)
	$(info --------------------------------------- )
	@awk '/^[a-zA-Z\-\_0-9]+:/ {                    \
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
	@echo ""
	@echo "EPICS_BASE                  : "$(EPICS_BASE)
	@echo "EPICS_HOST_ARCH             : "$(EPICS_HOST_ARCH)
	@echo "EPICS_BASE_NAME             : "$(EPICS_BASE_NAME)
	@echo "CROSS_COMPILER_TARGET_ARCHS : "$(CROSS_COMPILER_TARGET_ARCHS)
	@echo ""
	@echo "----- >>>> EPICS BASE Information <<<< -----"
	@echo ""
	@echo "EPICS_BASE_TAG              : "$(EPICS_BASE_TAG)
	@echo "CROSS_COMPILER_TARGET_ARCHS : "$(CROSS_COMPILER_TARGET_ARCHS)
	@echo ""
	@echo "----- >>>> ESS EPICS Environment  <<<< -----"
	@echo ""
	@echo "EPICS_LOCATION              : "$(EPICS_LOCATION)
	@echo "EPICS_MODULES               : "$(EPICS_MODULES)
	@echo "DEFAULT_EPICS_VERSIONS      : "$(DEFAULT_EPICS_VERSIONS)
	@echo "BASE_INSTALL_LOCATIONS      : "$(BASE_INSTALL_LOCATIONS)
	@echo "REQUIRE_VERSION             : "$(REQUIRE_VERSION)
	@echo "REQUIRE_PATH                : "$(REQUIRE_PATH)
	@echo "REQUIRE_TOOLS               : "$(REQUIRE_TOOLS)
	@echo "REQUIRE_BIN                 : "$(REQUIRE_BIN)
	@echo ""


git-submodule-sync:
	@git submodule sync

#
## Initialize EPICS BASE and E3 ENVIRONMENT Module
init: git-submodule-sync $(EPICS_BASE_NAME) $(E3_ENV_NAME)

#
# 
$(PKG_AUTOMATION_NAME): git-submodule-sync
	@$(git_update)
	bash $@/pkg_automation.bash

# EPICS Base doesn't have MASTER branch,
# 3.16 branch is selected for a 'virtual' master
#
$(EPICS_BASE_NAME): git-submodule-sync
	$(git_base_update)
	cd $@ && git checkout 3.16

$(E3_ENV_NAME): git-submodule-sync
	$(git_update)

#
## Clean installed EPICS BASE(s) according to  $(DEFAULT_EPICS_VERSIONS)
clean:
	@for subdir in $(BASE_INSTALL_LOCATIONS) ; do \
	     sudo rm -rf $$subdir ; \
	done

#
## Build EPICS BASE(s) according to $(DEFAULT_EPICS_VERSIONS)
build: $(DEFAULT_EPICS_VERSIONS)

$(DEFAULT_EPICS_VERSIONS): 
	@echo $@;
	@cd $(EPICS_BASE_SRC_PATH) && sudo -E make clean && git checkout -- * && git checkout tags/R$@
	@m4 -D_CROSS_COMPILER_TARGET_ARCHS="$(CROSS_COMPILER_TARGET_ARCHS)" \
	-D_EPICS_SITE_VERSION="EEE-$@" -D_INSTALL_LOCATION="$(EPICS_LOCATION)/base-$@" \
	$(TOP)/configure/config_site.m4  > $(EPICS_BASE)/configure/CONFIG_SITE
	@install -m 664 $(TOP)/configure/CONFIG_SITE_ENV  $(EPICS_BASE)/configure/
ifneq (,$(findstring linux-ppc64e6500,$(CROSS_COMPILER_TARGET_ARCHS)))
	@install -m 664 $(TOP)/configure/os/CONFIG_SITE.Common.linux-ppc64e6500  $(EPICS_BASE)/configure/os/
endif
	sudo -E $(MAKE) -C $(EPICS_BASE_NAME)
	@echo "This is the temporary solution for startup dir"
	@sudo install -d -m 755 "$(EPICS_LOCATION)/base-$@"/startup
	@sudo install -m 755 $(EPICS_BASE)/startup/EpicsHostArch.pl "$(EPICS_LOCATION)/base-$@"/startup/


.PHONY: help env git-submodule-sync build clean init
