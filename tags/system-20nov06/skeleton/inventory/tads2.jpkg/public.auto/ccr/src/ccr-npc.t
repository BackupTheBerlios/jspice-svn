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
 *  1-Jan-93	dmb	rec.arts.int-fiction BETA release (source only)
 *                      For beta testing only -- not for general
 *			distribution.
 * 20-Apr-93	dmb	Incorporated Mike Roberts' changes to make
 *			this a lot faster.  Uses the new intersect
 *			built-in, so CCR must now be built with TADS
 *			>= 2.0.13.
 *
 */

/*
 * This file handles non-player character (dwarves and pirate) movement.
 *
 * Be sure to update exitlist and/or npclist if you add any new travel
 * verbs to CCR_Room.
 */
initNPC: function
{
	local	o;

	//
	// Construct list of NPC exits for each room
	//
	o := firstobj(CCR_room);
	while (o <> nil) {
		if (not o.noNPCs) {
			//
			// Add this room to the global list of rooms
			// the NPC's can be in.
			//
			global.NPCrooms := global.NPCrooms + o;

			do_exitlist(o);
			do_npclist(o);
		}
		else if (global.debug) {
			//
			// Debugging info:
			// 
			"\b\"<< o.sdesc >>\" is off limits to NPC's."; 
		}

		o := nextobj(o, CCR_room);
	}
}

/*
 * Add standard exits to the list of exits that NPC's should check
 * when they're wandering about randomly.
 */
do_exitlist: function(o)
{
	local	exitlist, i, j, gotit;
        local   tot1, tot2;

	//
	// List of all exit property names that NPC's will consider.
	// Note that magic words are left out because NPC's don't
	// know them.
	//
	exitlist := [
		&north &south &east &west
		&ne &nw &se &sw
		&up &down &in &out

		&jump &upstream &downstream &forwards &outdoors 
		&left &right &cross &over &across &road &forest 
		&valley &stairs &building &gully &stream &rock &bed 
		&crawl &cobble &tosurface &dark &passage &low &canyon 
		&awkward &giant &view &pit &crack &steps &dome &hall 
		&barren &debris &hole &wall &broken &floor &toroom 
		&slit &slab &depression &entrance &secret &cave 
		&bedquilt &oriental &cavern &shell &reservoir &main 
		&office &fork
	];
        tot1 := length(exitlist);

	for (i := 1; i <= tot1; i++) {
		//
		// If this exit property is a simple
		// object (prop 2), NPC's can use it, so
		// add it to the room's NPC exit list.
		//
		// Make sure we don't add the same
		// desination room twice.  Just because
		// there are multiple travel verbs from
		// one place to another doesn't mean the
		// destination should be more likely.
		//
		if (proptype(o, exitlist[i]) = 2
					and not o.(exitlist[i]).noNPCs) {

			//
			// Search current exitlist for
			// this exit's destination.
			//
                        gotit := (find(o.NPCexits, o.(exitlist[i])) <> nil);
			if (not gotit)
				o.NPCexits := o.NPCexits + exitlist[i];
		}
	}
}

/*
 * Add NPC special exits to the list of exits that NPC's should check
 * when they're wandering about randomly.
 */
do_npclist: function(o)
{
	local	npclist, i, tot;

	//
	// NPC exits.  These get considered if even if they're methods.
	// The only way they won't be added to the list of exits to
	// try is if they're = nil and not methods.
	//
	npclist := [
		&NPCexit1 &NPCexit2 &NPCexit3 &NPCexit4
		&NPCexit5 &NPCexit6 &NPCexit7 &NPCexit8
	];

        tot := length(npclist);
	for (i := 1; i <= tot; i++) {
		//
		// If this NPC exit property is anything but
		// nil (i.e., just nil, and not a method
		// that returns nil). then NPC's can use it.
		// Methods that return nil are fine because
		// they might be conditional on some game
		// events, like the crystal bridge having
		// been created, etc.
		//
		if (proptype(o, npclist[i]) <> 5) // not = nil
			o.NPCexits := o.NPCexits + npclist[i];
	}
}

/*
 * Make sure NPC room connections are sound.
 */
check_connections: function
{
	local	o;

	o := firstobj(CCR_room);
	while (o <> nil) {
		if (not o.noNPCs)
			do_debug(o);

		o := nextobj(o, CCR_room);
	}
}
	
