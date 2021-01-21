NAME       := mercury
SRC_EXT    := gz
DL_VERSION := 2.0.1rc1

SLES_15_REPOS = $(OPENSUSE_REPOS_MIRROR)/repositories/science:/HPC/openSUSE_Leap_15.1/

include packaging/Makefile_packaging.mk
