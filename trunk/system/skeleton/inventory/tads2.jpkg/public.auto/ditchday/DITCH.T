/*  Copyright (c) 1990, 1999 by Michael J. Roberts.  All Rights Reserved. */
/*
    Ditch Day Drifter
    Interactive Fiction by Michael J. Roberts.
    
    Developed with TADS: The Text Adventure Development System.
    
    This game is a sample TADS source file.  It demonstrates many of the
    features of TADS.  The TADS language is fully documented in the TADS
    Author's Manual, which is freely available in electronic format;
    you can probably get a copy of the Author's Manual from the same
    place you obtained this file.
    
    Please read LICENSE.DOC for information about using and copying this
    file, and about registering your copy of TADS.
*/

/*
 *   First, insert the file containing the standard adventure definitions.
 */
#include <adv.t>
#include <gameinfo.t>

/*
 *   Pre-declare some functions, so the compiler knows they are functions.
 *   (This is only really necessary when a function will be referenced
 *   as a daemon or fuse before it is defined; however, it doesn't hurt
 *   anything to pre-declare all of them.)
 */
die: function;
scoreRank: function;
init: function;
terminate: function;
pardon: function;
sleepDaemon: function;
eatDaemon: function;
darkTravel: function;

getGameInfo: function
{
    return
        ['Name', 'Ditch Day Drifter',
        'Byline', 'by Michael J. Roberts',
        'Desc', 'You\'re an undergraduate at Caltech, and you wake up
                to find it\'s Ditch Day, the traditional event when
                seniors leave the campus for the day, leaving behind
                puzzles for the underclassmen to solve in order to
                break into the seniors\' rooms.  This is the original
                TADS sample game, but is also a fully fleshed-out
                traditional text adventure game.',
        'Version', version.vsnnum,
        'ReleaseDate', '1990-01-01',
        'LicenseType', 'Freeware',
        'CopyingRules', 'Nominal Cost Only'];
}

/* provide a preparse function, but don't bother doing anything */
preparse: function(cmd)
{
    return(true);
}

/* 
 *   Likewise, provide a parseErrorParam function that doesn't do
 *   anything.  This function could customize the messages that the parser
 *   generates when parser errors occur.  By returning nil, we simply let
 *   the parser use the default messages.  (We'd achieve the same effect
 *   by simply omitting this function entirely.)  
 */
parseErrorParam: function(num, str, ...)
{
    return nil;
}

/*
 *   Provide the default implementation of commandPrompt.  This has the
 *   same effect as leaving the function out altogether, but it avoids a
 *   compiler warning to have it defined. 
 */
commandPrompt: function(typ)
{
    "\b>";
}

/*
 *   The die() function is called when the player dies.  It tells the
 *   player how well he has done (with his score), and asks if he'd
 *   like to start over (the alternative being quitting the game).
 */
die: function
{
    "\b*** You have died ***\b";
    scoreRank();

    /*
     *   Check if the player (Me) purchased insurance.  If so, issue
     *   an appropriate message.
     */
    if ( Me.isinsured )
        "\bI'm sure that Lloyd is even now paying out a big lump sum for
        your early demise. However, that is of little use to you now. ";

    /*
     *   Tell the user the options available, and then ask for some
     *   input.  Keep asking until we get something we recognize.
     */
    "\bYou may restore a saved game, start over, undo the
        last move, or quit. ";
    while ( 1 )
    {
        local resp;

        "\nPlease enter RESTORE, RESTART, UNDO, or QUIT: >";
        resp := upper(input());     /* get input, convert to uppercase */
        if ( resp = 'RESTORE' )
        {
            resp := askfile( 'File to restore' );       /* find filename */
            if ( resp = nil ) "Restore failed. ";
            else if ( restore( resp )) "Restore failed. ";
            else
            {
                /*
                 *   We've successfully restored a game.  Reset the status
                 *   line's score/turn counter, and resume play.
                 */
                setscore( global.score, global.turnsofar );
                abort;
            }
        }
        else if ( resp = 'RESTART' )
        {
            /*
             *   We're going to start over.  Reset the status line's
             *   score/turn counter and start from the beginning.
             */
            setscore( 0, 0 );
            restart();
        }
        else if ( resp = 'UNDO' )
        {
            if (undo())
            {
                "(Undoing one command)\b";
                Me.location.lookAround(true);
                setscore(global.score, global.turnsofar);
                abort;
            }
            else
                "Sorry, no undo information is available.";
        }
        else if ( resp = 'QUIT' )
        {
            /*
             *   We're quitting the game.  Do any final activity necessary,
             *   and exit.
             */
            terminate();
            quit();
            abort;
        }
    }
}

/*
 *   The scoreRank() function displays how well the player is doing.
 *   In addition to displaying the numerical score and number of turns
 *   played so far, we'll classify the score with a rank such as "sophomore."
 *
 *   Note that "global.maxscore" defines the maximum number of points
 *   possible in the game.
 */
scoreRank: function
{
    local s;
    
    s := global.score;
    
    "In a total of "; say( global.turnsofar );
    " turns, you have achieved a score of ";
    say( s ); " points out of a possible "; say( global.maxscore );
    ", which gives you a rank of ";
    
    if ( s < 10 ) "high-school hopeful";
    else if ( s < 25 ) "freshman";
    else if ( s < 40 ) "sophomore";
    else if ( s < 60 ) "junior";
    else if ( s < global.maxscore ) "senior";
    else "graduate";
    
    ". ";
}

/*
 *   The init() function is run at the very beginning of the game.
 *   We display some introductory text, then move the player (Me) to the
 *   initial location and set up some background activity.
 */
init: function
{
    setscore(0, 0);                   // set up the initial status line display

    "\tYou wake up to the sound of voices in the hall. You are confused for
    a moment; it's only 8 AM, far too early for anyone to be getting up.
    Then, it dawns on you: it's ditch day here at the fictitious California
    Institute of Technology in the mythical city of Pasadena, California.
    \(Ditch Day\), that strange tradition wherein seniors bar their doors with
    various devices and underclassmen attempt to defeat these devices (for
    no other apparent reason than that the devices are there), has arrived.\b";
    
    version.sdesc;                // display the game's name and version number
    "\b";
    
    setdaemon( turncount, nil );               // start the turn counter daemon
    setdaemon( sleepDaemon, nil );                    // start the sleep daemon
    setdaemon( eatDaemon, nil );                     // start the hunger daemon
    Me.location := startroom;                // move player to initial location
    startroom.lookAround( true );                    // show player where he is
    startroom.isseen := true;
}

/*
 *   preinit() is called after compiling the game, before it is written
 *   to the binary game file.  It performs all the initialization that can
 *   be done statically before storing the game in the file, which speeds
 *   loading the game, since all this work has been done ahead of time.
 *
 *   This routine puts all lamp objects (those objects with islamp = true) into
 *   the list global.lamplist.  This list is consulted when determining whether
 *   a dark room contains any light sources.
 */
preinit: function
{
    local o;
    
    global.lamplist := [];
    o := firstobj(lightsource);
    while( o <> nil )
    {
        if ( o.islamp ) global.lamplist := global.lamplist + o;
        o := nextobj(o, lightsource);
    }
    initSearch();
    writeGameInfo(getGameInfo());
}

/*
 *   The terminate() function is called just before the game ends.  We
 *   just display a good-bye message.
 */
terminate: function
{
    "\bThanks for participating in \(Ditch Day!\)\n";
}

/*
 *   The pardon() function is called any time the player enters a blank
 *   line.
 */
pardon: function
{
    "I beg your pardon? ";
}

/*
 *   This function is a daemon, started by init(), that monitors how long
 *   it has been since the player slept.  It provides warnings for a while
 *   before the player gets completely exhausted, and causes the player
 *   to pass out and sleep when it has been too long.  The only penalty
 *   exacted if the player passes out is that he drops all his possessions.
 *   Some games might also wish to consider the effects of several hours
 *   having passed; for example, the time-without-food count might be
 *   increased accordingly.
 */
sleepDaemon: function( parm )
{
    local a, s;

    global.awakeTime := global.awakeTime + 1;
    a := global.awakeTime;
    s := global.sleepTime;

    if ( a = s or a = s+10 or a = s+20 )
        "\bYou're feeling a bit drowsy; you should find a
        comfortable place to sleep. ";
    else if ( a = s+25 or a = s+30 )
        "\bYou really should find someplace to sleep soon, or
        you'll probably pass out from exhaustion. ";
    else if ( a >= s+35 )
    {
      global.awakeTime := 0;
      if ( Me.location.isbed or Me.location.ischair )
      {
        "\bYou find yourself unable to stay awake any longer.
        Fortunately, you are ";
        if ( Me.location.isbed ) "on "; else "in ";
        Me.location.adesc; ", so you gently slip off into
        unconsciousness.
        \b* * * * *
        \bYou awake some time later, feeling refreshed. ";
      }
      else
      {
        local itemRem, thisItem;
        "\bYou find yourself unable to stay awake any longer.
        You pass out, falling to the ground.
        \b* * * * *
        \bYou awaken, feeling somewhat the worse for wear.
        You get up and dust yourself off. ";
        itemRem := Me.contents;
        while (car( itemRem ))
        {
            thisItem := car( itemRem );
            if ( not thisItem.isworn ) thisItem.moveInto( Me.location );
            itemRem := cdr( itemRem );
        }
      }
    }
}

/*
 *   This function is a daemon, set running by init(), which monitors how
 *   long it has been since the player has had anything to eat.  It will
 *   provide warnings for some time prior to the player's expiring from
 *   hunger, and will kill the player if he should go too long without
 *   heeding these warnings.
 */
eatDaemon: function( parm )
{
    local e, l;

    global.lastMealTime := global.lastMealTime + 1;
    e := global.eatTime;
    l := global.lastMealTime;

    if ( l = e or l = e+5 or l = e+10 )
        "\bYou're feeling a bit peckish. Perhaps it would be a good
        time to find something to eat. ";
    else if ( l = e+15 or l = e+20 or l = e+25 )
        "\bYou're feeling really hungry. You should find some food
        soon or you'll pass out from lack of nutrition. ";
    else if ( l=e+30 or l = e+35 )
        "\bYou really can't go much longer without food. ";
    else if ( l >= e+40 )
    {
        "\bYou simply can't go on any longer without food. You perish from
        lack of nutrition. ";
        die();
    }
}

/*
 *   The numObj object is used to convey a number to the game whenever
 *   the player uses a number in his command.  For example, "turn dial
 *   to 621" results in an indirect object of numObj, with its "value"
 *   property set to 621.  Just pick up the default definition from adv.t.
 */
numObj: basicNumObj
;

/*
 *   strObj works like numObj, but for strings.  So, a player command of
 *     type "hello" on the keyboard
 *   will result in a direct object of strObj, with its "value" property
 *   set to the string 'hello'.
 *
 *   Note that, because a string direct object is used in the save, restore,
 *   and script commands, this object must handle those commands.  We'll just
 *   pick up the default definition from adv.t.
 */
strObj: basicStrObj
;

/*
 *   The "global" object is the dumping ground for any data items that
 *   don't fit very well into any other objects.
 */
global: object
    turnsofar = 0                            // no turns have transpired so far
    score = 0                            // no points have been accumulated yet
    maxscore = 80                                     // maximum possible score
    verbose = nil                             // we are currently in TERSE mode
    awakeTime = 0               // time that has elapsed since the player slept
    sleepTime = 600     // interval between sleeping times (longest time awake)
    lastMealTime = 0              // time that has elapsed since the player ate
    eatTime = 250         // interval between meals (longest time without food)
    lamplist = []              // list of all known light providers in the game
;

/*
 *   The "version" object defines, via its "sdesc" property, the name and
 *   version number of the game.
 */
version: object
    sdesc = "\(Ditch Day Drifter\)
     \nInteractive Fiction by Michael J.\ Roberts
     \bRelease <<vsnnum>>
     \nCopyright (c) 1990, 2002 Michael J.\ Roberts. All Rights Reserved.
     \nDeveloped with TADS: The Text Adventure Development System. "

    vsnnum = '1.0'
;

/*
 *   "Me" is the player's actor.  Pick up the default definition, basicMe,
 *   from "adv.t".
 */
Me: basicMe
;

/*
 *   darkTravel() is called whenever the player attempts to move from a dark
 *   location into another dark location.  We don't do much of anything;
 *   some games might impose a probability of walking into the slavering
 *   jaws of a grue, whatever that might be.
 */
darkTravel: function
{
    "You stumble around in the dark, and don't get anywhere. ";
}

/*
 *   The player will start in the room called "startroom", by virtue
 *   of being placed there by the "init" function.
 *
 *   All rooms have an sdesc (short description), which is displayed on
 *   the status line and on entry to the room (even if the room has been
 *   seen before).  In addition, the ldesc (long description) is printed
 *   when the player enters the room for the first time or types "look."
 *   Directions (north, south, east, west, ne, nw, se, sw, in, out)
 *   specify where the exits go.  If a direction is not specified, no
 *   exit is in that direction.
 */
startroom: room
    sdesc = "Room 3"                                // short description
    ldesc = "This is your room. You live a fairly austere life, being a
     poor college student. The only notable features are the bed
     (unmade, of course) and a small wooden desk.  An exit is west. "
    west = alley1                                   // room that lies west
    out = alley1                                    // the exit
;

/*
 *   The desk is a surface, which means you can put stuff on top of it.
 *   Note that the drawer is a separate object.
 */
