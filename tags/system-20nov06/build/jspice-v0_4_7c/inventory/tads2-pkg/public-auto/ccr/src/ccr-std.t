/*
 * Colossal Cave Revisited
 *
 * A remake of Willie Crowther and Don Woods' classic Adventure.
 * Converted from Donald Ekman's PC port of the original FORTRAN source.
 * TADS version by David M. Baggett for ADVENTIONS.
 *
 * Please document all changes in the history so we know who did what.
 *
 * This source code is copylefted under the terms of the GNU Public
 * License.  Essentially, this means that you are free to do whatever
 * you wish with this source code, provided you do not charge any
 * money for it or for any derivative works.
 *
 * ADVENTIONS distributes this game, but you are free to do what you will
 * with it, provided you adhere to the terms in the GNU Public License.
 * Send correspondence regarding this game or original works distributed
 * by ADVENTIONS to 
 *
 *	ADVENTIONS
 *	PO Box 851
 *	Columbia, MD 21044
 *
 * If you would like a catalog of releases, please enclose a SASE.  Thanks!
 *
 * Contributors
 *
 *	dmb	In real life:	David M. Baggett
 *		Internet:	<dmb@ai.mit.edu>
 *		Compu$erve:	76440,2671 (ADVENTIONS account)
 *		GEnie:		ADVENTIONS
 *
 * Modification History
 *
 * 1-Jan-93	dmb	rec.arts.int-fiction BETA release (source only)
 *                      For beta testing only -- not for general
 *			distribution.
 *
 */

/*
 * This file includes the typical standard definitions.
 */
check_for_closing: function;
check_for_endgame: function;
makend: function;

/*
 * This is the program's entry point.
 */
init: function
{
	local l;

	"\b\b\b\b";
	version.sdesc;	// display the game's name and version number
	"\b";

	//
	// See if the player wants an easy or normal game.  (This
	// was the "Do you want instructions?" query in the original.)
	// In novice mode the lamp batteries last longer.
	//
	// It might also make sense to make some other things easier, like
	// the number of dwarves or their tenacity, but for now we only make
	// the change that was made for the original's novice mode.
	//
	// Novice mode costs the player global.novicepoints.
	//
	"Shall I go easy on you this game?  (An easy game will cost you ";
	say(-1 * global.novicepoints); " points.)\n>";
	if (yorn()) {
		incscore(global.novicepoints);

		//
		// Change some stuff to make the game easier.
		//
		brass_lantern.turnsleft := 1000;
	}

	"\b";

	//
	// Randomize after the first turn.  (This allows us to make a verb
	// that prevents randomization for regression testing.)
	//
	setfuse(makend, 1, nil);
	
	setdaemon(turncount, nil);		// start turn counter daemon
	setdaemon(check_for_closing, nil);	// start cave closing daemon
	setdaemon(check_for_endgame, nil);	// start endgame daemon
	Me.location := At_End_Of_Road;		// move player -> 1st location
	Me.location.lookAround(true);		// show player where he is

	//
	// Initialize non-player characters (dwarves, pirate) if we're
	// in debug mode.  Otherwise do it from preinit.
	//
	if (global.debug)
		initNPC();

	//
	// Check room connections for integrity.
	//
	check_connections();
}
makend: function(parm)
{
	if (global.nondeterministic) {
		randomize();
	}
	else {
		"\b*** This will be a deterministic game. ***";
	}

	//
	// Once we've randomized (if we're going to at all), place
	// all the NPC's.
	//
	Dwarves.place;
	notify(Dwarves, &move, 0);

	Pirates.place;
	notify(Pirates, &move, 0);
}

/*
 * The following function is run at compile time to build lists and
 * do other compute-intensive things ahead of time.
 */
preinit: function
{
	local o;

	//
	// Construct list of light sources
	//
	global.lamplist := [];
	o := firstobj(lightsource);
	while (o <> nil) {
		global.lamplist := global.lamplist + o;
		o := nextobj(o, lightsource);
	}

	//
	// Count treasures to get initial number of treasures
	// left to find.
	//
	global.treasures := 0;
	o := firstobj(CCR_treasure_item);
	while (o <> nil) {
		global.treasurelist := global.treasurelist + o;
		global.treasures := global.treasures + 1;

		o := nextobj(o, CCR_treasure_item);
	}

	//
	// Initialize non-player characters (dwarves, pirate) from
	// here if we're not in debug mode.  Otherwise do it in init.
	//
	if (not global.debug)
		initNPC();
}

