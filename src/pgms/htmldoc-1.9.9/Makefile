#
# Makefile for HTMLDOC, an HTML document processing program.
#
# Copyright 2011-2019 by Michael R Sweet.
# Copyright 1997-2010 by Easy Software Products.
#
# This program is free software.  Distribution and use rights are outlined in
# the file "COPYING".
#

#
# Include common definitions...
#

include Makedefs


#
# Subdirectories...
#

DIRS	=	jpeg  png htmldoc doc
INSTALLDIRS =	fonts data desktop doc htmldoc


#
# Make all targets...
#

all:
	for dir in $(DIRS); do\
		echo Making all in $$dir...;\
		(cd $$dir; $(MAKE) -$(MAKEFLAGS)) || exit 1;\
	done


#
# Remove object and target files...
#

clean:
	for dir in $(DIRS); do\
		echo Cleaning in $$dir...;\
		(cd $$dir; $(MAKE) -$(MAKEFLAGS) clean) || exit 1;\
	done


#
# Clean everything
#

distclean:	clean
	$(RM) -r autom4te*.cache
	$(RM) config.h
	$(RM) config.log
	$(RM) config.status
	$(RM) desktop/htmldoc.dt
	$(RM) desktop/htmldoc.plist
	$(RM) Makedefs
	$(RM) Makefile


#
# Install object and target files...
#

install:
	$(MAKE) all
	for dir in $(INSTALLDIRS); do\
		echo Installing in $$dir...;\
		(cd $$dir; $(MAKE) -$(MAKEFLAGS) install) || exit 1;\
	done


#
# Sign the HTMLDOC application bundle and make a disk image...  Set the
# APPLEID and TEAMID environment variables from the Apple developer pages.
#

IDENTITY	=	"Developer ID Application"
VERSION		=	1.9.9

dmg:
	echo Signing HTMLDOC application bundle
	codesign -s $(IDENTITY) --timestamp -o runtime htmldoc/htmldoc.app
	echo Creating archive for notarization
	rm -f htmldoc/htmldoc.zip
	ditto -c -k --keepParent htmldoc/htmldoc.app htmldoc/htmldoc.zip
	echo Notarizing application
	xcrun altool --notarize-app -f htmldoc/htmldoc.zip \
		--primary-bundle-id org.msweet.htmldoc \
		--username "$(APPLEID)" \
		--password "@keychain:AC_PASSWORD" \
		--asc-provider "$(TEAMID)"
	echo Making disk image
	rm -f ~/Desktop/htmldoc-$(VERSION)-macos.dmg
	dmgbuild -s dmgbuild.py "HTMLDOC $(VERSION)" ~/Desktop/htmldoc-$(VERSION)-macos.dmg
