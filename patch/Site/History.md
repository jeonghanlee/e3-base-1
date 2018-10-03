# os_class.p0.patch

* EPICS BASE : R3.15.5, R3.16.1
* Description : fsl linux cross compile failure, discussed through tech-talks
* created by Jeong Han Lee, han.lee@esss.se
* https://epics.anl.gov/tech-talk/2018/msg00229.php
* Sunday, February  4 21:12:38 CET 2018

# ppc64e6500_epics_host_arch.p0.patch

* EPICS BASE  : R3.15.5
* Description : EpicsHostArch.pl doesn't have the linux-ppc64e6500 as the host arch.
                So, I added it. However, the limited usage of arch and cpu variables
				are used to define it. It may be changed later if we have the different
				Linux distribution
* Command used to create it
```jhlee@kaffee: epics-base ((R3.15.5))$ git diff --no-prefix startup/EpicsHostArch.pl > ../patch/Site/R3.15.5/ppc64e6500_epics_host_arch.p0.patch```
* created by Jeong Han Lee, han.lee@esss.se
* Wednesday, April 18 15:58:02 CEST 2018


# R7.0.1.1

* EPICS BASE : R7.0.1.1
* Description : softIocPVA has only the following EPICS lib dependency :
               EPICS_BASE_IOC_LIBS  : libdbRecStd.so libdbCore.so libca.so libCom.so
			   EPICS_BASE_PVA_CORE_LIBS : libpvAccess.so libpvData.so libpvAccessIOC.so libpvAccessCA.so
	           And, libqsrv.so
			   
			   However, we need libnt.so and libpvDatabase.so generically in softIocPVA, because this executable is the core program in iocsh.bash
			   
* Created by Jeong Han Lee, han.lee@esss.se
* Wednesday, October  3 12:57:07 CEST 2018
			    