die: function
{
	local	resurrect;

	P(); I();

	// DMB: "reincarnate" in the text below should actually
	// be "resurrect," since presumably you're coming back
	// as the same person you were before.  I have left the
	// original text as is, however, for the sake of purity.

	resurrect := nil;	// assume no resurrection

	if (global.closed) {
		"It looks as though you're dead.  Well, seeing as how 
		it's so close to closing time anyway, I think we'll 
		just call it a day.";

		call_it_a_day();
	}
	else if (global.deaths = 0) {
		"Oh dear, you seem to have gotten yourself killed.  I 
		might be able to help you out, but I've never really 
		done this before.  Do you want me to try to 
		reincarnate you?\b>";

		if (yorn()) {
			"\bAll right.  But don't blame me if something 
			goes wr...... \b \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
			\ \ \ \ \ \ --- POOF!! --- \bYou are engulfed 
			in a cloud of orange smoke.  Coughing and 
			gasping, you emerge from the smoke and 
			find that you're....";

			resurrect := true;
		}
		else
			"\bVery well.";
	}
	else if (global.deaths = 1) {
		"You clumsy oaf, you've done it again!  I don't know 
		how long I can keep this up.  Do you want me to try 
		reincarnating you again?\b>";

		if (yorn()) {
			"\bOkay, now where did I put my orange 
			smoke?....  >POOF!<\bEverything disappears in 
			a dense cloud of orange smoke.";

			resurrect := true;
		}
		else
			"\bProbably a wise choice.";
	}
	else if (global.deaths = 2) {
		"Now you've really done it!  I'm out of orange smoke! 
		You don't expect me to do a decent reincarnation 
		without any orange smoke, do you?\b>";

		if (yorn()) {
			"\bOkay, if you're so smart, do it yourself!  
			I'm leaving!";
		}
		else
			"\bI thought not!";
	}

	global.deaths := global.deaths + 1;
	incscore(global.deathpoints);

	if (resurrect) {
		//
		// Resurrection:
		//
		// 1) Drop all player's items where he was killed.
		// 2) Move lamp outside of building and turn it off.
		// 3) Move the player into the building.
		//
		while (length(Me.contents) > 0)
			Me.contents[1].moveInto(Me.location);
		brass_lantern.turnoff;
		brass_lantern.moveInto(At_End_Of_Road);

		"\b";
		Me.travelTo(Inside_Building);
	}
	else {
		//
		// Player's done for good -- show score and quit.
		//
		scoreRank();
		terminate();
		quit();
		abort;
	}
}

/*
 * The player loses without any chance of reincarnation (for example,
 * if his batteries run out.)
 */
call_it_a_day: function
{
	scoreRank();
	terminate();
	quit();
	abort;
}

/*
 * The player has finished the game on a positive note.
 */
win: function
{
	scoreRank();
	terminate();
	quit();
	abort;
}

/*
 * Show score and ranking
 */
scoreRank: function
{
	local	pn;

	"You have scored "; say(global.score); " out of a possible ";
	say(global.maxscore); ", using "; say(global.turnsofar);
	if (global.turnsofar = 1)
		" turn.";
	else
		" turns.";

	"\n";
		
	if (global.score < 35) {
		//
		// DMB: This originally said, "Better luck next time,"
		// but this isn't really appropriate anymore since
		// we now give the player his ranking when he types
		// \"score.\"  (In the original, you only got your
		// rank when the game was over.)
		//
		"You are obviously a rank amateur.";
		pn := 35 - global.score;
	}
	else if (global.score < 100) {
		"Your score qualifies you as a Novice Class adventurer.";
		pn := 100 - global.score;
	}
	else if (global.score < 130) {
		"You have achieved the rating: \"Experienced Adventurer\".";
		pn := 130 - global.score;
	}
	else if (global.score < 200) {
		"You may now consider yourself a \"Seasoned Adventurer\".";
		pn := 200 - global.score;
	}
	else if (global.score < 250) {
		"You have reached \"Junior Master\" status.";
		pn := 250 - global.score;
	}
	else if (global.score < 300) {
		"Your score puts you in Master Adventurer Class C.";
		pn := 300 - global.score;
	}
	else if (global.score < 330) {
		"Your score puts you in Master Adventurer Class B.";
		pn := 330 - global.score;
	}
	else if (global.score < 349) {
		"Your score puts you in Master Adventurer Class A.";
		pn := 349 - global.score;
	}
	else {
		"All of Adventuredom gives tribute to you, Adventurer
		Grandmaster!";

		pn := 0;
	}

	"\n";

	if (pn > 0) {
		"To achieve the next higher rating, you need ";
		say(pn); " more ";

		if (pn = 1)
			"point.";
		else
			"points.";
	}
	else
		"To achieve the next higher rating would be a neat trick!";
	
	"\n";
}

/*
 * Print a nice message when we exit.
 */
terminate: function
{
	"\b";
	"Come back and visit the newly remodelled Colossal Cave soon!";
}

