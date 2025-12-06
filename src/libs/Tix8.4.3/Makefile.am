## Process this file with automake to produce Makefile.in
AUTOMAKE_OPTIONS = foreign subdir-objects
ACLOCAL_AMFLAGS = -I m4

noinst_LTLIBRARIES = libtix_funcs.la
lib_LTLIBRARIES = lib@UTDTOOLS_BUILD_ENV_SUFFIX@tix.la lib@UTDTOOLS_BUILD_ENV_SUFFIX@tix-static.la

libtix_funcs_la_SOURCES = \
      generic/tixClass.c \
      generic/tixCmds.c \
      generic/tixCompat.c \
      generic/tixError.c \
      generic/tixGeometry.c \
      generic/tixInit.c \
      generic/tixList.c \
      generic/tixMethod.c \
      generic/tixOption.c \
      generic/tixScroll.c \
      generic/tixSmpLs.c \
      generic/tixUtils.c \
      generic/tixWidget.c \
      generic/tixDItem.c \
      generic/tixDiITxt.c \
      generic/tixDiImg.c \
      generic/tixDiStyle.c \
      generic/tixDiText.c \
      generic/tixDiWin.c \
      generic/tixForm.c \
      generic/tixFormMisc.c \
      generic/tixGrid.c \
      generic/tixGrData.c \
      generic/tixGrFmt.c \
      generic/tixGrRC.c \
      generic/tixGrSel.c \
      generic/tixGrSort.c \
      generic/tixGrUtl.c \
      generic/tixHList.c \
      generic/tixHLCol.c \
      generic/tixHLInd.c \
      generic/tixHLHdr.c \
      generic/tixNBFrame.c \
      generic/tixTList.c \
      generic/tixImgCmp.c \
      generic/tixImgXpm.c \
      generic/tixInputO.c \
      unix/tixUnixMwm.c \
      unix/tixUnixDraw.c \
      unix/tixUnixXpm.c \
      unix/tixUnixWm.c

# Build the shared library with extra libraries
lib@UTDTOOLS_BUILD_ENV_SUFFIX@tix_la_SOURCES =
lib@UTDTOOLS_BUILD_ENV_SUFFIX@tix_la_LDFLAGES = -shared -version-info 8:4:3
lib@UTDTOOLS_BUILD_ENV_SUFFIX@tix_la_LIBADD = \
		libtix_funcs.la \
		../tk/unix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tkstub8.6.a \
		../tcl/unix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tclstub8.6.a

lib@UTDTOOLS_BUILD_ENV_SUFFIX@tix_static_la_SOURCES = 
lib@UTDTOOLS_BUILD_ENV_SUFFIX@tix_static_la_LDFLAGS = -static -version-info 8:4:3
lib@UTDTOOLS_BUILD_ENV_SUFFIX@tix_static_la_LIBADD = libtix_funcs.la

#========================================================================
# PKG_TCL_SOURCES identifies Tcl runtime files that are associated with
# this package that need to be installed, if any.
#========================================================================

PKG_TCL_SOURCES = \
	library/Init.tcl	library/Balloon.tcl	library/BtnBox.tcl \
	library/CObjView.tcl	library/ChkList.tcl	library/ComboBox.tcl \
	library/Compat.tcl	library/Console.tcl	library/Control.tcl \
	library/DefSchm.tcl	library/DialogS.tcl	library/DirBox.tcl \
	library/DirDlg.tcl	library/DirList.tcl	library/DirTree.tcl \
	library/DragDrop.tcl	library/DtlList.tcl	library/EFileBox.tcl \
	library/EFileDlg.tcl	library/Event.tcl	library/FileBox.tcl \
	library/FileCbx.tcl	library/FileDlg.tcl \
	library/FileEnt.tcl	library/FloatEnt.tcl	library/Grid.tcl \
	library/HList.tcl	library/HListDD.tcl	library/IconView.tcl \
	library/LabEntry.tcl	library/LabFrame.tcl	library/LabWidg.tcl \
	library/ListNBk.tcl	library/Meter.tcl	library/MultView.tcl \
	library/NoteBook.tcl	library/OldUtil.tcl	library/OptMenu.tcl \
	library/PanedWin.tcl	library/PopMenu.tcl	library/Primitiv.tcl \
	library/ResizeH.tcl	library/SGrid.tcl	library/SHList.tcl \
	library/SListBox.tcl	library/STList.tcl	library/SText.tcl \
	library/SWidget.tcl	library/SWindow.tcl	library/Select.tcl \
	library/Shell.tcl	library/SimpDlg.tcl	library/StackWin.tcl \
	library/StatBar.tcl	library/StdBBox.tcl	library/StdShell.tcl \
	library/TList.tcl	library/Tix.tcl		library/Tree.tcl \
	library/Utils.tcl	library/VResize.tcl	library/VStack.tcl \
	library/VTree.tcl	library/Variable.tcl	\
	library/WInfo.tcl	library/fs.tcl
  


AM_CPPFLAGS =\
	-I.\
	-I@srcdir@/generic \
	-I@srcdir@/unix \
	-I@UTDTOOLS_INCLUDE_PATH@ \
	-I@UTDTOOLS_INCLUDE_PATH@/tcl \
	-I@UTDTOOLS_INCLUDE_PATH@/tk \
	-I@UTDTOOLS_INCLUDE_PATH@/tix


# Need to store off config data for other programs
# Now done in top level configure.

AM_CFLAGS = -g $(X_CFLAGS) -DDEBUG

AM_CXXFLAGS = -g $(X_CFLAGS)

CC=@MCC@

		rm -f ../../../include/utd/config.h*
		cp config.h ../../../include/utd

PKG_DIR		= @PACKAGE_NAME@@PACKAGE_VERSION@
pkglibdir = $(libdir)/../@PACKAGE_NAME@@PACKAGE_VERSION@

clean-local:
	-rm -rf *~ autom4* *.dSYM

install-data-local:
	@mkdir -p $(DESTDIR)$(pkglibdir)
	@list='$(PKG_TCL_SOURCES)'; for p in $$list; do \
	  if test -f $(srcdir)/$$p; then \
	    destp=`basename $$p`; \
	    $(INSTALL_DATA) $(srcdir)/$$p $(DESTDIR)$(pkglibdir)/$$destp; \
	  fi; \
	done
	@echo "Installing preference sets to $(DESTDIR)$(pkglibdir)/pref"
	@mkdir -p $(DESTDIR)$(pkglibdir)/pref
	@cp -p $(srcdir)/library/pref/*.* $(DESTDIR)$(pkglibdir)/pref/
	@echo "Installing bitmaps to $(DESTDIR)$(pkglibdir)/bitmaps"
	@mkdir -p $(DESTDIR)$(pkglibdir)/bitmaps
	@cp -p $(srcdir)/library/bitmaps/*.* $(DESTDIR)$(pkglibdir)/bitmaps/
