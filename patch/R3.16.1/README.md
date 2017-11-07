Here is the directory, where ESS would like to keep EPICS Base R3.16.1 patch files. The human
interaction should be involved this directory. I (han.lee_at_esss.se) added the date as the prefix
of each patch file. 

Please see the detail information at

http://www.aps.anl.gov/epics/base/R3-16/1-docs/KnownProblems.html


```
% cd /path/to/base-3.16.1
% patch -p1 < /path/to/file.patch

```

* 2017-09-25: CA puts to several output record types that are using the Soft Channel device support can generate "Channel write request failed" error messages from 3.16.1 IOCs. To clean these errors up, apply this patch.
* 2017-09-19: Building MEDM against 3.16.1 fails due to a typo in the libCom cvtFast.c file, which can be fixed with this patch.
* IOCs running on some versions of Cygwin may display warnings at iocInit about duplicate EPICS CA Address list entries. These warnings might be due to a bug in Cygwin; they are benign and can be ignored.
* 64-bit Windows builds of the CAS library may not work with some compilers. The code in src/legacy/gdd is incompatible with the LLP64 model that Windows uses for its 64-bit ABI.


However, we would like to use p0 instead of p1, we changed it in wget_patch.bash scripts. And the original patch files are intact.


```
HEAD detached at R3.16.1
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   src/ioc/db/dbConstLink.c
        modified:   src/libCom/cvtFast/cvtFast.c
        modified:   src/std/link/lnkConst.c

no changes added to commit (use "git add" and/or "git commit -a")
```
