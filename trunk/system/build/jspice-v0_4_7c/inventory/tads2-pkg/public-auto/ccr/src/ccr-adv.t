/* $Header$ */
/* Copyright (c) 1988, 1991 by Michael J. Roberts.  All Rights Reserved. */
/*
   adv.t  - standard adventure definitions for TADS games
   Version 2.0

   This file is part of TADS:  The Text Adventure Development System.
   Please see the file LICENSE.DOC (which should be part of the TADS
   distribution) for information on using this file, and for information
   on reaching High Energy Software, the developers of TADS.

   This file defines the basic classes and functions used by most TADS
   adventure games.  It is generally #include'd at the start of each game
   source file.
*/

/*
 *   Define compound prepositions.  Since prepositions that appear in
 *   parsed sentences must be single words, we must define any logical
 *   prepositions that consist of two or more words here.  Note that
 *   only two words can be pasted together at once; to paste more, use
 *   a second step.  For example,  'out from under' must be defined in
 *   two steps:
 *
 *     compoundWord 'out' 'from' 'outfrom';
 *     compoundWord 'outfrom' 'under' 'outfromunder';
 *
 *   Listed below are the compound prepositions that were built in to
 *   version 1.0 of the TADS run-time.
 */
compoundWord 'on' 'to' 'onto';           /* on to --> onto */
compoundWord 'in' 'to' 'into';           /* in to --> into */
compoundWord 'in' 'between' 'inbetween'; /* and so forth */
compoundWord 'down' 'in' 'downin';
compoundWord 'down' 'on' 'downon';
compoundWord 'up' 'on' 'upon';
compoundWord 'out' 'of' 'outof';
compoundWord 'off' 'of' 'offof';

/*
 *   Format strings:  these associate keywords with properties.  When
 *   a keyword appears in output between percent signs (%), the matching
 *   property of the current command's actor is evaluated and substituted
 *   for the keyword (and the percent signs).  For example, if you have:
 *
 *      formatstring 'you' fmtYou;
 *
 *   and the command being processed is:
 *
 *      fred, pick up the paper
 *
 *   and the "fred" actor has fmtYou = "he", and this string is output:
 *
 *      "%You% can't see that here."
 *
 *   Then the actual output is:  "He can't see that here."
 *
 *   The format strings are chosen to look like normal output (minus the
 *   percent signs, of course) when the actor is Me.
 */
formatstring 'you' fmtYou;
formatstring 'your' fmtYour;
formatstring 'you\'re' fmtYoure;
formatstring 'youm' fmtYoum;
formatstring 'you\'ve' fmtYouve;
formatstring 's' fmtS;
formatstring 'es' fmtEs;
formatstring 'have' fmtHave;
formatstring 'do' fmtDo;
formatstring 'are' fmtAre;

/*
 *   Forward-declare functions.  This is not required in most cases,
 *   but it doesn't hurt.  Providing these forward declarations ensures
 *   that the compiler knows that we want these symbols to refer to
 *   functions rather than objects.
 */
checkDoor: function;
checkReach: function;
itemcnt: function;
listcont: function;
listcontcont: function;
turncount: function;
addweight: function;
addbulk: function;
incscore: function;
silent_incscore: function;	// DMB
darkTravel: function;
scoreRank: function;
terminate: function;
die: function;
init: function;
pardon: function;
preinit: function;
initSearch: function;

/*
 *   checkDoor:  if the door d is open, this function silently returns
 *   the room r.  Otherwise, print a message ("The door is closed.") and
 *   return nil.
 */
checkDoor: function( d, r )
{
    if ( d.isopen ) return( r );
    else
    {
        setit( d );
	caps(); d.thedesc; " is closed. ";
	return( nil );
    }
}

/*
 *   checkReach:  determines whether the object obj can be reached by
 *   actor in location loc, using the verb v.  This routine returns true
 *   if obj is a special object (numObj or strObj), if obj is in actor's
 *   inventory or actor's location, or if it's in the 'reachable' list
 *   for loc.
 */
checkReach: function( loc, actor, v, obj )
{
    if ( obj=numObj or obj=strObj ) return;
    if ( not ( actor.isCarrying( obj ) or obj.isIn( actor.location )))
    {
        if (find( loc.reachable, obj ) <> nil ) return;
        "%You% can't reach "; obj.thedesc; " from "; loc.thedesc; ". ";
        exit;
    }
}

/*
@itemcnt: function( list )
Returns a count of the ``listable'' objects in \it list\.  An
object is listable (that is, it shows up in a room's description)
if its \tt isListed\ property is \tt true\.  This function is
useful for determining how many objects (if any) will be listed
in a room's description.
*/
itemcnt: function( list )
{
    local cnt, tot, i;
    tot := length( list );
    cnt := 0;
    i := 1;
    while ( i <= tot )
    {
        if ( list[i].isListed ) cnt := cnt+1;
        i := i+1;
    }
    return( cnt );
}

/*
@listcont: function( obj )
This function displays the contents of an object, separated by
commas.  The \tt thedesc\ properties of the contents are used.
It is up to the caller to provide the introduction to the list
(usually something to the effect of ``The box contains'' is
displayed before calling \tt listcont\) and finishing the
sentence (usually by displaying a period).  An object is listed
only if its \tt isListed\ property is \tt true\.
*/
listcont: function( obj )
{
    local i, count, tot, list, cur, disptot;
    count := 0;
    list := obj.contents;
    tot := length( list );
    disptot := itemcnt( list );
    i := 1;
    while ( i <= tot )
    {
        cur := list[i];
        if ( cur.isListed )
        {
            if ( count > 0 )
            {
                if ( count+1 < disptot )
                    ", ";
                else if (count = 1)
                    " and ";
                else
                    ", and ";
            }
            count := count + 1;
            cur.adesc;               // list this object
            if ( cur.isworn ) " (being worn)";
            else if ( cur.islamp and cur.islit ) " (providing light)";
        }
        i := i + 1;
    }
}

/*
 *   showcontcont:  list the contents of the object, plus the contents of
 *   an fixeditem's contained by the object.  A complete sentence is shown.
 *   This is an internal routine used by listcontcont and listfixedcontcont.
 */
// DMB added print param and return value
showcontcont: function(obj, print)
{
	local cnt := 0;
	
    if (itemcnt( obj.contents ))
    {
        if ( obj.issurface and not obj.isqsurface )
        {
		cnt := cnt + itemcnt(obj.contents);
		if (print) {
			if (cnt > 1) {	// DMB added this check
				caps(); listcont(obj);
				" are sitting on "; obj.thedesc; ". ";
			}
			else {
				caps(); listcont(obj); " is sitting on ";
				obj.thedesc; ". ";
			}
		}
        }
        else if ( obj.contentsVisible and not obj.isqcontainer )
        {
		cnt := cnt + itemcnt(obj.contents);
		if (print) {
			caps();
			obj.thedesc; " seems to contain ";
			listcont( obj );
			". ";
		}
        }
    }
    if ( obj.contentsVisible and not obj.isqcontainer )
        cnt := cnt + listfixedcontcont(obj, print);

	return cnt;
}

/*
@listfixedcontcont: function( obj )
List the contents of the contents of any \tt fixeditem\ objects
in the \tt contents\ list of the object \it obj\.  This routine
makes sure that all objects that can be taken are listed somewhere
in a room's description.  This routine recurses down the contents
tree, following each branch until either something has been listed
or the branch ends without anything being listable.  This routine
displays a complete sentence, so no introductory or closing text
is needed.
*/
// DMB added print param and return value
listfixedcontcont: function(obj, print)
{
    local list, i, tot, thisobj;
    local cnt := 0;

    list := obj.contents;
    tot := length( list );
    i := 1;
    while ( i <= tot )
    {
        thisobj := list[i];
        if ( thisobj.isfixed and thisobj.contentsVisible and
	  not thisobj.isqcontainer )
            cnt := cnt + showcontcont(thisobj, print);
	i := i + 1;
    }
    return cnt;
}

/*
@listcontcont: function( obj )
This function lists the contents of the contents of an object.
It displays full sentences, so no introductory or closing text
is required.  Any item in the \tt contents\ list of the object
\it obj\ whose \tt contentsVisible\ property is \tt true\ has
its contents listed.  An Object whose \tt isqcontainer\ or
\tt isqsurface\ property is \tt true\ will not have its
contents listed.
*/
// DMB added print parameter and return value
listcontcont: function(obj, print)
{
    local list, i, tot;
    local cnt := 0;
    
    list := obj.contents;
    tot := length( list );
    i := 1;
    while ( i <= tot )
    {
        cnt := cnt + showcontcont(list[i], print);
	i := i + 1;
    }
    return cnt;
}

/*
@turncount: function( parm )
This function can be used as a daemon (normally set up in the \tt init\
function) to update the turn counter after each turn.  This routine
increments \tt global.turnsofar\, and then calls \tt setscore\ to
update the status line with the new turn count.
*/
turncount: function( parm )
{
    incturn();
    global.turnsofar := global.turnsofar + 1;
    setscore( global.score, global.turnsofar );
}
				   
/*
@addweight: function( list )
Adds the weights of the objects in \it list\ and returns the sum.
The weight of an object is given by its \tt weight\ property.  This
routine includes the weights of all of the contents of each object,
and the weights of their contents, and so forth.
*/
addweight: function( l )
{
    local tot, i, c, totweight;

    tot := length( l );
    i := 1;
    totweight := 0;
    while ( i <= tot )
    {
        c := l[i];
        totweight := totweight + c.weight;
        if (length( c.contents ))
            totweight := totweight + addweight( c.contents );
        i := i + 1;
    }
    return( totweight );
}

/*
@addbulk: function( list )
This function returns the sum of the bulks (given by the \tt bulk\
property) of each object in \it list\.  The value returned includes
only the bulk of each object in the list, and \it not\ of the contents
of the objects, as it is assumed that an object does not change in
size when something is put inside it.  You can easily change this
assumption for special objects (such as a bag that stretches as
things are put inside) by writing an appropriate \tt bulk\ method
for that object.
*/
addbulk: function( list )
{
    local i, tot, totbulk, rem, cur;

    tot := length( list );
    i := 1;
    totbulk := 0;
    while( i <= tot )
    {
        cur := list[i];
        if ( not cur.isworn )
            totbulk := totbulk + cur.bulk;
        i := i + 1;
    }
    return( totbulk );
}

/*
@incscore: function( amount )
Adds \it amount\ to the total score, and updates the status line
to reflect the new score.  The total score is kept in \tt global.score\.
Always use this routine rather than changing \tt global.score\
directly, since this routine ensures that the status line is
updated with the new value.
*/
incscore: function( amount )	/* DMB */
{
	silent_incscore(amount);

	"\b";
	if (amount = -1)
		"* Your score just went down by a point. *";
	else if (amount = 1)
		"* Your score just went up by a point. *";
	else if (amount < -1) {
		"* Your score just went down by ";
		say(-1 * amount); " points. *";
	}
	else if (amount > 1) {
		"* Your score just went up by "; say(amount); " points. *";
	}
	"\b";
}
// DMB: added the following:
silent_incscore: function( amount )
{
	global.score := global.score + amount;
	setscore( global.score, global.turnsofar );
}

/*
@initSearch: function
Initializes the containers of objects with a \tt searchLoc\, \tt underLoc\,
and \tt behindLoc\ by setting up \tt searchCont\, \tt underCont\, and
\tt behindCont\ lists, respectively.  You should call this function once in
your \tt preinit\ (or \tt init\, if you prefer) function to ensure that
the underable, behindable, and searchable objects are set up correctly.
*/
initSearch: function
{
    local o;
    
    o := firstobj(hiddenItem);
    while (o <> nil)
    {
	if (o.searchLoc)
	    o.searchLoc.searchCont := o.searchLoc.searchCont + o;
	else if (o.underLoc)
	    o.underLoc.underCont := o.underLoc.underCont + o;
	else if (o.behindLoc)
	    o.behindLoc.behindCont := o.behindLoc.behindCont + o;
	o := nextobj(o, hiddenItem);
    }
}

/*
@nestedroom: room
A special kind of room that is inside another room; chairs and
some types of vehicles, such as inflatable rafts, fall into this
category.  Note that a room can be within another room without
being a \tt nestedroom\, simply by setting its \tt location\ property
to another room.  The \tt nestedroom\ is different from an ordinary
room, though, in that it's an ``open'' room; that is, when inside it,
the actor is still really inside the enclosing room for purposes of
descriptions.  Hence, the player sees ``Laboratory, in the chair."
In addition, a \tt nestedroom\ is an object in its own right,
visible to the player; for example, a chair is an object in a
room in addition to being a room itself.
*/
class nestedroom: NoNPC	// DMB room -> NoNPC for CCR
    islit =
    {
        if ( self.location ) return( self.location.islit );
        return( nil );
    }
    statusLine = {
     		/* DMB onword */
   		self.location.sdesc; ", ";
   		self.onword; " "; 
   		self.thedesc; "\n\t";
    }
    lookAround( verbosity ) =
    {
        self.statusLine;
	self.location.nrmLkAround( verbosity );
    }
    roomDrop( obj ) =
    {
        if ( self.location = nil or self.isdroploc ) pass roomDrop;
	else self.location.roomDrop( obj );
    }
