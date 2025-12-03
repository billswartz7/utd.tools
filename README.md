# UTDTOOLS

This is the UTDTOOLS project, a set of tools to help students learn
using interactive techniques which try to make learning fun.

In addition, utd.tools is a new type of computer distribution
paradigm, one where the source and various instruction architectures
coexist in one relocatable directory structure.  These are application
programs and should *NOT* require a particular operating system.  It
is hoped that the binaries supplied will work over a large spectrum
of Linux, Mac, and FreeBSD distributions.

# Target Audience
UTDTOOLS tries to satisfy the needs of three types of users: 
end-users (students), advanced users who want to compile the
source natively, and developers who want to further the
state-of-the-art.

## Getting Started

### End-users
End-users should not need to worry about building the tools. In 
fact, all they should do it go the latest version directory (v1.0.0),
and type<br> 
  source setenv.sh<br>
for Bourne or BASH users <br>
  source setenv.csh <br>
for CSH and TCSH users.

The binaries are carefully built to be as backward compatible as possible,
allowing use on as many systems as possible.  The focus of these binaries
is to be as conservative as possible. Usability and correctness are traded
off against maximum optimization.

### Advanced users
Advanced users are expected to build the entire project resulting in
the creation of a new version directory such as v1.0.0.  Advanced users
need a minimal amount of installed compilation and linking tools.  
Advanced users will compile the source natively and optimize for
the hardware that the tools will be executed.

### Developers
End-users and advanced users do not need to focus on developer issues.  
Developer issues should be highlighted with the DEVELOPER keyword.  
Developers can change and modify the source code.


## Prerequisites

### Disk space requirements
* At least 2GB 

### END-USER
* Installed OpenSSL library

### ADVANCED USER
* Working C and C++ compiler
* gmake
* X11 libraries and development headers
* OpenSSL
* bz2-dev libraries for Python
* libz-dev libraries for Python

### DEVELOPER
* Working C and C++ compiler
* gmake
* X11 libraries and development headers
* OpenSSL
* Perl (for configure)
* Automake 1.15 or later
* Autoconf 2.69 or later

## Installing

#### Building as an ADVANCED USER
First set the UTDTOOLS build environment variables using either 
  buildenv.sh or buildenv.csh depending on your shell preference.   
  You need to source these files when your working directory is 
  at the top of the UTDTOOLS source directory or .../utd.tools/src.
  Let us assume a bash shell:<br>
"source buildenv.sh"

Next change directory to the "automake/build" directory<br>
"cd automake/build"

Next run the top level configure script by entering<br> 
"../configure"<br>
in the UTDTOOLS build directory $(UTDTOOLS)/src/automake/build. 
You may inquire about the top level options by typing "../configure --help".  By default
The top level "configure" creates the master Makefile.

Then compile, build and link the libraries and programs using<br>
"make"

That is it!  No need to type "make install" as the tools are going
to be created at $(UTDTOOLS)/$(UTDOOLSVERSION)

If everything is correct, you should see after the build<BR>

#### Building under WSL
Now utdtools compiles and build under Windows Subsystem for Linux (WSL).
In order to compile and build under WSL, assuming your are using the
default Ubuntu distribution, you will need the following packages:

gcc g++ make openssl libssl-dev zlib1g-dev libx11-dev libbz2-dev libffi-dev

and if you want reasonable fonts these two packages:

xfonts-base xfonts-100dpi 

You should use the command 

sudo apt install gcc g++ make openssl libssl-dev zlib1g-dev libx11-dev libbz2-dev libffi-dev

Optionally, you may want to install the readline package for use in Python:

libreadline-dev

After these packages are installed, you should be able to follow
the steps under "Building as an ADVANCED USER" to successfully build
all of the tools.

#### Building as a DEVELOPER

## Tested systems
* Linux (64 bits)
* MacOSX
* FreeBSD

## Running the tests


## DEVELOPERS

## Git and Automake
How did you get git and automake systems work together?  Git does
*NOT* maintain time date stamps and so all code using automake
would need the proper automake, autoconf, etc. installed on the
machine that the user would like to compile.  In the advanced but
not developer mode, we want only a minimal tool set.   

This took quite some time to figure out how to uncouple these two 
systems but in essence we explicitly turn off the automake 
system in all but the developer mode by overriding the following 
variables in the Makefile during configuration:

ACLOCAL="echo no aclocal mode"
AUTOCONF="echo no autoconf mode"
AUTOHEADER="echo no autoheader mode"
AUTOMAKE="echo no automake mode"
MAKEINFO="echo no makeinfo mode"

The developer will now need to explicitly call "autoreconf" when
changes are made to configure.ac or Makefile.am and autoconf when
changes are made to configure.in for sources that only use autoconf.
This puts the burden on the developer where it should be and not 
the end user or advanced user.


### How to add a new program to UTDTOOLS using Automake

You will need to do two major things: add your program to the top
level automake and configure your own new program directory.

First edit the Makefile.am file.  See the Makefile.am.README file
for a detailed discussion of what to do.

After modifying the Makefile.am file, you must run "autoreconf" in
the top level OpenRoad directory.  This will generate a new configure
and new Makefile.in file. 

Next you need to create a new directory under the pgms directory.
The name is your choice.  For example, let us call it myPgm

You need the following in your myPgm directory :

* configure.ac
* m4/
* Makefile.am
* "your source code"

The first three have been archived for you at: devel/start.tgz 

#### configure.ac:
  Most likely you won't need to change any of this file.

#### m4/
  Most likely you won't need to change anything in this directory

#### Makefile.am:
  Where all of the action goes.
  Look at the explanation of the Makefile.am file in the start kit.

## Programs
* Flow : a flow simulator

#### Program example
You should look at the ./pgms/flow directory as an example of how to
code for this project.  More details will follow.


## Built With

* tcl (https://www.tcl.tk/software/tcltk/download.html) - interpreter
* tk (https://www.tcl.tk/software/tcltk/download.html) - graphics
* Tix (http://tix.sourceforge.net/download.shtml) - meta widgets

## Contributing


## Versioning

Current version 0.9

## Authors

* ** William Swartz - *Initial work* - bill-swartz@utdallas.edu

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