/*
 * What we say when the user enters a blank line.
 */
pardon: function
{
	"What?";
}

/*
 *   The numObj object is used to convey a number to the game whenever
 *   the player uses a number in his command.  For example, "turn dial
 *   to 621" results in an indirect object of numObj, with its "value"
 *   property set to 621.
 */
numObj: basicNumObj;  // use default definition from adv.t

/*
 *   strObj works like numObj, but for strings.  So, a player command of
 *     type "hello" on the keyboard
 *   will result in a direct object of strObj, with its "value" property
 *   set to the string 'hello'.
 *
 *   Note that, because a string direct object is used in the save, restore,
 *   and script commands, this object must handle those commands.
 */
strObj: basicStrObj;     // use default definition from adv.t

/*
 *   The "global" object is the dumping ground for any data items that
 *   don't fit very well into any other objects.  The properties of this
 *   object that are particularly important to the objects and functions
 *   are defined here; if you replace this object, but keep other parts
 *   of this file, be sure to include the properties defined here.
 */
global: object
	//
	// Scoring values
	// Points for treasures are kept in the treasures themselves.
	//
	score = 36		// start out with 36 points:
				// (2 + (-1 * quitpoints) +
				// (-1 * deathpoints) * 3)
	maxscore = 350		// maximum possible score
	novicepoints = -5	// points for playing in easy mode (neg.)
	quitpoints = -4		// points for quitting (neg.)
	deathpoints = -10	// points gained each time player dies (neg.)
	farinpoints = 25	// points for getting well into the cave
	wittpoints = 1		// points for reaching Witt's End
	closingpoints = 25	// points for surviving until cave closing time
	endpoints = 10		// points for getting to final puzzle
	almostpoints = 20	// points for *almost* getting final puzzle
	winpoints = 35		// points for winning the final puzzle

	treasures = 0		// treasures left to deposit;
				// filled in by preinit
	treasurelist = []	// list of all treasures in the game;
				// filled in by preinit

	//
	// NPC stuff
	//
	dwarves = 5		// number of dwarves wandering about the cave
				// (Was 5 in original.)
	pirates = 1		// number of pirates lurking in the cave
				// (Was 1 in original.)

	dtenacity = 96		// percentage chance that a dwarf will
				// follow the player if in an adjacent
				// location.  (Was 100 in original.)
	ptenacity = 50		// percentage chance that a pirate will
				// follow the player if in an adjacent
				// location.  Don't set this too high or
				// the game will get really bogus!

	//
	// Where to start dwarves and pirate(s) out.  Dwarves are placed
	// in the locations given by drawfloc; if no locations remain when
	// we're placing a dwarf, we just put him in a random room selected
	// from NPCrooms.
	//
	// Note that the player gets the axe from the dwarf, so it's
	// fairly important to put at least dwarf early on (but only
	// in a room that's not off limits to NPC's!)
	//
	// Ditto for pirate(s).
	//
	dwarfloc = [
		In_Hall_Of_Mists
	]
	pirateloc = []

	dwarfattack = 75	// percentage chance that a dwarf will
				// throw a knife at the player if he's
				// in the same location.  (Was 100 in
				// the original.)
	dwarfhit = 66		// percentage chance the player will
				// hit a dwarf with his axe
				// (Was 1 in 3 chance in the original.)
	dwarfaccuracy = 9	// percentage chance that a dwarf will
				// hit the player with a thrown knife
				// (Was 9.5 in the original.)

	//
	// Output formatting
	//
	verbose = nil		// we are currently in TERSE mode
	indent = true		// indent paragraph beginnings
	doublespace = true	// double space the text

	//
	// Other stuff
	//
	deaths = 0		// number of times the player has died
	closingtime = 30	// close this many turns after player takes
				// the last treasure.  (was 30 in original)
	bonustime = 20		// start endgame this many turns after
				// the cave closes.  In the original this
				// was 50, but since we've change things
				// slightly (the closing timer starts once
				// the player deposits the last treasure in
				// the building, not once he merely *sees*
				// it), we've had to make this value smaller.
				// If we were to leave it the way it was,
				// it would be very hard to finish the game
				// before the lamp batteries died.
	panictime = 15		// extend timer by this many turns when player
				// panics at closing time

	closed = nil		// is the cave closed yet?

	turnsofar = 0		// no turns have transpired so far 
	lamplist = []		// list of all known light providers
				// in the game
	NPCrooms = []		// list of rooms NPC's (dwarves, pirate)
				// can go to

	//
	// Special wizard stuff.  Don't mess with it!
	//
	nondeterministic = true	// default to nondeterministic game
	debug = nil		// debugging messages on/off
;