;

/*
@chairitem: fixeditem, nestedroom, surface
Acts like a chair:  actors can sit on the object.  While sitting
on the object, an actor can't go anywhere until standing up, and
can only reach objects that are on the chair and in the chair's
\tt reachable\ list.  By default, nothing is in the \tt reachable\
list.  Note that there is no real distinction made between chairs
and beds, so you can sit or lie on either; the only difference is
the message displayed describing the situation.
*/
class chairitem: fixeditem, nestedroom, surface
    /* DMB onroom */
    onword = { if (self.onroom) "on"; else "in"; }
    offword = { if (self.onroom) "off"; else "out"; }

    reachable = []          // list of all containers reachable from here;
                            //  normally, you can only reach carried items
                            //  from a chair, but this makes special allowances
    ischair = true          // it is a chair by default; for beds or other
                            //  things you lie down on, make it false
    roomAction( actor, v, dobj, prep, io ) =
    {
        if ( dobj<>nil and v<>inspectVerb )
            checkReach( self, actor, v, dobj );
        if ( io<>nil and v<>askVerb and v<>tellVerb )
            checkReach( self, actor, v, io );
	pass roomAction;
    }
    enterRoom( actor ) = {}
    noexit =
    {
        "%You're% not going anywhere until %you% get%s% ";
	self.offword; " of"; self.thedesc; ". ";
        return( nil );
    }
    verDoBoard( actor ) = { self.verDoSiton( actor ); }
    doBoard( actor ) = { self.doSiton( actor ); }
    verDoSiton( actor ) =
    {
        if ( actor.location = self )
        {
            "%You're% already "; self.onword; " ";
            self.thedesc; "! ";
        }
    }
    doSiton( actor ) =
    {
        "Okay, %you're% now sitting "; self.onword; " "; self.thedesc; ". ";
        actor.travelTo( self );
    }
    verDoLieon( actor ) =
    {
        self.verDoSiton( actor );
    }
    doLieon( actor ) =
    {
	    // DMB changed so it says "lying"
        "Okay, %you're% now lying "; self.onword; " "; self.thedesc; ". ";
        actor.travelTo(self);
    }
    // DMB: added the following:
    doUnboard( actor ) =
    {
        if ( self.fastenitem )
	{
	    "%You%'ll have to unfasten "; actor.location.fastenitem.thedesc;
	    " first. ";
	}
	else
	{
            "Okay, %you're% no longer "; self.onword; " "; self.thedesc; ". ";
            self.leaveRoom( actor );
	    actor.moveInto( self.location );
	}
    }
;

/*
@beditem: chairitem
This object is the same as a \tt chairitem\, except that the player
is described as lying on, rather than sitting in, the object.
*/
class beditem: chairitem
    onroom = true
    ischair = nil
    isbed = true
    sdesc = "bed"
;

/*
@thing: object
The basic class for objects in a game.  The property \tt contents\
is a list that specifies what is in the object; this property is
automatically set up by the system after the game is compiled to
contain a list of all objects that have this object as their
\tt location\ property.  The \tt contents\ property is kept
consistent with the \tt location\ properties of referenced objects
by the \tt moveInto\ method; always use \tt moveInto\ rather than
directly setting a \tt location\ property for this reason.  The
\tt adesc\ method displays the name of the object with an indefinite
article; the default is to display ``a'' followed by the \tt sdesc\,
but objects that need a different indefinite article (such as ``an''
or ``some'') should override this method.  Likewise, \tt thedesc\
displays the name with a definite article; by default, \tt thedesc\
displays ``the'' followed by the object's \tt sdesc\.  The \tt sdesc\
simply displays the object's name (``short description'') without
any articles.  The \tt ldesc\ is the long description, normally
displayed when the object is examined by the player; by default,
the \tt ldesc\ displays a ``It looks like an ordinary \tt sdesc\.''
The \tt isIn( \it object\ )\ method returns \tt true\ if the
object's location is the specified \it object\ or the object's
\tt location\ is an object whose \tt contentsVisible\ property is
\tt true\ and that object's \tt isIn( \it object\ )\ method is
\tt true\.  Note that if \tt isIn\ is \tt true\, it doesn't
necessarily mean the object is reachable, because \tt isIn\ is
\tt true\ if the object is merely visible within the location.
The \tt thrudesc\ method displays a message for when the
player looks through the object (objects such as windows would
use this property).  The \tt moveInto( \it object\ )\ method
moves the object to be inside the specified \it object\; always use
\tt moveInto\ to move an object rather than setting its \tt location\
directly, so that the appropriate \tt contents\ lists are updated.
To make an object disappear, move it into \tt nil\.
*/
class thing: object
    isListed = true         // shows up in room/inventory listings
    contents = []           // set up automatically by system - do not set
    verGrab( obj ) = {}
    Grab( obj ) = {}
    adesc =
    {
        "a "; self.sdesc;   // default is "a <name>"; "self" is current object
    }
    thedesc =
    {
        "the "; self.sdesc; // default is "the <name>"
    }
    ldesc = { "It looks like an ordinary "; self.sdesc; " to me."; }
    readdesc = { "%You% can't read "; self.adesc; ". "; }
    actorAction( v, d, p, i ) =
    {
        "You have lost your mind. ";
        exit;
    }
    contentsVisible = { return( true ); }
    contentsReachable = { return( true ); }
    isIn( obj ) =
    {
        local myloc;

        myloc := self.location;
        if ( myloc )
        {
            if ( myloc = obj ) return( true );
            if ( myloc.contentsVisible ) return( myloc.isIn( obj ));
        }
        return( nil );
    }
    thrudesc = { "%You% can't see much through "; self.thedesc; ".\n"; }
    moveInto( obj ) =
    {
        local loc;

	/*
	 *   For the object containing me, and its container, and so forth,
	 *   tell it via a Grab message that I'm going away.
	 */
	loc := self.location;
	while ( loc )
	{
	    loc.Grab( self );
	    loc := loc.location;
	}

        if ( self.location )
            self.location.contents := self.location.contents - self;
        self.location := obj;
        if ( obj ) obj.contents := obj.contents + self;
    }
    verDoSave( actor ) =
    {
        "Please specify the name of the game to save in double quotes,
        for example, SAVE \"GAME1\". ";
    }
    verDoRestore( actor ) =
    {
        "Please specify the name of the game to restore in double quotes,
        for example, SAVE \"GAME1\". ";
    }
    verDoScript( actor ) =
    {
        "You should type the name of a file to write the transcript to
        in quotes, for example, SCRIPT \"LOG1\". ";
    }
    verDoSay( actor ) =
    {
        "You should say what you want to say in double quotes, for example,
        SAY \"HELLO\". ";
    }
    verDoPush( actor ) =
    {
        "Pushing "; self.thedesc; " doesn't do anything. ";
    }
    verDoWear( actor ) =
    {
        "%You% can't wear "; self.thedesc; ". ";
    }
    verDoTake( actor ) =
    {
        if ( self.location = actor )
        {
            "%You% already %have% "; self.thedesc; "! ";
        }
        else self.verifyRemove( actor );
    }
    verifyRemove( actor ) =
    {
  	/*
	 *   Check with each container to make sure that the container
	 *   doesn't object to the object's removal.
	 */
        local loc;

        loc := self.location;
        while ( loc )
        {
            if ( loc <> actor ) loc.verGrab( self );
            loc := loc.location;
        }
    }
    isVisible( vantage ) =
    {
        local loc;

        loc := self.location;
        if ( loc = nil ) return( nil );

        /* if it's in the vantage, it's visible */
        if ( loc = vantage ) return( true );

        /*
         *   if its location's contents are visible, and its location is
         *   itself visible, it's visible
         */
        if ( loc.contentsVisible and loc.isVisible( vantage )) return( true );

        /*
         *   If the vantage has a location, and the vantage's location's
         *   contents are visible (if you can see me I can see you), and
         *   the object is visible from the vantage's location, the object
         *   is visible
         */
        if ( vantage.location <> nil and vantage.location.contentsVisible and
         self.isVisible( vantage.location ))
            return( true );

        /* all tests failed:  it's not visible */
        return( nil );
    }
    cantReach( actor ) =
    {
        if ( self.location = nil )
        {
            if ( actor.location.location )
               "%You% can't reach that from << actor.location.thedesc >>. ";
            return;
        }
        if ( not self.location.isopenable or self.location.isopen )
            self.location.cantReach( actor );
        else "%You%'ll have to open << self.location.thedesc >> first. ";
    }
    isReachable( actor ) =
    {
        local loc;

        /* if the object is in the room's 'reachable' list, it's reachable */
        if (find( actor.location.reachable, self ) <> nil )
            return( true );

        /*
         *   If the object's container's contents are reachable, and the
         *   container is reachable, the object is reachable.
         */
        loc := self.location;
	if (find( actor.location.reachable, self ) <> nil )
	    return( true );
	if ( loc = nil ) return( nil );
	if ( loc = actor or loc = actor.location ) return( true );
	if ( loc.contentsReachable )
	    return( loc.isReachable( actor ));
	return( nil );
        return( nil );
    }
    doTake( actor ) =
    {
        local totbulk, totweight;

        totbulk := addbulk( actor.contents ) + self.bulk;
        totweight := addweight( actor.contents );
        if ( not actor.isCarrying( self ))
            totweight := totweight + self.weight;

        if ( totweight > actor.maxweight )
            "%Your% load is too heavy. ";
        else if ( totbulk > actor.maxbulk )
            "%You've% already got %your% hands full. ";
        else
        {
            self.moveInto( actor );
            "Taken. ";
        }
    }
    verDoDrop( actor ) =
    {
        if ( not actor.isCarrying( self ))
        {
            "%You're% not carrying "; self.thedesc; "! ";
        }
        else self.verifyRemove( actor );
    }
    doDrop( actor ) =
    {
        actor.location.roomDrop( self );
    }
    verDoUnwear( actor ) =
    {
        "%You're% not wearing "; self.thedesc; "! ";
    }
    verIoPutIn( actor ) =
    {
        "I don't know how to put anything into "; self.thedesc; ". ";
    }
    verDoPutIn( actor, io ) =
    {
        if ( io = nil ) return;

        if ( self.location = io )
        {
            caps(); self.thedesc; " is already in "; io.thedesc; "! ";
        }
        else if ( io = self or io.isIn( self ))
        {
            "%You% can't put "; self.thedesc; " in itself! ";
        }
        else self.verifyRemove( actor );
    }
    doPutIn( actor, io ) =
    {
        self.moveInto( io );
        "Done. ";
    }
    verIoPutOn( actor ) =
    {
        "There's no good surface on "; self.thedesc; ". ";
    }
    verDoPutOn( actor, io ) =
    {
        if ( io = nil ) return;

        if ( self.location = io )
        {
            caps(); self.thedesc; " is already on "; io.thedesc; "! ";
        }
        else if ( io = self or io.isIn( self ))
        {
            "%You% can't put "; self.thedesc; " on itself! ";
        }
        else self.verifyRemove( actor );
    }
    doPutOn( actor, io ) =
    {
        self.moveInto( io );
        "Done. ";
    }
    verIoTakeOut( actor ) = {}
    ioTakeOut( actor, dobj ) =
    {
        dobj.doTakeOut( actor, self );
    }
    verDoTakeOut( actor, io ) =
    {
        if ( io <> nil and not self.isIn( io ))
        {
            caps(); self.thedesc; " isn't in "; io.thedesc; ". ";
        }
	self.verDoTake(actor);         /* ensure object can be taken at all */
    }
    doTakeOut( actor, io ) =
    {
        self.doTake( actor );
    }
    verIoTakeOff( actor ) = {}
    ioTakeOff( actor, dobj ) =
    {
        dobj.doTakeOff( actor, self );
    }
    verDoTakeOff( actor, io ) =
    {
        if ( io <> nil and not self.isIn( io ))
        {
            caps(); self.thedesc; " isn't on "; io.thedesc; "! ";
        }
	self.verDoTake(actor);         /* ensure object can be taken at all */
    }
    doTakeOff( actor, io ) =
    {
        self.doTake( actor );
    }
    verIoPlugIn( actor ) =
    {
        "%You% can't plug anything into "; self.thedesc; ". ";
    }
    verDoPlugIn( actor, io ) =
    {
        "%You% can't plug "; self.thedesc; " into anything. ";
    }
    verIoUnplugFrom( actor ) =
    {
        "It's not plugged into "; self.thedesc; ". ";
    }
    verDoUnplugFrom( actor, io ) =
    {
        if ( io <> nil ) { "It's not plugged into "; io.thedesc; ". "; }
    }
    verDoLookin( actor ) =
    {
        "There's nothing in "; self.thedesc; ". ";
    }
    verDoLookthru( actor ) =
    {
        "%You% can't see anything through "; self.thedesc; ". ";
    }
    verDoLookunder( actor ) =
    {
        "There's nothing under "; self.thedesc; ". ";
    }
    verDoInspect( actor ) = {}
    doInspect( actor ) =
    {
        self.ldesc;
    }
    verDoRead( actor ) =
    {
        "I don't know how to read "; self.thedesc; ". ";
    }
    verDoLookbehind( actor ) =
    {
        "There's nothing behind "; self.thedesc; ". ";
    }
    verDoTurn( actor ) =
    {
        "Turning "; self.thedesc; " doesn't have any effect. ";
    }
    verDoTurnWith( actor, io ) =
    {
        "Turning "; self.thedesc; " doesn't have any effect. ";
    }
    verDoTurnTo( actor, io ) =
    {
        "Turning "; self.thedesc; " doesn't have any effect. ";
    }
    verIoTurnTo( actor ) =
    {
        "I don't know how to do that. ";
    }
    verDoTurnon( actor ) =
    {
        "I don't know how to turn "; self.thedesc; " on. ";
    }
    verDoTurnoff( actor ) =
    {
        "I don't know how to turn "; self.thedesc; " off. ";
    }
    verIoAskAbout( actor ) = {}
    ioAskAbout( actor, dobj ) =
    {
        dobj.doAskAbout( actor, self );
    }
    verDoAskAbout( actor, io ) =
    {
        "Surely, %you% can't think "; self.thedesc; " knows anything
        about it! ";
    }
    verIoTellAbout( actor ) = {}
    ioTellAbout( actor, dobj ) =
    {
        dobj.doTellAbout( actor, self );
    }
    verDoTellAbout( actor, io ) =
    {
        "It doesn't look as though "; self.thedesc; " is interested. ";
    }
    verDoUnboard( actor ) =
    {
        if ( actor.location <> self )
        {
            "%You're% not in "; self.thedesc; "! ";
        }
        else if ( self.location=nil )
        {
            "%You% can't get out of "; self.thedesc; "! ";
        }
    }
    doUnboard( actor ) =
    {
        if ( self.fastenitem )
	{
	    "%You%'ll have to unfasten "; actor.location.fastenitem.thedesc;
	    " first. ";
	}
	else
	{
            "Okay, %you're% no longer in "; self.thedesc; ". ";
            self.leaveRoom( actor );
	    actor.moveInto( self.location );
	}
    }
    verDoAttackWith( actor, io ) =
    {
        "Attacking "; self.thedesc; " doesn't appear productive. ";
    }
    verIoAttackWith( actor ) =
    {
        "It's not very effective to attack with "; self.thedesc; ". ";
    }
    verDoEat( actor ) =
    {
	    "I think I just lost my appetite.";		// DMB
    }
    verDoDrink( actor ) =
    {
	    "Don't be ridiculous!";	// DMB
    }
    verDoGiveTo( actor, io ) =
    {
        if ( not actor.isCarrying( self ))
        {
            "%You're% not carrying "; self.thedesc; ". ";
        }
        else self.verifyRemove( actor );
    }
    doGiveTo( actor, io ) =
    {
        self.moveInto( io );
        "Done. ";
    }
    verDoPull( actor ) =
    {
        "Pulling "; self.thedesc; " doesn't have any effect. ";
    }
    verDoThrowAt( actor, io ) =
    {
        if ( not actor.isCarrying( self ))
        {
            "%You're% not carrying "; self.thedesc; ". ";
        }
        else self.verifyRemove( actor );
    }
    doThrowAt( actor, io ) =
    {
        "%You% miss%es%. ";
        self.moveInto( actor.location );
    }
    verIoThrowAt( actor ) =
    {
        if ( actor.isCarrying( self ))
        {
            "%You% could at least drop "; self.thedesc; " first. ";
        }
    }
    ioThrowAt( actor, dobj ) =
    {
        dobj.doThrowAt( actor, self );
    }
    verDoThrowTo( actor, io ) =
    {
        if ( not actor.isCarrying( self ))
        {
            "%You're% not carrying "; self.thedesc; ". ";
        }
        else self.verifyRemove( actor );
    }
    doThrowTo( actor, io ) =
    {
        "%You% miss%es%. ";
        self.moveInto( actor.location );
    }
    verDoThrow( actor ) =
    {
        if ( not actor.isCarrying( self ))
        {
            "%You're% not carrying "; self.thedesc; ". ";
        }
        else self.verifyRemove( actor );
    }
    doThrow( actor ) =
    {
        "Thrown. ";
        self.moveInto( actor.location );
    }
    verDoShowTo( actor, io ) =
    {
    }
    doShowTo( actor, io ) =
    {
        if ( io <> nil ) { caps(); io.thedesc; " isn't impressed. "; }
    }
    verIoShowTo( actor ) =
    {
        caps(); self.thedesc; " isn't impressed. ";
    }
    verDoClean( actor ) =
    {
        caps(); self.thedesc; " looks a bit cleaner now. ";
    }
    verDoCleanWith( actor, io ) = {}
    doCleanWith( actor, io ) =
    {
        caps(); self.thedesc; " looks a bit cleaner now. ";
    }
    verDoMove( actor ) =
    {
        "Moving "; self.thedesc; " doesn't reveal anything. ";
    }
    verDoMoveTo( actor, io ) =
    {
        "Moving "; self.thedesc; " doesn't reveal anything. ";
    }
    verIoMoveTo( actor ) =
    {
        "That doesn't get us anywhere. ";
    }
    verDoMoveWith( actor, io ) =
    {
        "Moving "; self.thedesc; " doesn't reveal anything. ";
    }
    verIoMoveWith( actor ) =
    {
        caps(); self.thedesc; " doesn't seem to help. ";
    }
    verDoTypeOn( actor, io ) =
    {
        "You should say what you want to type in double quotes, for
        example, TYPE \"HELLO\" ON KEYBOARD. ";
    }
    verDoTouch( actor ) =
    {
        "Touching "; self.thedesc; " doesn't seem to have any effect. ";
    }
    verDoPoke( actor ) =
    {
        "Poking "; self.thedesc; " doesn't seem to have any effect. ";
    }
    genMoveDir = { "%You% can't seem to do that. "; }
    verDoMoveN( actor ) = { self.genMoveDir; }
    verDoMoveS( actor ) = { self.genMoveDir; }
    verDoMoveE( actor ) = { self.genMoveDir; }
    verDoMoveW( actor ) = { self.genMoveDir; }
    verDoMoveNE( actor ) = { self.genMoveDir; }
    verDoMoveNW( actor ) = { self.genMoveDir; }
    verDoMoveSE( actor ) = { self.genMoveDir; }
    verDoMoveSW( actor ) = { self.genMoveDir; }
    verDoSearch( actor ) =
    {
        "%You% find%s% nothing of interest. ";
    }

