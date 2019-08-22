Community, but Site patch 
===

From EPICS base 3.16.2, the community releases the base extremely quickly. So we cannot define the STABLE and LTS (Long Term Support) fixed BASE number anymore. Even if there is a bug, I cannot find any more individual patch files in the EPICS web site. 

The only thing I can do is to follow the bug fix and security patch one by one, and create the patch file per a case. 

I will keep the same patch file in R3.15.X, so p0 patch file will be used.



# re-add missing enum_t 

There is a bug about `enum_t` in two talks 

* https://epics.anl.gov/core-talk/2019/msg00810.php
* https://epics.anl.gov/tech-talk/2019/msg01365.php

The bug was fixed at the following commit

https://github.com/epics-base/pva2pva/commit/e41269230c295d77ff61539ebcd48efff5fc3ef8

in pva2pva with 1.2.2 DEVELOPMENT.

Because of pva2pva, one need the following configuration also. The default git diff cannot return your changes in submodules, so one needs to add the following configuration in ~/.gitconfig
```
[diff]
	submodule=diff
```
Or run the following commands before.

```
$ git config --global diff.submodule diff
```

Note that `epics-base` has already ESS site specific patch files in `pva2pva`. Thus, we have to revertpatch first in order to create the clean patch file for only this change. 

```
epics-base ((R7.0.3))$ cd ..
e3-base (master)$ make patchrevert
e3-base (master)$ cd epics-base/
epics-base ((R7.0.3))$ git diff --no-prefix modules/pva2pva/
Submodule modules/pva2pva contains modified content
diff --git modules/pva2pva/pdbApp/pvif.cpp modules/pva2pva/pdbApp/pvif.cpp
index 2a681a5..0b91c16 100644
--- modules/pva2pva/pdbApp/pvif.cpp
+++ modules/pva2pva/pdbApp/pvif.cpp
@@ -682,6 +682,7 @@ ScalarBuilder::dtype(dbChannel *channel)
     if(dbr==DBR_ENUM)
         builder = builder->setId("epics:nt/NTEnum:1.0")
                          ->addNestedStructure("value")
+                           ->setId("enum_t")
                             ->add("index", pvd::pvInt)
                             ->addArray("choices", pvd::pvString)
                          ->endNested();

epics-base ((R7.0.3))$ git diff --no-prefix modules/pva2pva/ > ../patch/R7.0.3/re-add_missing_enum_t.p0.patch

```



