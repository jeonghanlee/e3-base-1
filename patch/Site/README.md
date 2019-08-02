# Site Specific EPICS BASE Patch Files

Here is the real example, how we can create the ESS specific patch files for EPICS Base. I assume that readers should understand why we have to create these patch files. 

## Site Patch Files for BASE 7.0.3

### os_class.p0.patch

```
jhlee@hadron: epics-base ((R7.0.3))$ git diff --no-prefix configure/CONFIG_APP_INCLUDE 
diff --git configure/CONFIG_APP_INCLUDE configure/CONFIG_APP_INCLUDE
index 8b4bd7d08..21de4ad39 100644
--- configure/CONFIG_APP_INCLUDE
+++ configure/CONFIG_APP_INCLUDE
@@ -19,7 +19,7 @@ define  RELEASE_FLAGS_template
   $(1)_LIB = $$(wildcard $$(strip $$($(1)))/lib/$(T_A))
   SHRLIB_SEARCH_DIRS += $$($(1)_LIB)
   RELEASE_INCLUDES += $$(addprefix -I,$$(wildcard $$(strip $$($(1)))/include/compiler/$(CMPLR_CLASS)))
-  RELEASE_INCLUDES += $$(addprefix -I,$$(wildcard $$(strip $$($(1)))/include/os/$(OS_CLASS)))
+  RELEASE_INCLUDES += $$(addprefix -I,$$(wildcard $$(strip $$($(1)))/include/os/$$(OS_CLASS)))
   RELEASE_INCLUDES += $$(addprefix -I,$$(wildcard $$(strip $$($(1)))/include))
   RELEASE_DBD_DIRS += $$(wildcard $$(strip $$($(1)))/dbd)
   RELEASE_DB_DIRS += $$(wildcard $$(strip $$($(1)))/db)

jhlee@hadron: epics-base ((R7.0.3))$  git diff --no-prefix configure/CONFIG_APP_INCLUDE > ../patch/Site/R7.0.3/os_class.p0.patch
```

### enable_new_dtags.p0.patch

```
jhlee@hadron: epics-base ((R7.0.3))$ git diff --no-prefix configure/CONFIG.gnuCommon
diff --git configure/CONFIG.gnuCommon configure/CONFIG.gnuCommon
index c4fd8cedd..d30910c5a 100644
--- configure/CONFIG.gnuCommon
+++ configure/CONFIG.gnuCommon
@@ -57,8 +57,8 @@ STATIC_LDFLAGS_YES = -static
 STATIC_LDFLAGS_NO =
 
 SHRLIB_CFLAGS = -fPIC
-SHRLIB_LDFLAGS = -shared -fPIC
-LOADABLE_SHRLIB_LDFLAGS = -shared -fPIC
+SHRLIB_LDFLAGS = -shared -fPIC  -Wl,--enable-new-dtags
+LOADABLE_SHRLIB_LDFLAGS = -shared -fPIC  -Wl,--enable-new-dtags
 
 GNU_LDLIBS_YES = -lgcc

jhlee@hadron: epics-base ((R7.0.3))$ git diff --no-prefix configure/CONFIG.gnuCommon > ../patch/Site/R7.0.3/enable_new_dtags.p0.patch 

```

### add_pvdatabase_nt_softIocPVA.p0.patch

Here the default git diff cannot return your changes in submodules, so one needs to add the following configuration in ~/.gitconfig
```
[diff]
	submodule=diff
```
Or run the following commands before.

```
$ git config --global diff.submodule diff
```