#include "thingext.t"	// DMB: include extensions to standard thing class
;

/*
@item: thing
A basic item which can be picked up by the player.  It has no weight
(0) and minimal bulk (1).  The \tt weight\ property should be set
to a non-zero value for heavy objects.  The \tt bulk\ property
should be set to a value greater than 1 for bulky objects, and to
zero for objects that are very small and take essentially no effort
to hold---or, more precisely, don't detract at all from the player's
ability to hold other objects (for example, a piece of paper).
*/
class item: thing
    weight = 0
    bulk = 1
;
    
/*
@lightsource: item
A portable lamp, candle, match, or other source of light.  The
light source can be turned on and off with the \tt islit\ property.
If \tt islit\ is \tt true\, the object provides light, otherwise it's
just an ordinary object.
*/
class lightsource: item
    islamp = true
;

/*
@hiddenItem: object
This is an object that is hidden with one of the \tt hider\ classes. 
A \tt hiddenItem\ object doesn't have any special properties in its
own right, but all objects hidden with one of the \tt hider\ classes
must be of class \tt hiddenItem\ so that \tt initSearch\ can find
them.
*/
class hiddenItem: object
;

/*
@hider: item
This is a basic class of object that can hide other objects in various
ways.  The \tt underHider\, \tt behindHider\, and \tt searchHider\ classes
are examples of \tt hider\ subclasses.  The class defines
the method \tt searchObj(\it actor, list\)\, which is given the list
of hidden items contained in the object (for example, this would be the
\tt underCont\ property, in the case of a \tt underHider\), and ``finds''
the object or objects. Its action is dependent upon a couple of other
properties of the \tt hider\ object.  The \tt serialSearch\ property,
if \tt true\, indicates that items in the list are to be found one at
a time; if \tt nil\ (the default), the entire list is found on the
first try.  The \tt autoTake\ property, if \tt true\, indicates that
the actor automatically takes the item or items found; if \tt nil\, the
item or items are moved to the actor's location.  The \tt searchObj\ method
returns the \it list\ with the found object or objects removed; the
caller should assign this returned value back to the appropriate
property (for example, \tt underHider\ will assign the return value
to \tt underCont\).

Note that because the \tt hider\ is hiding something, this class
overrides the normal \tt verDoSearch\ method to display the
message, ``You'll have to be more specific about how you want
to search that.''  The reason is that the normal \tt verDoSearch\
message (``You find nothing of interest'') leads players to believe
that the object was exhaustively searched, and we want to avoid
misleading the player.  On the other hand, we don't want a general
search to be exhaustive for most \tt hider\ objects.  So, we just
display a message letting the player know that the search was not
enough, but we don't give away what they have to do instead.

The objects hidden with one of the \tt hider\ classes must be
of class \tt hiddenItem\.
*/
class hider: item
    verDoSearch(actor) =
    {
	"%You%'ll have to be more specific about how %you% want%s%
	to search that. ";
    }
    searchObj(actor, list) =
    {
	local found, dest, i, tot;

	/* see how much we get this time */
	if (self.serialSearch)
	{
	    found := [] + car(list);
	    list := cdr(list);
	}
	else
	{
	    found := list;
	    list := nil;
	}

	/* figure destination */
	dest := actor;
	if (not self.autoTake) dest := dest.location;
	
	/* note what we found, and move it to destination */
	"%You% find%s% ";
	tot := length(found);
	i := 1;
	while (i <= tot)
	{
	    found[i].adesc;
	    if (i+1 < tot) ", ";
	    else if (i = 1 and tot = 2) " and ";
	    else if (i+1 = tot and tot > 2) ", and ";
	    
	    found[i].moveInto(dest);
	    i := i + 1;
	}

	/* say what happened */
	if (self.autoTake) ", which %you% take%s%. ";
	else "! ";

	if (list<>nil and length(list)=0) list := nil;
	return(list);
    }
    serialSearch = nil             /* find everything in one try by default */
    autoTake = true               /* actor takes item when found by default */
;

/*
@underHider: hider
This is an object that can have other objects placed under it.  The
objects placed under it can only be found by looking under the object;
see the description of \tt hider\ for more information.  Note that you
should set the \tt underLoc\ property of each hidden object to point
to the \tt underHider\.

Note that an \tt underHider\ doesn't allow the \it player\ to put anything
under the object during the game.  Instead, it's to make it easy for the
game writer to set up hidden objects while implementing the game.  All you
need to do to place an object under another object is declare the top
object as an \tt underHider\, then declare the hidden object normally,
except use \tt underLoc\ rather than \tt location\ to specify the
location of the hidden object.  The \tt behindHider\ and \tt searchHider\
objects work similarly.

The objects hidden with \tt underHider\ must be of class \tt hiddenItem\.
*/
class underHider: hider
    underCont = []         /* list of items under me (set up by initSearch) */
    verDoLookunder(actor) = {}
    doLookunder(actor) =
    {
	if (self.underCont = nil)
	    "There's nothing else under <<self.thedesc>>. ";
	else
	    self.underCont := self.searchObj(actor, self.underCont);
    }
;

/*
@behindHider: hider
This is just like an \tt underHider\, except that objects are hidden
behind this object.  Objects to be behind this object should have their
\tt behindLoc\ property set to point to this object.

The objects hidden with \tt behindHider\ must be of class \tt hiddenItem\.
*/
class behindHider: hider
    behindCont = []
    verDoLookbehind(actor) = {}
    doLookbehind(actor) =
    {
	if (self.behindCont = nil)
	    "There's nothing else behind <<self.thedesc>>. ";
	else
	    self.behindCont := self.searchObj(actor, self.behindCont);
    }
;
    
/*
@searchHider: hider
This is just like an \tt underHider\, except that objects are hidden
within this object in such a way that the object must be looked in
or searched.  Objects to be hidden in this object should have their
\tt searchLoc\ property set to point to this object.  Note that this
is different from a normal container, in that the objects hidden within
this object will not show up until the object is explicitly looked in
or searched.

The items hidden with \tt searchHider\ must be of class \tt hiddenItem\.
*/
class searchHider: hider
    searchCont = []
    verDoSearch(actor) = {}
    doSearch(actor) =
    {
	if (self.searchCont = nil)
	    "There's nothing else in <<self.thedesc>>. ";
	else
	    self.searchCont := self.searchObj(actor, self.searchCont);
    }
    verDoLookin(actor) =
    {
	if (self.searchCont = nil)
	    pass verDoLookin;
    }
    doLookin(actor) =
    {
	if (self.searchCont = nil)
	    pass doLookin;
	else
	    self.searchCont := self.searchObj(actor, self.searchCont);
    }