do_debug: function(o)
{
	local	i, tot;

	if (length(o.NPCexits) = 0) {
		P(); I();
		"Oh dear, someone seems to have damaged one of my 
		room connections.  The room \"";

		o.sdesc;

		"\" has no exits for NPC's to follow, but it's not 
		listed as off limits to NPC's.  Please notify the 
		cave management as soon as possible!";
	}
	else if (global.debug) {
		//
		// Debugging info:
		// 			
		"\b\""; o.sdesc; "\" has "; say(length(o.NPCexits));
		if (length(o.NPCexits) > 1)
			" NPC exits:";
		else
			" NPC exit:";

	        tot := length(o.NPCexits);
		for (i := 1; i <= tot; i++) {
			"\b\t-> ";
			if (o.(o.NPCexits[i]))
				o.(o.NPCexits[i]).sdesc;
			else
				"(nil)";
		}
	}
}

/*
 * A class defining some common things for NPC's.
 */
class NPC: object
	//
	// List of currect pirate locations.
	//
	loclist = []		// where they are
	newloclist = []		// where they're going

	//
	// Scatter any NPC's that are currently in
	// the room to random rooms in the cave.  (We
 	// have to make sure the new rooms aren't off
	// limits to dwarves, though.) 
	//
	scatter = {
		local	i, dest, len, r, tot;
                local   melocs;

		for (melocs := [], i := Me.location ; i ; i := i.location)
	            melocs += i;
                if (length(intersect(melocs, self.loclist))) return;

		self.newloclist := [];
		tot := length(self.loclist);
                len := length(global.NPCrooms);
		for (i := 1; i <= tot; i++) {
			if (find(melocs, self.loclist[i])) {
				//
				// Make sure we get a real location.
				//
				dest := nil;
				while (dest = nil) {
					r := rand(len);
					dest := global.NPCrooms[r];
				}

				self.newloclist += dest;
			}
			else {
				self.newloclist += self.loclist[i];
			}

		}
		self.loclist := self.newloclist;
	}

	//
	// Returns true if any NPC's of this type are in locations
	// adjacent to the player.  (I.e., if any NPC's could take
	// any exit that would bring them to the player's current
	// location.)
	//
	anyadjacent = {
		local	adjacent, i, j, len, dir, dest, melocs;
	        local   tot1;
		local   cur;

//"\nanyadjacent(enter)\n";
		for (melocs := [], i := Me.location ; i ; i := i.location)
	            melocs += i;

		adjacent := nil;
	        tot1 := length(self.loclist);
		for (i := 1; i <= tot1; i++) {
			len := length(self.loclist[i].NPCexits);
	                cur := self.loclist[i];
			for (j := 1; j <= len; j++) {
	                        dest := cur.(cur.NPCexits[j]);

				//
				// We need to check the destination
				// to be sure it exists.  It may be
				// nil if we called an NPCexit method.
				//
				if (dest) if (find(melocs, dest)) {
					adjacent := true;
					break;
				}
			}

			//
			// If we've found an adjacent pirate we
			// can stop looking.
			//
			if (adjacent)
				break;
		}

//"\nanyadjacent(exit)\n";
		return adjacent;
	}
;

/*
 * Move the dwarves.  See the global object in ccr-std.t for paramters.
 */