room3desk: surface, fixeditem
    sdesc = "small wooden desk"
    noun = 'desk'
    adjective = 'small' 'wooden' 'wood'
    location = startroom
    ldesc =
    {
        "It's the small desk that comes with all of the rooms in the house.
        The desktop is pitifully small, especially considering that you often
        need to have several physics texts and tables of integrals open
        simultaneously. The desk has a small drawer (";
        if ( room3drawer.isopen ) "open"; else "closed";
        "). ";
    }
    /*
     *   For convenience, redirect any open/close activity to the
     *   drawer.  Since the desk can't be opened and closed, we can
     *   reasonably expect that the player is really referring to the
     *   drawer if he tries to open or close the desk.
     */
    verDoOpen( actor ) = { room3drawer.verDoOpen( actor ); }
    doOpen( actor ) = { room3drawer.doOpen( actor ); }
    verDoClose( actor ) = { room3drawer.verDoClose( actor ); }
    doClose( actor ) = { room3drawer.doClose( actor ); }
;

/*
 *   A container can contain stuff.  An openable is a special type of container
 *   that can be opened and closed.  Though it's technically part of the desk,
 *   it's a fixeditem (==> it can't be taken), so we can just as well make it
 *   part of startroom; note that this is in fact necessary, since if it were
 *   located in the desk, it would appear to be ON the desk (since the desk is
 *   a surface).
 */
room3drawer: openable, fixeditem
    isopen = nil
    sdesc = "drawer"
    noun = 'drawer'
    location = startroom
;

/*
 *   A qcontainer is a "quiet container."  It acts like a container in all
 *   ways, except that its contents aren't displayed in a room's message.
 *   We want the player to have to think to examine the wastebasket more
 *   carefully to find out what's in it, so we'll make it a qcontainer.
 *   Which is fairly natural:  when looking around a room, you don't usually
 *   notice what's in a waste basket, even though you may notice the waste
 *   basket itself.
 *
 *   The sdesc is just the name of the object, as displayed by the game
 *   (as in "You see a wastebasket here").  The noun and adjective lists
 *   specify how the user can refer to the object; only enough need be
 *   specified by the user to uniquely identify the object for the purpose
 *   of the command.  Hence, you can specify as many words as you want without
 *   adding any burden to the user---the more words the better.  The location
 *   specifies the object (a room in this case) where the object is
 *   to be found.
 */
wastebasket: qcontainer
    sdesc = "waste basket"
    noun = 'basket' 'wastebasket'
    adjective = 'waste'
    location = startroom
    moveInto( obj ) =
    {
        /*
         *   If this object is ever removed from its original location,
         *   turn off the "quiet" attribute.
         */
        self.isqcontainer := nil;
        pass moveInto;
    }
;

/*
 *   A beditem is something you can lie down on.
 */
bed: beditem
    noun = 'bed'
    location = startroom
    ldesc = "It's a perfectly ordinary bed. It's particularly ordinary
     (for around here, anyway) in that it hasn't been made in a very
     long time. "
    
    /*
     *   verDoLookunder is called when the player types "look under bed"
     *   to verify that this object can be used as a direct object (Do) for
     *   that verb (Lookunder).  If no message is printed, it means that
     *   it can be used.
     */
    verDoLookunder( actor ) = {}
    
    /*
     *   ...and then, if verification succeeded, doLookunder is called to
     *   actually apply the verb (Lookunder) to this direct object (do).
     */
    doLookunder( actor ) =
    {
        if ( dollar.isfound )       // already found the dollar?
            "You don't find anything of interest. ";
        else
        {
            dollar.isfound := true;
            "You find a dollar bill! You pocket the bill.
            (Okay, so it's an obvious adventure game puzzle, but I'm sure
            you would have been disappointed if nothing had been there.) ";
            dollar.moveInto( Me );
        }
    }
    
    /*
     *   Verification and action for the "Make" verb.
     */
    verDoMake( actor ) = {}
    doMake( actor ) =
    {
        "It was a nice thought, but you suddenly realize that you never
        learned how. ";
    }
;

/*
 *   We wish to add the verb "make."  We need to specify the sdesc (printed
 *   by the system under certain circumstances), the vocabulary word itself
 *   (as it will be entered by the user), and the suffix of the method that
 *   will be called in direct objects.  By specifying a doAction of 'Make',
 *   we are establishing that verDoMake and doMake messages will be sent to
 *   the direct object of the verb.
 */
makeVerb: deepverb
    sdesc = "make"
    verb = 'make'
    doAction = 'Make'
;

/*
 *   An "item" is the most basic class of objects that a user can carry
 *   around.  An item has no special properties.  The "iscrawlable"
 *   attribute that we're setting here is used in the north-south crawl
 *   in the steam tunnels (later in the game); setting it to "true"
 *   means that the player can carry this object through the crawl.
 */
dollar: item
    sdesc = "one dollar bill"
    noun = 'bill'
    adjective = 'dollar' 'one' '1'
    iscrawlable = true
;

room4: room
    sdesc = "Room 4"
    ldesc = "This is room 4, where the weird senior across the hall
     lives. An exit is to the east, and a strange passage leads down. "
    east = alley1
    out = alley1
    down =
    {
        /*
         *   This is a bit of code attached to a direction.  We can do
         *   anything we want in code like this, so long as we return a
         *   room (or nil) when we're done.  In this case, we just want
         *   to display a message when the player travels this way.
         */
        "The passage takes you down a winding stairway to a previously
        unseen entrance to...\b";
        return( shiproom );
    }
;

/*
 *   A readable is an object that can be read, such as a note, a sign, a
 *   book, or a memo.  By default, reading the object displays its ldesc.
 *   However, if a separate readdesc is specified, "look at note" and
 *   "read note" could display different messages.
 */
winNote: readable
    iscrawlable = true
    sdesc = "note"
    ldesc = "Congratulations! You've broken the stack! Please take this
     fine WarpMaster 2000(tm) warp motivator, with my compliments. I'll
     see you in \"Deep Space Drifter\"! "
    noun = 'note'
    location = room4
;

shiproom: room
    sdesc = "Spaceship Room"
    ldesc = "This is a very large cave dominated by a tall spaceship.
     High above, a vertical tunnel leads upward; it is evidently a launch
     tube for the spaceship. The exit is north. "
    north = chuteroom
    in = shipinterior
    up =
    {
        "The tunnel is far too high above to climb. ";
        return( nil );
    }
;

/*
 *   The receptacle is both a fixeditem (something that can't be taken and
 *   carried around) and a container, so both superclasses are specified.
 */
shiprecept: fixeditem, container
    sdesc = "socket"
    noun = 'socket'
    location = shiproom
    ioPutIn( actor, dobj ) =
    {
        /*
         *   We only want to allow the warp motivator to be put in here.
         *   Check any object going in and disallow it if it's anything else.
         */
        if ( dobj = motivator )
        {
            "It fits snugly. ";
            dobj.moveInto( self );
        }
        else "It doesn't fit. ";
    }
;

spaceship: fixeditem
    sdesc = "spaceship"
    noun = 'spaceship' 'ship'
    adjective = 'space'
    location = shiproom
    ldesc =
    {
        "The spaceship is a tall gray metal cylinder with a pointed nosecone
        high above, and three large fins at the bottom. A large socket ";
        if ( motivator.location = shiprecept )
            "on the side contains a warp motivator. ";
        else
            "is on the side (the socket is currently empty). The socket
            is labelled \"insert warp motivator here.\" ";
        "You can enter the spaceship through an open door. ";
    }
    verDoEnter( actor ) = {}
    doEnter( actor ) = { self.doBoard( actor ); }
    verDoBoard( actor ) = {}
    doBoard( actor ) =
    {
        actor.travelTo( shipinterior );
    }
;

shipinterior: room
    sdesc = "Spaceship"
    out = shiproom
    ldesc = "You are in the cockpit of the spaceship. The control panel is
     quite simple; the only feature that interests you at the moment is
     a button labelled \"Launch.\" "
;

/*
 *   This is a fake "ship" that the player can refer to while inside the
 *   spaceship.  This allows commands such as "look at ship" and "get out"
 *   to work properly while within the ship.
 */
shipship: fixeditem
    location = shipinterior
    sdesc = "spaceship"
    noun = 'ship' 'spaceship'
    adjective = 'space'
    ldesc = { shipinterior.ldesc; }
    verDoUnboard( actor ) = {}
    doUnboard( actor ) =
    {
        Me.travelTo( shipinterior.out );
    }
;

/*
 *   A buttonitem can be pushed.  It's automatically a fixeditem, and
 *   always defines the noun 'button'.  The doPush method specifies what
 *   happens when the button is pushed.
 */
launchbutton: buttonitem
    sdesc = "launch button"
    adjective = 'launch'
    location = shipinterior
    doPush( actor ) =
    {
        if ( motivator.location = shiprecept )
        {
            incscore( 10 );
            "The ship's engines start to come to life. \"Launch sequence
            engaged,\" the mechanical computer voice announces. ";
            if ( lloyd.location = Me.location )
                "\n\tLloyd heads for the door. \"Sorry,\" he says, \"I can't
                go with you. Your policy specifically excludes coverage
                during missions in deep space, and, frankly, it's too risky
                for my tastes. Besides, I don't appear in 'Deep Space
                Drifter.'\" Lloyd waves goodbye, and rolls out of the
                spaceship.\n\t";
            "The hatch closes automatically, sealing you into the
            space vessel. The engines become louder and louder.
            The computer voice announces, \"Launch
            in five... four... three... two... one... liftoff!\"
            The engines blast the ship into orbit.
            \n\tYou realize that the time has come to set course for
            \"Deep Space Drifter,\" another fine TADS adventure from
            High Energy Software.\b";
            
            scoreRank();
            terminate();
            quit();
            abort;
        }
        else
        {
            "The ship's computer voice announces from a hidden speaker,
            \"Error: no warp motivator installed.\" ";
        }
    }
;

motivator: treasure
    sdesc = "warp motivator"
    noun = 'motivator' 'warpmaster'
    takevalue = 20
    adjective = 'warp'
    location = room4
    ldesc = "It's a WarpMaster 2000(tm), the top-of-the-line model. "
;

foodthing: fooditem
    noun = 'food'
    sdesc = "food"
    adesc = "some food"
    ldesc = "It's a non-descript food item of the type the Food Service
     typically prepares. "
    location = room3drawer
;

/*
 *   An openable is a container, with the additional property that it can
 *   be opened and closed.  To simplify things, we don't have a separate
 *   cap; use of the cap is implied in the "open" and "close" commands.
 */
bottle: openable
    sdesc = "two-liter plastic bottle"
    noun = 'bottle'
    location = wastebasket
    adjective = 'two-liter' 'plastic' 'two' 'liter'
    isopen = nil
    ldesc =
    {
        "The bottle is ";
        if ( self.isfull ) "full of liquid nitrogen. ";
        else "empty. ";

        "It's "; if ( self.isopen ) "open. "; else "closed. ";
        
        if ( funnel.location = self )
            "There's a funnel in the bottle's mouth. ";
    }
    ioPutIn( actor, dobj ) =
    {
        if ( not self.isopen )
        {
            "It might help to open the bottle first. ";
        }
        else if ( dobj = ln2 )
        {
            if ( funnel.location = self )
            {
                "You manage to get some liquid nitrogen into the bottle. ";
                bottle.isfull := true;
            }
            else
            {
                "You can't manage to get any liquid nitrogen into the
                 tiny opening. ";
            }
        }
        else if ( dobj = funnel )
        {
            "A perfect fit! ";
            funnel.moveInto( self );
        }
        else "That won't fit in the bottle. ";
    }
    verIoPourIn( actor ) = {}
    ioPourIn( actor, dobj ) = { self.ioPutIn( actor, dobj ); }
    doClose( actor ) =
    {
        if ( funnel.location = self )
            "You'll have to take the funnel out first. ";
        else if ( self.isfull )
        {
            "It takes some effort to close the bottle, since the rapidly
            evaporating nitrogen occupies much more volume as a gas than
            as a liquid. However, you manage to close it. ";
            notify( self, #explodeWarning, 3 );
            self.isopen := nil;
        }
        else
        {
            "Okay, it's closed. ";
            self.isopen := nil;
        }
    }
    
    /*
     *   explodeWarning is sent to the bottle as a "notification," which is
     *   a message that's scheduled to occur some number of turns in the
     *   future.  In this case, closing the bottle while it has liquid
     *   nitrogen inside will set the explodeWarning notification.
     */
    explodeWarning =
    {
        if ( not self.isopen )
        {
            if ( self.isIn( Me.location ))
            {
                "\bThe bottle is starting to make lots of noise, as though
                the plastic were being stretched to its limit. ";
            }
            notify( self, #explode, 3 );
        }
    }
    
    /*
     *   explode is set as a notification by explodeWarning.  This routine
     *   actually causes the explosion.  Since the bottle explodes, we will
     *   remove it from the game (by moving it into "nil").  If the bottle
     *   is in the right place, we'll also do some useful things.
     */
    explode =
    {
        if ( not self.isopen )
        {
            "\b";
            if ( self.location = banksafe )
            {
                if ( Me.location = bankvault )
                {
                    "There is a terrible explosion from within the safe.
                     The door blasts open with a clang and a huge cloud of
                     water vapor. ";
                     
                    if ( lloyd.location = bankvault )
                        "\n\tLloyd throws himself between you and the
                        vault. \"Please be careful!\" he admonishes.
                        \"The payment for Accidental Death due to Explosion
                        is enormous!\" ";
                }
                else
                    "You hear a distant, muffled explosion. ";
                
                banksafe.isopen := true;
                banksafe.isblasted := true;
            }
            else if ( self.isIn( Me.location ))
            {
                "The bottle explodes with a deafening boom and a huge
                cloud of water vapor. As with most explosions, standing
                in such close proximity was not advisable; it was, in
                fact, fatal. ";
                die();
                abort;
            }
            else
            {
                "You hear a distant explosion. ";
            }
            
            self.moveInto( nil );
        }
    }
;

/*
 *   We're defining our own "class" of objects here.  Up to now, we've been
 *   using classes defined in "adv.t", which you will recall we included at
 *   the top of the file.  This class has some useful properties.  For one,
 *   it has an attribute (istreasure) that tells us that the object is
 *   indeed a treasure (used in the slot in room 4's door to ensure that
 *   an object can be put in the slot).  In addition, it supplements the
 *   doTake routine:  when a treasure is taken for the first time, we'll
 *   add the object's "takevalue" to the overall score.
 */
class treasure: item
    istreasure = true
    takevalue = 5       // default point value when object is taken
    putvalue = 5        // default point value when object is put in slot
    doTake( actor ) =
    {
        if ( not self.hasScored )       // have we scored yet?
        {
            incscore( self.takevalue ); // add our "takevalue" to the score
            self.hasScored := true;     // note that we have scored
        }
        pass doTake;        // continue with the normal doTake from "item"
    }
;

alley1: room
    sdesc = "Alley One"
    ldesc =
    {
        "You are in the eternal twilight of Alley One, one of the twisty
        little passages (all different) making up the student house in
        which you live. Your room (room 3) is to the east. To the west
        is a door (";
        if ( alley1door.isopen ) "open"; else "closed";
        "), affixed to which is a large sign. An exit is south, and the
        hallway continues north. ";
    }
    east = startroom
    north = alley1n
    west =
    {
        /*
         *   Sometimes, we'll want to run some code when the player walks
         *   in a particular direction rather than just go to a new room.
         *   This is how.  Returning "nil" means that the player can't go
         *   this way.
         */
        if ( alley1door.isopen )
        {
            return( room4 );
        }
        else
        {
            "The door is closed and locked. You might read the
            sign on the door for more information. ";
            return( nil );
        }
    }
    south = breezeway
    out = breezeway
;

alley1n: room
    sdesc = "Alley One"
    ldesc = "You are at the north end of alley 1.  A small room is
     to the west. "
    south = alley1
    west = alley1comp
;

alley1comp: room
    sdesc = "Computer Room"
    ldesc = 
    {
        "You are in a small computer room. Not surprisingly, the room
         contains a personal computer. The exit is east. ";
        if ( not self.isseen ) notify( compstudents, #converse, 0 );
    }
    east = alley1n
;

alley1pc: fixeditem
    sdesc = "personal computer"
    noun = 'computer'
    adjective = 'personal'
    location = alley1comp
    ldesc = "The computer is in use by a couple of your fellow undergraduates.
     Closer inspection of the screen shows that they seem to be playing a
     text adventure. You've never really understood the appeal of those games
     yourself, but you quickly surmise that the game is part of one of the
     seniors' stacks. "
    verIoTypeOn( actor ) = {}
    ioTypeOn( actor, dobj ) =
    {
        "The computer is already in use. Common courtesy demands that you
        wait your turn. ";
    }
    verDoTurnoff( actor ) = {}
    doTurnoff( actor ) =
    {
        "The students won't let you, since they're busy using the computer. ";
    }
;

compstudents: Actor
    location = alley1comp
    sdesc = "students"
    adesc = "a couple of students"
    ldesc = "The students are busy using the computer. "
    actorAction( v, d, p, i ) =
    {
        "They're too wrapped up in what they're doing. ";
        exit;
    }
    doAskAbout( actor, io ) =
    {
        "They're too busy to answer. ";
    }
    noun = 'students' 'undergraduates'
    actorDesc = "A couple of your fellow undergraduates are here, using
     the computer. They seem quite absorbed in what they're doing. "
    state = 0
    converse =
    {
        if ( Me.location = self.location )
        {
            "\b";
            if ( self.state = 0 )
                "\"Where are we going to find the dollar bill?\" one
                of the students asks the other. They sit back and stare
                at the screen, lost in thought. ";
            else if ( self.state = 1 )
                "\"Hey!\" says one of the students. \"Did you look under
                the bed?\" The other student shakes his head. \"No way,
                that would be a stupid puzzle!\" ";
            else if ( self.state = 2 )
                "One of the students using the computer types a long
                string of commands, and finally types \"look under bed.\"
                \"Wow! The dollar bill actually was under the bed! How
                lame!\" ";
            else
                "The students continue to play with the computer. ";
        
            self.state := self.state + 1;
        }
    }
;

class lockedDoor: fixeditem, keyedLockable
    isopen = nil
    islocked = true
    noun = 'door'
    sdesc = "door"
    ldesc =
    {
        if ( self.isopen ) "It's open. ";
        else if ( self.islocked ) "It's closed and locked. ";
        else "It's closed. ";
    }
    verIoPutIn( actor ) = { "You can't put anything in that! "; }
;

alley1door: lockedDoor
    location = alley1
    ldesc =
    {
        if ( self.isopen ) "It's open. ";
        else
            "The door is closed and locked. There is a slot in the door,
            and above that, a large sign is affixed to the door. ";
    }
;

alley1sign: fixeditem, readable
    noun = 'sign'
    sdesc = "sign"
    location = alley1
    ldesc = "The sign says:
     \b\t\tWelcome to Ditch Day!
     \bThis stack is a treasure hunt. Gather all of the treasures, and you
     break the stack.
     To satisfy the requirements of this stack, you must find the
     items listed below, and deposit them in the slot in the door. When
     all items have been put in the slot, the stack will be solved and
     the door will open automatically. The items to find are:
     \b\tThe Great Seal of the Omega
     \n\tMr.\ Happy Gear
     \n\tA Million Random Digits
     \n\tA DarbCard
     \bThese items are hidden amongst the expanses of the Great
     Undergraduate Excavation project. Happy hunting!
     \bFor first-time participants, please note that
     this is a \"finesse stack.\" You are not permitted to attempt to break
     the stack by brute force. Instead, you must follow the rules above. "
;

alley1slot: fixeditem, container
    noun = 'slot'
    sdesc = "slot"
    location = alley1
    itemcount = 0
    ioPutIn( actor, dobj ) =
    {
        if ( dobj.istreasure )
        {
            "\^<< dobj.thedesc >> disappears into the slot. ";
            dobj.moveInto( nil );
            incscore( dobj.putvalue );
            self.itemcount := self.itemcount + 1;
            if ( self.itemcount = 4 )
            {
                "As the treasure disappears into the slot, you hear a
                klaxon from the other side of the door. An elaborate
                series of clicks and clanks follows, then the door swings
                open. ";
                alley1door.islocked := nil;
                alley1door.isopen := true;
            }
        }
        else
        {
            "The slot will only accept items on the treasure list. ";
        }
    }
;

breezeway: room
    sdesc = "Breezeway"
    ldesc = "You are in a short passage that connects a courtyard,
     to the east, to the outside of the building, which lies to the
     west. A hallway leads north. "
    north = alley1
    east = courtyard
    west = orangeWalk1
;

courtyard: room
    sdesc = "Courtyard"
    ldesc = "You are in a large outdoor courtyard.
     An arched passage is to the west.
     A passage leads east, and a stairway leads down. "
    east = lounge
    down = hall1
    west = breezeway
;

lounge: room
    sdesc = "Lounge"
    ldesc = "You are in the lounge. A passage leads west, and a dining
     room lies to the north. "
    north = diningRoom
    west = courtyard
    out = courtyard
;

diningRoom: room
    sdesc = "Dining Room"
    ldesc = "You are in the dining room. There is a wooden table in
     the center of the room. The lounge lies to the south,
     and a passage to the east leads into the kitchen. "
    east = kitchen
    south = lounge
;

diningTable: surface, fixeditem
    sdesc = "wooden table"
    noun = 'table'
    adjective = 'wooden'
    location = diningRoom
;

fishfood: fooditem
    noun = 'module'
    adjective = 'fish' 'protein'
    sdesc = "fish protein module"
    ldesc = "It's a small pyramid-shaped white object, which is widely
     considered to consist primarily of fish protein. The food service
     typically resorts to such unappetizing fare toward the end of the
     year. "
    location = diningTable
;

kitchen: room
    sdesc = "Kitchen"
    ldesc = "You are in the kitchen.  A ToxiCola(tm) machine is here.
     A passage leads into the dining room to the west. "
    west = diningRoom
    out = diningRoom
;

toxicolaMachine: fixeditem, container
    noun = 'machine' 'compartment'
    adjective = 'toxicola'
    sdesc = "ToxiCola machine"
    ldesc =
    {
        "The machine dispenses ToxiCola, one of the big losers in the
         Cola Wars.  But, hey, it's cheap, so the food service installed it.
         The machine consists of a compartment large enough for a cup,
         and a button for dispensing ToxiCola into the cup. ";
         if ( cup.location = self )
            "The compartment contains a cup. ";
    }
    location = kitchen
    ioPutIn( actor, dobj ) =
    {
        if ( dobj <> cup )
            "That won't fit in the compartment. ";
        else pass ioPutIn;
    }
;

cup: container
    sdesc = "coffee cup"
    noun = 'cup'
    adjective = 'coffee'
    isFull = nil
    ldesc =
    {
        if ( self.isFull ) "It's full of a viscous brown fluid. ";
        else "It's empty. ";
    }
    location = diningTable
    ioPutIn( actor, dobj ) =
    {
        if ( dobj = ln2 ) "The liquid nitrogen evaporates on contact. ";
        else "It won't fit in the cup. ";
    }
;

toxicola: fixeditem
    sdesc = "toxicola"
    noun = 'toxicola' 'cola'
    ldesc = "It's a thick brown fluid. It appears to be quite flat. "
    doTake( actor ) =
    {
        "You'll have to leave it in the cup. ";
    }
    verDoDrink( actor ) = {}
    doDrink( actor ) =
    {
        "You drink the ToxiCola, despite your better judgment. It
        initially sparks a sugar and caffeine rush, but that rapidly
        fades, to be replaced by a strange dull throbbing. You enter
        a semi-conscious state for several hours. It finally passes,
        but you're not sure if it's been hours, weeks, or years. ";
        cup.isFull := nil;
        self.moveInto( nil );
    }
;

toxicolaButton: buttonitem
    location = kitchen
    sdesc = "button"
    doPush( actor ) =
    {
        if ( cup.location = toxicolaMachine )
        {
            if ( cup.isFull )
                "ToxiCola spills over the already full cup, and drains
                away. ";
            else
            {
                "The horrible brown viscous fluid you have come to
                know as ToxiCola fills the cup. ";
                cup.isFull := true;
                toxicola.moveInto( cup );
            }
        }
        else
        {
            "Horrible viscous brown fluid spills into the empty
            compartment, and drains away. ";
        }
    }
;

orangeWalk1: room
    sdesc = "Orange Walk"
    ldesc = "You are on a walkway lined with orange trees. The walkway
     continues to the north, and an arched passage leads into a building
     to the east. "
    east = breezeway
    north = orangeWalk2
;

/*
 *   We want a "class" of objects for the orange trees lining the
 *   orange walk.  They don't do anything, so they're "decoration."
 */
class orangeTree: decoration
    sdesc = "orange trees"
    ldesc = "The orange trees are perfectly ordinary. "
    adesc = "an orange tree"
    noun = 'tree' 'trees'
    adjective = 'orange'
    verDoClimb( actor ) = {}
    doClimb( actor ) =
    {
        "You climb into one of the orange trees, and quickly find the
        view from the few feet higher to be highly uninteresting. You
        soon climb back down. ";
    }
;

orangeTree1: orangeTree
    location = orangeWalk1
;

orangeWalk2: room
    sdesc = "Orange Walk"
    ldesc = "You are on a walkway lined with orange trees. The walkway
     continues to the south, and leads into a large grassy square to the
     north. "
    north = quad
    south = orangeWalk1
;

orangeTree2: orangeTree
    location = orangeWalk2
;

quad: room
    sdesc = "Quad"
    ldesc = "You are on the quad, a large grassy square in the
     center of campus.  The bookstore lies to the northwest; the
     health center lies to the northeast; Buildings and Grounds
     lies to the north; and walkways lead west and south.
     \n\tSome students dressed in radiation suits are staging a bogus
     toxic leak, undoubtedly to fulfill the requirements of one of the
     stacks.  They are wandering around, looking very busy.  Many reporters
     are standing at a safe distance, looking terrified.
     The supposed clean-up crew is pouring lots of liquid nitrogen onto
     the ground, resulting in huge clouds of water vapor. "
    south = orangeWalk2
    nw = bookstore
    west = walkway
    ne = healthCenter
    north = BandG
;

BandG: room
    sdesc = "B&G"
    ldesc = "You are in the Buildings and Grounds office. The exit is to
     the south. "
    south = quad
    out = quad
;

bngmemo: readable
    sdesc = "scrap of paper"
    iscrawlable = true
    noun = 'scrap' 'paper'
    location = BandG
    ldesc = "Most of the paper has been torn away; the part that remains
     seems to have a list of numerical codes of some kind on it:
     \b\t293 -- north tunnel lighting
     \n\t322 -- station 2 lighting
     \n\t612 -- behavior lab
     \bThe rest is missing. "
;

healthCenter: room
    sdesc = "Health Center"
    ldesc = "You are in the health center. Like the rest of campus, this
     place is deserted because of Ditch Day. The large desk would normally
     have a receptionist behind it, but today, no one is in sight. "
    sw = quad
    out = quad
;

healthDesk: fixeditem, surface
    sdesc = "desk"
    noun = 'desk'
    adjective = 'large'
    location = healthCenter
;

healthMemo: readable
    sdesc = "health memo"
    iscrawlable = true
    noun = 'memo'
    plural = 'memos'
    adjective = 'health'
    location = healthDesk
    ldesc =
       "From:\t\tDirector of the Health Center
      \nTo:\t\tAll Health Center Personnel
      \nSubject:\tToxiCola toxicity
      \bMany students have visited the Health Center recently, complaining
      that the ToxiCola that is served in the student houses has not been
      properly caffeinated.  The students are complaining of drowsiness,
      dizziness, and other symptoms that are normally associated with an
      insufficient intake of caffeine.
      \n\tUpon investigation, we have learned that the ToxiCola dispensers
      in the student houses have become contaminated with a substance that
      induces these effects. The substance has not yet been identified, but
      the concentration seems to be increasing. All Health Center personnel
      are urgently directed to advise students to avoid the ToxiCola if at
      all possible. Students should be informed that their student health
      insurance coverage will cover any purchases of other caffeinated
      beverages that they need for their studies. "
;

students: decoration
    sdesc = "students"
    adesc = "a group of students"
    noun = 'student' 'students'
    location = quad
    ldesc = "The students are making quite a good show of the simulated
     nuclear waste spill. They're all wearing white clean-room suits with
     official-looking \"Radiation Control District\" badges. They're
     scampering about purposefully, keeping the crowd of reporters back
     at a safe distance. "
;

presscorp: decoration
    sdesc = "reporters"
    adesc = "a group of reporters"
    noun = 'reporter' 'reporters'
    location = quad
;

flask: container
    sdesc = "flask"
    ldesc = "The flask appears to have lots of liquid nitrogen in it;
     it's hard to tell just how much, since the opening is perpetually
     clouded over with thick plumes of water vapor. "
    noun = 'flask'
    location = quad
    ioPutIn( actor, dobj ) =
    {
        "You know from experience that it wouldn't be a good idea to
        put "; dobj.thedesc; " into the liquid nitrogen, since the LN2 is
        really, really cold. ";
    }
;

pourVerb: deepverb
    sdesc = "pour"
    verb = 'pour'
    doAction = 'Pour'
    ioAction( inPrep ) = 'PourIn'
    ioAction( onPrep ) = 'PourOn'
;

ln2: item
    sdesc = "liquid nitrogen"
    adesc = "some liquid nitrogen"      // "a liquid nitrogen" doesn't compute
    ldesc = "You can't see much, thanks to the thick clouds of water
     vapor that inevitably form over such a cold substance. "
    noun = 'nitrogen' 'ln2'
    adjective = 'liquid'
    location = flask
    doTake( actor ) =
    {
        "You're better off leaving the liquid nitrogen in the flask. ";
    }
    verDoPour( actor ) = {}
    verDoPourIn( actor, io ) = {}
    doPour( actor ) =
    {
        askio( inPrep );
    }
;

walkway: room
    sdesc = "Walkway"
    ldesc = "You are on a walkway.  A large grassy square lies to the east;
     buildings lie to the north and south. The walkway continues west. "
    east = quad
    north = behaviorLab
    south = security
    west = walkway2
;

walkway2: room
    sdesc = "Walkway"
    ldesc = "You are on a walkway, which continues to the east. Buildings
     are to the north and south. "
    east = walkway
    south = explosiveLab
    north = biobuilding
;

biobuilding: room
    sdesc = "Biology Building"
    ldesc = "You are in the biology building. The exit is south. "
    south = walkway2
    out = walkway2
;

bionotes: readable
    sdesc = "notebook"
    location = biobuilding
    noun = 'notebook'
    ldesc = "The notebook explains various lab techniques used in cloning
     organisms. Since the invention of the CloneMaster, which requires only
     a sample of genetic material from a subject (such as some blood, or a
     bit of skin, or the like) and the basic skills required to operate a
     household blender, most of the techniques are obsolete. Some of the data,
     however, are interesting. For example, the notebook outlines the procedure
     for reversing the sex of a clone; the introduction of chemicals identified
     herein only as Genetic Factor XQ3, Polymerase Blue, and Compound T99 at
     the start of the cloning process aparently does the trick. Most of the
     rest of the document is a discussion of the human immune system; the
     author comes to the conclusion that the human immune system, though a
     novel idea, is far too improbable to ever actually be implemented. "
;

explosiveLab: room
    sdesc = "Explosive Lab"
    ldesc = "It's not that the lab itself is explosive (though it has blown
     up a couple times in the past); rather, they study explosives here.
     Unfortunately, all the good stuff has been removed by other Ditch Day
     participants who got up earlier than you did. The exit is north. "
    north = walkway2
    out = walkway2
;

ln2doc: readable
    sdesc = "thesis"
    noun = 'thesis'
    location = explosiveLab
    ldesc = "The thesis is about Thermal Expansion Devices. It explains about
     a new class of explosives that are made possible by low-temperature
     fluid technology (i.e., liquid nitrogen) and high-tension polymer
     containment vessels (i.e., plastic bottles). A great deal of jargon and
     complicated theories are presented, presumably to fool the faculty
     advisor into thinking the author actually did something useful with his
     research funds; after wading through the nonsense, you find that the
     paper is merely talking about putting liquid nitrogen into a plastic
     soft-drink bottle, closing the bottle, then letting nature take its
     course. Since the nitrogen will tend to evaporate at room temperature,
     but will have no place to go, the bottle will eventually explode.
     \bOn the cover page, you notice this important warning: \"Kids! Don't
     try this at home! Liquid nitrogen is extremely cold, and can cause severe
     injuries; it should only be handled by trained professionals. Never
     put liquid nitrogen in a closed container.\" "
;

bookstore: room
    sdesc = "Bookstore"
    ldesc = "You are in the bookstore. The shelves are quite empty; no doubt
     everything has been bought up by seniors in attempts to build their
     stacks and underclassmen in attempts to break them. The exit is to the
     southeast. "
    out = { return( self.se ); }
    se =
    {
        /*
         *   We need to check that the battery has been paid for, if it's
         *   been taken.  If not, don't let 'em out.
         */
        if ( battery.isIn( Me ) and not battery.isPaid )
        {
            "The clerk notices that you want to buy the battery. \"That'll be
            five dollars,\" she says, waiting patiently. ";
            return( nil );
        }
        else return( quad );
    }
;

battery: item
    location = bookstore
    isPaid = nil
    sdesc = "battery"
    noun = 'battery'
    verDoPayfor( actor ) =
    {
        if ( actor.location <> bookstore )
            "I don't see anyone to pay! ";
    }
    doPayfor( actor ) =
    {
        clerk.doPay( actor );
    }
    verIoPayFor( actor ) = {}
    ioPayFor( actor, dobj ) =
    {
        if ( dobj <> clerk )
        {
            "You can't pay "; dobj.thedesc; " for that! ";
        }
        else clerk.doPay( actor );
    }
;

forPrep: Prep
    sdesc = "for"
    preposition = 'for'
;

payVerb: deepverb
    sdesc = "pay"
    verb = 'pay'
    doAction = 'Pay'
    ioAction( forPrep ) = 'PayFor'
;

payforVerb: deepverb
    verb = 'pay for'
    sdesc = "pay for"
    doAction = 'Payfor'
;

money: item
    sdesc = "five dollar bill"
    noun = 'bill' 'money'
    adjective = 'five' 'dollar' '5'
    iscrawlable = true
;

clerk: Actor
    noun = 'clerk'
    location = bookstore
    sdesc = "Clerk"
    isHer = true
    ldesc = "The clerk is a kindly lady to whom you have paid many hundreds
     of dollars for books and other college necessities. "
    actorDesc = "A clerk is near the exit, prepared to ring up any purchases
     you might want to make (not that there's much left here to buy). "
    verIoGiveTo( actor ) = {}
    ioGiveTo( actor, dobj ) =
    {
        if ( dobj = money or dobj = dollar ) self.doPay( actor );
        else if ( dobj = darbcard )
        {
            "The clerk shakes her head. \"Sorry,\" she says, \"we only
            accept cash.\" ";
        }
        else if ( dobj = cup and cup.isFull )
        {
            "\"I never drink that stuff,\" the clerk says, \"and neither
            should you! Do you have any idea what's in there? I probably
            don't know half as much chemistry as you, but I know better
            than to drink that.\" ";
        }
        else
        {
            "She doesn't appear interested. ";
        }
    }
    verDoPay( actor ) = {}
    doPay( actor ) =
    {
        if ( not battery.isIn( Me ))
        {
            "The clerk looks confused. \"I don't see what you're
            paying for,\" she says. She then looks amused, realizing
            that the students here somtimes get a little ahead of
            themselves. ";
        }
        else if ( battery.isPaid )
        {
            "The clerk looks confused and says, \"You've already paid!\"
            She then looks amused, realizing that the students here can
            be a bit absent-minded at times. ";
        }
        else if ( not money.isIn( Me ))
        {
            if ( dollar.isIn( Me ))
            {
                "The clerk reminds you that the battery is five dollars.
                All you have is one dollar. She looks amused; \"They can
                do calculus in their sleep but they can't add,\" she jokes. ";
            }
            else
            {
                "You unfortunately don't have anything with which to pay the
                clerk. ";
            }
        }
        else
        {
            "The clerk accepts your money and says \"Thank you, have a nice
            day.\"";
            battery.isPaid := true;
            money.moveInto( nil );
        }
    }
;

behaviorLab: room
    sdesc = "Behavior Lab"
    ldesc = "You are in the behavior lab.  The exit is to the south,
     and a locked door is to the north. The door is labelled \"Maze -
     Experimental Subjects Only.\" In addition, a passage labelled
     \"Viewing Room\" leads east. "
    south = walkway
    out = walkway
    east = mazeview
    north =
    {
        "The door is closed and locked. Besides, do you really want to
        be an \"Experimental Subject\"?";
        return( nil );
    }
;

mazeview: room
    sdesc = "Maze Viewing Room"
    ldesc =
    {
        "The entire north wall of this room is occupied by a window
         overlooking a vast human-sized labyrinth. No experimental subjects
         (i.e., students) seem to be wandering through the maze at the
         moment, ";
         
        if ( not mazeStart.isseen )
            "but you have the strange feeling that you will have to find
            your way through the maze some day. You read with a sense of
            foreboding the plaque affixed to the wall:\b";
        else
            "so your attention wanders to the plaque on the wall:\b";
            
        mazeplaque.ldesc;
    }
    west = behaviorLab
;

mazewindow: fixeditem
    sdesc = "window"
    noun = 'window'
    location = mazeview
    verDoLookthru( actor ) = {}
    doLookthru( actor ) = { self.ldesc; }
    ldesc =
    {
        "The window looks out onto a vast human-sized labyrinth.
         The maze is currently devoid of experimental subjects";
        if ( not mazeStart.isseen )
            ", but you have the strange feeling that you'll have to find
            your way through the maze someday";
        ". ";
    }
;

mazeplaque: fixeditem, readable
    sdesc = "plaque"
    noun = 'plaque'
    location = mazeview
    ldesc = "*** The Behavioral Biology Laboratory Psycho-Magnetic Maze ***
     \bThe Psycho-Magnetic Maze that is visible through the window has been
     constructed to determine how the human directional sense interacts with
     strong electromagnetic and nuclear fields. Through careful tuning of
     these fields, we have found that human subjects often become completely
     disoriented in the maze, resulting in hours of random and
     desperate wandering, and much amusement to those of us in the observation
     room. "
;

behaviorDoor: lockedDoor
    ldesc = "The door is closed and locked, and labelled \"Experimental
     Subjects Only.\""
    location = behaviorLab
;

security: room
    sdesc = "Security Office"
    ldesc = "You are in the campus security office, the very nerve-center of
     the elite Kaltech Kops.  The officers all
     appear to be absent; undoubtedly they are all scurrying hither and
     yon trying to deal with the ditch-day festivities.  There is a desk
     in the center of the room.  The exit is to
     the north. "
    north = walkway
    out = walkway
;

securityDesk: fixeditem, surface
    sdesc = "desk"
    noun = 'desk'
    location = security
;

securityMemo: readable
    sdesc = "security memo"
    iscrawlable = true
    noun = 'memo'
    plural = 'memos'
    adjective = 'security'
    location = securityDesk
    ldesc =
       "From:\t\tDirector of Security
      \nTo:\t\tAll Security Personnel
      \nSubject:\tGreat Undergraduate Excavation
      \bIt has come to the attention of the Kaltech Kops that the student
      activity in the steam tunnels, known as the \"Great Undergraduate
      Excavation\" project, has escalated vastly in recent years. Due to
      objections from city officials about noise from underground and the
      fear local residents have expressed that their property will be
      undermined, this office has taken action to halt all GUE activity.
      Effective immediately, a security officer will be posted at all
      known steam tunnel entrances, and shall under no circumstances allow
      students to enter. "
;

flashlight: container, lightsource
    sdesc = "flashlight"
    noun = 'flashlight' 'light'
    adjective = 'flash'
    location = security
    ioPutIn( actor, dobj ) =
    {
        if ( dobj <> battery )
        {
            "You can't put "; dobj.thedesc; " into the flashlight. ";
        }
        else pass ioPutIn;
    }
    Grab( obj ) =
    {
        /*
         *   Grab( obj ) is invoked whenever an object 'obj' that was
         *   previously located within me is removed.  If the battery is
         *   removed, the flashlight turns off.
         */
        if ( obj = battery ) self.islit := nil;
    }
    ldesc =
    {
        if ( battery.location = self )
        {
            if ( self.islit )
                "The flashlight (which contains a battery) is turned on
                and is providing a warm, reassuring beam of light. ";
            else
                "The flashlight (which contains a battery) is currently off. ";
        }
        else
        {
            "The flashlight is off. It seems to be missing a battery. ";
        }
    }
    verDoTurnon( actor ) =
    {
        if ( self.islit ) "It's already on! ";
    }
    doTurnon( actor ) =
    {
        if ( battery.location = self )
        {
            "The flashlight is now on. ";
            self.islit := true;
        }
        else "The flashlight won't turn on without a battery. ";
    }
    verDoTurnoff( actor ) =
    {
        if ( not self.islit ) "It's not on. ";
    }
    doTurnoff( actor ) =
    {
        "Okay, the flashlight is now turned off. ";
        self.islit := nil;
    }
;

goToSleep: function
{
    "***\bYou wake up some time later, feeling refreshed. ";
    global.awakeTime := 0;
}

hall1: room
    sdesc = "Hallway"
    ldesc = "You are at the west end of a basement hallway. A stairway
     leads up. "
    up = courtyard
    east = hall2
;

hall2: room
    sdesc = "Hallway"
    ldesc = "You are in an east-west hallway in the basement.  Another hallway
     goes off to the north. "
    west = hall1
    east = hall3
    north = hall4
;

hall3: room
    sdesc = "Hallway"
    ldesc = "You are at the east end of a hallway in the basement.
     A passage leads north. "
    west = hall2
    north = laundry
;

laundry: room
    sdesc = "Laundry Room"
    ldesc = "You are in the laundry room. There is a washing machine
     against one wall. The exit is to the south. "
    south = hall3
    out = hall3
;

washingMachine: fixeditem, openable
    sdesc = "washing machine"
    isopen = nil
    location = laundry
    noun = 'machine' 'washer'
    adjective = 'washing'
;

jeans: item
    sdesc = "blue jeans"
    location = washingMachine
    noun = 'jeans' 'pants'
    adjective = 'blue'
    ldesc =
    {
        if ( self.isseen ) "It's an ordinary pair of jeans. ";
        else
        {
            "It looks like an ordinary pair of jeans, though not
            your size. As you inspect them, you notice a key fall
            out of them and to the ground. ";
            masterKey.moveInto( Me.location );
            self.isseen := true;
        }
    }
    verDoLookin( actor ) = {}
    doLookin( actor ) = { self.ldesc; }
    verDoWear( actor ) = { "They're not your size. "; }
;

masterKey: keyItem
    iscrawlable = true
    sdesc = "master key"
    noun = 'key'
    adjective = 'master'
    doTake( actor ) =
    {
        if ( not self.isseen )
        {
            "*Some* adventure games would try to impose their authors'
            misguided sense of ethics on you at this point, telling you
            that you don't feel like picking up the key, or you don't have
            time to do that, or that it's against the rules to even possess
            a master key, much less steal one from some other student's
            pants that you happened to find in a laundry, or even more
            likely that you are unable to take the key while wearing that
            dress. However, you're the player, and you're in charge around
            here, so I'll let you make your own judgments about what's
            ethical and proper here... ";
            self.isseen := true;
        }
        pass doTake;
    }
;

hall4: room
    sdesc = "Hallway"
    ldesc = "You are in a north-south hallway in the basement. "
    south = hall2
    north = hall5
;

hall5: room
    sdesc = "Hallway"
    ldesc = "You are at a corner in the basement hallway. You can go east
     or south. "
    south = hall4
    east = hall6
;

hall6: room
    sdesc = "Hallway"
    ldesc = "You are at the east end of a basement hallway. To the north is
     a \"storage room,\" which everyone knows is actually an entrance
     to the steam tunnels. "
    west = hall5
    north = storage
;

storage: room
    sdesc = "Storage Room"
    ldesc =
    {
        "You are in a large storage room. There really hasn't been
         anything stored here for a long time (at least, not anything that
         anybody wants to ever see again). The exit is to the south. To
         the north lies a door, which is ";
         if ( tunnelDoor.isopen ) "open"; else "closed"; ". A small card
         table is sitting in front of the door. ";
    }
    south = hall6
    north =
    {
        if ( guard.isActive )
        {
            "The guard won't let you enter the tunnel. ";
            return( nil );
        }
        else if ( not tunnelDoor.isopen )
        {
            "A closed door stands in your way. ";
            setit( tunnelDoor );       /* "it" now refers to the closed door */
            return( nil );
        }
        else return( tunnel1 );
    }
    enterRoom( actor ) =
    {
        if ( guard.isActive )
        {
            notify( guard, #patrol, 0 );
        }
        pass enterRoom;
    }
    leaveRoom( actor ) =
    {
        if ( guard.isActive )
        {
            unnotify( guard, #patrol );
        }
        pass leaveRoom;
    }
;

tunnelDoor: lockedDoor
    location = storage
    mykey = masterKey
;

guard: Actor
    sdesc = "guard"
    noun = 'guard' 'him'
    isHim = true
    ldesc =
    {
        "The guard is a member of the Kaltech Kops, the elite corps of
        dedicated men and women that keeps the campus safe from undesirables
        (i.e., the students). ";
        if ( not self.isActive )
            "Currently, the guard is fast asleep, which is quite typical. ";
    }
    adjective = 'security'
    isActive = true
    location = storage
    actorDesc =
    {
        if ( self.isActive )
            "A guard is sitting at the card table in front of the door.
            He watches you carefully, evidently thinking that you might
            be planning to try to go through the door. ";
        else
            "A guard is slumped over a small card table in front of the
            steam tunnel entrance, evidently fast asleep. How typical. ";
    }
    verIoGiveTo( actor ) =
    {
        if ( not self.isActive )
            "The guard appears to be fast asleep. ";
    }
    ioGiveTo( actor, dobj ) =
    {
        if ( dobj = dollar or dobj = money )
            "The guard looks at you sternly. \"You should be ashamed of
            yourself, trying to bribe a member of the elite Kaltech Kops!\"
            he admonishes you, refusing your offer. ";
        else if ( dobj <> cup or not cup.isFull )
            "The guard doesn't appear interested. ";
        else
        {
            self.isActive := nil;
            unnotify( self, #patrol );
            "The guard happily accepts your offer; \"ToxiCola! My favorite!\"
            he says appreciatively, not knowing the evil deed
            that you have in mind. He quickly drinks the entire cup of
            ToxiCola. \"Wow! Just the caffeine pickup I needed,\" he says
            happily.
            \n\tAfter a few moments, though, he looks rather queasy. \"That
            caffeine just doesn't last long enough,\" he says just before
            he passes out, slumping over the card table. ";
            cup.isFull := nil;
            toxicola.moveInto( nil );
            cup.moveInto( cardtable );
            incscore( 10 );
        }
    }
    patrolMessage =
    [
        // random message 1
        'The guard eyes you warily.'
        // random message 2
        'The guard looks at his empty glass, probably wishing he had
        something to drink.'
        // random message 3
        'The guard flips purposefully through the pages of his memo pad.'
        // random message 4
        'The guard writes something down on his memo pad, glancing up from
        time to time to eye you suspiciously.'
        // random message 5
        'The guard picks up his empty glass and starts to drink, then
        realizes it is empty and puts it back down.'
    ]
    patrol =
    {
        if ( self.location = Me.location )
        {
            "\b";
            say( self.patrolMessage[rand( 5 )]);
        }
    }
;

cardtable: fixeditem, surface
    noun = 'table'
    adjective = 'card'
    location = storage
    sdesc = "card table"
;

emptyglass: container
    noun = 'glass'
    adjective = 'empty'
    sdesc = "empty glass"
    adesc = "an empty glass"
    location = cardtable
    doTake( actor ) =
    {
        if ( guard.isActive )
            "The guard won't let you take the glass. \"Get your own,\"
            he says. ";
        else pass doTake;
    }
    ioPutIn( actor, dobj ) =
    {
        if ( dobj = ln2 ) "The liquid nitrogen evaporates on contact. ";
        else "It won't fit in the glass. ";
    }
;

tunnelSounds: function( parm )
{
    if ( Me.location.istunnel )
    {
        "\b";
        say( tunnelroom.randomsound[rand( 5 )]);
    }
    setfuse( tunnelSounds, rand( 5 ), nil );
}

class tunnelroom: room
    istunnel = true
    sdesc = "Steam Tunnel"
    randomsound = [
    // random sound 1
      'The rumbling sound suddenly becomes very loud, then, after
       a few moments, dies down to background levels again.'
    // random sound 2
      'A series of clanking noises, like marbles rolling through the
      steam pipes, starts in the distance, then comes
      closer and closer, until it seems to pass right overhead. It disappears
      into the distance.'
    // random sound 3
      'A very loud bang suddenly reverberates through the tunnel.'
    // random sound 4
      'One of the pipes starts to hiss wildly. After a few moments, it
      fades back into the background sounds.'
    // random sound 5
      'A loud buzzing sound, like an overloaded electrical circuit,
      emanates from somewhere nearby. After a few moments it is gone.'
    ]
;

tunnelpipes: fixeditem
    sdesc = "pipes"
    noun = 'pipe' 'pipes'
    ldesc = "The pipes range from very small copper tubes only an inch around
     to huge asbestos-covered cylinders over two feet in diameter.  Many of
     the larger pipes are marked \"STEAM - 300 PSI.\" "
    locationOK = true
    location =
    {
        if ( Me.location.istunnel ) return( Me.location );
        else return( nil );
    }
;

tunnel1: tunnelroom
    ldesc = "You are in a steam tunnel. It is very hot and dry in here.
     The place has a strange musty odor; the air is very still, but there
     are distant sounds of all sorts that vibrate through the pipes. The
     pipes all seem to be hissing quietly, and a low rumbling sound constantly
     reverberates through the tunnel. Occasionally a distant clang or thud
     or crack emanates from the pipes.
     \n\tThe steam tunnel runs east and west. A small passage leads south. "
    east = tunnel2
    west = tunnel3
    south = storage
    enterRoom( actor ) =
    {
        if ( not self.isseen ) setfuse( tunnelSounds, rand( 5 ), nil );
        pass enterRoom;
    }
;

tunnel2: tunnelroom
    ldesc = "You are at the east end of the steam tunnel. "
    west = tunnel1
;

tunnelStorage: room
    sdesc = "Storage Room"
    ldesc = "You are in a small storage room. The exit lies north. "
    north = tunnel13
;

tunnel3: tunnelroom
    ldesc = "You are in an east-west section of the steam tunnels. "
    east = tunnel1
    west = tunnel4
;

tunnel4: tunnelroom
    ldesc = "You are at a T-intersection of two sections of steam
     tunnel; tunnels go off to the north, south, and east. "
    east = tunnel3
    north = tunnel5
    south = tunnel6
;

darktunnel: darkroom, tunnelroom
    controlon = nil
    islit =
    {
        if ( self.controlon ) return( true );
        else pass islit;
    }
;

tunnel5: darktunnel
    ldesc = "You are at a corner in the steam tunnel: you can go
     west and south. "
    west = tunnel7
    south = tunnel4
;

tunnel6: tunnelroom
    ldesc = "You are at a corner in the steam tunnel: you can go
     west and north. "
    west = tunnel8
    north = tunnel4
;

tunnel7: darktunnel
    ldesc = "You are in an east-west section of the steam tunnel.
     A very small passage between some steam pipes leads north, but
     it would be a tight squeeze. "
    east = tunnel5
    west = tunnel9
    north =
    {
        return(crawltest( tunnel12,
         'You lay down on one of the pipes and start to snake
          through the passage. For a moment, you think you\'re
          stuck, but you manage to wriggle your way through. You
          emerge on the north side of the narrow crawl.' ));
    }
;

tunnel8: tunnelroom
    controlon = true
    ldesc =
    {
        "You are in an east-west section of the steam tunnel. On the
         wall is a control unit. ";
        if ( not self.controlon )
        {
            "It is quite dark in this section of the tunnel; the only
             illumination is coming from the control unit's display";
             
            if (( flashlight.isIn( Me ) or flashlight.isIn( tunnel8 ))
             and flashlight.islit )
                " (and from the flashlight, of course)";
        
            ". ";
        }
    }
    east = tunnel6
    west = tunnel10
;

controlunit: fixeditem
    sdesc = "control unit"
    noun = 'unit'
    adjective = 'control'
    location = tunnel8
    ldesc =
    {
        "The control unit is quite modern and high-tech looking, in
         stark contrast to the tunnels around it. It consists of a keypad
         which allows entry of arbitrary numbers, a large green button,
         and a display screen. The unit is labelled \"Station 2.\" ";
        controldisp.ldesc;
    }
    objref =
    {
        local l;
        
        l := self.value;
        
        if ( l = 322 ) return( tunnel8 );
        else if ( l = 612 ) return( mazeroom );
        else if ( l = 293 ) return( darktunnel );
        else return( nil );
    }
    value = 322
;

controlpad: fixeditem
    sdesc = "keypad"
    noun = 'keypad' 'pad'
    adjective = 'key'
    location = tunnel8
    ldesc = "It's one of those cheesy membrane keypads, like on a microwave
     oven or the new Enterprise's control panels. It allows you to type numbers
     made up of digits from 0 to 9. "
    verIoTypeOn( actor ) = {}
    ioTypeOn( actor, dobj ) =
    {
        if ( dobj <> numObj )
            "The keypad only allows entry of numbers. ";
        else
        {
            "As you type the number sequence, the display screen is
            updated. ";
            controlunit.value := numObj.value;
            controldisp.ldesc;
        }
    }
;

controlbutton: buttonitem
    sdesc = "button"
    adjective = 'green'
    location = tunnel8
    doPush( actor ) =
    {
        local r;
        
        r := controlunit.objref;
        if ( r )
        {
            "The display is updated as you press the button. ";
            r.controlon := not r.controlon;
            controldisp.ldesc;
            if ( r = tunnel8 )
            {
                "The lights in the tunnel ";
                if ( r.controlon )
                    "come on. ";
                else
                {
                    "go out, leaving only the display screen's light ";
                    if (( flashlight.isIn( Me ) or flashlight.isIn( tunnel8 ))
                     and flashlight.islit )
                        "(and the flashlight, of course) ";
                    "for illumination. ";
                }
            }
        }
        else "The unit beeps; nothing else appears to happen. ";
    }
;

controldisp: fixeditem
    sdesc = "display screen"
    noun = 'screen'
    adjective = 'display'
    location = tunnel8
    ldesc =
    {
        local l, r;
        
        l := controlunit.value;
        r := controlunit.objref;
        "The screen is currently displaying: \""; say( l ); ": ";       
        if ( r )
        {
            if ( r.controlon ) "ON"; else "OFF";
        }
        else "???";
        
        "\". ";
    }
;

tunnel9: darktunnel
    ldesc = "You are at a corner in the steam tunnel.  You can go east
     or south. "
    east = tunnel7
    south = tunnel11
;

tunnel10: tunnelroom
    ldesc = "You are at a corner in the steam tunnel. You can go east
     or north. "
    east = tunnel8
    north = tunnel11
;

tunnel11: tunnelroom
    ldesc = "You are in a north-south section of the steam tunnels. Set
     into one wall is a large chute. "
    north = tunnel9
    south = tunnel10
;

chute: fixeditem, container
    sdesc = "chute"
    noun = 'chute'
    location = tunnel11
    ldesc = "The chute is large enough for anything you're carrying,
     but not nearly big enough for you. You can't tell where it goes,
     except down. "
    ioPutIn( actor, dobj ) =
    {
        "You put "; dobj.thedesc; " into the chute, and it slides away
        into the darkness. After a few moments, you hear a soft thud. ";
        dobj.moveInto( chuteroom );
    }
;

crawltest: function( rm, msg )
{
    local i;
    
    i := 1;
    while ( i <= length( Me.contents ))
    {
        if ( not Me.contents[i].iscrawlable )
        {
            "You'll never get through carrying ";
            Me.contents[i].thedesc; ". ";
            return( nil );
        }
        i := i + 1;
    }
    say( msg ); "\b";
    return( rm );
}

tunnel12: tunnelroom
    ldesc =
    {
        if ( self.isseen )
            "You are in an east-west section of the steam tunnels. A narrow
            passage between some steam pipes might allow you to go south. ";
        else
            "You are in another steam tunnel, but this one is substantially
            different from the tunnels you have been in so far. This tunnel
            is much wider, less cluttered; it looks like it was built more
            recently than the south tunnels. The tunnel itself runs east
            and west, and passing back to the south is evidently possible,
            given your presence here. ";
    }
    east = tunnel13
    west = pitTop
    south =
    {
        return(crawltest( tunnel7, 'Going through the crawl
         southbound is just as difficult as it was coming north,
         you observe.' ));
    }
;

tunnel13: tunnelroom
    ldesc = "You are at the east end of a steam tunnel. A passage leads
     north, and another one leads south. "
    west = tunnel12
    north = maze0
    south = tunnelStorage
;

maze0: room
    sdesc = "Outside Maze"
    ldesc =
    {
        "You are in a small room, with exits north and south. The
         passage to the north has a small sign reading \"Behavior Lab Maze\";
         the room is filled with strange equipment, which you surmise is
         connected in some way to the maze. ";
         
        if ( mazeroom.controlon )
            "The equipment is buzzing loudly. Standing
             near it makes you feel vaguely dizzy. ";
        
        if ( not self.isseen )
        {
            "\n\tYou sigh in resignation as you realize that you have reached
            the obligatory Adventure Game Maze, and ";
            if ( mazeview.isseen )
                "wish that this were a graphical adventure, so your trip to
                the maze viewing room had resulted in a map you could refer
                to now. Fortunately, you do recall noting that the passages
                in the maze all lead east-west or north-south. ";
            else
                "wonder what this maze's unique twist will be. Surely, it
                won't just be a boring old labyrinth... ";
        }
    }
    south = tunnel13
    north = maze1
;

mazeequip: decoration
    noun = 'equipment' 'coil' 'coils' 'pipe' 'pipes' 'wire' 'wires'
    adjective = 'electric' 'electrical'
    sdesc = "equipment"
    location = maze0
    ldesc =
    {
        "The equipment resembles some of the particle accelerators that
        you have seen. It has several huge electric coils, all arranged
        around a series of foot-diameter pipes. A tangled web of enormous
        wires connects various parts of the equipment together and other
        wires feed it power. ";
        
        if ( mazeroom.controlon )
            "The equipment is buzzing loudly. Standing near it makes
            you feel vaguely dizzy. ";
    }
;

mazeroom: room
    controlon = true
    sdesc = "Lost in the Maze"
    lookAround( verbosity ) =
    {
        self.statusLine;
        self.nrmLkAround( self.controlon ? true : verbosity );
    }
    ldesc =
    {
        if ( self.controlon )
            "You can't quite seem to get your bearings. There are some
            passages leading away, but you can't quite tell how many or
            in which direction they leads. ";
        else
        {
            local cnt, tot, i;
            
            tot := 0;
            i := 1;
            while ( i <= 4 )
            {
                if ( self.dirlist[i] ) tot := tot + 1;
                i := i + 1;
            }

            "You are in a room in the maze; they all look alike.
            You can go ";
            
            i := 1;
            cnt := 0;
            while ( i <= 4 )
            {
                if ( self.dirlist[i] )
                {
                    if ( cnt > 0 )
                    {
                        if ( tot = 2 ) " and ";
                        else if ( cnt+1 = tot ) ", and ";
                        else ", ";
                    }
                    cnt := cnt + 1;
                    
                    say( ['north' 'south' 'east' 'west'][i] );
                }
                i := i + 1;
            }
            ". ";
        }
    }
    mazetravel( rm ) =
    {
        if ( self.controlon )
        {
            local r;
            
            "You can't figure out which direction is which; the more you
            stumble about, the more the room seems to spin around. After a
            few steps, you're not sure if you've actually gone anywhere,
            since all these rooms look alike...\b";
            
            /*
             *   We know we can only go one of four directions, but generate
             *   a random number up to 6; if we generate 5 or 6, we won't go
             *   anywhere, but we won't let on that this is the case.
             */
            r := rand( 6 );
            
            /*
             *   Note that we want to confuse the player in active-maze mode
             *   as much as possible, so we don't want any clues as to whether
             *   there was any travel in this direction or not.  So, return
             *   "self" rather than "nil," since we won't get any message if
             *   we return "nil," but we'll get the current room's message if
             *   we return "self;" since all the messages are the same, this
             *   won't provide any information.
             */
            if ( r < 5 )
            {
                r := self.dirlist[ r ];
                if ( r ) return( r );
                else return( self );
            }
            else return( self );
        }
        else
        {
            if ( rm )
                return( rm );
            else
            {
                "You can't go that way. ";
                return( nil );
            }
        }
    }
    north = ( self.mazetravel( self.dirlist[1] ))
    south = ( self.mazetravel( self.dirlist[2] ))
    east = ( self.mazetravel( self.dirlist[3] ))
    west = ( self.mazetravel( self.dirlist[4] ))
    up = ( self.mazetravel( 0 ))
    down = ( self.mazetravel( 0 ))
    in = ( self.mazetravel( 0 ))
    out = ( self.mazetravel( 0 ))
    ne = ( self.mazetravel( 0 ))
    nw = ( self.mazetravel( 0 ))
    se = ( self.mazetravel( 0 ))
    sw = ( self.mazetravel( 0 ))
;

maze1: mazeroom
    dirlist = [ 0 maze0 maze2 0 ]
;

maze2: mazeroom
    dirlist = [ maze9 0 maze3 maze1 ]
;

maze3: mazeroom
    dirlist = [ maze8 0 maze4 maze2 ]
;

maze4: mazeroom
    dirlist = [ 0 0 maze5 maze3 ]
;

maze5: mazeroom
    dirlist = [ maze6 0 0 maze4 ]
;

maze6: mazeroom
    dirlist = [ 0 maze5 0 maze7 ]
;

maze7: mazeroom
    dirlist = [ maze30 0 maze9 maze8 ]
;

maze8: mazeroom
    dirlist = [ maze29 maze3 maze7 0 ]
;

maze9: mazeroom
    dirlist = [ 0 maze2 0 maze10 ]
;

maze10: mazeroom
    dirlist = [ 0 0 maze9 maze11 ]
;

maze11: mazeroom
    dirlist = [ 0 maze35 maze10 maze12 ]
;

maze12: mazeroom
    dirlist = [ 0 0 maze11 0 ]
;

maze13: mazeroom
    dirlist = [ maze24 maze18 0 0 ]
;

maze14: mazeroom
    dirlist = [ 0 maze17 0 maze15 ]
;

maze15: mazeroom
    dirlist = [ 0 maze16 maze14 0 ]
;

maze16: mazeroom
    dirlist = [ maze15 maze23 maze17 0 ]
;

maze17: mazeroom
    dirlist = [ maze14 maze22 maze18 maze16 ]
;

maze18: mazeroom
    dirlist = [ maze13 maze21 0 maze17 ]
;

maze19: mazeroom
    dirlist = [ 0 maze20 maze35 0 ]
;

maze20: mazeroom
    dirlist = [ maze19 0 0 maze21 ]
;

maze21: mazeroom
    dirlist = [ maze18 0 maze20 0 ]
;

maze22: mazeroom
    dirlist = [ maze17 0 0 0 ]
;

maze23: mazeroom
    dirlist = [ maze16 0 0 0 ]
;

maze24: mazeroom
    dirlist = [ 0 maze13 maze25 0 ]
;

maze25: mazeroom
    dirlist = [ maze33 0 maze26 maze24 ]
;

maze26: mazeroom
    dirlist = [ maze32 0 0 maze25 ]
;

maze27: mazeroom
    dirlist = [ maze31 0 0 0 ]
;

maze28: mazeroom
    dirlist = [ 0 0 maze29 0 ]
;

maze29: mazeroom
    dirlist = [ 0 maze8 maze30 maze28 ]
;

maze30: mazeroom
    dirlist = [ 0 maze7 0 maze29 ]
;

maze31: mazeroom
    dirlist = [ 0 maze27 0 maze32 ]
;

maze32: mazeroom
    dirlist = [ 0 maze26 maze31 0 ]
;

maze33: mazeroom
    dirlist = [ 0 maze25 0 maze34 ]
;

maze34: mazeroom
    dirlist = [ 0 0 maze33 mazeStart ]
;

maze35: mazeroom
    dirlist = [ maze11 0 0 maze19 ]
;

mazeStart: room
    sdesc = "Start of Maze"
    ldesc = "You are at the start of the maze. A passage into the
     maze is to the east, and a heavy one-way door marked \"Exit\" is to the
     south. "
    east = maze34
    south = behaviorLab
;

mazedoor: fixeditem
    sdesc = "door"
    noun = 'door'
    adjective = 'exit' 'one-way' 'heavy'
    verDoOpen( actor ) = { "No need; just walk on through. "; }
    location = mazeStart
;

chuteroom: room
    sdesc = "Chute Room"
    ldesc = "You are in a small room with exits to the northwest
     and south. The bottom of a large chute opens into the room. "
    nw = pitBottom
    south = shiproom
;

chute2: fixeditem, container
    sdesc = "chute"
    noun = 'chute'
    location = chuteroom
    ioPutIn( actor, dobj ) =
    {
        "This is the bottom of the chute; you can't put objects
        into it. ";
    }
;

pitTop: tunnelroom
    sdesc = "Top of Pit"
    ldesc =
    {
        "You are in a large open area in the steam tunnels. In
         the center of the room is a large pit, around which is a protective
         railing. A steam tunnel is to the east. ";
        if ( rope.tieItem = railing )
            "A rope is tied to the railing, and extends down into the pit. ";
    }
    east = tunnel12
    down =
    {
        if ( rope.tieItem = railing )
        {
            "You climb down the rope...\b";
            return( pitBottom );
        }
        else
        {
            "You'd probably break your neck if you tried to jump
            into the pit. ";
            return( nil );
        }
    }
;

tieVerb: deepverb
    sdesc = "tie"
    verb = 'tie'
    prepDefault = toPrep
    ioAction( toPrep ) = 'TieTo'
;

railing: fixeditem
    sdesc = "rail"
    noun = 'rail' 'railing'
    location = pitTop
    verIoTieTo( actor ) = {}
    ioTieTo( actor, dobj ) =
    {
        "You tie one end of the rope to the railing, and lower the other
        end into the pit. It appears to extend to the bottom of the pit. ";
        rope.tieItem := self;
        rope.moveInto( pitTop );
        rope.isfixed := true;
    }
;

climbupVerb: deepverb
    verb = 'climb up'
    sdesc = "climb up"
    doAction = 'Climbup'
;

climbdownVerb: deepverb
    verb = 'climb down'
    sdesc = "climb down"
    doAction = 'Climbdown'
;

rope: item
    sdesc = "rope"
    isListed = ( not self.isfixed )
    noun = 'rope'
    location = tunnelStorage
    ldesc =
    {
        if ( self.tieItem )
        {
            "It's tied to "; self.tieItem.thedesc; ". ";
        }
        else pass ldesc;
    }
    verDoTieTo( actor, io ) =
    {
        if ( self.tieItem )
        {
            "It's already tied to "; self.tieItem.thedesc; "! ";
        }
    }
    doTake( actor ) =
    {
        if ( self.tieItem )
        {
            "(You untie it first, of course.) ";
            self.tieItem := nil;
            self.isfixed := nil;
        }
        pass doTake;
    }
    verDoClimb( actor ) =
    {
        if ( self.tieItem = nil )
            "Climbing down the rope in its present configuration would
            get you nowhere. ";
    }
    doClimb( actor ) =
    {
        "You climb down the rope...\b";
        Me.travelTo( pitBottom );
    }
    verDoClimbdown( actor ) = {}
    doClimbdown( actor ) = { self.doClimb( actor ); }
;

pitBottom: room
    sdesc = "Huge Cavern"
    ldesc = "You are in a huge and obviously artificial cavern. The cave
     has apparently been dug out over a long period of time; some parts
     look very old, and other areas look comparatively recent. A small bronze
     plaque affixed to one of the older walls reads, \"Great Undergraduate
     Excavation - 1982.\"
     From high above, a small opening in
     the ceiling casts a dim glow over the vast chamber. A rope extends
     from the opening above. Passages of various ages lead north, south,
     east, west, southeast, and southwest. "
    up =
    {
        "It's a long climb, but you somehow manage it.\b";
        return( pitTop );
    }
    se = chuteroom
    east = biohall1
    south = bank
    north = cave
    sw = insOffice
    west = machineshop
;

pitplaque: fixeditem, readable
    noun = 'plaque'
    sdesc = "bronze plaque"
    adjective = 'bronze' 'small'
    location = pitBottom
    ldesc = "Great Undergraduate Excavation\n\t\t\t1982"
;

insOffice: room
    sdesc = "Insurance Office"
    ldesc =
    {
        "You are in an insurance office. Like most insurance offices,
        the area is rather non-descript. The exit is northeast. ";
        if ( not self.isseen )
        {
            "\n\tAs you walk into the office, a large metallic robot, very
            much like the traditional sci-fi film robot, but wearing a dark
            polyester business suit, zips up to you. \"Hi, I'm Lloyd the
            Friendly Insurance Robot,\" he says in a mechanical British
            accent. \"You look like you could use some insurance! Here, let
            me prepare a policy for you.\"
            \n\tLloyd scurries around the room, gathering papers and
            studying charts, occasionally zipping up next to you and
            measuring your height and other dimensions, making all kinds
            of notes, and generally scampering about. After a few minutes,
            he comes up to you, showing you a piece of paper.
            \n\t\"I have the perfect policy for you. Just one dollar will
            buy you a hundred thousand worth of insurance!\" He watches
            you anxiously. ";
            
            notify( lloyd, #offerins, 0 );
        }
    }
    ne = pitBottom
    out = pitBottom
;

/*
 *   Lloyd the Friendly Insurance Robot is a full-featured actor. He will
 *   initially just wait in his office until paid for a policy, but will
 *   thereafter follow the player around relentlessly.  Lloyd doesn't
 *   interact much, though; he just hangs around and does wacky things.
 */
lloyd: Actor
    noun = 'lloyd' 'him'
    sdesc = "Lloyd"
    adesc = "Lloyd"
    thedesc = "Lloyd"
    isHim = true
    ldesc = "Lloyd the Friendly Insurance Robot is a strange combination
     of the traditional metallic robot and an insurance salesman; over his
     bulky metal frame is a polyester suit. "
    actorAction( v, d, p, i ) =
    {
        if ( v = helloVerb )
            "\"Hello,\" Lloyd responds cheerfully. ";
        else if ( v = followVerb and d = Me )
        {
            if ( self.offering )
                "\"Sorry, but I must stay here until I've made a sale.\" ";
            else
                "\"I will follow you,\" Lloyd says. \"That will allow me
                to pay any claim you make immediately should the need arise.
                It's just one of the ways we keep our overhead so low.\" ";
        }
        else
            "\"I'm sorry, that's not in your policy.\" ";
        exit;
    }
    verDoAskAbout( actor, io ) = {}
    doAskAbout( actor, io ) =
    {
        if ( io = policy )
            "\"Your policy perfectly fits your needs, according to my
            calculations,\" Lloyd says. \"I'm afraid it's much too
            complicated to go into in any detail right now, but you have
            my assurances that you won't be disappointed.\" ";
        else
            "\"I'm afraid I don't know much about that,\" Lloyd says
            apologetically. ";
    }
    actorDesc =
    {
        if ( self.offering )
            "Lloyd is here, offering you an insurance policy for only
            one dollar. ";
        else
            "Lloyd the Friendly Insurance Robot is here. ";
    }
    offering = true
    offermsg =
    [
        'Lloyd waits patiently for you to make up your mind about the
         insurance policy.'
        'Lloyd watches you expectantly, hoping you will buy the insurance
         policy.'
        'Lloyd shows you the insurance policy again. "Only a dollar," he
         says.'
        'Lloyd looks at you intently. "What can I do to make you buy this
         insurance policy right now?" he asks rhetorically.'
        'Lloyd reviews the policy to make sure it looks just right, and
         offers it to you again.'
    ]
    offerins =
    {
        if ( self.location = Me.location )
        {
            "\b";
            say(self.offermsg[rand( 5 )]);
        }
    }
    followmsg =
    [
        'Lloyd watches attentively to make sure you don\'t hurt yourself.'
        'Lloyd hums one of his favorite insurance songs.'
        'Lloyd gets out some actuarial tables and does some computations.'
        'Lloyd looks through his papers.'
        'Lloyd checks the area to make sure it\'s safe.'
    ]
    follow =
    {
        if ( Me.location = machinestorage ) return;
        
        "\b";
        if ( self.location <> Me.location )
        {
            if ( Me.location = railcar )
                "Lloyd hops into the railcar, showing remarkable agility
                for such a large mechanical device. ";
            else if ( self.location = railcar )
                "Lloyd hops out of the railcar. ";
            else if ( Me.location = pitTop and self.location = pitBottom )
                "Amazingly, Lloyd scrambles up the rope and joins you. ";
            else if ( Me.location = pitBottom and self.location = pitTop )
                "Lloyd descends smoothly down the rope and joins you. ";
            else if (( Me.location = tunnel7 and self.location = tunnel12 )
             or ( Me.location = tunnel12 and self.location = tunnel7 ))
                "Somehow, Lloyd manages to squeeze through the crawl. ";
            else if ( Me.location = quad )
                "Lloyd follows you. When he sees the apparent radioactive
                waste spill, he is quite alarmed. After a moment, though,
                he deduces that the spill is a staged part of the Ditch Day
                festivities, and he calms down. ";
            else if ( Me.location = storage )
                "Lloyd enters the storage room. Upon seeing the guard, he
                rolls over and starts giving his insurance pitch. After a
                moment, he notices the guard is unconscious. \"It's just as
                well,\" Lloyd confides; \"security work is awfully risky, and
                his rates would have been quite high.\" ";
            else
                "Lloyd follows you. ";
                
            self.moveInto( Me.location );
        }
        else
        {
            say(self.followmsg[rand( 5 )]);
        }
    }
    verIoGiveTo( actor ) = {}
    ioGiveTo( actor, dobj ) =
    {
        if ( dobj = dollar )
            self.doPay( actor );
        else if ( dobj = darbcard )
            "Lloyd looks at you apologetically. \"So sorry, I must insist
            on cash,\" he says. ";
        else
            "Lloyd doesn't appear interested. ";
    }
    verDoPay( actor ) = {}
    doPay( actor ) =
    {
        if ( not self.offering )
        {
            "Lloyd looks at you, confused. \"I've already sold you all
            the insurance you need!\" ";
        }
        else if ( dollar.isIn( actor ))
        {
            "Lloyd graciously accepts the payment, and hands you a copy
            of your policy. \"You might wonder how we keep costs so low,\"
            Lloyd says. \"It's simple: we're highly automated, which keeps
            labor costs low; I run the whole company, which keeps the
            bureaucratic overhead low; and, most importantly, I follow you
            everywhere you go for the duration of the policy, ensuring that
            you're paid on the spot should anything happen, which means we
            don't have to waste money investigating claims!\" ";
            
            unnotify( self, #offerins );
            notify( self, #follow, 0 );
            dollar.moveInto( nil );
            policy.moveInto( Me );
            self.offering := nil;
            Me.isinsured := true;
        }
        else
        {
            "You don't have any money with which to pay Lloyd. ";
        }
    }
    location = insOffice
;

policy: readable
    sdesc = "insurance policy"
    adesc = "an insurance policy"
    iscrawlable = true
    noun = 'policy'
    adjective = 'insurance'
    location = lloyd
    ldesc =
    {
        "The insurance policy lists the payment schedule for hundreds
        of types of injuries; the list is far too lengthy to go into in any
        detail here, but rest assured, ";
        if ( lloyd.offering )
            "it looks like an excellent deal. ";
        else
            "you're highly satisified with what you
            got for your dollar. You feel extremely well protected. ";
    }
;

machineshop: room
    sdesc = "Machine Shop"
    ldesc = "You are in the machine shop. It appears that this huge
     chamber was once used to build and maintain the equipment that
     was used to create the Great Undergraduate Excavation.  Though
     most of the equipment is gone now, one very large and strange
     machine dominates the center of the room.
     The exit is east, and a small passage leads north. "
    east = pitBottom
    out = pitBottom
    north = machinestorage
;

machine: fixeditem
    sdesc = "machine"
    noun = 'machine'
    location = machineshop
    ldesc = "The machine is unlike anything you've seen before; it's not
     at all clear what its purpose is. The only feature that looks like it
     might do anything useful is a large red button labelled \"DANGER!\" "
;

machinebutton: buttonitem
    location = machineshop
    sdesc = "red button"
    adjective = 'red'
    doPush( actor ) =
    {
        "As you push the button, the machine starts making horrible noises
        and flinging huge metal rods in all directions. Enormous clouds of
        smoke rise from the machine as it flails about. After a few minutes
        of this behavior, you think to step back from the machine.  You're
        not fast enough, though; before you can escape it, a stray metal
        bar flings itself against your thumb, creating a sensation not unlike
        intense pain. ";
        
        if ( lloyd.location = self.location )
        {
            "\n\t";
            if ( self.isscored )
                "Lloyd looks at you apologetically. \"I don't want to sound
                patronizing, but you knew it would do that. I'm afraid I can't
                accept a claim for that injury, as it was effectively
                self-inflicted.\" He looks at you sadly. \"I do sympathize,
                though. That must be quite painful,\" he understates. ";
            else
            {
                self.isscored := true;
                "Lloyd rolls over and looks at your thumb. \"That looks
                awful,\" he says as you jump about, holding your thumb.
                Lloyd produces a thick pile of paper and starts leafing
                through it. \"Temporary loss of use of one thumb... ah,
                yes, here it is. That injury pays five dollars.\" Lloyd puts
                away his papers and produces a crisp new five dollar bill,
                which you accept (with your other hand). ";
                money.moveInto( Me );
            }
        }
    }
;

machinestorage: darkroom
    sdesc = "Storage Closet"
    ldesc = "You are in a small storage closet off the machine shop.
     The exit is south. "
    south = machineshop
    out = machineshop
;

happygear: treasure
    location = machinestorage
    noun = 'gear'
    adjective = 'mr.' 'mr' 'happy' 'mister'
    sdesc = "Mr.\ Happy Gear"
    thedesc = "Mr.\ Happy Gear"
    adesc = "Mr.\ Happy Gear"
    ldesc = "It's an ordinary gear, about an inch in diameter; the only
     notable feature is that it has holes cut in such a manner that it
     looks like a happy face. "
;

bank: room
    sdesc = "Bank"
    ldesc = "You're in what was once the Great Undergraduate Excavation's
     bank. It doesn't appear to get much use any more. The exit is north,
     and a small passage leads south. "
    north = pitBottom
    south = bankvault
    out = pitBottom
;

bankvault: room
    sdesc = "Vault Room"
    ldesc = "The feature dominating this room is the bank's safe.
     The only exit is north. "
    north = bank
    out = bank
;

banksafe: fixeditem, openable
    sdesc = "safe"
    noun = 'safe' 'door' 'vault'
    location = bankvault
    isopen = nil
    ldesc =
    {
        if ( self.isblasted )
        {
            "The safe looks as though it has suffered some sort of
            intense trauma lately; the door is just barely hanging on
            its hinges, leaving the contents of the safe quite exposed. ";
            pass ldesc;
        }
        else
        {
            "The safe is huge, like the type you might find in a bank.
            The only notable features are a huge metal door (quite closed),
            and a large slot labelled \"Night Deposit Slot.\" ";
        }
    }
    doOpen( actor ) =
    {
        if ( self.isblasted ) pass doOpen;
        else
            "You can't open such a secure safe without resorting
             to some sort of drastic action. ";
    }
;

darbcard: treasure
    sdesc = "DarbCard"
    noun = 'darbcard' 'card'
    adjective = 'darb'
    location = banksafe
;

bankslot: fixeditem, container
    sdesc = "night deposit slot"
    noun = 'slot'
    adjective = 'night' 'deposit'
    location = bankvault
    ldesc = "The slot is very large, big enough to put a large sack of
     money into. Unfortunately, you won't have much luck extracting anything
     from the slot, since it has been carefully constructed to allow items
     to enter, but not leave. "
    ioPutIn( actor, dobj ) =
    {
        "\^<< dobj.thedesc >> disappears into the deposit slot. ";
        dobj.moveInto( banksafe );
    }
;

cave: room
    sdesc = "Tunnel"
    ldesc = "You're in a north-south tunnel. The tunnel slopes steeply
     downward to the north. "
    north = railway1
    down = railway1
    south = pitBottom
    up = pitBottom
;

railway1: room
    sdesc = "Subway Station"
    ldesc = "You're in a very large musty chamber deep underground. In the
     center of the room is a small rail car. Strangely, the car is sitting on
     the floor; there are no rails under the car, or, indeed, in the station
     at all. You look around, and notice about three meters up the east wall
     is a round tunnel. A passage leads south. "
    south = cave
    destination = railway2
    tunneltime = 3
    east =
    {
        "The tunnel is too high up the wall. You won't be able to enter
        it without benefit of the railcar. ";
        return( nil );
    }
;

class rtunnel: fixeditem
    sdesc = "tunnel"
    noun = 'tunnel'
    verDoEnter( actor ) = {}
    doEnter( actor ) =
    {
        railway1.east;
    }
;

rtunnel1: rtunnel
    location = railway1
;

rtunnel2: rtunnel
    location = railway2
;

railway2: room
    sdesc = "Subway Station"
    ldesc = "You're in a subway station. About three meters up the west
     wall is a tunnel; a passage (at ground level) leads south. A railcar
     is sitting on the floor in the center of the room. "
    south = computercenter
    destination = railway1
    tunneltime = 3
    west =
    {
        "The tunnel is too high up the wall. You won't be able to enter
        it without benefit of the railcar. ";
        return( nil );
    }
;

computercenter: room
    sdesc = "Computer Center"
    ldesc = "You're in a computer room. Unfortunately, all the equipment
     here is hopelessly out of date and doesn't interest you in the least.
     The exit is north. "
    north = railway2
;

compequip: decoration
    sdesc = "computer equipment"
    noun = 'equipment'
    adjective = 'computer'
    location = computercenter
    ldesc = "The equipment is all very outdated. It's not the least bit
     interesting. "
;

randombook: treasure, readable
    sdesc = "book"
    ldesc = "The book is entitled \"A Million Random Digits.\" In flipping
     through the book, you find that it is, in fact, a million random digits,
     nicely tabulated and individually numbered from 0 to 999,999 (computer
     people always start numbering at 0). "
    noun = 'book' 'digits'
    adjective = 'million' 'random' 'digits' 'numbers'
    location = computercenter
;

railtunnel: room
    sdesc = "Tunnel"
    ldesc = "The tunnel is rather non-descript. "
;

railcar: fixeditem, vehicle, container
    location = railway1
    isdroploc = true        // stuff dropped while on board ends up in railcar
    sdesc = "rail car"
    noun = 'car' 'railcar'
    adjective = 'rail'
    ldesc =
    {
        "This is a small rail car, big enough for a couple of people.
         It has a small control panel, which consists of a green button,
         a gauge, and a small hole labelled \"Coolant.\" ";
         if ( funnel.location = railhole )
            "The hole seems to contain a funnel. ";
         railmeter.ldesc;
    }
    travel =
    {
        if ( self.location <> railtunnel )
        {
            "\bThe car rises to about three meters off the floor. It then
            starts to accelerate toward the tunnel, and plunges into the
            tunnel with a rush of air. ";
            self.destination := self.location.destination;
            self.tunneltime := self.location.tunneltime;
            self.moveInto( railtunnel );
        }
        else if ( self.tunneltime > 0 )
        {
            "\bThe car races down the tunnel at terrifying speed. ";
            self.tunneltime := self.tunneltime - 1;
        }
        else
        {
            "\bThe car starts to decelerate sharply. After a few more seconds,
            it emerges into a station and glides to a halt. It slowly
            descends to the ground; once settled, the hum of its engine
            gradually disappears. ";
            self.isActive := nil;
            self.moveInto( self.destination );
            unnotify( self, #travel );
        }
    }
    checkunboard =
    {
        if ( self.isActive )
        {
            "Please wait until the railcar has come to a complete and
            final stop, and the captain has turned off the \"Fasten Seat
            Belt\" sign. (Actually, I made up the part about the \"Fasten
            Seat Belt\" sign, but you'll have to wait until the car
            has stopped nonetheless.) ";
            return( nil );
        }
        else return( true );
    }
    out =
    {
        if ( self.checkunboard ) pass out;
        else return( nil );
    }
    doUnboard( actor ) =
    {
        if ( self.checkunboard ) pass doUnboard;
    }
;

railmeter: fixeditem
    location = railcar
    sdesc = "gauge"
    noun = 'gauge' 'meter'
    ldesc =
    {
        "The gauge is not labelled with any units you recognize, but
         the arc is divided into regions colored green, yellow, and red. The
         needle is currently in the ";
        if ( railcar.iscooled ) "green"; else "red";
        " section of the scale. ";
    }
;

railhole: fixeditem, container
    location = railcar
    sdesc = "hole"
    noun = 'hole'
    adjective = 'coolant'
    ldesc =
    {
        if ( funnel.location = self )
            "A funnel is in the hole. ";
        else if ( railcar.iscooled )
            "Wisps of water vapor rise from the hole. ";
        else
            "The hole is labelled \"Coolant.\" It's about an inch
            or so in diameter. ";
    }
    verIoPourIn( actor ) = {}
    ioPourIn( actor, dobj ) = { self.ioPutIn( actor, dobj ); }
    ioPutIn( actor, dobj ) =
    {
        if ( dobj = funnel )
        {
            "A perfect fit! ";
            funnel.moveInto( self );
        }
        else if ( dobj = ln2 )
        {
            if ( funnel.location = self )
            {
                if ( railcar.iscooled )
                    "It's already full of liquid nitrogen! ";
                else
                {
                    "You carefully pour the liquid nitrogen into the
                    funnel.  It doesn't take very much before the tank
                    is full. ";
                    railcar.iscooled := true;
                }
            }
            else
            {
                "The hole is too small; most if not all of the liquid
                nitrogen you pour spills all around, rather than into
                the hole. ";
            }
        }
        else
        {
            "It won't fit in the hole. ";
        }
    }
;

railbutton: buttonitem
    location = railcar
    sdesc = "green button"
    adjective = 'green'
    doPush( actor ) =
    {
        if ( Me.location <> railcar )
        {
            "Get in the railcar first. ";
        }
        else if ( railcar.isbroken )
        {
            "Nothing happens. ";
        }
        else if ( railcar.isActive )
        {
            "Nothing happens. Perhaps this is because you have
            already pushed the button quite recently. ";
        }
        else if ( railcar.iscooled )
        {
            "A low-frequency hum sounds from within the railcar. After
            a few moments, it starts to levitate off the track. ";
            notify( railcar, #travel, 0 );
            railcar.isActive := true;
        }
        else
        {
            "A low-frequency hum sounds from within the railcar. It grows
            in strength, and soon starts to vibrate the whole car. You smell
            the familiar odor of burning electronic components. Suddenly,
            a bright light flashes underneath the railcar, a cloud of thick
            black smoke rises, and the humming stops. It appears you have
            toasted the railcar. ";
            railcar.isbroken := true;
        }
    }
;

biohall1: room
    sdesc = "Hall"
    ldesc = "You are in an east-west hallway. A passage labelled \"Bio Lab\"
     leads south. "
    west = pitBottom
    east = biohall2
    south = biolab
;

biolab: room
    sdesc = "Bio Lab"
    ldesc =
    {
        "You are in the Biology Lab. All sorts of strange equipment is
        scattered around the room. A lab bench is in the center of the room,
        and on one wall is a cabinet (which is ";
        if ( biocabinet.isopen ) "open"; else "closed";
        "). A passage leads north. ";
    }
    north = biohall1
;

bioEquipment: decoration
    sdesc = "strange equipment"
    noun = 'equipment'
    adjective = 'strange'
    location = biolab
    ldesc = "The equipment is entirely unfamiliar to you. "
;

biobench: fixeditem, surface
    noun = 'bench'
    adjective = 'lab'
    sdesc = "lab bench"
    location = biolab
    ldesc =
    {
        "The bench is topped with one of those strange black rubber surfaces
        that seemingly all scientific lab benches have. ";
        pass ldesc;
    }
;

funnel: container
    sdesc = "funnel"
    noun = 'funnel'
    location = biobench
    ioPutIn( actor, dobj ) =
    {
        if ( dobj = ln2 )
        {
            if ( self.location = railhole or self.location = bottle )
                self.location.ioPutIn( actor, dobj );
            else
                "The liquid nitrogen pours through the funnel, lands
                nowhere in particular, and evaporates. ";
        }
        else
        {
            "It wouldn't accomplish anything to put ";
            dobj.thedesc; " into the funnel. ";
        }
    }
    ldesc =
    {
        if ( self.location = bottle or self.location = railhole )
        {
            "The funnel is stuck into "; self.location.adesc; ". ";
        }
        else
            "It's a normal white plastic funnel, about six inches
            across at its wide end and about half an inch at its
            narrow end. ";
    }
    verIoPourIn( actor ) = {}
    ioPourIn( actor, dobj ) = { self.ioPutIn( actor, dobj ); }
;

biohall2: room
    sdesc = "Hall"
    ldesc =
    {
        "You are at the east end of an east-west hallway. A doorway
         leads east. ";
        if ( not self.isseen )
        {
            notify( biocreature, #menace, 0 );
        }
    }
    west = biohall1
    east =
    {
        if ( biocreature.location = self )
        {
            if ( slime.location = nil )
            {
                "The creature grabs you and pushes you back, depositing
                a huge glob of slime on you in the process. ";
                slime.moveInto( Me );
                slime.isworn := true;
            }
            else "The creature won't let you pass. ";
            return( nil );
        }
        else return( biooffice );
    }
;

slime: clothingItem
    noun = 'glob' 'slime'
    sdesc = "glob of slime"
    doWear( actor ) =
    {
        "No, thank you. ";
    }
;

biocreature: Actor
    location = biohall2
    sdesc = "creature"
    noun = 'creature'
    isHim = true
    ldesc = "It looks like the result of a biological experiment that
      failed (or succeeded, depending on who performed the experiment). "
    actorDesc = "An enormous creature is blocking the hallway to the east.
      He (please don't press for details as to how you know, but \"he\"
      is the appropriate pronoun here) appears to be part human, but
      exactly what part is not clear. The creature's leathery skin is
      a bright green, and is largely covered with a thick transluscent
      slime. "
    menaceMessage =
    [
        'The creature roars a huge roar in your general direction.'
        'The creature menaces you.'
        'In a tender moment, the creature produces a magazine and opens up
         the centerfold. He looks longingly at the picture. After a few
         moments, he notices you again, and puts away the magazine; as he\'s
         putting it away, you see that it\'s a copy of "Playmutant."'
        'The creature looks at you warily.'
        'The creature growls at you, showing his enormous pointy fangs.'
    ]
    menace =
    {
        if ( self.location = Me.location )
        {
            "\b";
            say( self.menaceMessage[rand( 5 )]);
        }
    }
;

biooffice: room
    sdesc = "Bio Office"
    ldesc = "You are in the Biology Office. A large desk dominates the
     room. The exit is west. "
    west = biohall2
;

biodesk: fixeditem, surface
    noun = 'desk'
    adjective = 'large'
    location = biooffice
    sdesc = "desk"
;

biocabinet: openable, fixeditem
    noun = 'cabinet'
    location = biolab
    sdesc = "cabinet"
    isopen = nil
;

class chemitem: item
    location = biocabinet
    noun = 'chemical'
    plural = 'chemicals'
    adesc = { "some "; self.sdesc; }
    ldesc =
    {
        "It's a small lump of goo. The only identification is
         a label reading \""; self.sdesc; ".\" ";
    }
;
    
gfxq3: chemitem
    noun = 'GF-XQ3'
    sdesc = "GF-XQ3"
;

gfxq9: chemitem
    noun = 'GF-XQ9'
    sdesc = "GF-XQ9"
;

polyred: chemitem
    noun = 'red'
    adjective = 'poly'
    sdesc = "Poly Red"
;

polyblue: chemitem
    noun = 'blue'
    adjective = 'poly'
    sdesc = "Poly Blue"
;

compoundT99: chemitem
    noun = 't99'
    adjective = 'compound'
    sdesc = "Compound T99"
;

compoundT30: chemitem
    noun = 't30'
    adjective = 'compound'
    sdesc = "Compound T30"
;

clonemaster: container
    noun = 'master' 'clonemaster'
    adjective = 'clone'
    location = biobench
    sdesc = "CloneMaster"
    ldesc =
    {
        "The CloneMaster is a simple machine. It consists of a button
        marked \"Clone,\" and a small receptacle. ";
         clonerecept.ldesc;
    }
    ioPutIn( actor, dobj ) = { clonerecept.ioPutIn( actor, dobj ); }
    verDoTakeOut( actor, io ) = { clonerecept.verIoTakeOut( actor, io ); }
;

clonerecept: fixeditem, container
    sdesc = "receptacle"
    noun = 'receptacle'
    location = clonemaster
    ldesc =
    {
        "The receptacle is somewhat like that of a kitchen blender. ";
        pass ldesc;
    }
;

clonebutton: buttonitem
    sdesc = "clone button"
    adjective = 'clone'
    doPush( actor ) =
    {
        if ( slime.location = clonerecept )
        {
            "The CloneMaster clicks and whirs for several seconds. ";
            if ( gfxq3.location = clonerecept and
             polyblue.location = clonerecept and
             compoundT99.location = clonerecept
             and length( clonerecept.contents ) = 4 )
            {
                "A monstrous female version (again, don't ask how you know
                 it's female) leaps from the tiny machine";
                if ( Me.location = biocreature.location )
                {
                    ". The two monsters look at each other with passion in
                    their mutant eyes. They run to each other with open arms,
                    seemingly in slow motion. They embrace, engage in some
                    mushy behavior, and then run away together to elope. ";
                    biocreature.moveInto( nil );
                    unnotify( biocreature, #menace );
                }
                else
                    ", looks around, and, seeing nothing of
                    interest, runs off. ";
            }
            else
                "An exact duplicate of the monstrous creature whose slime
                you placed in the CloneMaster leaps forth from the tiny
                machine. He looks at you menacingly for a moment, then
                runs off into the distance, never to be seen again. ";
                
            slime.moveInto( nil );
        }
        else "Nothing happens. ";
    }
    location = clonemaster
;

omega: treasure
    sdesc = "Great Seal of the Omega"
    noun = 'seal' 'omega' 'stamp'
    adjective = 'great' 'rubber'
    location = biodesk
    ldesc = "The Great Seal is a large rubber stamp, about an inch and
     a half square. The stamp consists of a large circle that is filled by a
     giant capital omega, under which is the word \"Approved.\" Around the
     outside of the circle, the words \"The Great Seal of the Omega\" are
     inscribed. "
;

rope2: fixeditem
    sdesc = "rope"
    noun = 'rope'
    location = pitBottom
    ldesc = "The rope extends from the opening in the ceiling high above. "
    verDoTake( actor ) =
    {
        "The rope seems to be tied to something from above (which would
        probably explain why it's extending up to the ceiling in the
        first place, you deduce in a rare moment of lucid thinking). ";
    }
    verDoClimbup( actor ) = {}
    doClimbup( actor ) = { self.doClimb( actor ); }
    verDoClimb( actor ) = {}
    doClimb( actor ) =
    {
        "It's a long climb, but you somehow manage it.\b";
        Me.travelTo( pitTop );
    }
;