;
    

/*
@fixeditem: thing
An object that cannot be taken or otherwise moved from its location.
Note that a \tt fixeditem\ is sometimes part of a movable object;
this can be done to make one object part of another, ensuring that
they cannot be separated.  By default, the functions that list a room's
contents do not automatically describe \tt fixeditem\ objects (because
the \tt isListed\ property is set to \tt nil\).  Instead, the game author
will generally describe the \tt fixeditem\ objects separately as part of
the room's \tt ldesc\.  
*/
class fixeditem: thing      // An immovable object
    isListed = nil          // not listed in room/inventory displays
    isfixed = true          // Item can't be taken
    weight = 0              // no actual weight
    bulk = 0
    verDoTake( actor ) =
    {
        "%You% can't have "; self.thedesc; ". ";
    }
    verDoTakeOut( actor, io ) =
    {
        self.verDoTake( actor );
    }
    verDoDrop( actor ) =
    {
        "%You% can't drop "; self.thedesc; ". ";
    }
    verDoTakeOff( actor, io ) =
    {
        self.verDoTake( actor );
    }
    verDoPutIn( actor, io ) =
    {
        "%You% can't put "; self.thedesc; " anywhere. ";
    }
    verDoPutOn( actor, io ) =
    {
        "%You% can't put "; self.thedesc; " anywhere. ";
    }
    verDoMove( actor ) =
    {
        "%You% can't move "; self.thedesc; ". ";
    }
;

/*
@readable: item
An item that can be read.  The \tt readdesc\ property is displayed
when the item is read.  By default, the \tt readdesc\ is the same
as the \tt ldesc\, but the \tt readdesc\ can be overridden to give
a different message.
*/
class readable: item
    verDoRead( actor ) =
    {
    }
    doRead( actor ) =
    {
        self.readdesc;
    }
    readdesc =
    {
        self.ldesc;
    }
;

/*
@fooditem: item
An object that can be eaten.  When eaten, the object is removed from
the game, and \tt global.lastMealTime\ is decremented by the
\tt foodvalue\ property.  By default, the \tt foodvalue\ property
is \tt global.eatTime\, which is the time between meals.  So, the
default \tt fooditem\ will last for one ``nourishment interval.''
*/
class fooditem: item
    verDoEat( actor ) =
    {
        self.verifyRemove( actor );
    }
    doEat( actor ) =
    {
        "That was delicious! ";
        // global.lastMealTime := global.lastMealTime - self.foodvalue;
        self.moveInto( nil );
    }
    foodvalue = { return( global.eatTime ); }
;

/*
@dialItem: fixeditem
This class is used for making ``dials,'' which are controls in
your game that can be turned to a range of numbers.  You must
define the property \tt maxsetting\ as a number specifying the
highest number to which the dial can be turned; the lowest number
on the dial is always 1.  The \tt setting\ property is the dial's
current setting, and can be changed by the player by typing the
command ``turn dial to \it number\.''  By default, the \tt ldesc\
method displays the current setting.
*/
class dialItem: fixeditem
    maxsetting = 10 // it has settings from 1 to this number
    setting = 1     // the current setting
    ldesc =
    {
        caps(); self.thedesc; " can be turned to settings
        numbered from 1 to << self.maxsetting >>. It's
        currently set to << self.setting >>. ";
    }
    verDoTurn( actor ) = {}
    doTurn( actor ) =
    {
        askio( toPrep );
    }
    verDoTurnTo( actor, io ) = {}
    doTurnTo( actor, io ) =
    {
        if ( io = numObj )
        {
            if ( numObj.value < 1 or numObj.value > self.maxsetting )
            {
                "There's no such setting! ";
            }
            else if ( numObj.value <> self.setting )
            {
                self.setting := numObj.value;
                "Okay, it's now turned to "; say( self.setting ); ". ";
            }
            else
            {
                "It's already set to "; say( self.setting ); "! ";
            }
        }
        else
        {
            "I don't know how to turn "; self.thedesc;
            " to that. ";
        }
    }
;

/*
@switchItem: fixeditem
This is a class for things that can be turned on and off by the
player.  The only special property is \tt isActive\, which is \tt nil\
if the switch is turned off and \tt true\ when turned on.  The object
accepts the commands ``turn it on'' and ``turn it off,'' as well as
synonymous constructions, and updates \tt isActive\ accordingly.
*/
class switchItem: fixeditem
    verDoSwitch( actor ) = {}
    doSwitch( actor ) =
    {
        self.isActive := not self.isActive;
        "Okay, "; self.thedesc; " is now switched ";
        if ( self.isActive ) "on"; else "off";
        ". ";
    }
    verDoTurnon( actor ) =
    {
        if ( self.isActive ) "It's already turned on! ";
    }
    doTurnon( actor ) =
    {
        self.isActive := true;
        "Okay, it's now turned on. ";
    }
    verDoTurnoff( actor ) =
    {
        if ( not self.isActive ) "It's already turned off! ";
    }
    doTurnoff( actor ) =
    {
        self.isActive := nil;
        "Okay, it's now turned off. ";
    }
;

/*
@room: thing
A location in the game.  By default, the \tt islit\ property is
\tt true\, which means that the room is lit (no light source is
needed while in the room).  You should create a \tt darkroom\
object rather than a \tt room\ with \tt islit\ set to \tt nil\ if you
want a dark room, because other methods are affected as well.
The \tt isseen\ property records whether the player has entered
the room before; initially it's \tt nil\, and is set to \tt true\
the first time the player enters.  The \tt roomAction( \it actor,
verb, directObject, preposition, indirectObject\ )\ method is
activated for each player command; by default, all it does is
call the room's location's \tt roomAction\ method if the room
is inside another room.  The \tt lookAround( \it verbosity\ )\
method displays the room's description for a given verbosity
level; \tt true\ means a full description, \tt nil\ means only
the short description (just the room name plus a list of the
objects present).  \tt roomDrop( \it object\ )\ is called when
an object is dropped within the room; normally, it just moves
the object to the room and displays ``Dropped.''  The \tt firstseen\
method is called when \tt isseen\ is about to be set \tt true\
for the first time (i.e., when the player first sees the room);
by default, this routine does nothing, but it's a convenient
place to put any special code you want to execute when a room
is first entered.  The \tt firstseen\ method is called \it after\
the room's description is displayed.
*/

/*
 *  room: thing
 *
 *  A location in the game.  By default, the islit property is
 *  true, which means that the room is lit (no light source is
 *  needed while in the room).  You should create a darkroom
 *  object rather than a room with islit set to nil if you
 *  want a dark room, because other methods are affected as well.
 *  The isseen property records whether the player has entered
 *  the room before; initially it's nil, and is set to true
 *  the first time the player enters.  The roomAction( actor,
 *  verb, directObject, preposition, indirectObject ) method is
 *  activated for each player command; by default, all it does is
 *  call the room's location's roomAction method if the room
 *  is inside another room.  The lookAround( verbosity )
 *  method displays the room's description for a given verbosity
 *  level; true means a full description, nil means only
 *  the short description (just the room name plus a list of the
 *  objects present).  roomDrop( object ) is called when
 *  an object is dropped within the room; normally, it just moves
 *  the object to the room and displays "Dropped."  The firstseen
 *  method is called when isseen is about to be set true
 *  for the first time (i.e., when the player first sees the room);
 *  by default, this routine does nothing, but it's a convenient
 *  place to put any special code you want to execute when a room
 *  is first entered.  The firstseen method is called after
 *  the room's description is displayed.
*/
room: thing
    topline = true	// DMB -- see nestedroom
    
    /*
     *   'reachable' is the list of explicitly reachable objects, over and
     *   above the objects that are here.  This is mostly used in nested
     *   rooms to make objects in the containing room accessible.  Most
     *   normal rooms will leave this as an empty list.
     */
    reachable = []
	
    /*
     *   roomCheck is true if the verb is valid in the room.  This
     *   is a first pass; generally, its only function is to disallow
     *   certain commands in a dark room.
     */
    roomCheck( v ) = { return( true ); }
    islit = true            // rooms are lit unless otherwise specified
    isseen = nil            // room has not been seen yet
    enterRoom( actor ) =    // sent to room as actor is entering it
    {
        self.lookAround(( not self.isseen ) or global.verbose );
        if ( self.islit )
	{
	    if (not self.isseen) self.firstseen;
	    self.isseen := true;
	}
    }
    roomAction( a, v, d, p, i ) =
    {
        if ( self.location ) self.location.roomAction( a, v, d, p, i );
    }

    /*
     *   Whenever a normal object (i.e., one that does not override the
     *   default doDrop provided by 'thing') is dropped, the actor's
     *   location is sent roomDrop(object being dropped).  By default, 
     *   we move the object into this room.
     */
    roomDrop( obj ) =
    {
        "Dropped. ";
	obj.moveInto( self );
    }

    /*
     *   Whenever an actor leaves this room, we run through the leaveList.
     *   This is a list of objects that have registered themselves with us
     *   via addLeaveList().  For each object in the leaveList, we send
     *   a "leaving" message, with the actor as the parameter.  It should
     *   return true if it wants to be removed from the leaveList, nil
     *   if it wants to stay.
     */
    leaveList = []
    addLeaveList( obj ) =
    {
        self.leaveList := self.leaveList + obj;
    }
    leaveRoom( actor ) =
    {
        local tmplist, thisobj, i, tot;

        tmplist := self.leaveList;
	tot := length( tmplist );
	i := 1;
        while ( i <= tot )
        {
	    thisobj := tmplist[i];
            if ( thisobj.leaving( actor ))
                self.leaveList := self.leaveList - thisobj;
            i := i + 1;
        }
    }
    /*
     *   lookAround describes the room.  If verbosity is true, the full
     *   description is given, otherwise an abbreviated description (without
     *   the room's ldesc) is displayed.
     */
    nrmLkAround( verbosity ) =      // lookAround without location status
    {
        local l, cur, i, tot;

        if ( verbosity )
        {
            /* "\n\t"; self.ldesc; */
		"\b"; self.ldesc;	/* DMB */

            l := self.contents;
	    tot := length( l );
	    i := 1;
            while ( i <= tot )
            {
	        cur := l[i];
                if ( cur.isfixed ) cur.heredesc;
                i := i + 1;
            }
        }
        /* "\n\t"; */
        if (itemcnt( self.contents ))
        {
            P(); I();	/* DMB */
            "You see "; listcont( self ); " here. ";
       }
        else {
            "\n\t";
        }

	/*
	 * DMB add stuff to listcontcont so we can see if there's
         * anything to print before putting the paragraph separator out.
         */
	if (listcontcont(self, nil)) {
		P(); I();
		listcontcont(self, true);
	}

	/*
	 * DMB: Hack for Colossal Cave: since the bear has a location
	 * that's a method, his actorDesc doesn't get printed by
         * the code below.
         */
	if (Bear.isIn(self))
		Bear.actorDesc;

        l := self.contents;
	tot := length( l );
	i := 1;
        while ( i <= tot )
        {
	    cur := l[i];
            if ( cur.isactor )
            {
                if ( cur <> Me )
                {
                    "\n\t";
                    cur.actorDesc;
                }
            }
            i := i + 1;
        }
    }
    /* DMB: */
    statusline = { self.sdesc; }
    statusLine =
    {
    	self.statusline;
    }
    lookAround( verbosity ) =
    {
    	self.statusline; // DMB -- removed "\b";
        self.nrmLkAround( verbosity );
    }
    
    /*
     *   Direction handlers.  The directions are all set up to
     *   the default, which is no travel allowed.  To make travel
     *   possible in a direction, just assign a room to the direction
     *   property.
     */
    north = { return( self.noexit ); }
    south = { return( self.noexit ); }
    east  = { return( self.noexit ); }
    west  = { return( self.noexit ); }
    up    = { return( self.noexit ); }
    down  = { return( self.noexit ); }
    ne    = { return( self.noexit ); }
    nw    = { return( self.noexit ); }
    se    = { return( self.noexit ); }
    sw    = { return( self.noexit ); }
    in    = { return( self.noexit ); }
    out   = { return( self.noexit ); }
    
    /*
     *   noexit displays a message when the player attempts to travel
     *   in a direction in which travel is not possible.
     */
    noexit = { "%You% can't go that way. "; return( nil ); }
;

