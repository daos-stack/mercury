NAME        := mercury
VERSION     := 1.0.1
RELEASE     := 2
DIST        := $(shell rpm --eval %{dist})
SRPM        := _topdir/SRPMS/$(NAME)-$(VERSION)-$(RELEASE)$(DIST).src.rpm
RPMS        := _topdir/RPMS/x86_64/$(NAME)-$(VERSION)-$(RELEASE)$(DIST).x86_64.rpm           \
	       _topdir/RPMS/x86_64/$(NAME)-devel-$(VERSION)-$(RELEASE)$(DIST).x86_64.rpm     \
	       _topdir/RPMS/x86_64/$(NAME)-debuginfo-$(VERSION)-$(RELEASE)$(DIST).x86_64.rpm
SPEC        := $(NAME).spec
SRC_EXT     := bz2
SOURCE      := https://github.com/mercury-hpc/$(NAME)/releases/download/v$(VERSION)/$(NAME)-$(VERSION).tar.$(SRC_EXT)
#PATCH1      := https://github.com/mercury-hpc/mercury/commit/9f9dd80164a2b14b184f2b373efeb50a5fc80dc5.patch
PATCH1      := https://github.com/mercury-hpc/mercury/compare/c68870ffc0409c29eece5ba036c6efd3c22cee41^...v1.0.1.patch
SOURCES     := _topdir/SOURCES/$(NAME)-$(VERSION).tar.$(SRC_EXT) _topdir/SOURCES/c68870ffc0409c29eece5ba036c6efd3c22cee41^...v1.0.1.patch #_topdir/SOURCES/9f9dd80164a2b14b184f2b373efeb50a5fc80dc5.patch
TARGETS      := $(RPMS) $(SRPM)

all: $(TARGETS)

%/:
	mkdir -p $@

_topdir/SOURCES/%: % | _topdir/SOURCES/
	rm -f $@
	ln $< $@

$(NAME)-$(VERSION).tar.$(SRC_EXT):
	curl -f -L -O '$(SOURCE)'

#9f9dd80164a2b14b184f2b373efeb50a5fc80dc5.patch:
c68870ffc0409c29eece5ba036c6efd3c22cee41^...v1.0.1.patch:
	curl -f -L -O '$(PATCH1)'

# see https://stackoverflow.com/questions/2973445/ for why we subst
# the "rpm" for "%" to effectively turn this into a multiple matching
# target pattern rule
$(subst rpm,%,$(RPMS)): $(SPEC) $(SOURCES)
	rpmbuild -bb --define "%_topdir $$PWD/_topdir" $(SPEC)

$(SRPM): $(SPEC) $(SOURCES)
	rpmbuild -bs --define "%_topdir $$PWD/_topdir" $(SPEC)

srpm: $(SRPM)

$(RPMS): Makefile

rpms: $(RPMS)

ls: $(TARGETS)
	ls -ld $^

mockbuild: $(SRPM) Makefile
	mock $<

rpmlint: $(SPEC)
	rpmlint $<

.PHONY: srpm rpms ls mockbuild rpmlint FORCE
