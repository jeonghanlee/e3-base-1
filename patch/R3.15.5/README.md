Here is the directory, where ESS would like to keep EPICS Base R3.15.5 patch files. The human
interaction should be involved this directory. I (han.lee_at_esss.se) added the date as the prefix
of each patch file. 

Please see the detail information at

http://www.aps.anl.gov/epics/base/R3-15/5-docs/KnownProblems.html

```
    % cd /path/to/base-3.15.5
    % patch -p0 < /path/to/file.patch
```

The following significant problems have been reported with this version of EPICS Base:

* 2017-08-31: This patch is a fix for Launchpad bug 1678494 which causes 3.15.5 IOCs to crash when reading a single character from a long string (i.e. DBF_CHAR) array.
* 2017-08-23: setsockopt(..., IP_MULTICAST_LOOP, ...) needs a different type for its data value argument on different OSs. This patch should fix the issue for the OSs we know about.
* 2017-06-22: Constant link initialization is possible using hex numbers for IOCs running 3.14.12, but is broken in 3.15 releases. This patch fixes the issue and allows hex constants in some places where they didn't work before.
* 2017-04-24: IOCs with very large numbers of CA links may crash on shutdown due to a bug in the dbCa code. This patch solves the issue.

```
jhlee@kaffee: epics-base ((R3.15.5))$ git st
HEAD detached at R3.15.5
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)


        modified:   src/ca/client/udpiiu.cpp
        modified:   src/ioc/db/dbAccess.c
        modified:   src/ioc/db/dbCa.c
        modified:   src/ioc/db/dbLink.c
        modified:   src/ioc/rsrv/caservertask.c
        modified:   src/libCom/osi/os/Darwin/osdSock.h
        modified:   src/libCom/osi/os/Linux/osdSock.h
        modified:   src/libCom/osi/os/RTEMS/osdSock.h
        modified:   src/libCom/osi/os/WIN32/osdSock.h
        modified:   src/libCom/osi/os/cygwin32/osdSock.h
        modified:   src/libCom/osi/os/freebsd/osdSock.h
        modified:   src/libCom/osi/os/iOS/osdSock.h
        modified:   src/libCom/osi/os/solaris/osdSock.h
        modified:   src/libCom/osi/os/vxWorks/osdSock.h

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        src/ioc/rsrv/caservertask.c.orig
        src/libCom/osi/os/solaris/osdSock.h.orig
		```
		