```
jhlee@hadron: epics-base ((R7.0.3))$ git diff --no-prefix modules/pva2pva/
Submodule modules/pva2pva contains modified content
diff --git modules/pva2pva/pdbApp/Makefile modules/pva2pva/pdbApp/Makefile
index ee78988..38d0d60 100644
--- modules/pva2pva/pdbApp/Makefile
+++ modules/pva2pva/pdbApp/Makefile
@@ -61,12 +61,15 @@ FINAL_LOCATION ?= $(shell $(PERL) $(TOOLS)/fullPathName.pl $(INSTALL_LOCATION))
 
 USR_CPPFLAGS += -DFINAL_LOCATION="\"$(FINAL_LOCATION)\""
 
+USR_LDFLAGS += -Wl,--no-as-needed
+
 PROD_IOC += softIocPVA
 
 softIocPVA_SRCS += softMain.cpp
 softIocPVA_SRCS += softIocPVA_registerRecordDeviceDriver.cpp
 
 softIocPVA_LIBS += qsrv
+softIocPVA_LIBS += pvDatabase nt
 softIocPVA_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
 softIocPVA_LIBS += $(EPICS_BASE_IOC_LIBS)
 
@@ -81,6 +84,7 @@ endif
 softIocPVA_DBD += softIoc.dbd
 softIocPVA_DBD += PVAServerRegister.dbd
 softIocPVA_DBD += qsrv.dbd
+softIocPVA_DBD += registerChannelProviderLocal.dbd
 
 #===========================

jhlee@hadron: epics-base ((R7.0.3))$ git diff --no-prefix modules/pva2pva/ > ../patch/Site/R7.0.3/add_pvdatabase_nt_softIocPVA.p0.patch
```


### remove_mkdir_from_rules_build.p0.patch

```
jhlee@hadron: epics-base ((R7.0.3))$ git diff --no-prefix configure/RULES_BUILD
diff --git configure/RULES_BUILD configure/RULES_BUILD
index 2a78a96b1..b9a43e2c2 100644
--- configure/RULES_BUILD
+++ configure/RULES_BUILD
@@ -307,7 +307,7 @@ $(LOADABLE_SHRLIBNAME): $(LOADABLE_SHRLIB_PREFIX)%$(LOADABLE_SHRLIB_SUFFIX):
 
 $(LIBNAME) $(SHRLIBNAME) $(LOADABLE_SHRLIBNAME): | $(INSTALL_LIB)
 $(INSTALL_LIB):
-       @$(MKDIR) $@
+#      @$(MKDIR) $@
 
 #---------------------------------------------------------------
 # C++ munching for VxWorks

jhlee@hadron: epics-base ((R7.0.3))$ git diff --no-prefix configure/RULES_BUILD > ../patch/Site/R7.0.3/remove_mkdir_from_rules_build.p0.patch

```

### ess_epics_host_arch.p0.patch

```
jhlee@hadron: epics-base ((R7.0.3))$ git diff --no-prefix src/tools/EpicsHostArch.pl
diff --git src/tools/EpicsHostArch.pl src/tools/EpicsHostArch.pl
index e8e49bc5e..3b228035c 100644
--- src/tools/EpicsHostArch.pl
+++ src/tools/EpicsHostArch.pl
@@ -42,6 +42,10 @@ sub HostArch {
         return 'solaris-x86'    if m/^i86pc-solaris/;
 
         my ($kernel, $hostname, $release, $version, $cpu) = uname;
+       if (m/^x86_64-linux/) {
+           if ( $release=~ m/cct$/) {return "linux-corei7-poky";}
+           else                     {return "linux-x86_64"; }
+       }
         if (m/^darwin/) {
             for ($cpu) {
                 return 'darwin-x86' if m/^(i386|x86_64)/;
@@ -49,7 +53,12 @@ sub HostArch {
             }
             die "$0: macOS CPU type '$cpu' not recognized\n";
         }
-
+        if (m/^powerpc64-linux/) {
+            for ($cpu) {
+               return 'linux-ppc64e6500' if m/^ppc64/;
+            }
+            die "$0: linux-ppc64 OS CPU type '$cpu' not recognized\n";
+        }
         die "$0: Architecture '$arch' not recognized\n";
     }
 }

jhlee@hadron: epics-base ((R7.0.3))$ git diff --no-prefix src/tools/EpicsHostArch.pl > ../patch/Site/R7.0.3/ess_epics_host_arch.p0.patch

```