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


# add_pvdatabase_nt_softIocPVA.p0.patch

* EPICS BASE : R7.0.1.1
* Description : softIocPVA has only the following EPICS lib dependency :
               EPICS_BASE_IOC_LIBS  : libdbRecStd.so libdbCore.so libca.so libCom.so
			   EPICS_BASE_PVA_CORE_LIBS : libpvAccess.so libpvData.so libpvAccessIOC.so libpvAccessCA.so
	           And, libqsrv.so
			   
			   Ubuntu needs the following LDFLAGS in order to link libnt.so
			   
		       USR_LDFLAGS += -Wl,--no-as-needed
			   
			   However, we need libnt.so and libpvDatabase.so generically in softIocPVA, because this executable is the core program in iocsh.bash
			   
			   And it is now tricy to create p0.patch because it stays in gitsubmodule
			   cd pvapva
		       git diff  pdbApp/Makefile > ../../../patch/Site/R7.0.1.1/add_pvdatabase_nt_softIocPVA.p0.patch
					   
			   edit to replace */pdbApp/Makefile with modules/pva2pva/pdbApp/Makefile
			   
			   
* Created by Jeong Han Lee, han.lee@esss.se
* Wednesday, October  3 22:05:34 CEST 2018
			    


# R3.15.X

There are two patch files are needed for R3.15.5 with Yocto Cross Compiler tools. 
* `cortexa9hf-neon-corei7-poky_dbltExpand_lib_p0.patch`
* `cortexa9hf-neon-corei7-poky_ioc_prod_lib.p0.patch`

However, R3.15.6, makefile was updated to cover dbltExpand_lib_p0.patch. So we don't need this patch. In addition,
even if we don't have ioc_prod_lib.p0.patch in R3.15.6, we can compile R3.15.6 base without any issues. 