/*
@darkroom: room
A dark room.  The player must have some object that can act as a
light source in order to move about and perform most operations
while in this room.  Note that the room's lights can be turned
on by setting the room's \tt lightsOn\ property to \tt true\;
do this instead of setting \tt islit\, because \tt islit\ is
a method which checks for the presence of a light source.
*/
class darkroom: room        // An enterable area which might be dark
    islit =                 // true ONLY if something is lighting the room
    {
        local rem, cur, tot, i;

	if ( self.lightsOn ) return( true );

	rem := global.lamplist;
	tot := length( rem );
	i := 1;
	while ( i <= tot )
	{
	    cur := rem[i];
	    if ( cur.isIn( self ) and cur.islit ) return( true );
	    i := i + 1;
	}
	return( nil );
    }
    roomAction( actor, v, dobj, prep, io ) =
    {
        if ( not self.islit and not v.isTravelVerb and not v.issysverb )
	{
	    "%You% can't see a thing. ";
	    exit;
	}
	else pass roomAction;
    }
    statusLine =
    {
        if ( self.islit ) pass statusLine;
	else "In the dark.";
    }
    lookAround( verbosity ) =
    {
	    // DMB: Changed pitch dark message
        if ( self.islit ) pass lookAround;
	else "It is now pitch dark.
	If you proceed you will likely fall into a pit."; 

    }
    noexit =
    {
        if ( self.islit ) pass noexit;
	else
	{
	    darkTravel();
	    return( nil );
	}
    }
    roomCheck( v ) =
    {
        if ( self.islit or v.issysverb or v.isTravelVerb ) return( true );
	else
	{
	    "It's pitch black.\n";
	    return( nil );
	}
    }
;

/*
 *  theFloor is a special item that appears in every room (hence
 *  the non-standard location property).  This object is included
 *  mostly for completeness, so that the player can refer to the
 *  floor; otherwise, it doesn't do much.  Dropping an item on the
 *  floor, for example, moves it to the current room.
 */
class theFloor: beditem
    onroom = true	// DMB so it won't say "in the ground"
    noun = 'floor' 'ground'
    sdesc = "ground"
    adesc = "the ground"
    location =
    {
        if ( Me.location = self )
            return( self.sitloc );
        else
            return( Me.location );
    }
    locationOK = true        // suppress warning about location being a method
    doSiton( actor ) =
    {
        "Okay, %you're% now sitting on "; self.thedesc; ". ";
        self.sitloc := actor.location;
        actor.moveInto( self );
    }
    doLieon( actor ) =
    {
	// DMB changed so it says "lying."
        "Okay, %you're% now lying on "; self.thedesc; ". ";
        self.sitloc := actor.location;
        actor.moveInto( self );
    }
    ioPutOn( actor, dobj ) =
    {
        dobj.doDrop( actor );
    }
    ioPutIn( actor, dobj ) =
    {
        dobj.doDrop( actor );
    }
;

/*
@Actor: fixeditem, movableActor
A character in the game.  The \tt maxweight\ property specifies
the maximum weight that the character can carry, and the \tt maxbulk\
property specifies the maximum bulk the character can carry.  The
\tt actorAction( \it verb, directObject, preposition, indirectObject\ )\
method specifies what happens when the actor is given a command by
the player; by default, the actor ignores the command and displays
a message to this effect.  The \tt isCarrying( \it object\ )\
method returns \tt true\ if the \it object\ is being carried by
the actor.  The \tt actorDesc\ method displays a message when the
actor is in the current room; this message is displayed along with
a room's description when the room is entered or examined.  The
\tt verGrab( \it object\ )\ method is called when someone tries to
take an object the actor is carrying; by default, an actor won't
let other characters take its possessions.

If you want the player to be able to follow the actor when it
leaves the room, you should define a \tt follower\ object to shadow
the character, and set the actor's \tt myfollower\ property to
the \tt follower\ object.  The \tt follower\ is then automatically
moved around just behind the actor by the actor's \tt moveInto\
method.

The \tt isHim\ property should return \tt true\ if the actor can
be referred to by the player as ``him,'' and likewise \tt isHer\
should be set to \tt true\ if the actor can be referred to as ``her.''
Note that both or neither can be set; if neither is set, the actor
can only be referred to as ``it,'' and if both are set, any of ``him,''
``her,'' or ``it'' will be accepted.
*/
class Actor: fixeditem, movableActor
;

/*
@movableActor: qcontainer
Just like an \tt Actor\ object, except that the player can
manipulate the actor like an ordinary item.  Useful for certain
types of actors, such as small animals.
*/
class movableActor: qcontainer // A character in the game
    isListed = nil          // described separately from room's contents
    weight = 10             // actors are pretty heavy
    bulk = 10               // and pretty bulky
    maxweight = 50          // Weight that can be carried at once
    maxbulk = 20            // Number of objects that can be carried at once
    isactor = true          // flag that this is an actor
    actorAction( v, d, p, i ) =
    {
        caps(); self.thedesc; " doesn't appear interested. ";
        exit;
    }
    isCarrying( obj ) = { return( obj.isIn( self )); }
    actorDesc =
    {
        caps(); self.adesc; " is here. ";
    }
    verGrab( item ) =
    {
        caps(); self.thedesc; " is carrying "; item.thedesc;
        " and won't let %youm% have it. ";
    }
    verDoFollow( actor ) =
    {
        "But "; self.thedesc; " is right here! ";
    }
    moveInto( obj ) =
    {
        if ( self.myfollower ) self.myfollower.moveInto( self.location );
	pass moveInto;
    }
    // these properties are for the format strings
    fmtYou = "he"
    fmtYour = "his"
    fmtYoure = "he's"
    fmtYoum = "him"
    fmtYouve = "he's"
    fmtS = "s"
    fmtEs = "es"
    fmtHave = "has"
    fmtDo = "does"
    fmtAre = "is"
;

/*
@follower: Actor
This is a special object that can ``shadow'' the movements of a
character as it moves from room to room.  The purpose of a \tt follower\
is to allow the player to follow an actor as it leaves a room by
typing a ``follow'' command.  Each actor that is to be followed must
have its own \tt follower\ object.  The \tt follower\ object should
define all of the same vocabulary words (nouns and adjectives) as the
actual actor to which it refers.  The \tt follower\ must also
define the \tt myactor\ property to be the \tt Actor\ object that
the \tt follower\ follows.  The \tt follower\ will always stay
one room behind the character it follows; no commands are effective
with a \tt follower\ except for ``follow.''
*/
class follower: Actor
    sdesc = { self.myactor.sdesc; }
    isfollower = true
    ldesc = { caps(); self.thedesc; " is no longer here. "; }
    actorAction( v, d, p, i ) = { self.ldesc; }
    actorDesc = {}
    myactor = nil   // set to the Actor to be followed
    verDoFollow( actor ) = {}
    doFollow( actor ) =
    {
        actor.travelTo( self.myactor.location );
    }
;

/*
@basicMe: Actor
A default implementation of the \tt Me\ object, which is the
player character.  \tt adv.t\ defines \tt basicMe\ instead of
\tt Me\ to allow your game to override parts of the default
implementation while still using the rest, and without changing
\tt adv.t\ itself.  To use \tt basicMe\ unchanged as your player
character, include this in your game:  ``\tt Me: basicMe;\''.

The \tt basicMe\ object defines all of the methods and properties
required for an actor, with appropriate values for the player
character.  The nouns ``me'' and ``myself'' are defined (``I''
is not defined, because it conflicts with the ``inventory''
command's minimal abbreviation of ``i'' in certain circumstances,
and is generally not compatible with the syntax of most player
commands anyway).  The \tt sdesc\ is ``you''; the \tt thedesc\
and \tt adesc\ are ``yourself,'' which is appropriate for most
contexts.  The \tt maxbulk\ and \tt maxweight\ properties are
set to 10 each; a more sophisticated \tt Me\ might include the
player's state of health in determining the \tt maxweight\ and
\tt maxbulk\ properties.
*/
class basicMe: Actor
    roomCheck( v ) = { return( self.location.roomCheck( v )); }
    noun = 'me' 'myself'
    sdesc = "you"
    thedesc = "yourself"
    adesc = "yourself"
    ldesc = "You look about the same as always. "
    maxweight = 10
    maxbulk = 10
    verDoFollow( actor ) =
    {
        if ( actor = self ) "You can't follow yourself! ";
    }
    actorAction( verb, dobj, prep, iobj ) = 
    {
    }
    travelTo( room ) =
    {
        if ( room )
        {
	    if ( room.isobstacle )
	    {
	        self.travelTo( room.destination );
	    }
	    else if ( not ( self.location.islit or room.islit ))
	    {
	        darkTravel();
	    }
	    else
	    {
                if ( self.location ) self.location.leaveRoom( self );
                self.location := room;
                room.enterRoom( self );
	    }
        }
    }
    moveInto( room ) =
    {
        self.location := room;
    }
    // these properties are for the format strings
    fmtYou = "you"
    fmtYour = "your"
    fmtYoure = "you're"
    fmtYoum = "you"
    fmtYouve = "you've"
    fmtS = ""
    fmtEs = ""
    fmtHave = "have"
    fmtDo = "do"
    fmtAre = "are"
;

/*
@decoration: fixeditem
An item that doesn't have any function in the game, apart from
having been mentioned in the room description.  These items
are immovable and can't be manipulated in any way, but can be
referred to and inspected.  Liberal use of \tt decoration\ items
can improve a game's playability by helping the parser recognize
all the words the game uses in its descriptions of rooms.
*/
class decoration: fixeditem
;

/*
@buttonitem: fixeditem
A button (the type you push).  The individual button's method
\tt doPush( \it actor\ )\, which must be specified in
the button, carries out the function of the button.  Note that
all buttons have the noun ``button'' defined.
*/
class buttonitem: fixeditem
    noun = 'button'
    plural = 'buttons'
    verDoPush( actor ) = {}
;

/*
@clothingItem: item
Something that can be worn.  By default, the only thing that
happens when the item is worn is that its \tt isworn\ property
is set to \tt true\.  If you want more to happen, override the
\tt doWear( \it actor\ )\ property.  Note that, when a \tt clothingItem\
is being worn, certain operations will cause it to be removed (for
example, dropping it causes it to be removed).  If you want
something else to happen, override the \tt checkDrop\ method;
if you want to disallow such actions while the object is worn,
use an \tt exit\ statement in the \tt checkDrop\ method.
*/
class clothingItem: item
    checkDrop =
    {
        if ( self.isworn )
	{
	    "(Taking off "; self.thedesc; " first)\n";
	}
    }
    doDrop( actor ) =
    {
        self.checkDrop;
	pass doDrop;
    }
    doPutIn( actor, io ) =
    {
        self.checkDrop;
	pass doPutIn;
    }
    doPutOn( actor, io ) =
    {
        self.checkDrop;
	pass doPutOn;
    }
    doGiveTo( actor, io ) =
    {
        self.checkDrop;
	pass doGiveTo;
    }
    doThrowAt( actor, io ) =
    {
        self.checkDrop;
	pass doThrowAt;
    }
    doThrowTo( actor, io ) =
    {
        self.checkDrop;
	pass doThrowTo;
    }
    doThrow( actor ) =
    {
        self.checkDrop;
	pass doThrow;
    }
    moveInto( obj ) =
    {
        /*
	 *   Catch any other movements with moveInto; this won't stop the
	 *   movement from happening, but it will prevent any anamolous
	 *   consequences caused by the object moving but still being worn.
	 */
        self.isworn := nil;
	pass moveInto;
    }
    verDoWear( actor ) =
    {
        if ( self.isworn )
        {
            "%You're% already wearing "; self.thedesc; "! ";
        }
        else if ( not actor.isCarrying( self ))
        {
            "%You% %do%n't have "; self.thedesc; ". ";
        }
    }
    doWear( actor ) =
    {
        "Okay, %you're% now wearing "; self.thedesc; ". ";
        self.isworn := true;
    }
    verDoUnwear( actor ) =
    {
        if ( not self.isworn )
        {
            "%You're% not wearing "; self.thedesc; ". ";
        }
    }
    doUnwear( actor ) =
    {
        "Okay, %you're% no longer wearing "; self.thedesc; ". ";
        self.isworn := nil;
    }
;

/*
@obstacle: object
An \tt obstacle\ is used in place of a room for a direction
property.  The \tt destination\ property specifies the room that
is reached if the obstacle is successfully negotiated; when the
obstacle is not successfully negotiated, \tt destination\ should
display an appropriate message and return \tt nil\.
*/
class obstacle: object
    isobstacle = true
;

