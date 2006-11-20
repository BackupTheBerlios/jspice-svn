Welcome to JSpice
=================

[1] Introduction
----------------

JSpice is an open source implementation of the OpenSpice language
written in Java.  It includes both an interpreter and a library.  It is
very much a work in progress at the time of writing and really only
suitable for evaluation by developers.

The OpenSpice language itself is a separate project and you can read
about it at 
	http://www.openspice.org/

It is being developed as part of a larger application suite by Stephen
F. K. Leach and is made available under the GNU Public License.  That
license is included as part of this distribution as LICENSE.txt.  For
more information,  please contact me at: <mailto:steve@watchfield.com>.


[2] Projects Downloads and Bug Reporting
----------------------------------------

The JSpice project is hosted by BerliOS at
	http://developer.berlios.de/projects/jspice
and bugs should be reported using at the Berlios site: 
	http://developer.berlios.de/bugs/?group_id=1900

You can download an install package either from
	http://developer.berlios.de/project/showfiles.php?group_id=1900
or from the OpenSpice website
	http://www.openspice.org/download/jspice/


[3] System Requirements
-----------------------

JSpice requires Java 1.4.2 or better and UNIX with a filing system that
supports long Unicode file names.

Unfortunately a very few aspects of OpenSpice cannot be implemented in
pure Java (e.g. environment variable handling, terminal raw mode) and so
the installation package currently creates executables that require UNIX
shells.  If anyone wishes to help with a port to MS Windows, that would
be appreciated.

JSpice has been actively tested under Mac OS X and Linux.  The
probability of it working without change under any random UNIX are
excellent.


[3] What Gets Installed?
------------------------

The tarballs unpack into a single directory called 
	jspice-<version>.
The contents of the various directories are described in INDEX
files.

=======================================================================
Steve Leach, 17th March 2004
Modified 22nd May 2004
Modified 22nd July 2004