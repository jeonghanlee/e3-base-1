# Site Specific EPICS BASE Patch Files

## How to create a p0 patch file

* Modify a file which one would like to modify

* Check its status via git status

```
jhlee@hadron: epics-base ((R3.15.5))$ git status
HEAD detached at R3.15.5
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   configure/CONFIG_APP_INCLUDE

no changes added to commit (use "git add" and/or "git commit -a")
```
* Create p0 patch

```
jhlee@hadron: epics-base ((R3.15.5))$ git diff --no-prefix > ../patch/Site/R3.15.5/os_class.p0.patch
```

* Update Histdory.md in ../patch/Site directory

```
# os_class.p0.patch

fsl linux cross compile failure, discussed through tech-talks

* created by Jeong Han Lee, han.lee@esss.se
* https://epics.anl.gov/tech-talk/2018/msg00229.php
* Sunday, February  4 21:12:38 CET 2018
```


## How to apply the created patch to epics-base

Makefile apply patch files accrding to its base version.
