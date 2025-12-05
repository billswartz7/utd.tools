AUTOMAKE_OPTIONS = foreign
ACLOCAL_AMFLAGS = -I m4

SUBDIRS = .

SUB_DIRS := \
	 libs/utd/automake \
	 libs/tcl/unix \
	 libs/tk/unix \
	 libs/tix \
	 libs/blt/automake \
	 libs/gui/automake \
	 pgms/python/automake \
	 libs/base/automake \
	 libs/js/automake \
	 libs/tclpython/automake \
	 libs/sverilog/automake \
	 libs/expect/automake \
	 libs/prtable/automake \
	 libs/tcludp/automake \
	 pgms/byacc/automake \
	 pgms/cometFlow/automake \
	 pgms/cometTix/automake \
	 pgms/valgrindp/automake \
	 pgms/verilog-11.0/automake \
	 pgms/yosys-abc/automake


PYTHON_DSCRIPTS = \
	 easy_install-3.8 \
	 pip3 \
	 pip3.8

PYTHON_DSCRIPTS2 = \
	2to3-3.8 \
	idle3 \
	idle3.8 \
	pydoc3.8 \
	python3-config \
	python3.8-config

AUTOMAKE_DIRS = \
	 libs/utd/automake \
	 libs/blt/automake \
	 libs/js/automake \
	 libs/gui/automake \
	 libs/base/automake \
	 libs/tclpython/automake \
	 libs/sverilog/automake \
	 libs/prtable/automake \
	 pgms/byacc/automake \
	 pgms/cometFlow/automake \
	 pgms/cometTix/automake \
	 pgms/valgrindp/automake

## This is the name of the last library built.  We need this
## because we want to install the libraries before we build the
## programs.
LAST_LIBRARY_BUILT = ${abs_builddir}/libs/base/automake/libutdtools_base.la

dist_bin_SCRIPTS = bin/utdos bin/utduname bin/utdcustom_python bin/utdmodules \
		   bin/utdautoload \
		   bin/utd_run_valgrind \
		   tcl/EZ/tcl/utdezlearn \
		   tcl/cache/cachepractice \
		   tcl/banks/membanks tcl/memory/mempractice

config.recursive : 
	make config
	touch config.recursive

