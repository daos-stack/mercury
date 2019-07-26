NAME    := mercury
SRC_EXT := bz2
SOURCE   = https://github.com/mercury-hpc/$(NAME)/releases/download/v$(VERSION)/$(NAME)-$(VERSION).tar.$(SRC_EXT)
#PATCH1 is reversed for RPMS.
PATCH1  := https://github.com/mercury-hpc/mercury/compare/v1.0.1...cc0807e8377e129945834d292be21a6667a8cbb3.patch
ID_LIKE1=$(shell . /etc/os-release; echo $$ID_LIKE)
ifeq ($(ID_LIKE1),debian)
# Debian can not use a reverse patch
PATCHES := $(shell rm -rf _topdir/BUILD) v1.0.1...cc0807e8377e129945834d292be21a6667a8cbb3.patch
else
PATCHES := v1.0.1...cc0807e8377e129945834d292be21a6667a8cbb3.patch
endif

v1.0.1...cc0807e8377e129945834d292be21a6667a8cbb3.patch
	curl -f -L -O '$(PATCH1)'

include Makefile_packaging.mk