Dwarves: NPC, Actor
	rhetoricalturn = -999	// hack -- see yesVerb in ccr-verbs.t
	attackers = 0		// number of dwarves that attack this turn
	
	sdesc = "threatening little dwarf"
	ldesc = {
		"It's probably not a good idea to get too close.  Suffice
		it to say the little guy's pretty aggressive.";
	}

	noun = 'dwarf' 'dwarves' 'guy'
	adjective = 'threatening' 'nasty' 'little' 'mean'

	//
	// We don't use actorDesc for the dwarves because it gets printed
	// too early.  (We want to let the player know that a dwarf is
	// in the room as soon as the dwarf moves into the room, not at
	// the start of the next turn.)
	//
	actorDesc = {}

	locationOK = true	// tell compiler OK for location to be method
	location = {
		local	i, melocs;

		for (melocs := [], i := Me.location ; i ; i := i.location)
	            melocs += i;
		if (length(intersect(melocs, self.loclist)) = 0)
		    return(nil);

		//
		// Check each dwarf's location.  If at least one dwarf
		// is in the same location as the player, make our
		// location the same as the player's.
		//
		for (i := 1; i <= length(self.loclist); i++)
			if (find(melocs, self.loclist[i]))
				return self.loclist[i];

		return nil;
	}

	verDoKick(actor) =  {}
	doKick(actor) = {
		"You boot the dwarf across the room.  He curses, then 
		gets up and brushes himself off.  Now he's madder 
		than ever!";
	}
	verDoAttack(actor) = {
		if (not axe.isIn(Me)) {
			"With what?  Your bare hands?";
			self.rhetoricalturn := global.turnsofar;
		}
	}
	doAttack(actor) = { self.doAttackWith(actor, axe); }

	//
	// The following method is called when the player responds, "yes"
	// to "With what?  Your bare hands?"
	//
	nicetry = { "You wish."; }
	
	verDoAttackWith(actor, io) = {}
	doAttackWith(actor, io) = {
		//
		// If the player throws the axe at the dwarf, he
		// might reduce the dwarf to a cloud of greasy
		// black smoke.
		//
		if (io = axe) {
			if (rand(100) <= global.dwarfhit) {
				"You killed a little dwarf.  The body 
				vanishes in a cloud of greasy black 
				smoke.";

				//
				// Remove this location from our list
				// of locations where dwarves are.
				//
				self.loclist -= self.location;
			}
			else {
				"You attack a little dwarf, but he 
				dodges out of the way.";
			}

			axe.moveInto(Me.location);
		}
		else if (io = Hands)
			self.nicetry;
		else
			"Somehow I doubt that'll be very effective.";
	}
	
	verIoGiveTo(actor) = {}
	ioGiveTo(actor, dobj) = {
		if (dobj = tasty_food) {
			self.doFeed(Me);
		}
		else {
			"The dwarf is not at all interested in your 
			offer.  (The reason being, perhaps, that if 
			he kills you he gets everything you have 
			anyway.)";
		}
	}

	verIoThrowAt(actor) = { self.verIoGiveTo(actor); }
	ioThrowAt(actor, dobj) = {
		if (dobj = axe)
			self.doAttackWith(actor, dobj);
		else
			self.ioGiveTo(actor, dobj);
	}
	verIoThrowTo(actor) = { self.verIoGiveTo(actor); }
	ioThrowTo(actor, dobj) = {
		if (dobj = axe)
			self.doAttackWith(actor, dobj);
		else
			self.ioGiveTo(actor, dobj);
	}

	verDoFeed(actor) = {}
	doFeed(actor) = {
		if (tasty_food.isIn(Me)) {
			"You fool, dwarves eat only coal!  Now you've 
			made him *really* mad!!";
		}
		else {
			"You have no food to give the dwarf.";
		}
	}

	//
	// Place dwarves in starting locations.
	//
	place = {
		local	i, loc, r;

		self.loclist := [];
		for (i := 1; i <= global.dwarves; i++) {
			//
			// If there are any fixed starting locations
			// for dwarves left, put this dwarf in the
			// next one.  Otherwise place him randomly.
			//
			loc := nil;
			if (length(global.dwarfloc) >= i)
				loc := global.dwarfloc[i];

			//
			// Invalidate initial location if it's off limits
			// to NPC's.
			//
			if (loc)
				if (loc.noNPCs)
					loc := nil;

			//
			// Make sure we get a real location.
			//
			while (loc = nil) {
				r := rand(length(global.NPCrooms));
				loc := global.NPCrooms[r];
			}
			
			//
			// Add this dwarf's location to the list.
			//
			self.loclist := self.loclist + loc;
		}
	}

	//
	// Move dwarves.
	//
	move = {
		local	i, j, len, r, dest, done, dir, loc;
		local   melocs;
//"\ndwarves.move(enter)\n";

		//
		// Move each remaining dwarf.
		//
		// If the dwarf is currently in the player's location,
		// he stays where he is.
		//
		// If a dwarf is in a location adjacent to the player's
		// current location, he moves into the player's location
		// if he can.  (We check his possible exits to see if
		// any of them go the player's location.)  A consequence
		// of this is that dwarves will follow the player
		// relentlessly once they've spotted him.  (But the global
		// value dwarftenacity can be set to prevent dwarves
		// from *always following*, of course.)
		//
		// If a dwarf isn't adjacent to the player, he just moves
		// around randomly.
		//
	    
		for (melocs := [], i := Me.location ; i ; i := i.location)
	            melocs += i;

		self.newloclist := [];
		self.attackers := 0;	// assume no dwarves attack this turn
		for (i := length(self.loclist); i > 0; i--) {
			//
			// Get a copy of this dwarf's location for speed.
			//
			loc := self.loclist[i];

			//
			// Haven't found a new location yet.
			//
			done := nil;

			//
			// In player's current location?
			//
	                if (find(melocs, loc)) {
				dest := loc;	// stay put
				done := true;
			}

			//
			// Try each exit and see if we can reach the
			// player.  If we have an exit that leads to
			// the player, we know it's an OK destination
			// location, since we pruned off all the noNPCs
			// rooms when we constructed the exit lists. 
			//
			len := length(loc.NPCexits);
			if (not done) for (j := len; j > 0; j--) {
				dir := loc.NPCexits[j];
				dest := loc.(dir);

				//
				// We need to check the destination
				// to be sure it exists.  It may be
				// nil if we called an NPCexit method.
				//
			        if (dest <> nil and find(melocs, dest) <> nil)
			        {
					//
					// Is this dwarf tenacious enough
					// to follow the player?
					//
					if (rand(100) <= global.dtenacity)
						done := true;
					break;
				}
			}

			//
			// Have we found a destination yet?  If not,
			// move dwarf to a randomly selected adjacent
			// location.
			//
			// We need to check the destination because
			// the NPCexit methods in the rooms can sometimes
			// return nil.  (For example, when the crystal
			// bridge doesn't exist yet, the giant's door
			// has not been opened, etc.)
			//
			while (not done) {
				dir := loc.NPCexits[rand(len)];
				dest := loc.(dir);

				if (dest)
					done := true;
			}

			//
			// Set new destination.
			//
			self.newloclist += dest; 

			//
			// If the dwarf didn't move, he has an opportunity
			// to attack.
			//
			if (loc = dest) {
			        if (find(melocs, loc))
					if (rand(100) <= global.dwarfattack)
						self.attackers++;

				//
				// Print some debugging info if in debug mode
				//
				if (global.debug) {
					P();
					"Dwarf stays \""; dest.sdesc; ".\"\n";
				}
			}
			else {
				//
				// Print some debugging info if in debug mode
				//
				if (global.debug) {
					P();
					"Dwarf moves from \"";
					self.loclist[i].sdesc; "\" to \"";
					dest.sdesc; ".\"\n";
				}
			}
		}

		//
		// Replace old locations with destinations.
		//
		self.loclist := self.newloclist;

		self.tell;
//"\ndwarves.move(exit)\n";
	}

	//
	// Tell the player what's going on with the dwarves.
	//
	tell = {	
		local	i, j, len, r, dest, done, dir, count, adjacent;
		local   melocs;
//"\ntell(enter)\n";
		//
		// Count how many dwarves are in the room with the player.
		//
		for (melocs := [], i := Me.location ; i ; i := i.location)
	            melocs += i;
		count := length(intersect(melocs, self.loclist));

		//
		// If any dwarves are in the room with the player and
		// the axe hasn't been thrown yet, throw the axe and
		// scatter the dwarves.
		//
		if (count > 0 and axe.location = nil) {
			P(); I();

			"A little dwarf just walked around a corner, 
			saw you, threw a little axe at you which 
			missed, cursed, and ran away.";

			axe.moveInto(self.location);

			//
			// Scatter any dwarves in the room.
			//
			self.scatter;

			//
			// No dwarves in the room.  Be sure we take back
			// those attacks too...
			//
			count := 0;
			self.attackers := 0;
		}

		//
		// Tell the player if any dwarves are in the room with him,
		// or if any are nearby.
		//
		if (count = 0) {
			//
			// If no dwarves are in the room, but at least
			// one dwarf is in an adjacent location, tell
			// the player he hears something.
			//
			// (Only the pirate makes noise in the original,
			// which seem a bit strange and not as much fun.)
			//
			if (self.anyadjacent) {
				P(); I(); "You hear the pitter-patter 
				of little feet.";
			}
		}
		else if (count = 1) {
			P(); I();
			"There is a threatening little dwarf in the 
			room with you.";
		}
		else if (count > 1) {
			P(); I();
			"There are "; say(count); " threatening 
			little dwarves in the room with you.";
		}

		//
		// Handle dwarf attacks.
		//
		if (self.attackers > 0) {
			if (self.attackers = 1) {
				if (count = 1)
					" He throws a knife at you!";
		 		else
					" One of them throws a knife 
					at you!";
			}
			else {
				if (self.attackers = count) {
					if (count = 2)
						" Both of them throw 
						knives at you!";
					else 
						" All of them throw 
						knives at you!";
				}
				else {
					say(self.attackers); " of them throw 
					knives at you!";
				}
			}

			//
			// Curtains for our hero?!
			//
			count := 0;
			for (i := 1; i <= self.attackers; i++) {
				if (rand(100) <= global.dwarfaccuracy)
					count++;
			}

			P(); I();
			if (count > 0) {
				if (count = self.attackers) {
					if (count = 1)
						"It gets you!";
					else if (count = 2)
						"Both of them get you!";
					else
						"All of them get you!";
				}
				else if (count = 1) {
					"One of them gets you!";
				}
				else {
					say(count); " of them get 
					you!";
				}

				die();
			}
			else {
				if (self.attackers = 1) 
					"It misses you!";
				else if (self.attackers = 2)
					"Both of them miss you!";
				else
					"They all miss you!";
			}
		}
//"\ntell(exit)\n";
	}