/*
@doorway: fixeditem, obstacle
A \tt doorway\ is an obstacle that impedes progress when it is closed.
When the door is open (\tt isopen\ is \tt true\), the user ends up in
the room specified in the \tt doordest\ property upon going through
the door.  Since a doorway is an obstacle, use the door object for
a direction property of the room containing the door.

If \tt noAutoOpen\ is not set to \tt true\, the door will automatically
be opened when the player tries to walk through the door, unless the
door is locked (\tt islocked\ = \tt true\).  If the door is locked,
it can be unlocked simply by typing ``unlock door'', unless the
\tt mykey\ property is set, in which case the object specified in
\tt mykey\ must be used to unlock the door.  Note that the door can
only be relocked by the player under the circumstances that allow
unlocking, plus the property \tt islockable\ must be set true.
By default, the door is closed; set \tt isopen\ to true if the door
is to start out open (and be sure to open the other side as well).

\tt otherside\ specifies the corresponding doorway object in the
destination room (\tt doordest\), if any.  If \tt otherside\ is
specified, its \tt isopen\ and \tt islocked\ properties will be
kept in sync automatically.
*/
class doorway: fixeditem, obstacle
    isdoor = true           // Item can be opened and closed
    destination =
    {
        if ( self.isopen ) return( self.doordest );
	else if ( not self.islocked and not self.noAutoOpen )
	{
	    self.isopen := true;
	    if ( self.otherside ) self.otherside.isopen := true;
	    "(Opening << self.thedesc >>)\n";
	    return( self.doordest );
	}
	else
	{
	    "%You%'ll have to open << self.thedesc >> first. ";
	    setit( self );
	    return( nil );
	}
    }
    verDoOpen( actor ) =
    {
        if ( self.isopen ) "It's already open. ";
	else if ( self.islocked ) "It's locked. ";
    }
    doOpen( actor ) =
    {
        "Opened. ";
	self.isopen := true;
	if ( self.otherside ) self.otherside.isopen := true;
    }
    verDoClose( actor ) =
    {
        if ( not self.isopen ) "It's already closed. ";
    }
    doClose( actor ) =
    {
        "Closed. ";
	self.isopen := nil;
	if ( self.otherside ) self.otherside.isopen := nil;
    }
    verDoLock( actor ) =
    {
        if ( self.islocked ) "It's already locked! ";
	else if ( not self.islockable ) "It can't be locked. ";
	else if ( self.isopen ) "%You%'ll have to close it first. ";
    }
    doLock( actor ) =
    {
        if ( self.mykey = nil )
	{
	    "Locked. ";
	    self.islocked := true;
	    if ( self.otherside ) self.otherside.islocked := true;
	}
	else
            askio( withPrep );
    }
    verDoUnlock( actor ) =
    {
        if ( not self.islocked ) "It's not locked! ";
    }
    doUnlock( actor ) =
    {
        if ( self.mykey = nil )
	{
	    "Unlocked. ";
	    self.islocked := nil;
	    if ( self.otherside ) self.otherside.islocked := nil;
	}
	else
	    askio( withPrep );
    }
    verDoLockWith( actor, io ) =
    {
        if ( self.islocked ) "It's already locked. ";
	else if ( not self.islockable ) "It can't be locked. ";
	else if ( self.mykey = nil )
	    "%You% %do%n't need anything to lock it. ";
	else if ( self.isopen ) "%You%'ll have to close it first. ";
    }
    doLockWith( actor, io ) =
    {
        if ( io = self.mykey )
	{
	    "Locked. ";
	    self.islocked := true;
	    if ( self.otherside ) self.otherside.islocked := true;
	}
	else "It doesn't fit the lock. ";
    }
    verDoUnlockWith( actor, io ) =
    {
        if ( not self.islocked ) "It's not locked! ";
	else if ( self.mykey = nil )
	    "%You% %do%n't need anything to unlock it. ";
    }
    doUnlockWith( actor, io ) =
    {
        if ( io = self.mykey )
	{
	    "Unlocked. ";
	    self.islocked := nil;
	    if ( self.otherside ) self.otherside.islocked := nil;
	}
	else "It doesn't fit the lock. ";
    }
    ldesc =
    {
	if ( self.isopen ) "It's open. ";
	else
	{
	    if ( self.islocked ) "It's closed and locked. ";
	    else "It's closed. ";
	}
    }
;

/*
@lockableDoorway: doorway
This is just a normal doorway with the \tt islockable\ and
\tt islocked\ properties set to \tt true\.  Fill in the other
properties (\tt otherside\ and \tt doordest\) as usual.  If
the door has a key, set property \tt mykey\ to the key object.
*/
class lockableDoorway: doorway
    islockable = true
    islocked = true
;

/*
@vehicle: item, nestedroom
This is an object that an actor can board.  An actor cannot go
anywhere while on board a vehicle; the actor must get out first.
*/
class vehicle: item, nestedroom
    reachable = ([] + self)
    isvehicle = true
    verDoEnter( actor ) = { self.verDoBoard( actor ); }
    doEnter( actor ) = { self.doBoard( actor ); }
    verDoBoard( actor ) =
    {
        if ( actor.location = self )
        {
            "%You're% already in "; self.thedesc; "! ";
        }
    }
    doBoard( actor ) =
    {
        "Okay, %you're% now in "; self.thedesc; ". ";
        actor.moveInto( self );
    }
    noexit =
    {
        "%You're% not going anywhere until %you% get%s% out of ";
	  self.thedesc; ". ";
        return( nil );
    }
    out = ( self.location )
;

/*
@surface: item
Objects can be placed on a surface.  Apart from using the
preposition ``on'' rather than ``in'' to refer to objects
contained by the object, a \tt surface\ is identical to a
\tt container\.  Note: that an object cannot be both a
\tt surface\ and a \tt container\, because there is no
distinction between the two internally.
*/
class surface: item
    issurface = true        // Item can hold objects on its surface
    ldesc =
    {
        if (itemcnt( self.contents ))
        {
            "On "; self.thedesc; " %you% see%s% "; listcont( self ); ". ";
        }
        else
        {
            "There's nothing on "; self.thedesc; ". ";
        }
    }
    verIoPutOn( actor ) = {}
    ioPutOn( actor, dobj ) =
    {
        dobj.doPutOn( actor, self );
    }
;

/*
@container: item
This object can contain other objects.  The \tt iscontainer\ property
is set to \tt true\.  The default \tt ldesc\ displays a list of the
objects inside the container, if any.  The \tt maxbulk\ property
specifies the maximum amount of bulk the container can contain.
*/
class container: item
    maxbulk = 10            // maximum bulk the container can contain
    isopen = true           // in fact, it can't be closed at all
    iscontainer = true      // Item can contain other items
    ldesc =
    {
        if ( self.contentsVisible and itemcnt( self.contents ) <> 0 )
        {
            "In "; self.thedesc; " %you% see%s% "; listcont( self ); ". ";
        }
        else
        {
            "There's nothing in "; self.thedesc; ". ";
        }
    }
    verIoPutIn( actor ) =
    {
    }
    ioPutIn( actor, dobj ) =
    {
        if (addbulk( self.contents ) + dobj.bulk > self.maxbulk )
        {
            "%You% can't fit that in "; self.thedesc; ". ";
        }
        else
        {
	    dobj.doPutIn( actor, self );
        }
    }
    verDoLookin( actor ) = {}
    doLookin( actor ) =
    {
        self.ldesc;
    }
;

/*
@openable: container
A container that can be opened and closed.  The \tt isopenable\
property is set to \tt true\.  The default \tt ldesc\ displays
the contents of the container if the container is open, otherwise
a message saying that the object is closed.
*/
class openable: container
    contentsReachable = { return( self.isopen ); }
    contentsVisible = { return( self.isopen ); }
    isopenable = true
    ldesc =
    {
    	caps(); self.thedesc;
    	if ( self.isopen )
	{
	    " is open. ";
	    pass ldesc;
	}
    	else " is closed. ";
    }
    isopen = true
    verDoOpen( actor ) =
    {
        if ( self.isopen )
	{
	    caps(); self.thedesc; " is already open! ";
	}
    }
    doOpen( actor ) =
    {
        if (itemcnt( self.contents ))
	{
	    "Opening "; self.thedesc; " reveals "; listcont( self ); ". ";
	}
	else "Opened. ";
	self.isopen := true;
    }
    verDoClose( actor ) =
    {
        if ( not self.isopen )
	{
	    caps(); self.thedesc; " is already closed! ";
	}
    }
    doClose( actor ) =
    {
        "Closed. ";
	self.isopen := nil;
    }
    verIoPutIn( actor ) =
    {
        if ( not self.isopen )
	{
	    caps(); self.thedesc; " is closed. ";
	}
    }
    verDoLookin( actor ) =
    {
        if ( not self.isopen ) "It's closed. ";
    }
;

/*
@qcontainer: container
A ``quiet'' container:  its contents are not listed when it shows
up in a room description or inventory list.  The \tt isqcontainer\
property is set to \tt true\.
*/
class qcontainer: container
    isqcontainer = true
;

/*
@lockable: openable
A container that can be locked and unlocked.  The \tt islocked\
property specifies whether the object can be opened or not.  The
object can be locked and unlocked without the need for any other
object; if you want a key to be involved, use a \tt keyedLockable\.
*/
class lockable: openable
    doOpen( actor ) =
    {
        if ( self.islocked )
        {
            "It's locked. ";
        }
        else pass doOpen;
    }
    verDoLock( actor ) =
    {
        if ( self.islocked )
        {
            "It's already locked! ";
        }
    }
    doLock( actor ) =
    {
        if ( self.isopen )
        {
            "%You%'ll have to close "; self.thedesc; " first. ";
        }
        else
        {
            "Locked. ";
            self.islocked := true;
        }
    }
    verDoUnlock( actor ) =
    {
        if ( not self.islocked ) "It's not locked! ";
    }
    doUnlock( actor ) =
    {
        "Unlocked. ";
        self.islocked := nil;
    }
    verDoLockWith( actor, io ) =
    {
        if ( self.islocked ) "It's already locked. ";
    }
    verDoUnlockWith( actor, io ) =
    {
        if ( not self.islocked ) "It's not locked! ";
    }
;

/*
@keyedLockable: lockable
This subclass of \tt lockable\ allows you to create an object
that can only be locked and unlocked with a corresponding key.
Set the property \tt mykey\ to the \tt keyItem\ object that can
lock and unlock the object.
*/
class keyedLockable: lockable
    mykey = nil     // set 'mykey' to the key which locks/unlocks me
    doLock( actor ) =
    {
        askio( withPrep );
    }
    doUnlock( actor ) =
    {
        askio( withPrep );
    }
    doLockWith( actor, io ) =
    {
        if ( self.isopen )
        {
            "%You% can't lock << self.thedesc >> when it's open. ";
        }
        else if ( io = self.mykey )
        {
            "Locked. ";
            self.islocked := true;
        }
        else "It doesn't fit the lock. ";
    }
    doUnlockWith( actor, io ) =
    {
        if ( io = self.mykey )
        {
            "Unlocked. ";
            self.islocked := nil;
        }
        else "It doesn't fit the lock. ";
    }
;

/*
@keyItem: item
This is an object that can be used as a key for a \tt keyedLockable\
or \tt lockableDoorway\ object.  It otherwise behaves as an ordinary item.
*/
class keyItem: item
    verIoUnlockWith( actor ) = {}
    ioUnlockWith( actor, dobj ) =
    {
        dobj.doUnlockWith( actor, self );
    }
    verIoLockWith( actor ) = {}
    ioLockWith( actor, dobj ) =
    {
        dobj.doLockWith( actor, self );
    }
;

/*
@transparentItem: item
An object whose contents are visible, even when the object is
closed.  Whether the contents are reachable is decided in the
normal fashion.  This class is useful for items such as glass
bottles, whose contents can be seen when the bottle is closed
but cannot be reached.
*/
class transparentItem: item
    contentsVisible = { return( true ); }
    verGrab( obj ) =
    {
        if ( self.isopenable and not self.isopen )
            "%You% will have to open << self.thedesc >> first. ";
    }
    doOpen( actor ) =
    {
        self.isopen := true;
        "Opened. ";
    }
;

/*
@basicNumObj: object
This object provides a default implementation for \tt numObj\.
To use this default unchanged in your game, include in your
game this line:  ``\tt numObj: basicNumObj\''.
*/
class basicNumObj: object   // when a number is used in a player command,
    value = 0               //  this is set to its value
    sdesc = "that"
    adesc = "that"
    thedesc = "that"
    verDoTypeOn( actor, io ) = {}
    doTypeOn( actor, io ) = { "\"Tap, tap, tap, tap...\" "; }
    verIoTurnTo( actor ) = {}
    ioTurnTo( actor, dobj ) = { dobj.doTurnTo( actor, self ); }
;

/*
@basicStrObj: object
This object provides a default implementation for \tt strObj\.
To use this default unchanged in your game, include in your
game this line:  ``\tt strObj: basicStrObj\''.
*/
class basicStrObj: object   // when a string is used in a player command,
    value = ''              //  this is set to its value
    sdesc = "that"
    adesc = "that"
    thedesc = "that"
    verDoTypeOn( actor, io ) = {}
    doTypeOn( actor, io ) = { "\"Tap, tap, tap, tap...\" "; }
    verDoSave( actor ) = {}
    doSave( actor ) =
    {
        if (save( self.value ))
            "Save failed. ";
        else
            "Saved. ";
	abort;
    }
    verDoRestore( actor ) = {}
    doRestore( actor ) =
    {
        if (restore( self.value ))
            "Restore failed. ";
        else
	{
            "Restored. ";
	    setscore( global.score, global.turnsofar );
	}
        abort;
    }
    verDoScript( actor ) = {}
    doScript( actor ) =
    {
        logging( self.value );
        "Writing script file. ";
        abort;
    }
    verDoSay( actor ) = {}
    doSay( actor ) =
    {
	    // DMB added ZOT code, etc.
	    if (upper(strObj.value) = 'XYZZY') {
		    xyzzyVerb.action(actor);
	    }
    	    else if (upper(strObj.value) = 'PLUGH') {
		    plughVerb.action(actor);
	    }
	    else if (upper(strObj.value) = 'PLOVER') {
		    ploverVerb.action(actor);
	    }
   	    else if (upper(strObj.value) = 'Y2') {
		    y2Verb.action(actor);
	    }
   	    else if (upper(strObj.value) = 'FEE') {
		    feeVerb.action(actor);
	    }
   	    else if (upper(strObj.value) = 'FIE') {
		    fieVerb.action(actor);
	    }
   	    else if (upper(strObj.value) = 'FOE') {
		    foeVerb.action(actor);
	    }
   	    else if (upper(strObj.value) = 'FOO') {
		    fooVerb.action(actor);
	    }
   	    else if (upper(strObj.value) = 'FUM') {
		    fumVerb.action(actor);
	    }
	    else if (upper(strObj.value) = 'FEE FIE FOE FOO') {
		    "Try saying the words one at a time.";
	    }
	    else if (upper(strObj.value) = 'FEE FIE FOE FUM') {
		    "Try saying the words one at a time.";
	    }
	    else {
		    "That doesn't seem very productive.";
	    }
    }
