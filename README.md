# E3-BASE

This is the pilot project to build the EPICS BASE(s) in order to build the ESS EPICS Environment (aka E3). However, it can be used to build a generic EPICS base also. 


## Tested Platform

* Debian 8
* CentOS 7

## Procedure


```
$ make init
```

Print pre-defined environments
```
$ make env
```

Modify e3-env/e3-env file for
* EPICS_BASE_TAGS
* CROSS_COMPILER_TARGET_ARCHS
* EPICS Installation Location : (should be in / directory, the makefile and other commands are optimized with this working model)

```
$ make env
```

If one needs to install any required pkgs, please do
```
$ make pkgs
```
Currently, please execute twice with CentOS.

Build and Install EPICS BASE(s). Note that SUDO permission is needed.

```
$ make build
```

## Cross compilier should be ready
```
$ tree -L 1 /opt/fsl-qoriq/
/opt/fsl-qoriq/
├── [root     4.0K]  1.9
├── [root     4.0K]  2.0
└── [root        4]  current -> 2.0/
```


## Example

```
e3-base (master)$ make env

EPICS_BASE                  : /home/jhlee/gitsrc/e3-base/epics-base
EPICS_HOST_ARCH             : linux-x86_64
EPICS_BASE_NAME             : epics-base
CROSS_COMPILER_TARGET_ARCHS : linux-ppc64e6500

----- >>>> EPICS BASE Information <<<< -----

EPICS_BASE_TAG              : R3.15.4 R3.15.5 R3.16.1
CROSS_COMPILER_TARGET_ARCHS : linux-ppc64e6500

----- >>>> ESS EPICS Environment  <<<< -----

EPICS_LOCATION              : /e3/bases
EPICS_MODULES               : /e3/modules
DEFAULT_EPICS_VERSIONS      : 3.15.4 3.15.5 3.16.1
BASE_INSTALL_LOCATIONS      : /e3/bases/base-3.15.4 /e3/bases/base-3.15.5 /e3/bases/base-3.16.1
REQUIRE_VERSION             : 2.5.3
REQUIRE_PATH                : /e3/modules/require/2.5.3
REQUIRE_TOOLS               : /e3/modules/require/2.5.3/tools
REQUIRE_BIN                 : /e3/modules/require/2.5.3/bin
```


```
root@kaffee:/e3/bases# tree -L 2
.
├── base-3.15.4
│   ├── bin
│   ├── configure
│   ├── db
│   ├── dbd
│   ├── html
│   ├── include
│   ├── lib
│   ├── startup
│   └── templates
├── base-3.15.5
│   ├── bin
│   ├── configure
│   ├── db
│   ├── dbd
│   ├── html
│   ├── include
│   ├── lib
│   ├── startup
│   └── templates
└── base-3.16.1
    ├── bin
    ├── configure
    ├── db
    ├── dbd
    ├── html
    ├── include
    ├── lib
    ├── startup
    └── templates
	
root@kaffee:/e3/bases# tree -L 1 base-3.15.5/bin/
base-3.15.5/bin/
├── linux-ppc64e6500
└── linux-x86_64

```

## Site Configuration
We have the following information in CONFIG_SITE_ENV

```
EPICS_TIMEZONE = CET/CEST::-60:032602:102902
EPICS_TS_NTP_INET=mmo1.ntp.se
IOCSH_PS1="e3> "
IOCSH_HISTSIZE=100
EPICS_IOC_LOG_FILE_LIMIT=1000000
```
