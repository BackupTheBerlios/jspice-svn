#
# Makefile for Colossal Cave Revisited
# Requires TADS compiler 2.1.0 or greater.
#
# Note that some of the Unix versions of the compilers return error
# codes when everything's actually fine.
#

#
# Set TC and TR to point to your TADS compiler and run-time.
#
TC=		tadsc
TR=		tadsr

PROGNAME=	ccr
DEBUG=		-ds
SWAPTIONS=
OOPTIONS=	-s -mp32000
OPTIONS=	$(OOPTIONS) $(SWAPTIONS) $(DEBUG)

# Production version options
POPTIONS=	$(OOPTIONS) $(SWAPTIONS)

.PRECIOUS=	$(PROGNAME).gam		# do not delete game file on errors

HEADERS= ccr-adv.t ccr-std.t
ROOMS=   ccr-room.t
OBJECTS= ccr-item.t
MISC=    close.t ccr-verb.t format.t help.t ccr-npc.t preparse.t thingext.t

$(PROGNAME).gam: makefile $(PROGNAME).t $(HEADERS) $(ROOMS) $(OBJECTS) $(MISC)
	$(TC) $(OPTIONS) $(PROGNAME).t

production: makefile $(PROGNAME).t $(HEADERS) $(ROOMS) $(OBJECTS) $(MISC)
	$(TC) $(POPTIONS) $(PROGNAME).t