config:
	@for subdir in $(SUB_DIRS); do \
	  echo "Making build target in $$subdir"; \
	  test -d $${subdir} || mkdir -p $${subdir} ;\
	done;
	(echo "configuring utdlib..."; cd ${abs_builddir}/libs/utd/automake ; ${abs_top_srcdir}/libs/utd/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=$(UTDTOOLS)/libs/utd @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_AUTOTOOLS@ @UTDTOOLS_MEM_DEBUG@ @UTDTOOLS_DEBUG_OPTS@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring tcl..."; cd ${abs_builddir}/libs/tcl/unix ; ${abs_top_srcdir}/libs/tcl/unix/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} --enable-corefoundation=no @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_OPTS2@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring tk..."; cd ${abs_builddir}/libs/tk/unix ; ${abs_top_srcdir}/libs/tk/unix/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-x --with-tcl=../../tcl/unix --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} --enable-aqua=no --enable-corefoundation=no --disable-xft --disable-xss @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_OPTS2@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring tix..."; cd ${abs_builddir}/libs/tix ; ${abs_top_srcdir}/libs/tix/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-x --with-tcl=../tcl/unix --with-tk=../tk/unix --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_OPTS2@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring expect..."; cd ${abs_builddir}/libs/expect/automake ; ${abs_top_srcdir}/libs/expect/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-tclinclude=${abs_top_srcdir}/../include/tcl --with-tcl=@abs_builddir@/libs/tcl/unix --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring gui..."; cd ${abs_builddir}/libs/gui/automake ; ${abs_top_srcdir}/libs/gui/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-x --with-tcl=../../tcl/unix --with-tk=../../tk/unix --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring blt..."; cd ${abs_builddir}/libs/blt/automake ; ${abs_top_srcdir}/libs/blt/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring base..."; cd ${abs_builddir}/libs/base/automake ; ${abs_top_srcdir}/libs/base/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring js..."; cd ${abs_builddir}/libs/js/automake ; ${abs_top_srcdir}/libs/js/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring sverilog..."; cd ${abs_builddir}/libs/sverilog/automake ; ${abs_top_srcdir}/libs/sverilog/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring prtable..."; cd ${abs_builddir}/libs/prtable/automake ; ${abs_top_srcdir}/libs/prtable/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring tcludp..."; cd ${abs_builddir}/libs/tcludp/automake ; ${abs_top_srcdir}/libs/tcludp/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-x --with-tcl=../../tcl/unix --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_OPTS2@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring python..."; cd ${abs_builddir}/pgms/python/automake;${abs_top_srcdir}/pgms/python/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-tcltk-includes='-I${abs_top_srcdir}/include $(X_CFLAGS)' --with-tcltk-libs='-L@prefix@/lib/${UTDTOOLSOS} -lutdtools_tk8.6 -lutdtools_tcl8.6 -lutd' --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} @UTDTOOLS_OPENSSL_DIR@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring tclpython..."; cd ${abs_builddir}/libs/tclpython/automake ; ${abs_top_srcdir}/libs/tclpython/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-buildenv=@UTDTOOLS_BUILD_ENV_VARIABLE@ --with-buildroot=${UTDTOOLS} @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring byacc..."; cd ${abs_builddir}/pgms/byacc/automake;${abs_top_srcdir}/pgms/byacc/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring cometFlow..."; cd ${abs_builddir}/pgms/cometFlow/automake;${abs_top_srcdir}/pgms/cometFlow/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-x --with-tcl=../../../libs/tcl/unix --with-tk=../../../libs/tk/unix @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ @UTDTOOLS_GRAPHICS_BUILD@ )
	(echo "configuring cometTix..."; cd ${abs_builddir}/pgms/cometTix/automake;${abs_top_srcdir}/pgms/cometTix/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ --with-x --with-tcl=../../../libs/tcl/unix --with-tk=../../../libs/tk/unix @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ @UTDTOOLS_GRAPHICS_BUILD@ )
	(echo "configuring valgrindp..."; cd ${abs_builddir}/pgms/valgrindp/automake;${abs_top_srcdir}/pgms/valgrindp/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring iverilog..."; cd ${abs_builddir}/pgms/verilog-11.0/automake;${abs_top_srcdir}/pgms/verilog-11.0/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ @UTDTOOLS_DEBUG_BUILD@ )
	(echo "configuring yosys..."; cd ${abs_builddir}/pgms/yosys-abc/automake;${abs_top_srcdir}/pgms/yosys-abc/automake/configure --prefix=@prefix@ --libdir=@UTDTOOLS_LIB_DIR@ --bindir=@UTDTOOLS_BIN_DIR@ @UTDTOOLS_THREAD_BUILD@ @UTDTOOLS_SHARED_BUILD@ @UTDTOOLS_DEBUG_BUILD@ )

clean-local:
	-rm -rf *~ autom4* *.dSYM config.libinstall

distclean-local:
	-rm -rf config.recursive

all-local: config.recursive $(SUB_DIRS) install_tcl install_extra install_ezlearn final_message 

$(SUB_DIRS):
	$(MAKE) -C $@ all install

.PHONY: $(SUB_DIRS) final_message

final_message:
	@echo "####################################"
	@echo " Congratulations! Build is complete." 
	@echo "####################################"

install_extra: install-dist_binSCRIPTS
	cd ${prefix}/bin ;
	@for pscript in $(PYTHON_DSCRIPTS); do \
	  echo "Customizing Python script $$pscript"; \
	  ${prefix}/bin/utdos -override utdtools ${UTDTOOLS}/.. utdcd ${prefix}/bin utdcustom_python -n -q -q -q -- $$pscript -remove ;\
	done;
	cd ${prefix}/bin/$(UTDTOOLSOS) ;
	@for pscript in $(PYTHON_DSCRIPTS2); do \
	  echo "Customizing Python script $$pscript"; \
	  ${prefix}/bin/utdos -override utdtools ${UTDTOOLS}/.. utdcd ${prefix}/bin/${UTDTOOLSOS} utdcustom_python -n -q -q -q -- $$pscript -remove -newdir ../ ;\
	done;

install_tcl:
	  (cd $(abs_top_srcdir)/.. ; tar cvf - tcl | gzip -9 -c >${prefix}/pkg.tgz ) ; \
	  (cd ${prefix}; test -f pkg.tgz && tar -xvzf pkg.tgz ; rm -f pkg.tgz ) ; \
	  (cd $(abs_top_srcdir)/../init ; tar cvf - setenv.* | gzip -9 -c >${prefix}/pkg2.tgz ) ; \
	  (cd ${prefix}; test -f pkg2.tgz && tar -xvzf pkg2.tgz ; rm -f pkg2.tgz )

install_ezlearn:
	  (cd $(abs_top_srcdir)/../ ; tar cvf - ezlearn | gzip -9 -c >${prefix}/pkg3.tgz ) ; \
	  (cd ${prefix}/share; test -f ../pkg3.tgz && tar -xvzf ../pkg3.tgz ; rm -f ../pkg3.tgz ) ;

config_clean:
	@for subdir in $(GUIDIRS) $(SUBDIRS) ; do \
	  echo "Cleaning in $$subdir"; \
	  (cd $$subdir ; \rm -rf autom4te.cache config.log config.status) \
	done;

save_arch:
	cd ${prefix}; \
	ARCH=`utduname` ; \
	VERSION=`basename ${prefix}` ; \
	echo "VERSION : $${VERSION} ARCH: $${ARCH}" ; \
	cd ../; \
	tar cvf - $${VERSION}/bin/$${ARCH} $${VERSION}/lib/$${ARCH} | gzip -9 -c >${prefix}/../arch/$${VERSION}.$${ARCH}.tgz ; 

link_automake_scripts:
	@for subdir in $(AUTOMAKE_DIRS) ; do \
	  echo "Linking automake scripts in $$subdir"; \
	  (cd $(abs_top_srcdir)/../$$subdir ; link_automake_files ../../../automake) \
	done;

reconf_automake_dirs:
	@for subdir in $(AUTOMAKE_DIRS) ; do \
	  echo "Rebuilding automake data in $$subdir"; \
	  (cd $(abs_top_srcdir)/../$$subdir ; autoreconf --force --install ; \rm -rf autom4te.cache) \
	done;