;
/*
 * The player can never get the dwarves' knives (that would be too easy),
 * but we'll let him examine them anyway.
 */
DwarfKnives: decoration
	sdesc = "dwarf's knife"
	ldesc = { self.verifyRemove(Me); }
	noun = 'knife' 'knives'
	adjective = 'sharp' 'nasty' 'dwarf\'s' 'dwarvish' 'dwarven'
			'dwarfish'

	locationOK = true	// tell compiler OK for location to be method
	location = {
		return Dwarves.location;
	}

	verifyRemove(actor) = {
		"The dwarves' knives vanish as they strike the walls 
		of the cave.";
	}

	verIoAttackWith(actor) = {
		"You don't have the dwarf's knife!";
	}
;

/*
 * Move the pirate(s).  See the global object in ccr-std.t for paramters.
 *
 * This code is quite similar to the Dwarves code, but is simple because
 * there's never any interaction between the player and the pirates. (The
 * pirates just come in, do their stuff, and vanish.)
 *
 * Note that even if there's more than one pirate, the text printed in
 * in this object will treat all the pirates as a single one. So the
 * only difference having multiple pirates makes is that the more you
 * have, the more likely the player is to run into "him."
 */
Pirates: NPC, Actor
	location = nil	// not a real actor, so pretend we don't exist

	seen = nil	// has the player seen (one of) us?

	//
	// Place pirates in starting locations.
	//
	place = {
		local	i, loc, r;

		self.loclist := [];
		for (i := 1; i <= global.pirates; i++) {
			//
			// If there are any fixed starting locations
			// for pirates left, put this pirate in the
			// next one.  Otherwise place him randomly.
			//
			loc := nil;
			if (length(global.pirateloc) >= i)
				loc := global.pirateloc[i];

			//
			// Invalidate initial location if it's off limits
			// to NPC's.
			//
			if (loc)
				if (loc.noNPCs)
					loc := nil;

			//
			// Make sure we get a real location.
			//
			while (loc = nil) {
				r := rand(length(global.NPCrooms));
				loc := global.NPCrooms[r];
			}
			
			//
			// Add this pirate's location to the list.
			//
			self.loclist := self.loclist + loc;
		}
	}

	//
	// Move pirates.
	//
	move = {
		local	i, j, len, r, dest, done, dir, melocs;

//"\npirates.move(enter)\n";
		//
		// Move each remaining pirate.
		//
		// If the pirate is currently in the player's location,
		// he stays where he is.
		//
		// If a pirate is in a location adjacent to the player's
		// current location, he moves into the player's location
		// if he can.  We limit this with the ptenacity global.
		//
		// If a pirate isn't adjacent to the player, he just moves
		// around randomly.
		//
		self.newloclist := [];
		for (melocs := [], i := Me.location ; i ; i := i.location)
	            melocs += i;

		for (i := 1; i <= length(self.loclist); i++) {
			//
			// Haven't found a new location yet.
			//
			done := nil;

			//
			// In player's current location?
			//
			if (find(melocs, self.loclist[i])) {
				dest := self.loclist[i];	// stay put
				done := true;
			}

			//
			// Try each exit and see if we can reach the
			// player.  If we have an exit that leads to
			// the player, we know it's an OK destination
			// location, since we pruned off all the noNPCs
			// rooms when we constructed the exit lists. 
			//
			len := length(self.loclist[i].NPCexits);
			if (not done) for (j := 1; j <= len; j++) {
				dir := self.loclist[i].NPCexits[j];
				dest := self.loclist[i].(dir);

				//
				// We need to check the destination
				// to be sure it exists.  It may be
				// nil if we called an NPCexit method.
				//
				if (dest) if (find(melocs, dest)) {
					//
					// Is this pirate tenacious enough
					// to follow the player?
					//
					if (rand(100) <= global.ptenacity)
						done := true;
					break;
				}
			}

			//
			// Have we found a destination yet?  If not,
			// move pirate to a randomly selected adjacent
			// location.
			//
			// We need to check the destination because
			// the NPCexit methods in the rooms can sometimes
			// return nil.  (For example, when the crystal
			// bridge doesn't exist yet, the giant's door
			// has not been opened, etc.)
			//
			while (not done) {
				dir := self.loclist[i].NPCexits[rand(len)];
				dest := self.loclist[i].(dir);

				if (dest)
					done := true;
			}

			//
			// Set new destination.
			//
			self.newloclist += dest; 

			//
			// Print some debugging info if in debug mode
			//
			if (self.loclist[i] = dest) {
				if (global.debug) {
					P();
					"Pirate stays \""; dest.sdesc; ".\"\n";
				}
			}
			else {
				if (global.debug) {
					P();
					"Pirate moves from \"";
					self.loclist[i].sdesc; "\" to \"";
					dest.sdesc; ".\"\n";
				}
			}
		}

		//
		// Replace old locations with destinations.
		//
		self.loclist := self.newloclist;

		self.tell;
//"\npirates.move(exit)\n";
	}

	//
	// Tell the player what's going on with the pirates.
	//
	tell = {	
		local	i, t, count, snagged, melocs;
//"\npirates.tell(enter)\n";

		//
		// Count how many pirates are in the room with the player.
		// (We really only need to know if there are any at all,
		// but this is just as easy.)
		//
		for (melocs := [], i := Me.location ; i ; i := i.location)
	            melocs += i;
		count := length(intersect(melocs, self.loclist));
						
		//
		// Tell the player if any pirates are nearby.
		//
		if (count = 0) {
			//
			// If no pirates are in the room, but at least
			// one pirate is in an adjacent location, tell
			// the player he hears something.
			//
			if (self.anyadjacent) {
				P(); I();
				"There are faint rustling noises from 
				the darkness behind you.";
			}
		}
		else if (count > 0) {
			//
			// A pirate has snagged the player.
			// Move any treasures the player is carring
			// to the pirate's repository, currently
			// hard-coded as Dead_End_13 because there's
			// code in that room that can't easily be
			// made general.
			//
			// Since the player may be keeping his treasures
			// in containers, it's actually easier just
			// to search through the global list of
			// treasures and check each one's location to
			// see if it's in the player, rather than
			// recursively checking all the player's belongings
			// and seeing if they're treasures.  (Also, we want
			// to get treasures that are just lying around in
			// the room too.)
			//
			snagged := 0;
			for (i := 1; i <= length(global.treasurelist); i++) {
				t := global.treasurelist[i] ;
				if (t.isIn(Me.location)) {
					t.moveInto(Dead_End_13);
					snagged++;
				}
			}

			//
			// Print a message telling the player what happened.
			//
			if (snagged > 0) {
				P();
				I(); "Out from the shadows behind you 
				pounces a bearded pirate!  \"Har, 
				har,\" he chortles.  \"I'll just take 
				all this booty and hide it away with 
				me chest deep in the maze!\"  He 
				snatches your treasure and vanishes 
				into the gloom.";
			}
			else {
				//
				// In the original code, if you weren't
				// holding the lamp, you just wouldn't
				// see the pirate when you weren't
				// carrying any treasures.  This seems
				// bogus, so I've added a conditional here.
				//
				P();
				I(); "There are faint rustling noises 
				from the darkness behind you.  As you 
				turn toward them, ";

				if (brass_lantern.isIn(Me))
					"the beam of your lamp falls 
					across";
				else
					"you spot";

				" a bearded pirate. He is carrying a 
				large chest.  \"Shiver me timbers!\" 
				He cries, \"I've been spotted!  I'd 
				best hie meself off to the maze to 
				hide me chest!\" With that, he 
				vanishes into the gloom.";
			}

			//
			// Install the treasure chest if it hasn't
			// already been installed.  No worries about
			// the chest appearing out of nowhere when
			// the player's at Dead_End_13, because the
			// pirate can't go there.  (It's off limits
			// to NPC's.)
			//
			if (not self.seen) {
				treasure_chest.moveInto(Dead_End_13);
				self.seen := true;
			}

			//
			// Scatter any pirates in the room.
			//
			self.scatter;
		}
//"\npirates.tell(enter)\n";
	}
;
