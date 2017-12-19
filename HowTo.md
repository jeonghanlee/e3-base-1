# How to install the different EPICS BASE

## Deployment Mode


Most of case, only configure/CONFIG_BASE should be edited according to the proper git tags of the EPICS BASE.
One should define the local E3 version of this base as it is. 

```
  EPICS_BASE_TAG:=tags/R3.16.1
  E3_BASE_VERSION:=3.16.1
``

In case, the old information (patch, and any modifications) in $(E3_BASE_SRC_PATH) exists, it should have no modification in that directory. Practically, the following steps should help 

```
sudo rm -rf epics-base/*
make init
make build
```

If one wants to apply the existent patch files to epics base, please consider to run the patch command before build command. 
```
make patch
make build
```
Patch files can be reverted via
```
make patchrevert
```


## Development Mode