;

/*
@deepverb: object
A ``verb object'' that is referenced by the parser when the player
uses an associated vocabulary word.  A \tt deepverb\ contains both
the vocabulary of the verb and a description of available syntax.
The \tt verb\ property lists the vocabulary words known as verbs;
one word (such as \tt 'take'\) or a pair (such as \tt 'pick up'\)
can be used.  In the latter case, the second word must be a
preposition, and may move to the end of the sentence in a player's
command, as in ``pick it up.''  The \tt action( \it actor\ )\
method specifies what happens when the verb is used without any
objects; its absence specifies that the verb cannot be used without
an object.  The \tt doAction\ specifies the root of the message
names (in single quotes) sent to the direct object when the verb
is used with a direct object; its absence means that a single object
is not allowed.  Likewise, the \tt ioAction( \it preposition\ )\
specifies the root of the message name sent to the direct and
indirect objects when the verb is used with both a direct and
indirect object; its absence means that this syntax is illegal.
Several \tt ioAction\ properties may be present:  one for each
preposition that can be used with an indirect object with the verb.

The \tt validDo( \it actor, object, seqno\ )\ method returns \tt true\
if the indicated object is valid as a direct object for this actor.
The \tt validIo( \it actor, object, seqno\ )\ method does likewise
for indirect objects.  The \it seqno\ parameter is a ``sequence
number,'' starting with 1 for the first object tried for a given
verb, 2 for the second, and so forth; this parameter is normally
ignored, but can be used for some special purposes.  For example,
\tt askVerb\ does not distinguish between objects matching vocabulary
words, and therefore accepts only the first from a set of ambiguous
objects.  These methods do not normally need to be changed; by
default, they return \tt true\ if the object is accessible to the
actor.

The \tt doDefault( \it actor, prep, indirectObject\ )\ and
\tt ioDefault( \it actor, prep\ )\ methods return a list of the
default direct and indirect objects, respectively.  These lists
are used for determining which objects are meant by ``all'' and which
should be used when the player command is missing an object.  These
normally return a list of all objects that are applicable to the
current command.
*/
class deepverb: object                // A deep-structure verb.
    validDo( actor, obj, seqno ) =
    {
    	return( obj.isReachable( actor ));
    }
    invalidObj( actor, obj, name ) =
    {
        if ( not obj.isVisible( actor ))
            "I don't see any << name >> here. ";
        else
            "%You% can't do that with << obj.thedesc >>. ";
    }
    validIo( actor, obj, seqno ) =
    {
    	return( obj.isReachable( actor ));
    }
    doDefault( actor, prep, io ) =
    {
	/* DMB */
	//return( actor.contents + actor.location.contents );
	return nil;
    }
    ioDefault( actor, prep ) =
    {
    	/* DMB */
	//return( actor.contents + actor.location.contents );
	return nil;
    }
;

/*
 *   Various verbs.
 */
inspectVerb: deepverb
    verb = 'inspect' 'examine' 'look at' 'x' /* DMB: */ 'search' 'ex'
    sdesc = "inspect"
    doAction = 'Inspect'
    validDo( actor, obj, seqno ) =
    {
        return( obj.isVisible( actor ));
    }
;
askVerb: deepverb
    verb = 'ask'
    sdesc = "ask"
    prepDefault = aboutPrep
    ioAction( aboutPrep ) = 'AskAbout'
    validIo( actor, obj, seqno ) = { return( seqno = 1 ); }
;
tellVerb: deepverb
    verb = 'tell'
    sdesc = "tell"
    prepDefault = aboutPrep
    ioAction( aboutPrep ) = 'TellAbout'
    validIo( actor, obj, seqno ) = { return( seqno = 1 ); }
;
followVerb: deepverb
    sdesc = "follow"
    verb = 'follow'
    doAction = 'Follow'
;
/*
 * DMB -- now defined in ccr-verbs.t
digVerb: deepverb
    verb = 'dig' 'dig in'
    sdesc = "dig in"
    prepDefault = withPrep
    ioAction( withPrep ) = 'DigWith'
;
 */
/*
 * DMB -- now defined in ccr-verbs.t
 *
jumpVerb: deepverb
    verb = 'jump' 'jump over' 'jump off'
    doAction = 'Jump'
    action(actor) = { "Wheeee!"; }
;
*/
pushVerb: deepverb
    verb = 'push' 'press'
    sdesc = "push"
    doAction = 'Push'
;
attachVerb: deepverb
    verb = 'attach' 'connect'
    sdesc = "attach"
    prepDefault = toPrep
    ioAction( toPrep ) = 'AttachTo'
;
wearVerb: deepverb
    verb = 'wear' 'put on'
    sdesc = "wear"
    doAction = 'Wear'
;
dropVerb: deepverb
    verb = 'drop' 'put down' 'free' 'release'	// DMB: added last two
    sdesc = "drop"
    ioAction( onPrep ) = 'PutOn'
    doAction = 'Drop'
    doDefault( actor, prep, io ) =
    {
        return( actor.contents );
    }
;
removeVerb: deepverb
    verb = 'take off'
    sdesc = "take off"
    doAction = 'Unwear'
    ioAction( fromPrep ) = 'RemoveFrom'
;
openVerb: deepverb
    verb = 'open' 'pry'		// DMB added pry for "pry clam with trident"
    sdesc = "open"
    doAction = 'Open'
    ioAction(withPrep) = 'OpenWith'
;
closeVerb: deepverb
    verb = 'close'
    sdesc = "close"
    doAction = 'Close'
;
putVerb: deepverb
    verb = 'put' 'place' 'insert'	// DMB: added 'insert'
    sdesc = "put"
    prepDefault = inPrep
    ioAction( inPrep ) = 'PutIn'
    ioAction( onPrep ) = 'PutOn'
    doDefault( actor, prep, io ) =
    {
        return( takeVerb.doDefault( actor, prep, io ) + actor.contents );
    }
;
takeVerb: deepverb                   // This object defines how to take things
    verb = 'take' 'pick up' 'get' 'remove'
    sdesc = "take"
    ioAction( offPrep ) = 'TakeOff'
    ioAction( outPrep ) = 'TakeOut'
    ioAction( fromPrep ) = 'TakeOut'
    ioAction( inPrep ) = 'TakeOut'
    ioAction( onPrep ) = 'TakeOff'
    doAction = 'Take'
    doDefault( actor, prep, io ) =
    {
        local ret, rem, cur, rem2, cur2, tot, i, tot2, j;
	
	ret := [];
        
	/*
	 *   For "take all out/off of <iobj>", return the (non-fixed)
	 *   contents of the indirect object.  Same goes for "take all in
	 *   <iobj>", "take all on <iobj>", and "take all from <iobj>".
	 */
	if (( prep=outPrep or prep=offPrep or prep=inPrep or prep=onPrep
	 or prep=fromPrep ) and io<>nil )
	{
	    rem := io.contents;
	    i := 1;
	    tot := length( rem );
	    while ( i <= tot )
	    {
	        cur := rem[i];
	        if ( not cur.isfixed ) ret := ret + cur;
		i := i + 1;
	    }
            return( ret );
	}

        /*
	 *   In the general case, return everything that's not fixed
	 *   in the actor's location, or everything inside fixed containers
	 *   that isn't itself fixed.
	 */
        rem := actor.location.contents;
	tot := length( rem );
	i := 1;
        while ( i <= tot )
        {
	    cur := rem[i];
            if ( cur.isfixed )
            {
                if ((( cur.isopenable and cur.isopen ) or
                  ( not cur.isopenable )) and ( not cur.isactor ))
                {
                    rem2 := cur.contents;
		    tot2 := length( rem2 );
		    j := 1;
                    while ( j <= tot2 )
                    {
		        cur2 := rem2[j];
                        if ( not cur2.isfixed and not cur2.notakeall )
			{
			    ret := ret + cur2;
			}
                        j := j + 1;
                    }
                }
            }
            else if ( not cur.notakeall )
	    {
	        ret := ret + cur;
	    }

	    i := i + 1;            
        }
        return( ret );
    }
;
plugVerb: deepverb
    verb = 'plug'
    sdesc = "plug"
    prepDefault = inPrep
    ioAction( inPrep ) = 'PlugIn'
;
lookInVerb: deepverb
    verb = 'look in' 'look on'
    sdesc = "look in"
    doAction = 'Lookin'
;
screwVerb: deepverb
    verb = 'screw'
    sdesc = "screw"
    ioAction( withPrep ) = 'ScrewWith'
    doAction = 'Screw'
;
unscrewVerb: deepverb
    verb = 'unscrew'
    sdesc = "unscrew"
    ioAction( withPrep ) = 'UnscrewWith'
    doAction = 'Unscrew'
;
turnVerb: deepverb
    verb = 'turn' 'rotate' 'twist'
    sdesc = "turn"
    ioAction( toPrep ) = 'TurnTo'
    ioAction( withPrep ) = 'TurnWith'
    doAction = 'Turn'
;
switchVerb: deepverb
    verb = 'switch'
    sdesc = "switch"
    doAction = 'Switch'
;
flipVerb: deepverb
    verb = 'flip'
    sdesc = "flip"
    doAction = 'Flip'
;
turnOnVerb: deepverb
    verb = 'activate' 'turn on' 'switch on'
    sdesc = "turn on"
    doAction = 'Turnon'
;
turnOffVerb: deepverb
    verb = 'turn off' 'deactivate' 'switch off'	// DMB: deavtiv + ate
    sdesc = "turn off"
    doAction = 'Turnoff'
;
lookVerb: deepverb
    verb = 'look' 'l' 'look around'
    action( actor ) =
    {
        actor.location.lookAround( true );
    }
;
sitVerb: deepverb
    verb = 'sit on' 'sit in' 'sit' 'sit down' 'sit downin' 'sit downon'
    sdesc = "sit on"
    doAction = 'Siton'
;
lieVerb: deepverb
    verb = 'lie' 'lie on' 'lie in' 'lie down' 'lie downon' 'lie downin'
    sdesc = "lie on"
    doAction = 'Lieon'
;
getOutVerb: deepverb
    verb = 'get out' 'get outof' 'get off' 'get offof'
    sdesc = "get out of"
    doAction = 'Unboard'
    doDefault( actor, prep, io ) =
    {
        if ( actor.location and actor.location.location )
            return( [] + actor.location );
        else return( [] );
    }
;
boardVerb: deepverb
    verb = 'get in' 'get into' 'board' 'get on'
    sdesc = "get on"
    doAction = 'Board'
;
againVerb: deepverb         // Required verb:  repeats last command.  No
                            // action routines are necessary; this one's
                            // handled internally by the parser.
    verb = 'again' 'g'
;
waitVerb: deepverb
    verb = 'wait' 'z'
    action( actor ) =
    {
        "Time passes...\n";
    }
;
iVerb: deepverb
    verb = 'inventory' 'i'
    action( actor ) =
    {
        if (length( actor.contents ))
        {
            "%You% %have% "; listcont( actor ); ". ";
	    // DMB added the check for any contents
	    if (listcontcont(actor, nil)) {
		    P();
		    listcontcont(actor, true);	// DMB added second param
	    }
        }
	else
            "%You% %are% empty-handed.\n";
    }
;
lookThruVerb: deepverb
    verb = 'look through' 'look thru'
    sdesc = "look through"
    doAction = 'Lookthru'
;
attackVerb: deepverb
    verb = 'attack' 'kill' 'hit'
    sdesc = "attack"
    doAction = 'Attack'	// DMB
    prepDefault = withPrep
    ioAction( withPrep ) = 'AttackWith'
;
eatVerb: deepverb
    verb = 'eat' 'consume'
    sdesc = "eat"
    doAction = 'Eat'
;
drinkVerb: deepverb
    verb = 'drink' 'drink from'	// DMB: added 'drink from'
    sdesc = "drink"
    doAction = 'Drink'
;
giveVerb: deepverb
    verb = 'give' 'offer'
    sdesc = "give"
    prepDefault = toPrep
    ioAction( toPrep ) = 'GiveTo'
;
pullVerb: deepverb
    verb = 'pull'
    sdesc = "pull"
    doAction = 'Pull'
;
readVerb: deepverb
    verb = 'read'
    sdesc = "read"
    doAction = 'Read'
