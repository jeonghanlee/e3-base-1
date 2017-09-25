# eee-base

This is the pilot project to build the EPICS BASE(s) in order to build the ESS EPICS Environment (aka EEE). However, it will be used to build a generic EPICS base also.


## Tested Platform

* Debian 8
* CentOS 7


## Procedure

* Edit configure/CONFIG
* make init
* make build or sudo -E make build (in case EEE_BASES_PATH in a location, where root can access)


## If CONFIG is changed
* make init     (Set EPICS BASE_TAG properly)
* make prepare  (Set EEE_BASE_VERISON properly)
* make build


## One wants to install EPICS base 3.15.5 and 3.16.1

* set
```
EPICS_BASE_TAG:=R3.15.5
EEE_BASE_VERSION=3.15.5
```
in configure/CONFIG
```
$ make init
$ make prepare
$ make build or sudo -E make build
```

* set
```
EPICS_BASE_TAG:=R3.16.1
EEE_BASE_VERSION=3.16.1
```
in configure/CONFIG
```
$ make init
$ make prepare
$ make build or sudo -E make build
```


Then, one can see the following in

```
jhlee@kaffee: eee$ tree -L 2 /eee/bases/
/eee/bases/
├── [root     4.0K]  base-3.15.5
│   ├── [root     4.0K]  bin
│   ├── [root     4.0K]  configure
│   ├── [root     4.0K]  db
│   ├── [root     4.0K]  dbd
│   ├── [root     4.0K]  html
│   ├── [root      12K]  include
│   ├── [root     4.0K]  lib
│   └── [root     4.0K]  templates
└── [root     4.0K]  base-3.16.1
    ├── [root     4.0K]  bin
    ├── [root     4.0K]  configure
    ├── [root     4.0K]  db
    ├── [root     4.0K]  dbd
    ├── [root     4.0K]  html
    ├── [root      12K]  include
    ├── [root     4.0K]  lib
    └── [root     4.0K]  templates
```
