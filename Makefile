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
# Date    : Thursday, September 21 09:35:24 CEST 2017
# version : 0.0.1

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
	@echo "Temp. EPICS_BASE       : "$(EPICS_BASE)
	@echo "EPICS_HOST_ARCH        : "$(EPICS_HOST_ARCH)
	@echo "EPICS_BASE_NAME        : "$(EPICS_BASE_NAME)
	@echo "EPICS_BASE_TAG         : "$(EPICS_BASE_TAG)
	@echo "EPICS_BASE_SRC_PATH    : "$(EPICS_BASE_SRC_PATH)
	@echo ""
	@echo "EPICS_MODULE_NAME      : "$(EPICS_MODULE_NAME)
	@echo "EPICS_MODULE_TAG       : "$(EPICS_MODULE_TAG)
	@echo "EPICS_MODULE_SRC_PATH  : "$(EPICS_MODULE_SRC_PATH)
	@echo "ESS_MODULE_MAKEFILE    : "$(ESS_MODULE_MAKEFILE)
	@echo "PROJECT                : "$(PROJECT)
	@echo "LIBVERSION             : "$(LIBVERSION)
	@echo ""

	@echo "EEE_BASE_VERSION       : "$(EEE_BASE_VERSION)
	@echo "EEE_BASES_PATH         : "$(EEE_BASES_PATH)
	@echo "EEE_MODULES_PATH       : "$(EEE_MODULES_PATH)


	@echo "EPICS_BASES_PATH       : "$(EPICS_BASES_PATH)
	@echo "EPICS_MODULES_PATH     : "$(EPICS_MODULES_PATH)
	@echo "EPICS_HOST_ARCH        : "$(EPICS_HOST_ARCH)
	@echo "EPICS_ENV_PATH         : "$(EPICS_ENV_PATH)
	@echo ""



dirs:
	@echo $(M_DIRS) || true

## 
init:
	git submodule init $(EPICS_BASE_NAME)
	git submodule update --init --recursive $(EPICS_BASE_NAME)/.



git-submodule-sync:
	git submodule sync




## Initialize $(EPICS_BASE_NAME) with $(EPICS_BASE_TAG)
base-init:  git-submodule-sync
	@git submodule deinit -f $(EPICS_BASE_NAME)/
	git submodule deinit -f $(EPICS_BASE_NAME)/
	sed -i '/submodule/,$$d'  $(TOP)/.git/config	
	git submodule init $(EPICS_BASE_NAME)
	git submodule update --init --recursive $(EPICS_BASE_NAME)/.
	cd $(EPICS_BASE_NAME) && git checkout tags/$(EPICS_BASE_TAG)


## Build $(EPICS_BASE_NAME)
base-build: base-init
	$(MAKE) -C $(EPICS_BASE_NAME)


## Clean only $(EPICS_BASE_NAME).
base-clean:
	$(MAKE) -C $(EPICS_BASE_NAME) clean




## Get      EPICS Module, and change its $(EPICS_MODULE_TAG)
env-init: git-submodule-sync
	@git submodule deinit -f $(EPICS_MODULE_NAME)/
	git submodule deinit -f $(EPICS_MODULE_NAME)/	
	git submodule init $(EPICS_MODULE_NAME)/
	git submodule update --init --remote --recursive $(EPICS_MODULE_NAME)/.
#	cd $(EPICS_MODULE_NAME) && git checkout tags/$(EPICS_MODULE_TAG)


## Build     EPICS Module in order to use it with EEE
env-build: 
	$(MAKE) -C $(EPICS_MODULE_NAME) build


## Install   EPICS Module in order to use it with EEE
env-install:
	$(MAKE) -C $(EPICS_MODULE_NAME) install


## Clean     EPICS Module in terms of EEE Makefile (module.Makefile)
env-clean:
	$(MAKE) -C $(EPICS_MODULE_NAME) clean


## Distclean EPICS Module in terms of EEE Makefile (module.Makefile)
env-distclean:
	$(MAKE) -C $(EPICS_MODULE_NAME) distclean




.PHONY: help env dirs init git-msync base-init base-clean base-build env-install env-build env-clean env-distclean env-init