/*
 *   The "version" object defines, via its "sdesc" property, the name and
 *   version number of the game.  Change this to a suitable name for your
 *   game.
 */
version: object
	sdesc = {
		"\(Colossal Cave Revisited\)\n
		Version 1.0, released April 1993.\b";

		"A remake of Willie Crowther and Don Woods' classic
		Adventure.\n Converted from Donald Ekman's PC port of 
		the original FORTRAN source.\n TADS version by David 
		M.\ Baggett for \(ADVENTIONS\).\b";

		"\(Colossal Cave Revisited\) and its accompanying 
		source code are\n Copyright (C) 1993 David M.\ 
		Baggett."; P();

		I(); "This program is free software; you can 
		redistribute it and/or modify it under the terms of 
		version 2 of the GNU General Public License as 
		published by the Free Software Foundation."; P();

		I(); "This program is distributed in the hope that it 
		will be useful, but WITHOUT ANY WARRANTY; without 
		even the implied warranty of MERCHANTABILITY or 
		FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
		General Public License for more details."; P();

		I(); "You should have received a copy of the GNU 
		General Public License along with this program; if 
		not, write to the Free Software Foundation, Inc., 675 
		Mass Ave, Cambridge, MA 02139, USA."; P();

		I(); "\(ADVENTIONS\) distributes this game, but you are 
		free to do what you will with it, provided you adhere 
		to the terms in the GNU Public License v2. Send 
		correspondence regarding this game or other works 
		distributed by \(ADVENTIONS\) to"; P();

		"\t\(ADVENTIONS\)\n
		 \tPO Box 851\n
		 \tColumbia, MD 21044"; P();

		I(); "If you want to report a bug or typo, be sure to 
		include the version number of the copy you are 
		playing, as well as the configuration of the machine 
		you are running it on."; P();

		I(); "\(ADVENTIONS\) has many other games like this 
		available, including adventures in the popular 
		Unnkulian saga.  Send a self-addressed, stamped 
		envelope to the address above for a current catalog 
		of our releases, or drop us email online:\b

		\tCompuserve:\t76440,2671\n
		\tGEnie:\t\tADVENTIONS\n
		\tInternet:\tdmb@ai.mit.edu\b

		or on the following BBS's:\b

		\tFANTAZIA (410) 521-5636 (8N1)\n
		\tHigh Energy BBS (415) 493-2420 (8N1)"; P();

		"***"; P();

		I(); "Most game companies have abandoned interactive 
		fiction because it isn't profitable enough.  We think 
		that interactive novels are exciting and important 
		elements of the gaming world that offer possibilities 
		currently impossible to explore in graphics-oriented 
		settings.  We spend as much time on our games as 
		\"normal\" authors spend on novels.  Please support 
		us to help keep the interactive fiction genre alive.  
		Thanks, and have fun!"; P();

		"***";
	}
;

/*
 *   "Me" is the player's actor.  Pick up the default definition, basicMe,
 *   from "adv.t".
 */
Me: basicMe
	panicked = nil	// has the player panicked after closing time?
	
	// The original code only allowed the player to carry
	// seven objects at a time.  Weight wasn't taken into
	// consideration.

	maxbulk = 7

	//
	// Give the player points for getting a fair ways into
	// the cave.
	//
	awardedpointsforgettingfarin = nil
	travelTo(room) = {
		if (room = nil)
			pass travelTo;
		else if (global.closed and room.isoutside) {
			"A mysterious recorded voice groans into life 
			and announces, \"This exit is closed.  Please 
			leave via main office.\"";

			if (not self.panicked) {
				self.panicked := true;

				//
				// The player is obviously panicking
				// at closing time and is desperately
				// trying to get out.  In the original
				// code the endgame timer is (erroneously?)
				// set to 15 in this circumstance.
				//
				// Comments in the code suggest that the
				// intention was to *extend* the timer
				// by 15, so we'll do that here.
				//
				global.bonustime := global.bonustime +
					global.panictime;
			}
			
			return;		// no pass travelTo
		}
		else if (not self.awardedpointsforgettingfarin) {
			if (not room.notfarin) {
				incscore(global.farinpoints);
				self.awardedpointsforgettingfarin := true;
			}
		}

		pass travelTo;
	}
;

/*
 * darkTravel() is called whenever the player attempts to move from a dark
 * location into another dark location.
 *
 * This isn't quite the way the original worked, but it's close enough.
 */
darkTravel: function
{
	"It is now pitch dark.  If you proceed you will likely fall 
	into a pit."; 

	/*
	 * 1 in 4 chance of death.
	 */
	if (rand(4) = 1) {
		P(); I();
		"You fell into a pit and broke every bone in your body!";
		die();
	}
}
