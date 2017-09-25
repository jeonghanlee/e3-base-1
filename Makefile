#
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
# Date    : Monday, September 25 13:50:41 CEST 2017
# version : 0.0.2

TOP = $(CURDIR)
include $(TOP)/configure/CONFIG


M_DIRS:=$(sort $(dir $(wildcard $(TOP)/*/.)))


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


## Print ENV variables
env:
	@echo ""
	@echo "EPICS_BASE_NAME             : "$(EPICS_BASE_NAME)
	@echo "EPICS_BASE_TAG              : "$(EPICS_BASE_TAG)
	@echo "EPICS_BASE_SRC_PATH         : "$(EPICS_BASE_SRC_PATH)
	@echo ""
	@echo "EPICS_BASE                  : "$(EPICS_BASE)
	@echo "EPICS_HOST_ARCH             : "$(EPICS_HOST_ARCH)
	@echo ""

	@echo "EEE_BASE_VERSION            : "$(EEE_BASE_VERSION)
	@echo "EEE_BASES_PATH              : "$(EEE_BASES_PATH)
#	@echo "EEE_MODULES_PATH            : "$(EEE_MODULES_PATH)
#	@echo ""

#	@echo "EPICS_BASES_PATH            : "$(EPICS_BASES_PATH)
#	@echo "EPICS_MODULES_PATH          : "$(EPICS_MODULES_PATH)
#	@echo "EPICS_HOST_ARCH             : "$(EPICS_HOST_ARCH)
#	@echo "EPICS_ENV_PATH              : "$(EPICS_ENV_PATH)
#	@echo ""

	@echo "CROSS_COMPILER_TARGET_ARCHS : " $(CROSS_COMPILER_TARGET_ARCHS)
	@echo "EPICS_SITE_VERSION          : " $(EPICS_SITE_VERSION)
	@echo ""


dirs:
	@echo $(M_DIRS) || true

## Must run the first time ever
once:
	@git submodule init $(EPICS_BASE_NAME)
	@git submodule update --init --recursive $(EPICS_BASE_NAME)/.



git-submodule-sync:
	git submodule sync




## Initialize $(EPICS_BASE_NAME) with $(EPICS_BASE_TAG)
init:   git-submodule-sync
	@git submodule deinit -f $(EPICS_BASE_NAME)/
	git submodule deinit -f $(EPICS_BASE_NAME)/
	sed -i '/submodule/,$$d'  $(TOP)/.git/config	
	git submodule init $(EPICS_BASE_NAME)
	git submodule update --init --recursive $(EPICS_BASE_NAME)/.
	cd $(EPICS_BASE_NAME) && git checkout tags/$(EPICS_BASE_TAG)


## Build $(EPICS_BASE_NAME)
build: prepare
	$(MAKE) -C $(EPICS_BASE_NAME)


## Clean only $(EPICS_BASE_NAME).
clean:
	$(MAKE) -C $(EPICS_BASE_NAME) clean

## In case, sudo permission will make one trouble, rm touched $(EPICS_BASE_NAME)
distclean:
	@sudo rm -rf $(EPICS_BASE_NAME)

## Rebuild $(EPICS_BASE_NAME).
rebuild:
	$(MAKE) -C $(EPICS_BASE_NAME) rebuild


# Please consult config_site.m4 when one would like to use the different configuration in CONFIG_SITE
# -D_ options gives an user to select what one wants to do.
## Prepare EPICS BASE SITE Configuration
prepare: 
#	@m4 -D_CROSS_COMPILER_TARGET_ARCHS="$(CROSS_COMPILER_TARGET_ARCHS)" -D_EPICS_SITE_VERSION="$(EPICS_SITE_VERSION)"  $(TOP)/configure/config_site.m4  > $(EPICS_BASE)/configure/CONFIG_SITE
	@m4 -D_CROSS_COMPILER_TARGET_ARCHS="$(CROSS_COMPILER_TARGET_ARCHS)" \
	    -D_EPICS_SITE_VERSION="$(EPICS_SITE_VERSION)" \
	    -D_INSTALL_LOCATION="$(EEE_BASES_PATH)" \
	    $(TOP)/configure/config_site.m4  > $(EPICS_BASE)/configure/CONFIG_SITE
	@install -m 664 $(TOP)/configure/CONFIG_SITE_ENV  $(EPICS_BASE)/configure/
ifneq (,$(findstring base,$(EEE_BASES_PATH)))
	@echo "Installation Path : "$(EEE_BASES_PATH)
endif

ifneq (,$(findstring linux-ppc64e6500,$(CROSS_COMPILER_TARGET_ARCHS)))
	@install -m 664 $(TOP)/configure/os/CONFIG_SITE.Common.linux-ppc64e6500  $(EPICS_BASE)/configure/os/
endif




.PHONY: help env dirs init git-msync base-init build clean rebuild