;
throwVerb: deepverb
    verb = 'throw' 'toss'
    sdesc = "throw"
    prepDefault = atPrep
    ioAction( atPrep ) = 'ThrowAt'
    ioAction( toPrep ) = 'ThrowTo'
;
standOnVerb: deepverb
    verb = 'stand on'
    sdesc = "stand on"
    doAction = 'Standon'
;
standVerb: deepverb
    verb = 'stand' 'stand up' 'get up'
    sdesc = "stand"
    action( actor ) =
    {
        if ( actor.location=nil or actor.location.location = nil )
            "%You're% already standing! ";
        else
        {
	    actor.location.doUnboard( actor );
        }
    }
;
helloVerb: deepverb
    verb = 'hello' 'hi' 'greetings'
    action( actor ) =
    {
        "Nice weather we've been having.\n";
    }
;
showVerb: deepverb
    verb = 'show'
    sdesc = "show"
    prepDefault = toPrep
    ioAction( toPrep ) = 'ShowTo'
;
cleanVerb: deepverb
    verb = 'clean'
    sdesc = "clean"
    ioAction( withPrep ) = 'CleanWith'
    doAction = 'Clean'
;
sayVerb: deepverb
    verb = 'say'
    sdesc = "say"
    doAction = 'Say'
;
yellVerb: deepverb
    verb = 'yell' 'shout' 'yell at' 'shout at'
    action( actor ) =
    {
        "%Your% throat is a bit sore now. ";
    }
;
moveVerb: deepverb
    verb = 'move'
    sdesc = "move"
    ioAction( withPrep ) = 'MoveWith'
    ioAction( toPrep ) = 'MoveTo'
    doAction = 'Move'
;
fastenVerb: deepverb
    verb = 'fasten' 'buckle' 'buckle up'
    sdesc = "fasten"
    doAction = 'Fasten'
;
unfastenVerb: deepverb
    verb = 'unfasten' 'unbuckle'
    sdesc = "unfasten"
    doAction = 'Unfasten'
;
unplugVerb: deepverb
    verb = 'unplug'
    sdesc = "unplug"
    ioAction( fromPrep ) = 'UnplugFrom'
    doAction = 'Unplug'
;
lookUnderVerb: deepverb
    verb = 'look under' 'look beneath'
    sdesc = "look under"
    doAction = 'Lookunder'
;
lookBehindVerb: deepverb
    verb = 'look behind'
    sdesc = "look behind"
    doAction = 'Lookbehind'
;
typeVerb: deepverb
    verb = 'type'
    sdesc = "type"
    prepDefault = onPrep
    ioAction( onPrep ) = 'TypeOn'
;
lockVerb: deepverb
    verb = 'lock'
    sdesc = "lock"
    ioAction( withPrep ) = 'LockWith'
    doAction = 'Lock'
    prepDefault = withPrep
;
unlockVerb: deepverb
    verb = 'unlock'
    sdesc = "unlock"
    ioAction( withPrep ) = 'UnlockWith'
    doAction = 'Unlock'
    prepDefault = withPrep
;
detachVerb: deepverb
    verb = 'detach' 'disconnect'
    prepDefault = fromPrep
    ioAction( fromPrep ) = 'DetachFrom'
    doAction = 'Detach'
    sdesc = "detach"
;
/*
 * DMB
 */
sleepVerb: deepverb
	action(actor) = {
    		"This is no time for loafing!";
	}
	
	verb = 'sleep' 'rest' 'loaf' 'nap' 'relax'
;
pokeVerb: deepverb
    verb = 'poke' 'jab'
    sdesc = "poke"
    doAction = 'Poke'
;
touchVerb: deepverb
    verb = 'touch'
    sdesc = "touch"
    doAction = 'Touch'
;
moveNVerb: deepverb
    verb = 'move north' 'move n' 'push north' 'push n'
    sdesc = "move north"
    doAction = 'MoveN'
;
moveSVerb: deepverb
    verb = 'move south' 'move s' 'push south' 'push s'
    sdesc = "move south"
    doAction = 'MoveS'
;
moveEVerb: deepverb
    verb = 'move east' 'move e' 'push east' 'push e'
    sdesc = "move east"
    doAction = 'MoveE'
;
moveWVerb: deepverb
    verb = 'move west' 'move w' 'push west' 'push w'
    sdesc = "move west"
    doAction = 'MoveW'
;
moveNEVerb: deepverb
    verb = 'move northeast' 'move ne' 'push northeast' 'push ne'
    sdesc = "move northeast"
    doAction = 'MoveNE'
;
moveNWVerb: deepverb
    verb = 'move northwest' 'move nw' 'push northwest' 'push nw'
    sdesc = "move northwest"
    doAction = 'MoveNW'
;
moveSEVerb: deepverb
    verb = 'move southeast' 'move se' 'push southeast' 'push se'
    sdesc = "move southeast"
    doAction = 'MoveSE'
;
moveSWVerb: deepverb
    verb = 'move southwest' 'move sw' 'push southwest' 'push sw'
    sdesc = "move southwest"
    doAction = 'MoveSW'
;
centerVerb: deepverb
    verb = 'center'
    sdesc = "center"
    doAction = 'Center'
;
/*
 * DMB search is synonymous with inspect.
 */
/*
searchVerb: deepverb
    verb = 'search'
    sdesc = "search"
    doAction = 'Search'
;
*/
/*
 *   Travel verbs  - these verbs allow the player to move about.
 *   All travel verbs have the property isTravelVerb set true.
 */
class travelVerb: deepverb
    isTravelVerb = true
;
climbVerb: deepverb, travelVerb	// DMB: made this into a travelVerb
    verb = 'climb'
    travelDir( actor ) = { return(actor.location.climb); }

    sdesc = "climb"
    action( actor ) = { actor.travelTo(self.travelDir(actor)); }
    doAction = 'Climb'
;
eVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 'e' 'east' 'go east'
    travelDir( actor ) = { return( actor.location.east ); }
;
sVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 's' 'south' 'go south'
    travelDir( actor ) = { return( actor.location.south ); }
;
nVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 'n' 'north' 'go north'
    travelDir( actor ) = { return( actor.location.north ); }
;
wVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 'w' 'west' 'go west'
    travelDir( actor ) = { return( actor.location.west ); }
;
neVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 'ne' 'northeast' 'go ne' 'go northeast'
    travelDir( actor ) = { return( actor.location.ne ); }
;
nwVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 'nw' 'northwest' 'go nw' 'go northwest'
    travelDir( actor ) = { return( actor.location.nw ); }
;
seVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 'se' 'southeast' 'go se' 'go southeast'
    travelDir( actor ) = { return( actor.location.se ); }
;
swVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 'sw' 'southwest' 'go sw' 'go southwest'
    travelDir( actor ) = { return( actor.location.sw ); }
;
inVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 'in' 'go in' 'enter'
    sdesc = "enter"
    doAction = 'Enter'
    travelDir( actor ) = { return( actor.location.in ); }
;
outVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 'out' 'go out' 'exit' 'leave'
    travelDir( actor ) = { return( actor.location.out ); }
;
dVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 'd' 'down' 'go down'
    travelDir( actor ) = { return( actor.location.down ); }
;
uVerb: travelVerb
    action( actor ) = { actor.travelTo( self.travelDir( actor )); }
    verb = 'u' 'up' 'go up'
    travelDir( actor ) = { return( actor.location.up ); }
;

/*
 *   sysverb:  A system verb.  Verbs of this class are special verbs that
 *   can be executed without certain normal validations.  For example,
 *   a system verb can be executed in a dark room.  System verbs are
 *   for operations such as saving, restoring, and quitting, which are
 *   not really part of the game.
 */
class sysverb: deepverb
    issysverb = true
;
quitVerb: sysverb
    verb = 'quit'
    action( actor ) =
    {
        local yesno;

	/* XXX */
        "\bDo you really want to quit? (YES or NO) > ";
        yesno := yorn();
        "\b";
        if ( yesno = 1 )
        {
	    silent_incscore(global.quitpoints); // points for quitting (neg.)
	    scoreRank();	// DMB: moved here from XXX
            terminate();    // allow user good-bye message
	    quit();
        }
        else
        {
            "Okay. ";
        }
	abort;
    }
;
verboseVerb: sysverb
    verb = 'verbose'
    action( actor ) =
    {
        "Okay, now in VERBOSE mode.\n";
        global.verbose := true;
	Me.location.lookAround( true );
	abort;
    }
;
terseVerb: sysverb
    verb = 'brief' 'terse'
    action( actor ) =
    {
        "Okay, now in TERSE mode.\n";
        global.verbose := nil;
	abort;
    }
;
scoreVerb: sysverb
    verb = 'score' 'status'
    action( actor ) =
    {
        scoreRank();
	abort;
    }
;
saveVerb: sysverb
    verb = 'save'
    sdesc = "save"
    doAction = 'Save'
    action( actor ) =
    {
        local savefile;
	
	savefile := askfile( 'File to save game in' );
	if ( savefile = nil or savefile = '' )
	    "Failed. ";
	else if (save( savefile ))
	    "Saved failed. ";
	else
	    "Saved. ";
	abort;
    }
;
restoreVerb: sysverb
    verb = 'restore'
    sdesc = "restore"
    doAction = 'Restore'
    action( actor ) =
    {
        local savefile;
	
	savefile := askfile( 'File to restore game from' );
	if ( savefile = nil or savefile = '' )
	    "Failed. ";
	else if (restore( savefile ))
	    "Restore failed. ";
	else
	{
	    setscore( global.score, global.turnsofar );
	    "Restored. ";
	}
	abort;
    }
;
scriptVerb: sysverb
    verb = 'script'
    doAction = 'Script'
    action( actor ) =
    {
        local scriptfile;
	
	scriptfile := askfile( 'File to write transcript to' );
	if ( scriptfile = nil or scriptfile = '' )
	    "Failed. ";
	else
	{
	    logging( scriptfile );
	    "Writing script file. ";
	}
	abort;
    }
;
unscriptVerb: sysverb
    verb = 'unscript'
    action( actor ) =
    {
        logging( nil );
        "Script closed.\n";
        abort;
    }
;
restartVerb: sysverb
    verb = 'restart'
    action( actor ) =
    {
        local yesno;
        while ( true )
        {
            "Are you sure you want to start over? (YES or NO) > ";
            yesno := yorn();
            if ( yesno = 1 )
            {
                "\n";
		setscore( 0, 0 );
                restart();
                abort;
            }
            else if ( yesno = 0 )
            {
                "\nOkay.\n";
                abort;
            }
        }
    }
;
versionVerb: sysverb
    verb = 'version'
    action( actor ) =
    {
        version.sdesc;
        abort;
    }
;
debugVerb: sysverb
    verb = 'debug'
    action( actor ) =
    {
	if (debugTrace())
	    "You can't think this game has any bugs left in it... ";
	abort;
    }
;

undoVerb: sysverb
    verb = 'undo'
    action(actor) =
    {
	/* do TWO undo's - one for this 'undo', one for previous command */
	if (undo() and undo())
	{
	    "(Undoing one command)\b";
	    Me.location.lookAround(true);
	    setscore(global.score, global.turnsofar);
	}
	else
	    "No more undo information is available. ";

	abort;
    }
;

/*
@Prep: object
A preposition.  The \tt preposition\ property specifies the
vocabulary word.
*/
class Prep: object
;

/*
 *   Various prepositions
 */
aboutPrep: Prep
    preposition = 'about'
    sdesc = "about"
;
withPrep: Prep
    preposition = 'with'
    sdesc = "with"
;
toPrep: Prep
    preposition = 'to'
    sdesc = "to"
;
onPrep: Prep
    preposition = 'on' 'onto' 'downon' 'upon'
    sdesc = "on"
;
inPrep: Prep
    preposition = 'in' 'into' 'downin'
    sdesc = "in"
;
offPrep: Prep
    preposition = 'off' 'offof'
    sdesc = "off"
;
outPrep: Prep
    preposition = 'out' 'outof'
    sdesc = "out"
;
fromPrep: Prep
    preposition = 'from'
    sdesc = "from"
;
betweenPrep: Prep
    preposition = 'between' 'inbetween'
    sdesc = "between"
;
overPrep: Prep
    preposition = 'over'
    sdesc = "over"
;
atPrep: Prep
    preposition = 'at'
    sdesc = "at"
;
aroundPrep: Prep
    preposition = 'around'
    sdesc = "around"
;
thruPrep: Prep
    preposition = 'through' 'thru'
    sdesc = "through"
;
dirPrep: Prep
    preposition = 'north' 'south' 'east' 'west' 'up' 'down' 'northeast' 'ne'
                  'northwest' 'nw' 'southeast' 'se' 'southwest' 'sw'
    sdesc = "north"         // Shouldn't ever need this, but just in case
;
underPrep: Prep
    preposition = 'under' 'beneath'
    sdesc = "under"
;
behindPrep: Prep
    preposition = 'behind'
    sdesc = "behind"
;

/*
 *   articles:  the "built-in" articles.  "The," "a," and "an" are
 *   defined.
 */
articles: object
    article = 'the' 'a' 'an'
;
