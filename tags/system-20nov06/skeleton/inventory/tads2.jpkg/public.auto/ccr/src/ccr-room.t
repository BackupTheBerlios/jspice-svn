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
 * 20-Apr-93	dmb	Added the stream decoration to Inside_Building
 *			you can get water there.
 *
 */

/*
 * This file defines all the locations.
 */

/*
 * First we need to define a new class for our rooms.
 * In the original fortran version of the game, you could move around
 * by naming adjacent places.  Since we want to retain this capability,
 * we need to augment the existing set of room movement methods.
 *
 * We also make rooms dark by default.
 *
 * We also need a few things to help our NPC's move about the cave
 * without getting stuck or wandering where they're not supposed to.
 *
 * IMPORTANT NOTE: If you add exit properties (i.e., things like
 * out, east, down, etc.), be sure to update the exitlist in ccr-npc.t
 * or NPC's won't know to look at them, and might get stuck!
 */
class CCR_room: darkroom
	//
	// By default, exits don't go anywhere.
	//
	// The directional ones call noexit, the standard TADS
	// "You can't go that way" method.
	//
	// The magic words print "Nothing happens."
	//
	// For the other words, the game tells the player it
	// doesn't know how to apply the word in the given
	// location.
	//
	jump = { "I don't see how that will help here."; return nil; }

	//
	// Directions
	//
	upstream = { return self.noexit; }
	downstream = { return self.noexit; }
	forwards = { return self.noexit; }
	outdoors = { return self.noexit; }
	left = { return self.noexit; }
	right = { return self.noexit; }
	cross = { return self.noexit; }
	over = { return self.noexit; }
	across = { return self.noexit; }

	//
	// Magic words
	//
	// Note that it's important to have these implemented as travel
	// verbs because once the cave closes, these stop working just
	// like the usual travel verbs.
	//
	// Non-travel magic words are defined in ccr-verbs.t
	//
	xyzzy = { return self.nothinghappens; }
	y2 = { return self.nothinghappens; }
	plugh = { return self.nothinghappens; }
	plover = { return self.nothinghappens; }

	//
	// Feature names
	//
	// These allow limited teleporting to prominent locations.
	//
	road = { return self.doesnotapplyhere; }
	forest = { return self.doesnotapplyhere; }
	valley = { return self.doesnotapplyhere; }
	stairs = { return self.doesnotapplyhere; }
	building = { return self.doesnotapplyhere; }
	gully = { return self.doesnotapplyhere; }
	stream = { return self.doesnotapplyhere; }
	rock = { return self.doesnotapplyhere; }
	bed = { return self.doesnotapplyhere; }
	crawl = { return self.doesnotapplyhere; }
	cobble = { return self.doesnotapplyhere; }
	tosurface = { return self.doesnotapplyhere; }
	dark = { return self.doesnotapplyhere; }
	passage = { return self.doesnotapplyhere; }
	low = { return self.doesnotapplyhere; }
	canyon = { return self.doesnotapplyhere; }
	awkward = { return self.doesnotapplyhere; }
	giant = { return self.doesnotapplyhere; }
	view = { return self.doesnotapplyhere; }
	pit = { return self.doesnotapplyhere; }
	crack = { return self.doesnotapplyhere; }
	steps = { return self.doesnotapplyhere; }
	dome = { return self.doesnotapplyhere; }
	hall = { return self.doesnotapplyhere; }
	barren = { return self.doesnotapplyhere; }
	debris = { return self.doesnotapplyhere; }
	hole = { return self.doesnotapplyhere; }
	wall = { return self.doesnotapplyhere; }
	broken = { return self.doesnotapplyhere; }
	floor = { return self.doesnotapplyhere; }
	toroom = { return self.doesnotapplyhere; }
	slit = { return self.doesnotapplyhere; }
	slab = { return self.doesnotapplyhere; }
	depression = { return self.doesnotapplyhere; }
	entrance = { return self.doesnotapplyhere; }
	secret = { return self.doesnotapplyhere; }
	cave = { return self.doesnotapplyhere; }
	bedquilt = { return self.doesnotapplyhere; }
	oriental = { return self.doesnotapplyhere; }
	cavern = { return self.doesnotapplyhere; }
	shell = { return self.doesnotapplyhere; }
	reservoir = { return self.doesnotapplyhere; }
	main = { return self.doesnotapplyhere; }
	office = { return self.doesnotapplyhere; }
	fork = { return self.doesnotapplyhere; }

	nothinghappens = {
		"Nothing happens.";
		return nil;
	}
	doesnotapplyhere = {
		"I don't know how to apply that word here.";
		return nil;
	}

	//
	// Exits for NPC's.  Since NPC's won't take regular exits
	// that are methods (instead of simple object names), we
	// have to add "hints" in some rooms to allow complete access
	// to all rooms.  By default, these are all nil.  (Note that
	// it is important for them to be nil ojects, and not methods
	// that return nil.  If they are methods, NPC's will try them.)
	//
	NPCexit1 = nil
	NPCexit2 = nil
	NPCexit3 = nil
	NPCexit4 = nil
	NPCexit5 = nil
	NPCexit6 = nil
	NPCexit7 = nil
	NPCexit8 = nil

	//
	// Each room has a list of exit properties that can be considered by
	// NPC's.  The lists is determined at preinit time by looking
	// at all the exit methods and discarding those that are methods.
	// (The NPCexits are always considered, whether they are methods
	// or not, since they're guranteed not to print anything or
	// change game state when they're run.)
	//
	// Note: the list doesn't contain locations; it contains properties;
	// i.e., it contains [ &west &up ... ], not [ At_Y2 ... ].
	//
	NPCexits = []
;

/*
 * A class for the rooms in the "alike" maze.
 */
class CCR_alike_maze_room: CCR_room
	sdesc = "Maze of Twisty Little Passages, All Alike"
	ldesc = {
		I(); "You are in a maze of twisty little passages, 
		all alike.";
	}
;

/*
 * A class for rooms that are forbidden to non-player characters.
 * (This means dwarves and pirate, not bear.)
 *
 * All pits inherit this class because the original source claims
 * that dwarves won't follow the player into a pit, even though
 * they do.  It makes more sense for them to give up the chase
 * when the player scrambles down into a pit, and for that matter
 * it may sound a bit funny for a combat to occur in a little pit,
  * so I've add NoNPC too all the pit rooms.
 */
class NoNPC: CCR_room
	noNPCs = true
;

/*
 * A class for the dead ends.
 */
class CCR_dead_end_room: CCR_room
	sdesc = "At a Dead End"
	ldesc = {
		I(); "You have reached a dead end.";
	}
;

/*
 * A class for areas that are naturally lit.
 */
class lightroom: CCR_room
	islit = true
;

/*
 * A class for rooms that are outside.
 * These rooms are off limits once the cave is closed.
 */
class Outside: CCR_room
	isoutside = true
;

/*
 * A class for rooms that aren't far enough in to earn the player
 * the bonus for getting "well in."
 *
 * See the definition of Me in ccr-std.t for info on how this is used.
 */
class NotFarIn: CCR_room, NoNPC
	notfarin = true
;

class CCR_decoration: decoration;

/*
 * This class lets us easily define a decoration that's in multiple
 * places at once.  You just list the locations it appears in in
 * a list called loclist.
 *
 * This is particularly nice for things like water, which can be
 * manipulated -- we only have one object name to consider (Stream)
 * for all the water in the game that can be taken.  (See ioPutIn
 * for the bottle in ccr-item.t)
 */
class floatingdecoration: CCR_decoration
	locationOK = true	// OK for location to be method
	location = {
		if (find(self.loclist, Me.location))
			return Me.location;
		else
			return nil;
	}
;

/*
 * The locations
 */
At_End_Of_Road: CCR_room, lightroom, NotFarIn, Outside
	sdesc = "At End Of Road"
	ldesc = {
		I(); "You are standing at the end of a road before a 
		small brick building. Around you is a forest.  A 
		small stream flows out of the building and down a 
		gully.";
	}
	road = At_Hill_In_Road
	west = At_Hill_In_Road
	up = At_Hill_In_Road
	building = Inside_Building
	in = Inside_Building
	east = Inside_Building
	downstream = In_A_Valley
	gully = In_A_Valley
	stream = In_A_Valley
	south = In_A_Valley
	down = In_A_Valley
	forest = In_Forest_1
	north = In_Forest_1
	depression = Outside_Grate

	// This was in the original fortran code, but conflicts
	// with the fact that the building is to the east:
	// east = In_Forest
;
Building: floatingdecoration
	sdesc = "building"
	ldesc = {
		if (Me.isIn(Inside_Building))
			"You're in it.";
		else
			"It's a small brick building.  It seems to be 
			a well house.";
	}
	noun = 'building' 'house' 'wellhouse'
	adjective = 'well' 'small' 'brick'
	loclist = [ At_End_Of_Road  At_Hill_In_Road  Inside_Building ]

	verDoEnter(actor) = {}
	doEnter(actor) = {
		actor.travelTo(At_End_Of_Road.in);
	}
;
Road: floatingdecoration
	sdesc = "road"
	noun = 'road' 'street' 'path'
	adjective = 'dirt'
	loclist = [ At_End_Of_Road  At_Hill_In_Road  In_Forest_2 ]
;
Forest: floatingdecoration
	sdesc = "forest"
	adesc = "forest"
	ldesc = {
		"The trees of the forest are large hardwood oak and 
		maple, with an occasional grove of pine or spruce.  
		There is quite a bit of undergrowth, largely birch 
		and ash saplings plus nondescript bushes of various 
		sorts.  This time of year visibility is quite 
		restricted by all the leaves, but travel is quite 
		easy if you detour around the spruce and berry 
		bushes.";
	}

	noun = 'forest' 'tree' 'trees' 'oak' 'maple' 'grove' 'pine'
		'spruce' 'birch' 'ash' 'saplings' 'bushes' 'leaves'
		'berry' 'berries'
	adjective = 'surrounding' 'open' 'hardwood' 'oak' 'maple' 'pine'
		'spruce' 'birch' 'ash' 'berry'
	loclist = [
		At_End_Of_Road  At_Hill_In_Road  In_A_Valley
		In_Forest_1  In_Forest_2
	]
;
Stream: floatingdecoration
	sdesc = "stream"
	ldesc = {
		if (Me.isIn(Inside_Building))
			"The stream flows out through a pair of 1 
			foot diameter sewer pipes.";
		else
			pass ldesc;
	}
	noun = 'stream' 'water' 'brook' 'river' 'lake'
	adjective = 'small' 'tumbling' 'splashing' 'babbling' 'rushing'
		'reservoir'
	loclist = [
		At_End_Of_Road  In_A_Valley  At_Slit_In_Streambed
		In_Pit  In_Cavern_With_Waterfall  At_Reservoir
		Inside_Building
	]

	verDoDrink(actor) = {}
	doDrink(actor) = {
		"You have taken a drink from the stream.  The water 
		tastes strongly of minerals, but is not unpleasant.  
		It is extremely cold.";
	}

	verDoTake(actor) = {
		if (not bottle.isIn(Me))
			"You have nothing in which to carry the water.";
	}
	doTake(actor) = {
		bottle.ioPutIn(actor, self);
	}
	verDoPutIn(actor, io) = {}
	doPutIn(actor, io) = {
		if (io <> bottle)
			"You have nothing in which to carry the water.";
		else
			bottle.ioPutIn(actor, self);
	}
;
Gully: floatingdecoration
	sdesc = "gully"
	noun = 'gully'
	loclist = [ At_End_Of_Road  At_Slit_In_Streambed  Outside_Grate ]
;

At_Hill_In_Road: CCR_room, lightroom, NotFarIn, Outside
	sdesc = "At Hill In Road"
	ldesc = {
		I(); "You have walked up a hill, still in the forest. 
		The road slopes back down the other side of the 
		hill.  There is a building in the distance.";
	}
	road = At_End_Of_Road
	building = At_End_Of_Road
	forwards = At_End_Of_Road
	east = At_End_Of_Road
	north = At_End_Of_Road
	down = At_End_Of_Road
	forest = In_Forest_1
	south = In_Forest_1

	// Another bug in the original code:
	// north = In_Forest
;
Hill: CCR_decoration
	sdesc = "hill"
	ldesc = "It's just a typical hill."
	noun = 'hill' 'bump' 'incline'
	location = At_Hill_In_Road
;
OtherSideOfHill: CCR_decoration
	sdesc = "other side of hill"
	thedesc = "the other side of the hill"
	adesc = { self.thedesc; }
	ldesc = "Why not explore it yourself?"
	noun = 'side'
	adjective = 'other'
	location = At_Hill_In_Road
;

Inside_Building: CCR_room, lightroom, NotFarIn, Outside
	sdesc = "Inside Building"
	ldesc = {
		I(); "You are inside a building, a well house for a 
		large spring.";
	}
	out = At_End_Of_Road
	outdoors = At_End_Of_Road
	west = At_End_Of_Road
	xyzzy = In_Debris_Room
	plugh = At_Y2
	downstream = { return self.stream; }
	stream = {
		"The stream flows out through a pair of 1 foot 
		diameter sewer pipes. It would be advisable to use 
		the exit.";

		return nil;
	}
;
Spring: CCR_decoration
	sdesc = "spring"
	location = Inside_Building
	noun = 'spring'
	adjective = 'large'
;
SewerPipes: CCR_decoration
	sdesc = "pair of 1 foot diameter sewer pipes"
	location = Inside_Building
	noun = 'pipes' 'pipe'
	adjective = 'one' 'foot' '1-foot' 'diameter' 'sewer'
;

In_A_Valley: CCR_room, lightroom, NotFarIn, Outside
	sdesc = "In A Valley"
	ldesc = {
		I(); "You are in a valley in the forest beside a 
		stream tumbling along a rocky bed.";
	}
	upstream = At_End_Of_Road
	building = At_End_Of_Road
	north = At_End_Of_Road
	forest = In_Forest_1
	east = In_Forest_1
	west = In_Forest_1
	up = In_Forest_1
	downstream = At_Slit_In_Streambed
	south = At_Slit_In_Streambed
	down = At_Slit_In_Streambed
	depression = Outside_Grate
;
Streambed: floatingdecoration
	sdesc = "streambed"
	noun = 'bed' 'streambed' 'rock'
	adjective = 'stream' 'water' 'river' 'small' 'tumbling' 'splashing'
			'babbling' 'rushing' 'rocky' 'bare' 'dry'
	loclist = [ In_A_Valley  At_Slit_In_Streambed  Outside_Grate ]
;
Valley: floatingdecoration
	sdesc = "valley"
	ldesc = {
		if (Me.isIn(In_A_Valley))
			"You're in it.";
		else
			pass ldesc;
	}
	noun = 'valley'
	adjective = 'deep'
	loclist = [ In_A_Valley  In_Forest_1  In_Forest_2 ]
;

In_Forest_1: CCR_room, lightroom, NotFarIn, Outside
	sdesc = "In Forest"
	ldesc = {
		I(); "You are in open forest, with a deep valley to 
		one side.";
	}
	valley = In_A_Valley
	east = In_A_Valley
	down = In_A_Valley

	// An approximation of the original code:
	forest = {
		if (rand(100) <= 50)
			return In_Forest_1;
		else
			return In_Forest_2;
	}

	forwards = In_Forest_1
	north = In_Forest_1
	west = In_Forest_1
	south = In_Forest_1
;

In_Forest_2: CCR_room, lightroom, NotFarIn, Outside
	sdesc = "In Forest"
	ldesc = {
		I(); "You are in open forest near both a valley and a 
		road.";
	}
	road = At_End_Of_Road
	north = At_End_Of_Road
	valley = In_A_Valley
	east = In_A_Valley
	west = In_A_Valley
	down = In_A_Valley
	forest = In_Forest_1
	south = In_Forest_1
;

At_Slit_In_Streambed: CCR_room, lightroom, NotFarIn, Outside
	sdesc = "At Slit In Streambed"
	ldesc = {
		I(); "At your feet all the water of the stream 
		splashes into a 2-inch slit in the rock.  Downstream 
		the streambed is bare rock.";
	}
	building = At_End_Of_Road
	upstream = In_A_Valley
	north = In_A_Valley
	forest = In_Forest_1
	east = In_Forest_1
	west = In_Forest_1
	downstream = Outside_Grate
	rock = Outside_Grate
	bed = Outside_Grate
	south = Outside_Grate

	slit = { return self.down; }
	stream = { return self.down; }
	down = {
		"You don't fit through a two-inch slit!";
		return nil;
	}
;
Slit: CCR_decoration
	sdesc = "2-inch slit"
	ldesc = "It's just a 2-inch slit in the rock, through which the
		stream is flowing."
	location = At_Slit_In_Streambed
	noun = 'slit'
	adjective = 'two' 'inch' '2-inch' 'two-inch'
;

Outside_Grate: CCR_room, lightroom, NotFarIn, Outside
	sdesc = "Outside Grate"
	ldesc = {
		I(); "You are in a 20-foot depression floored with 
		bare dirt.  Set into the dirt is a strong steel grate 
		mounted in concrete.  A dry streambed leads into the 
		depression.";
	}
	forest = In_Forest_1
	east = In_Forest_1
	west = In_Forest_1
	south = In_Forest_1
	building = At_End_Of_Road
	upstream = At_Slit_In_Streambed
	gully = At_Slit_In_Streambed
	north = At_Slit_In_Streambed
	
	in = { return self.down; }
	down = {
		Grate.doEnter(Me);
		return nil;
	}
;
Depression: CCR_decoration
	sdesc = "20-foot depression"
	ldesc = "You're standing in it."
	location = Outside_Grate
	noun = 'depression' 'dirt'
	adjective = '20-foot' 'twenty' 'foot' 'twenty-foot' 'bare'
;
Grate: fixeditem, keyedLockable
	isopen = nil
	islocked = true
	sdesc = "steel grate"
	ldesc = {
		if (self.isIn(Outside_Grate)) {
			"It just looks like an ordinary grate
			mounted in concrete.";
		}
		else {
			"It's just a 3x3 steel grate mounted
			in the ceiling.";
		}

		" It is ";
		if (self.isopen)
			"open.";
		else if (self.islocked) 
			"closed and locked.";
		else 
			"closed.";
	}
	noun = 'grate' 'lock' 'gate' 'grille'
	adjective = 'metal' 'strong' 'steel' 'open' 'closed' 'locked'
		'unlocked'

	locationOK = true // Tell compiler OK for location to be method
	location = {
		if (Me.isIn(Outside_Grate))
			return Outside_Grate;
		else	    
			return Below_The_Grate;
	}
	mykey = set_of_keys

	verDoEnter(actor) = {}
	doEnter(actor) = {
		if (not Grate.islocked) {
			if (not Grate.isopen) {
				"(Opening the grate first.)\b";
				Grate.isopen := true;
						
			}
			if (actor.isIn(Outside_Grate))
				actor.travelTo(Below_The_Grate);
			else
				actor.travelTo(Outside_Grate);
		}
		else {
			"You can't go through a locked steel grate!";
		}
	}
	
	verIoPutIn(actor) = { "You can't put anything in that! "; }
	verDoPick = { "You have no tools to pick the lock with."; }
;

Below_The_Grate: CCR_room, lightroom, NotFarIn
	sdesc = "Below the Grate"
	ldesc = {
		I(); "You are in a small chamber beneath a 3x3 steel 
		grate to the surface. A low crawl over cobbles leads 
		inward to the west.";
	}
	crawl = In_Cobble_Crawl
	cobble = In_Cobble_Crawl
	in = In_Cobble_Crawl
	west = In_Cobble_Crawl
	pit = At_Top_Of_Small_Pit
	debris = In_Debris_Room

	outdoors = { return self.up; }	// DMB: added
	out = { return self.up; }
	up = {
		Grate.doEnter(Me);
		return nil;
	}
;
Cobbles: floatingdecoration
	sdesc = "cobbles"
	adesc = "cobbles"
	ldesc = "They're just ordinary cobbles."
	noun = 'cobble' 'cobbles' 'cobblestones' 'cobblestone' 'stones'
		'stone'
	adjective = 'cobble'
	loclist = [ Below_The_Grate  In_Cobble_Crawl  In_Debris_Room ]
;

In_Cobble_Crawl: CCR_room, lightroom, NotFarIn
	sdesc = "In Cobble Crawl"
	ldesc = {
		I(); "You are crawling over cobbles in a low passage. 
		There is a dim light at the east end of the 
		passage.";
	}
	out = Below_The_Grate
	tosurface = Below_The_Grate
	east = Below_The_Grate
	in = In_Debris_Room
	dark = In_Debris_Room
	west = In_Debris_Room
	debris = In_Debris_Room
	pit = At_Top_Of_Small_Pit

	// DMB: added the following, in accordance with its presence
	// in In_Debris_Room and rooms beyond.
	depression = {
		Grate.doEnter(Me);

		// If the player didn't move, the grate must be
		// locked.  Move the player underneath the grate.
		if (Me.isIn(self)) {
			"\b";
			Me.travelTo(Below_The_Grate);
		}
		// We've already moved the player, but we have to
		// return a value, so just return nil (which results
		// in no more movement).
		return nil;
	}
;

In_Debris_Room: CCR_room, NotFarIn
	sdesc = "In Debris Room"
	ldesc = {
		I(); "You are in a debris room filled with stuff 
		washed in from the surface. A low wide passage with 
		cobbles becomes plugged with mud and debris here, but 
		an awkward canyon leads upward and west."; P();

		I(); "A note on the wall says, \"Magic word XYZZY.\"";
	}
	entrance = Below_The_Grate
	crawl = In_Cobble_Crawl
	cobble = In_Cobble_Crawl
	passage = In_Cobble_Crawl
	low = In_Cobble_Crawl
	east = In_Cobble_Crawl
	canyon = In_Awkward_Sloping_E_W_Canyon
	in = In_Awkward_Sloping_E_W_Canyon
	up = In_Awkward_Sloping_E_W_Canyon
	west = In_Awkward_Sloping_E_W_Canyon
	xyzzy = Inside_Building
	pit = At_Top_Of_Small_Pit

	// The original occasionally allowed the player to teleport
	// large distances in one turn.  This is just one example.
	depression = {
		Grate.doEnter(Me);

		// If the player didn't move, the grate must be
		// locked.  Move the player underneath the grate.
		if (Me.isIn(self)) {
			"\b";
			Me.travelTo(Below_The_Grate);
		}

		// We've already moved the player, but we have to
		// return a value, so just return nil (which results
		// in no more movement).
		return nil;
	}
;
Debris: floatingdecoration
	sdesc = "debris"
	ldesc = "Yuck."
	noun = 'debris' 'stuff' 'mud'
	loclist = [ In_Debris_Room  In_Arched_Hall ]
;
XyzzyNote: CCR_decoration, readable
	sdesc = "note"
	ldesc = { self.readdesc; }
	readdesc = "The note says \"Magic word XYZZY\"."
	noun = 'note'
	location = In_Debris_Room
;

In_Awkward_Sloping_E_W_Canyon: CCR_room, NotFarIn
	sdesc = "In Awkward Sloping E/W Canyon"
	ldesc = {
		I(); "You are in an awkward sloping east/west 
		canyon.";
	}

	entrance = Below_The_Grate
	down = In_Debris_Room
	east = In_Debris_Room
	debris = In_Debris_Room
	in = In_Bird_Chamber
	up = In_Bird_Chamber
	west = In_Bird_Chamber
	pit = At_Top_Of_Small_Pit

	depression = {
		Grate.doEnter(Me);

		// If the player didn't move, the grate must be
		// locked.  Move the player underneath the grate.
		if (Me.isIn(self)) {
			"\b";
			Me.travelTo(Below_The_Grate);
		}
		
		// We've already moved the player, but we have to
		// return a value, so just return nil (which results
		// in no more movement).
		return nil;
	}
;

In_Bird_Chamber: CCR_room, NotFarIn
	sdesc = "In Bird Chamber"
	ldesc = {
		I(); "You are in a splendid chamber thirty feet high. 
		The walls are frozen rivers of orange stone.  An 
		awkward canyon and a good passage exit from east and 
		west sides of the chamber.";
	}

	entrance = Below_The_Grate
	debris = In_Debris_Room
	canyon = In_Awkward_Sloping_E_W_Canyon
	east = In_Awkward_Sloping_E_W_Canyon
	passage = At_Top_Of_Small_Pit
	pit = At_Top_Of_Small_Pit
	west = At_Top_Of_Small_Pit

	depression = {
		Grate.doEnter(Me);

		// If the player didn't move, the grate must be
		// locked.  Move the player underneath the grate.
		if (Me.isIn(self)) {
			"\b";
			Me.travelTo(Below_The_Grate);
		}

		// We've already moved the player, but we have to
		// return a value, so just return nil (which results
		// in no more movement).
		return nil;
	}
;

At_Top_Of_Small_Pit: CCR_room, NotFarIn
	sdesc = "At Top of Small Pit"
	ldesc = {
		// Note: this used to say "An east passage ends here..."
		// but that's obviously a mistake.

		I(); "At your feet is a small pit breathing traces of 
		white mist.  A west passage ends here except for a 
		small crack leading on."; P();

		I(); "Rough stone steps lead down the pit.";
	}
	entrance = Below_The_Grate
	debris = In_Debris_Room
	passage = In_Bird_Chamber
	east = In_Bird_Chamber
	crack = { return self.west; }
	west = {
		"The crack is far too small for you to follow.";
		return nil;
	}

	down = {
		if (large_gold_nugget.isIn(Me))
			return broken_neck.death;
		else
			return In_Hall_Of_Mists;
	}

	depression = {
		Grate.doEnter(Me);

		// If the player didn't move, the grate must be
		// locked.  Move the player underneath the grate.
		if (Me.isIn(self)) {
			"\b";
			Me.travelTo(Below_The_Grate);
		}
		
		// We've already moved the player, but we have to
		// return a value, so just return nil (which results
		// in no more movement).
		return nil;
	}
; 
SmallPit: CCR_decoration
	sdesc = "small pit"
	ldesc = "The pit is breathing traces of white mist."
	location = At_Top_Of_Small_Pit
	noun = 'pit'
;
PitCrack: CCR_decoration
	sdesc = "crack"
	ldesc = "The crack is very small -- far too small for you to follow."
	location = At_Top_Of_Small_Pit
	noun = 'crack'
	adjective = 'small'
;
Mist: floatingdecoration
	sdesc = "mist"
	ldesc = {
		"Mist is a white vapor, usually water, seen from time 
		to time in caverns.  It can be found anywhere but is 
		frequently a sign of a deep pit leading down to 
		water.";
	}
	noun = 'mist' 'vapor' 'wisps'
	adjective = 'white' 'water'
	loclist = [
		At_Top_Of_Small_Pit In_Hall_Of_Mists
		On_East_Bank_Of_Fissure  At_Window_On_Pit_1
		At_West_End_Of_Hall_Of_Mists In_Misty_Cavern
		In_Mirror_Canyon  At_Reservoir At_Window_On_Pit_2
		On_Sw_Side_Of_Chasm
	]
;

In_Hall_Of_Mists: CCR_room
	sdesc = "In Hall of Mists"
	ldesc = {
		I(); "You are at one end of a vast hall stretching 
		forward out of sight to the west.  There are openings 
		to either side.  Nearby, a wide stone staircase leads 
		downward.  The hall is filled with wisps of white 
		mist swaying to and fro almost as if alive.  A cold 
		wind blows up the staircase.  There is a passage at 
		the top of a dome behind you."; P();

		I(); "Rough stone steps lead up the dome.";
	}
	left = In_Nugget_Of_Gold_Room
	south = In_Nugget_Of_Gold_Room
	forwards = On_East_Bank_Of_Fissure
	hall = On_East_Bank_Of_Fissure
	west = On_East_Bank_Of_Fissure
	stairs = In_Hall_Of_Mt_King
	down = In_Hall_Of_Mt_King
	north = In_Hall_Of_Mt_King
	y2 = Jumble_Of_Rock

	up = {
		if (large_gold_nugget.isIn(Me)) {
			"The dome is unclimbable.";
			return nil;
		}
		else {
			return At_Top_Of_Small_Pit;
		}
	}
;
Staircase: CCR_decoration
	sdesc = "wide stone staircase"
	ldesc = "The staircase leads down."
	location = In_Hall_Of_Mists
	noun = 'stair' 'stairs' 'staircase'
	adjective = 'wide' 'stone'
;
DomeSteps: CCR_decoration
	sdesc = "rough stone steps"
	ldesc = "The rough stone steps lead up the dome."
	location = In_Hall_Of_Mists
	noun = 'stair' 'stairs' 'staircase'
	adjective = 'rough' 'stone'
;
Dome: CCR_decoration
	sdesc = "dome"
	ldesc = {
		if (large_gold_nugget.isIn(Me))
			"I'm not sure you'll be able to get up it
			with what you're carrying.";
		else
			"It looks like you might be able to climb up it.";
	}
	location = In_Hall_Of_Mists
	noun = 'dome'

	verDoClimb(actor) = {}
	doClimb(actor) = {
		actor.travelTo(In_Hall_Of_Mists.up);
	}
;

On_East_Bank_Of_Fissure: CCR_room
	sdesc = "On East Bank of Fissure"
	ldesc = {
		I(); "You are on the east bank of a fissure slicing 
		clear across the hall. The mist is quite thick here, 
		and the fissure is too wide to jump.";

 		if (CrystalBridge.exists) {
			P(); I();
			"A crystal bridge now spans the fissure.";
		}
	}
	hall = In_Hall_Of_Mists
	east = In_Hall_Of_Mists

	forwards = { return self.jump; }
	jump = {
		if (CrystalBridge.exists) {
			"I respectfully suggest you go across the 
			bridge instead of jumping.";

			return nil;
		}
		else
			return didnt_make_it.death;
	}

	over = { return self.across; }
	west = { return self.across; }
	cross = { return self.across; }
	across = {
		CrystalBridge.doCross(Me);
		return nil;
	}

	//
	// NPC's can go across too, but only if the bridge exists.
	//
	NPCexit1 = {
		if (CrystalBridge.exists)
			return West_Side_Of_Fissure;
		else
			return nil;
	}
;
BridgeFissure: floatingdecoration
	sdesc = "fissure"
	ldesc = {
		if (CrystalBridge.exists)
			"A crystal bridge now spans the fissure.";
		else
			"The fissure looks far too wide to jump.";
	}
	noun = 'fissure'
	adjective = 'wide'
	loclist = [ West_Side_Of_Fissure  On_East_Bank_Of_Fissure ]
;
CrystalBridge: CCR_decoration
	exists = nil
	sdesc = "Crystal bridge"
	ldesc = "It spans the fissure, thereby providing you a way across."
	locationOK = true	// tell compiler OK for location to be method
	location = {
		if (self.exists) {
			if (Me.isIn(West_Side_Of_Fissure))
				return West_Side_Of_Fissure;
			else
				return On_East_Bank_Of_Fissure;
		}
		else
			return nil;
	}
	noun = 'bridge'
	adjective = 'crystal' 'magic' 'rod'

	verDoCross(actor) = {}
	doCross(actor) = {
		if (self.exists) {
			if (actor.isIn(On_East_Bank_Of_Fissure))
				actor.travelTo(West_Side_Of_Fissure);
			else
				actor.travelTo(On_East_Bank_Of_Fissure);
		}
		else
			"There is no way across the fissure.";
	}
;

In_Nugget_Of_Gold_Room: CCR_room
	sdesc = "In Nugget of Gold Room"
	ldesc = {
		I(); "This is a low room with a crude note on the 
		wall. "; NuggetNote.readdesc;
	}
	hall = In_Hall_Of_Mists
	out = In_Hall_Of_Mists
	north = In_Hall_Of_Mists
;
NuggetNote: CCR_decoration, readable
	sdesc = "note"
	ldesc = { self.readdesc; }
	readdesc = {
		"The note says, \"You won't get it up the steps\".";
	}
	location = In_Nugget_Of_Gold_Room
	noun = 'note'
	adjective = 'crude'
;

In_Hall_Of_Mt_King: CCR_room
	sdesc = "In Hall of Mt King"
	ldesc = {
		I(); "You are in the hall of the mountain king, with 
		passages off in all directions.";

		if (Snake.isIn(self)) {
			P();
			I(); "A huge green fierce snake bars the way!";
		}
	}
	stairs = In_Hall_Of_Mists
	up = In_Hall_Of_Mists
	east = In_Hall_Of_Mists

	left = { return self.north; }
	north = {
		if (self.snakecheck)
			return Low_N_S_Passage;
		else
			return nil;
	}
	
	right = { return self.south; }
	south = {
		if (self.snakecheck)
			return In_South_Side_Chamber;
		else
			return nil;
	}

	forwards = { return self.west; }
	west = {
		if (self.snakecheck)
			return In_West_Side_Chamber;
		else
			return nil;
	}

	/*
	 * An interesting little bit of trivia here:
	 * 35% of the time you can slip past the snake and into
	 * the secret canyon.  (This is in the original fortran
	 * code.)  But if you say "secret" you will *always* sneak
	 * by it.
	 */
	sw = {
		if (rand(100) <= 35) {
			return In_Secret_E_W_Canyon;
		}
		else {
			if (self.snakecheck)
				return In_Secret_E_W_Canyon;
			else
				return nil;
		}
	}
	secret = In_Secret_E_W_Canyon

	snakecheck = {
		if (Snake.isIn(Me.location)) {
			"You can't get by the snake.";
			return nil;
		}
		else
			return true;
	}
;
Snake: CCR_decoration
	sdesc = "snake"
	ldesc = "I wouldn't mess with it if I were you."
	location = In_Hall_Of_Mt_King
	noun = 'snake' 'cobra' 'asp'
	adjective = 'huge' 'fierce' 'green' 'ferocious' 'venemous'
		'venomous' 'large' 'big' 'killer'

	verDoFeed(actor) = {}
	doFeed(actor) = {
		if (little_bird.isIn(Me)) {
			"The snake has now devoured your bird.";
			little_bird.moveInto(nil);
		}
		else if (little_bird.isIn(self.location))
			"You have nothing to feed it.";
		else
			"There's nothing here it wants to eat (except 
			perhaps you).";
	}
	verIoGiveTo(actor) = {}
	doGiveTo(actor, dobj) = {
		if (dobj = little_bird)
			self.doFeed(actor);
		else {
			"The snake does not seem interested in ";
			dobj.thedesc; ".";
		}
	}
	
	verDoAttack(actor) = {}
	doAttack(actor) = {
		"Attacking the snake both doesn't work and is very 
		dangerous.";
	}
	verDoAttackWith(actor, io) = { self.verDoAttack(actor); }
	doAttackWith(actor, io) = { self.doAttack(actor); }

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
	
	verDoKick(actor) = {}
	doKick(actor) = { "That would be satisfying, but totally insane."; }

	verifyRemove(actor) = { "Surely you're joking."; }
;

At_West_End_Of_Twopit_Room: CCR_room
	sdesc = "At West End of Twopit Room"
	ldesc = {
		I(); "You are at the west end of the twopit room.  
 		There is a large hole in the wall above the pit at 
		this end of the room.";

		if (PlantStickingUp.isIn(self)) {
			P(); I(); PlantStickingUp.ldesc;
		}
	}
	east = At_East_End_Of_Twopit_Room
	across = At_East_End_Of_Twopit_Room
	west = In_Slab_Room
	slab = In_Slab_Room
	down = In_West_Pit
	pit = In_West_Pit

	up = { return self.hole; }	// DMB: added
	hole = {
		"It is too far up for you to reach.";
		return nil;
	}
;
HoleAbovePit_1: CCR_decoration
	sdesc = "hole above pit"
	ldesc = {
		"The hole is in the wall above the pit at 
		this end of the room.";
	}
	noun = 'hole'
	adjective = 'large'
	location = At_West_End_Of_Twopit_Room

	verDoEnter(actor) = { "It is too far up for you to reach."; }
;
PlantStickingUp: CCR_decoration
	sdesc = {
		if (Plant.size = 1)
			"top of 12-foot-tall beanstalk";
		else
			"huge beanstalk";
	}
	ldesc = {
		if (Plant.size = 1)
			"The top of a 12-foot-tall beanstalk is 
			poking out of the west pit.";
		else
			"There is a huge beanstalk growing out of the 
			west pit up to the hole.";
	}
	noun = 'plant' 'beanstalk' 'stalk'
	adjective = 'bean' 'giant' 'tiny' 'little' 'murmuring'
		'12-foot-tall' 'twelve' 'foot' 'tall' 'bellowing'

	location = {
		if (Plant.size = 0)
			return nil;
		else if (Me.isIn(At_West_End_Of_Twopit_Room))
			return At_West_End_Of_Twopit_Room;
		else
			return At_East_End_Of_Twopit_Room;		
	}
;

In_East_Pit: CCR_room, NoNPC
	sdesc = "In East Pit"
	ldesc = {
		I(); "You are at the bottom of the eastern pit in the 
		twopit room.  There is a small pool of oil in one 
		corner of the pit.";
	}
	up = At_East_End_Of_Twopit_Room
	out = At_East_End_Of_Twopit_Room
;
EastPit: CCR_decoration
	sdesc = "eastern pit"
	ldesc = "You're in it."
	noun = 'pit' 'corner'
	adjective = 'east' 'eastern'
	location = In_East_Pit
;
Oil: CCR_decoration
	sdesc = "pool of oil"
	noun = 'pool' 'oil'
	adjective = 'small'
	location = In_East_Pit

	verDoTake(actor) = {
		if (not bottle.isIn(Me))
			"You have nothing in which to carry the oil.";
	}
	doTake(actor) = {
		bottle.ioPutIn(actor, self);
	}
	verDoPutIn(actor, io) = {}
	doPutIn(actor, io) = {
		if (io <> bottle)
			"You have nothing in which to carry the oil.";
		else
			bottle.ioPutIn(actor, self);
	}
;

In_West_Pit: CCR_room, NoNPC
	sdesc = "In West Pit"
	ldesc = {
		I(); "You are at the bottom of the western pit in the 
		twopit room.  There is a large hole in the wall about 
		25 feet above you."; P();

		I(); Plant.ldesc;
	}
	up = At_West_End_Of_Twopit_Room
	out = At_West_End_Of_Twopit_Room
	climb = {
		if (Plant.size < 1 or Plant.size > 2) {
			"There is nothing here to climb.  Use \"up\" 
			or \"out\" to leave the pit.";

			return nil;
		}
		else {
			Plant.doClimb(Me);
			return nil;
		}
	}
;
Plant: CCR_decoration
	size = 0

	sdesc = {
		if (self.size = 0)
			"plant";
		else if (self.size = 1)
			"beanstalk";
		else if (self.size = 2)
			"giant beanstalk";
	}
	ldesc = {
		if (self.size = 0)
			"There is a tiny little plant in the pit, 
			murmuring \"Water, water, ...\"";
		else if (self.size = 1)
			"There is a 12-foot-tall beanstalk stretching 
			up out of the pit, bellowing \"Water!! 
			Water!!\"";
		else if (self.size = 2)
			"There is a gigantic beanstalk stretching all 
			the way up to the hole.";
	}
	location = In_West_Pit
	noun = 'plant' 'beanstalk' 'stalk'
	adjective = 'bean' 'giant' 'tiny' 'little' 'murmuring'
		'12-foot-tall' 'twelve' 'foot' 'tall' 'bellowing'

	verDoClimb(actor) = {
		if (self.size = 0)
			"It's just a little plant!";
	}
	doClimb(actor) = {
		if (self.size = 1) {
			"You have climbed up the plant and out of the 
			pit.\b";

			Me.travelTo(At_West_End_Of_Twopit_Room);
		}
		else {
			"You clamber up the plant and scurry through 
			the hole at the top.\b";

			Me.travelTo(In_Narrow_Corridor);
		}
	}

	verDoWater(actor) = {}
	doWater(actor) = {
		if (bottle.isIn(Me))
			bottle.doPourOn(actor, self);
		else
			"You have nothing to water the plant with.";
	}
	verDoOil(actor) = {}
	doOil(actor) = { self.doWater(actor); }

	// The plant's not going anywhere.
	verifyRemove(actor) = {
		"The plant has exceptionally deep roots and cannot be 
		pulled free.";
	}

	water = {
		self.size := self.size + 1;

		if (self.size = 1)
			"The plant spurts into furious growth for a 
			few seconds.";
		else if (self.size = 2)
			"The plant grows explosively, almost filling 
			the bottom of the pit.";
		else {
			"You've over-watered the plant!  It's 
			shriveling up!  It's, it's...";

			self.size := 0;
		}

		P(); I(); Plant.ldesc;
	}
;
WestPit: CCR_decoration
	sdesc = "western pit"
	ldesc = "You're in it."
	noun = 'pit' 'corner'
	adjective = 'west' 'western'
	location = In_West_Pit
;
HoleAbovePit_2: CCR_decoration
	sdesc = "hole above pit"
	ldesc = "The hole is in the wall above you."
	noun = 'hole'
	adjective = 'large'
	location = At_West_End_Of_Twopit_Room

	verDoEnter(actor) = {
		"You're not anywhere near the pit -- it's far overhead.";
	}
;

West_Side_Of_Fissure: CCR_room
	sdesc = "West Side of Fissure"
	ldesc = {
		I(); "You are on the west side of the fissure in the 
		hall of mists.";

		if (CrystalBridge.exists) {
			P(); I();
			"A crystal bridge now spans the fissure.";
		}
	}

	west = At_West_End_Of_Hall_Of_Mists

	forwards = { return self.jump; }
	jump = {
		if (CrystalBridge.exists) {
			"I respectfully suggest you go across the 
			bridge instead of jumping.";

			return nil;
		}
		else
			return didnt_make_it.death;
	}

	over = { return self.across; }
	east = { return self.across; }
	cross = { return self.across; }
	across = {
		CrystalBridge.doCross(Me);
		return nil;
	}

	north = {
		"You have crawled through a very low wide passage 
		parallel to and north of the hall of mists.\b";

		return At_West_End_Of_Hall_Of_Mists;
	}

	//
	// NPC's can go across too, but only if the bridge exists.
	//
	NPCexit1 = {
		if (CrystalBridge.exists)
			return On_East_Bank_Of_Fissure;
		else
			return nil;
	}
;

Low_N_S_Passage: CCR_room
	sdesc = "Low N/S Passage"
	ldesc = {
		I(); "You are in a low N/S passage at a hole in the 
		floor.  The hole goes down to an E/W passage.";
	}
	hall = In_Hall_Of_Mt_King
	out = In_Hall_Of_Mt_King
	south = In_Hall_Of_Mt_King
	north = At_Y2
	y2 = At_Y2
	down = In_Dirty_Passage
	hole = In_Dirty_Passage
;

In_South_Side_Chamber: CCR_room
	sdesc = "In South Side Chamber"
	ldesc = {
		I(); "You are in the south side chamber.";
	}
	hall = In_Hall_Of_Mt_King
	out = In_Hall_Of_Mt_King
	north = In_Hall_Of_Mt_King
;

In_West_Side_Chamber: CCR_room
	sdesc = "In West Side Chamber"
	ldesc = {
		I(); "You are in the west side chamber of the hall of 
		the mountain king. A passage continues west and up 
		here.";
	}
	hall = In_Hall_Of_Mt_King
	out = In_Hall_Of_Mt_King
	east = In_Hall_Of_Mt_King
	west = Crossover
	up = Crossover
;

At_Y2: CCR_room
	sdesc = "At \"Y2\""
	ldesc = {
		I(); "You are in a large room, with a passage to the 
		south, a passage to the west, and a wall of broken 
		rock to the east. There is a large \"Y2\" on ";

		if (Me.isIn(Y2Rock))
			"the rock you are sitting on.";
		else
			"a rock in the room's center.";

		self.hollowvoice;
	}
	plugh = Inside_Building
	south = Low_N_S_Passage
	east = Jumble_Of_Rock
	wall = Jumble_Of_Rock
	broken = Jumble_Of_Rock
	west = At_Window_On_Pit_1
 	plover = {
		if (egg_sized_emerald.isIn(Me))
			egg_sized_emerald.moveInto(In_Plover_Room);
			
		return In_Plover_Room;
	}

	hollowvoice = {
		if (rand(100) <= 25) {
			P(); I(); "A hollow voice says, \"Plugh.\"";
		}
	}
;
Y2Rock: CCR_decoration, chairitem, readable
	sdesc = "\"Y2\" rock"
	ldesc = { self.readdesc; }
	readdesc = "There is a large \"Y2\" painted on the rock."
	noun = 'rock'
	adjective = 'y2'

	location = At_Y2

	plugh = { return self.location.plugh; }

	onroom = true	// We set ON the rock, not IN it.

	//
	// We want the player to be able to pick things in the
	// room up while sitting on the rock.
	//
	reachable = {
		return [Y2Rock] + At_Y2.contents;
	}
;

Jumble_Of_Rock: CCR_room
	sdesc = "Jumble of Rock"
	ldesc = {
		I(); "You are in a jumble of rock, with cracks 
		everywhere.";
	}
	down = At_Y2
	y2 = At_Y2
	up = In_Hall_Of_Mists
;

At_Window_On_Pit_1: CCR_room
	sdesc = "At Window on Pit"
	ldesc = {
		I(); "You're at a low window overlooking a huge pit, 
		which extends up out of sight.  A floor is 
		indistinctly visible over 50 feet below.  Traces of 
		white mist cover the floor of the pit, becoming 
		thicker to the right. Marks in the dust around the 
		window would seem to indicate that someone has been 
		here recently.  Directly across the pit from you and 
		25 feet away there is a similar window looking into a 
		lighted room.  A shadowy figure can be seen there 
		peering back at you.";
	}
	east = At_Y2
	y2 = At_Y2
	jump = { return broken_neck.death; }
;
Window: floatingdecoration
	sdesc = "window"
	ldesc = "It looks like a regular window."
	noun = 'window'
	adjective = 'low'
	loclist = [ At_Window_On_Pit_1  At_Window_On_Pit_2 ]

	verDoOpen(actor) = {}
	doOpen(actor) = { "OK, the window is now open."; }
	verDoClose(actor) = {}
	doClose(actor) = { "OK, the window is now closed."; }
;
WindowPit: floatingdecoration
	sdesc = "huge pit"
	ldesc = {
		"It's so deep you can barely make out the floor below,
		and the top isn't visible at all.";
	}
	noun = 'pit'
	adjective = 'deep' 'large'
	loclist = [ At_Window_On_Pit_1  At_Window_On_Pit_2 ]
;
MarksInTheDust: floatingdecoration
	sdesc = "marks in the dust"
	adesc = { self.sdesc; }
	ldesc = "Evidently you're not alone here."
	loclist = [ At_Window_On_Pit_1  At_Window_On_Pit_2 ]
;
ShadowyFigure: floatingdecoration
	sdesc = "shadowy figure"
	ldesc = {
		"The shadowy figure seems to be trying to attract 
		your attention.";
	}
	noun = 'figure' 'shadow' 'person' 'individual'
	adjective = 'shadowy' 'mysterious'
	loclist = [ At_Window_On_Pit_1  At_Window_On_Pit_2 ]
;
In_Dirty_Passage: CCR_room
	sdesc = "In Dirty Passage"
	ldesc = {
		I(); "You are in a dirty broken passage.  To the east 
		is a crawl.  To the west is a large passage.  Above 
		you is a hole to another passage.";
	}
	east = On_Brink_Of_Pit
	crawl = On_Brink_Of_Pit
	up = Low_N_S_Passage
	hole = Low_N_S_Passage
	west = In_Dusty_Rock_Room
	bedquilt = In_Bedquilt
	slab = In_Slab_Room	// DMB: this is only in some versions
;

On_Brink_Of_Pit: CCR_room
	sdesc = "On Brink of Pit"
	ldesc = {
		I(); "You are on the brink of a small clean climbable 
		pit.  A crawl leads west.";
	}
	west = In_Dirty_Passage
	crawl = In_Dirty_Passage
	down = In_Pit
	pit = In_Pit
	climb = In_Pit
	in = In_Pit	// DMB: added
;
CleanPit: CCR_decoration
	sdesc = "small pit"
	ldesc = "It looks like you might be able to climb down into it."
	noun = 'pit'
	adjective = 'small' 'clean' 'climable'
	location = On_Brink_Of_Pit

	verDoClimb(actor) = {}
	doClimb(actor) = { Me.travelTo(self.location.climb); }
	verDoEnter(actor) = {}
	doEnter(actor) = { self.doClimb(actor); }
;
In_Pit: CCR_room, NoNPC
	sdesc = "In Pit"
	ldesc = {
		I(); "You are in the bottom of a small pit with a 
		little stream, which enters and exits through tiny 
		slits.";
	}
	climb = On_Brink_Of_Pit
	up = On_Brink_Of_Pit
	out = On_Brink_Of_Pit

	slit = { return self.down; }
	stream = { return self.down; }
	upstream = { return self.down; }
	downstream = { return self.down; }
	down = {
		// In the original, the same message given
		// in At_Slit_In_Streambed was used here.
		// Since it's not quite right (and was probably only
		// reused to save space), I've changed it slightly.

		"You don't fit through the tiny slits!";
		return nil;
	}
;
PitSlits: decoration
	sdesc = "tiny slits"
	adesc = { self.sdesc; }
	ldesc = {
		"The slits form a complex pattern in the rock.";
	}
	location = In_Pit
	noun = 'slit' 'slits'
	adjective = 'tiny'
;

In_Dusty_Rock_Room: CCR_room
	sdesc = "In Dusty Rock Room"
	ldesc = {
		I(); "You are in a large room full of dusty rocks.  
		There is a big hole in the floor.  There are cracks 
		everywhere, and a passage leading east.";
	}
	east = In_Dirty_Passage
	passage = In_Dirty_Passage
	down = At_Complex_Junction
	hole = At_Complex_Junction
	floor = At_Complex_Junction
	bedquilt = In_Bedquilt
;
DustyRocks: CCR_decoration
	sdesc = "dusty rocks"
	ldesc = "They're just rocks.  (Dusty ones, that is.)"
	location = In_Dusty_Rock_Room
	noun = 'rocks' 'boulders' 'stones' 'rock' 'boulder' 'stone'
	adjective = 'dusty' 'dirty'
;

At_West_End_Of_Hall_Of_Mists: CCR_room
	sdesc = "At West End of Hall of Mists"
	ldesc = {
		I(); "You are at the west end of the hall of mists.  
		A low wide crawl continues west and another goes 
		north.  To the south is a little passage 6 feet off 
		the floor.";
	}
	south = Alike_Maze_1
	up = Alike_Maze_1
	passage = Alike_Maze_1
	climb = Alike_Maze_1
	east = West_Side_Of_Fissure
	west = At_East_End_Of_Long_Hall
	crawl = At_East_End_Of_Long_Hall

	north = {
		"You have crawled through a very low wide passage 
		parallel to and north of the hall of mists.\b";

		return West_Side_Of_Fissure;
	}	
;

Alike_Maze_1: CCR_alike_maze_room
	up = At_West_End_Of_Hall_Of_Mists
	north = Alike_Maze_1
	east = Alike_Maze_2
	south = Alike_Maze_4
	west = Alike_Maze_11
;

Alike_Maze_2: CCR_alike_maze_room
	west = Alike_Maze_1
	south = Alike_Maze_3
	east = Alike_Maze_4
;

Alike_Maze_3: CCR_alike_maze_room
	east = Alike_Maze_2
	down = Dead_End_3
	south = Alike_Maze_6
	north = Dead_End_13
;

Alike_Maze_4: CCR_alike_maze_room
	west = Alike_Maze_1
	north = Alike_Maze_2
	east = Dead_End_1
	south = Dead_End_2
	up = Alike_Maze_14
	down = Alike_Maze_14
;

Dead_End_1: CCR_dead_end_room
	west = Alike_Maze_4
	out = Alike_Maze_4
;

Dead_End_2: CCR_dead_end_room
	east = Alike_Maze_4
	out = Alike_Maze_4
;

Dead_End_3: CCR_dead_end_room
	up = Alike_Maze_3
	out = Alike_Maze_3
;

Alike_Maze_5: CCR_alike_maze_room
	east = Alike_Maze_6
	west = Alike_Maze_7
;

Alike_Maze_6: CCR_alike_maze_room
	east = Alike_Maze_3
	west = Alike_Maze_5
	down = Alike_Maze_7
	south = Alike_Maze_8
;

Alike_Maze_7: CCR_alike_maze_room
	west = Alike_Maze_5
	up = Alike_Maze_6
	east = Alike_Maze_8
	south = Alike_Maze_9
;

Alike_Maze_8: CCR_alike_maze_room
	west = Alike_Maze_6
	east = Alike_Maze_7
	south = Alike_Maze_8
	up = Alike_Maze_9
	north = Alike_Maze_10
	down = Dead_End_12
;

Alike_Maze_9: CCR_alike_maze_room
	west = Alike_Maze_7
	north = Alike_Maze_8
	south = Dead_End_4
;

Dead_End_4: CCR_dead_end_room
	west = Alike_Maze_9
	out = Alike_Maze_9
;

Alike_Maze_10: CCR_alike_maze_room
	west = Alike_Maze_8
	north = Alike_Maze_10
	down = Dead_End_5
	east = At_Brink_Of_Pit
;

Dead_End_5: CCR_dead_end_room
	up = Alike_Maze_10
	out = Alike_Maze_10
;

At_Brink_Of_Pit: CCR_room
	sdesc = "At Brink of Pit"
	ldesc = {
		I(); "You are on the brink of a thirty foot pit with 
		a massive orange column down one wall.  You could 
		climb down here but you could not get back up.  The 
		maze continues at this level.";
	}
	down = In_Bird_Chamber
	climb = In_Bird_Chamber
	west = Alike_Maze_10
	south = Dead_End_6
	north = Alike_Maze_12
	east = Alike_Maze_13
;
OrangeColumn: CCR_decoration
	sdesc = "massive orange column"
	ldesc = "It looks like you could climb down it."
	noun = 'column'
	adjective = 'massive' 'orange' 'big' 'huge'
	location = At_Brink_Of_Pit
	
	verDoClimb(actor) = {}
	doClimb(actor) = { Me.travelTo(self.location.down); }
;
ThirtyFootPit: CCR_decoration
	sdesc = "pit"
	ldesc = "You'll have to climb down to find out anything more..."
	noun = 'pit'
	adjective = 'thirty' 'foot' 'thirty-foot' '30-foot'
	location = At_Brink_Of_Pit

	verDoClimb(actor) = {}
	doClimb(actor) = { Me.travelTo(self.location.down); }
	verDoEnter(actor) = {}
	doEnter(actor) = { self.doClimb(actor); }
;

Dead_End_6: CCR_dead_end_room
	east = At_Brink_Of_Pit
	out = At_Brink_Of_Pit
;

At_East_End_Of_Long_Hall: CCR_room
	sdesc = "At East End of Long Hall"
	ldesc = {
		I(); "You are at the east end of a very long hall 
		apparently without side chambers.  To the east a low 
		wide crawl slants up.  To the north a round two foot 
		hole slants down.";
	}
	east = At_West_End_Of_Hall_Of_Mists
	up = At_West_End_Of_Hall_Of_Mists
	crawl = At_West_End_Of_Hall_Of_Mists
	west = At_West_End_Of_Long_Hall
	north = Crossover
	down = Crossover
	hole = Crossover
;

At_West_End_Of_Long_Hall: CCR_room
	sdesc = "At West End of Long Hall"
	ldesc = {
		I(); "You are at the west end of a very long 
		featureless hall.  The hall joins up with a narrow 
		north/south passage.";
	}
	east = At_East_End_Of_Long_Hall
	north = Crossover
	south = Different_Maze_1
;

Crossover: CCR_room
	sdesc = "N/S and E/W Crossover"
	ldesc = {
		I(); "You are at a crossover of a high N/S passage 
		and a low E/W one.";
	}
	west = At_East_End_Of_Long_Hall
	north = Dead_End_7
	east = In_West_Side_Chamber
	south = At_West_End_Of_Long_Hall
;
TheCrossover: CCR_decoration
	sdesc = "crossover"
	ldesc = "You know as much as I do at this point."
	noun = 'crossover' 'over'
	adjective = 'cross'
	location = Crossover
;

Dead_End_7: CCR_dead_end_room
	south = Crossover
	out = Crossover
;

At_Complex_Junction: CCR_room
	sdesc = "At Complex Junction"
	ldesc = {
		I(); "You are at a complex junction.  A low hands and 
		knees passage from the north joins a higher crawl 
		from the east to make a walking passage going west.  
		There is also a large room above.  The air is damp 
		here.";
	}
	up = In_Dusty_Rock_Room
	climb = In_Dusty_Rock_Room
	toroom = In_Dusty_Rock_Room
	west = In_Bedquilt
	bedquilt = In_Bedquilt
	north = In_Shell_Room
	shell = In_Shell_Room
	east = In_Anteroom
;

In_Bedquilt: CCR_room
	sdesc = "In Bedquilt"
	ldesc = {
		I(); "You are in bedquilt, a long east/west passage 
		with holes everywhere. To explore at random select 
		north, south, up, or down.";
	}
	east = At_Complex_Junction
	west = In_Swiss_Cheese_Room
	south = {
		if (rand(100) <= 80)
			return crawled_around.message;
		else
			return self.slab;
	}
	slab = In_Slab_Room

	up = {
		if (rand(100) <= 80)
			return crawled_around.message;
		else if (rand(100) <= 50)
			return In_Secret_N_S_Canyon_1;
		else
			return In_Dusty_Rock_Room;
	}

	north = {
		if (rand(100) <= 60)
			return crawled_around.message;
		else if (rand(100) <= 75)
			return In_Large_Low_Room;
		else
			return At_Junction_Of_Three_Secret_Canyons;
	}

	down = {
		if (rand(100) <= 80)
			return crawled_around.message;
		else
			return In_Anteroom;
	}

	//
	// Let the NPC's go everywhere out of here too.
	//
	NPCexit1 = In_Secret_N_S_Canyon_1
	NPCexit2 = In_Dusty_Rock_Room
	NPCexit3 = In_Large_Low_Room
	NPCexit4 = At_Junction_Of_Three_Secret_Canyons
	NPCexit5 = In_Anteroom
;

In_Swiss_Cheese_Room: CCR_room
	sdesc = "In Swiss Cheese Room"
	ldesc = {
		I(); "You are in a room whose walls resemble swiss 
		cheese.  Obvious passages go west, east, ne, and nw.  
		Part of the room is occupied by a large bedrock 
		block.";
	}
	ne = In_Bedquilt
	west = At_East_End_Of_Twopit_Room
	south = {
		if (rand(100) <= 80)
			return crawled_around.message;
		else
			return self.canyon;
	}
	canyon = In_Tall_E_W_Canyon

	east = In_Soft_Room
	nw = {
		if (rand(100) <= 50)
			return crawled_around.message;
		else
			return self.oriental;
	}
	oriental = In_Oriental_Room
;
BedrockBlock: CCR_decoration
	sdesc = "bedrock block"
	ldesc = "It's just a huge block."
	noun = 'block'
	adjective = 'bedrock' 'large'
	location = In_Swiss_Cheese_Room

	verDoLookunder(actor) = { "Surely you're joking."; }
	verDoMove(actor) = { self.verDoLookunder(actor); }
	verifyRemove(actor) = { self.verDoLookunder(actor); }
;

At_East_End_Of_Twopit_Room: CCR_room
	sdesc = "At East End of Twopit Room"
	ldesc = {
		I(); "You are at the east end of the twopit room.  
		The floor here is littered with thin rock slabs, 
		which make it easy to descend the pits. There is a 
		path here bypassing the pits to connect passages from 
		east and west.  There are holes all over, but the 
		only big one is on the wall directly over the west 
		pit where you can't get to it.";

		if (PlantStickingUp.isIn(self)) {
			P(); I(); PlantStickingUp.ldesc;
		}
	}
	east = In_Swiss_Cheese_Room
	west = At_West_End_Of_Twopit_Room
	across = At_West_End_Of_Twopit_Room
	down = In_East_Pit
	pit = In_East_Pit
;
Slabs: CCR_decoration
	sdesc = "thin rock slabs"
	adesc = { self.sdesc; }
	ldesc = "They almost form natural stairs down into the pit."
	noun = 'slabs' 'slab' 'rocks' 'stairs'
	adjective = 'thin' 'rock'
	location = At_East_End_Of_Twopit_Room

	verDoLookunder(actor) = { "Surely you're joking."; }
	verDoMove(actor) = { self.verDoLookunder(actor); }
	verifyRemove(actor) = { self.verDoLookunder(actor); }
;

In_Slab_Room: CCR_room
	sdesc = "In Slab Room"
	ldesc = {
		I(); "You are in a large low circular chamber whose 
		floor is an immense slab fallen from the ceiling 
		(slab room).  East and west there once were large 
		passages, but they are now filled with boulders.  Low 
		small passages go north and south, and the south one 
		quickly bends west around the boulders.";
	}
	south = At_West_End_Of_Twopit_Room
	up = In_Secret_N_S_Canyon_0
	climb = In_Secret_N_S_Canyon_0
	north = In_Bedquilt
;
Slab: CCR_decoration
	sdesc = "slab"
	ldesc = "It is now the floor here."
	noun = 'slab'
	adjective = 'immense'
	location = In_Slab_Room
;
SlabBoulders: CCR_decoration
	sdesc = "boulders"
	ldesc = "They're just ordinary boulders."
	noun = 'boulder' 'boulders' 'rocks' 'stones'
	location = In_Slab_Room
;

In_Secret_N_S_Canyon_0: CCR_room
	sdesc = "In Secret N/S Canyon"
	ldesc = {
		I(); "You are in a secret N/S canyon above a large 
		room.";
	}
	down = In_Slab_Room
	slab = In_Slab_Room

	south = {
		In_Secret_Canyon.enteredfrom := self;
		return In_Secret_Canyon;
	}

	north = In_Mirror_Canyon
	reservoir = At_Reservoir

	//
	// Let NPC's go into the secret canyon too, without regard to
	// whether the dragon's there.
	//
	NPCexit1 = In_Secret_Canyon
;

In_Secret_N_S_Canyon_1: CCR_room
	sdesc = "In Secret N/S Canyon"
	ldesc = {
		I(); "You are in a secret N/S canyon above a sizable 
		passage.";
	}
	north = At_Junction_Of_Three_Secret_Canyons
	down = In_Bedquilt
	passage = In_Bedquilt
	south = Atop_Stalactite
;

At_Junction_Of_Three_Secret_Canyons: CCR_room
	sdesc = "At Junction of Three Secret Canyons"
	ldesc = {
		I(); "You are in a secret canyon at a junction of 
		three canyons, bearing north, south, and se.  The 
		north one is as tall as the other two combined.";
	}
	se = In_Bedquilt
	south = In_Secret_N_S_Canyon_1
	north = At_Window_On_Pit_2
;

In_Large_Low_Room: CCR_room
	sdesc = "In Large Low Room"
	ldesc = {
		I(); "You are in a large low room.  Crawls lead 
		north, se, and sw.";
	}
	bedquilt = In_Bedquilt
	sw = In_Sloping_Corridor
	north = Dead_End_Crawl
	se = In_Oriental_Room
	oriental = In_Oriental_Room
;

Dead_End_Crawl: CCR_dead_end_room
	sdesc = "Dead End Crawl"
	ldesc = {
		I(); "This is a dead end crawl.";
	}
	south = In_Large_Low_Room
	crawl = In_Large_Low_Room
	out = In_Large_Low_Room
;

In_Secret_E_W_Canyon: CCR_room
	sdesc = "In Secret E/W Canyon Above Tight Canyon"
	ldesc = {
		I(); "You are in a secret canyon which here runs E/W. 
		It crosses over a very tight canyon 15 feet below.  
		If you go down you may not be able to get back up.";
	}
	east = In_Hall_Of_Mt_King
	west = {
		In_Secret_Canyon.enteredfrom := self;
		return In_Secret_Canyon;
	}
	down = In_N_S_Canyon

	//
	// Let NPC's go into the secret canyon too, without regard to
	// whether the dragon's there.
	//
	NPCexit1 = In_Secret_Canyon
;

In_N_S_Canyon: CCR_room
	sdesc = "In N/S Canyon"
	ldesc = {
		I(); "You are at a wide place in a very tight N/S 
		canyon.";
	}
	south = Canyon_Dead_End
	north = In_Tall_E_W_Canyon
;

Canyon_Dead_End: CCR_dead_end_room
	sdesc = "Canyon Dead End"
	ldesc = {
		I(); "The canyon here becomes too tight to go further 
		south.";
	}
	north = In_N_S_Canyon
;

In_Tall_E_W_Canyon: CCR_room
	sdesc = "In Tall E/W Canyon"
	ldesc = {
		I(); "You are in a tall E/W canyon.  A low tight 
		crawl goes 3 feet north and seems to open up.";
	}
	east = In_N_S_Canyon
	west = Dead_End_8
	north = In_Swiss_Cheese_Room
	crawl = In_Swiss_Cheese_Room
;

Dead_End_8: CCR_dead_end_room
	ldesc = {
		I(); "The canyon runs into a mass of boulders -- dead 
		end.";
	}
	south = In_Tall_E_W_Canyon
	out = In_Tall_E_W_Canyon	// DMB: added
;
MassOfBoulders: CCR_decoration
	sdesc = "mass of boulders"
	ldesc = "They just like ordinary boulders."
	noun = 'boulders' 'mass'
	location = Dead_End_8
;

Alike_Maze_11: CCR_alike_maze_room
	north = Alike_Maze_1
	west = Alike_Maze_11
	south = Alike_Maze_11
	east = Dead_End_9
;

Dead_End_9: CCR_dead_end_room
	west = Alike_Maze_11
	out = Alike_Maze_11
;

Dead_End_10: CCR_dead_end_room
	south = Alike_Maze_3
	out = Alike_Maze_3
;

Alike_Maze_12: CCR_alike_maze_room
	south = At_Brink_Of_Pit
	east = Alike_Maze_13
	west = Dead_End_11
;

Alike_Maze_13: CCR_alike_maze_room
	north = At_Brink_Of_Pit
	west = Alike_Maze_12
	nw = Dead_End_13
;

Dead_End_11: CCR_dead_end_room
	east = Alike_Maze_12
	out = Alike_Maze_12
;

Dead_End_12: CCR_dead_end_room
	up = Alike_Maze_8
	out = Alike_Maze_8
;

Alike_Maze_14: CCR_alike_maze_room
	up = Alike_Maze_4
	down = Alike_Maze_4
;

In_Narrow_Corridor: CCR_room
	sdesc = "In Narrow Corridor"
	ldesc = {
		I(); "You are in a long, narrow corridor stretching 
		out of sight to the west.  At the eastern end is a 
		hole through which you can see a profusion of 
		leaves.";
	}
	down = In_West_Pit
	climb = In_West_Pit
	east = In_West_Pit
	jump = { return broken_neck.death; }
	west = In_Giant_Room
	giant = In_Giant_Room
;
Leaves: CCR_decoration
	sdesc = "leaves"
	ldesc = {
		"The leaves appear to be attached to the beanstalk 
		you climbed to get here.";
	}
	location = In_Narrow_Corridor
	noun = 'leaf' 'leaves' 'plant' 'tree' 'stalk' 'beanstalk' 'profusion'
;

At_Steep_Incline_Above_Large_Room: CCR_room
	sdesc = "At Steep Incline Above Large Room"
	ldesc = {
		I(); "You are at the top of a steep incline above a 
		large room.  You could climb down here, but you would 
		not be able to climb up.  There is a passage leading 
		back to the north.";
	}
	north = In_Cavern_With_Waterfall
	cavern = In_Cavern_With_Waterfall
	passage = In_Cavern_With_Waterfall
	down = In_Large_Low_Room
	climb = In_Large_Low_Room
;

In_Giant_Room: CCR_room
	sdesc = "In Giant Room"
	ldesc = {
		I(); "You are in the giant room.  The ceiling here is 
		too high up for your lamp to show it.  Cavernous 
		passages lead east, north, and south.  On the west 
		wall is scrawled the inscription, \"Fee fie foe foo\" 
		[sic].";
	}
	south = In_Narrow_Corridor
	east = At_Recent_Cave_In
	north = In_Immense_N_S_Passage
;
Inscription: CCR_decoration, readable
	sdesc = "scrawled inscription"
	ldesc = "It says, \"Fee fie foe foo [sic].\""
	noun = 'inscription' 'writing' 'scrawl'
	adjective = 'scrawled'
	location = In_Giant_Room
;

At_Recent_Cave_In: CCR_room
	sdesc = "At Recent Cave-in"
	ldesc = {
		I(); "The passage here is blocked by a recent 
		cave-in.";
	}
	south = In_Giant_Room
	giant = In_Giant_Room
	out = In_Giant_Room
;
CaveIn: CCR_decoration
	sdesc = "cave-in"
	ldesc = { self.location.ldesc; }
	noun = 'in' 'cave-in'
	adjective = 'cave'
	location = At_Recent_Cave_In
;

In_Immense_N_S_Passage: CCR_room
	sdesc = "In Immense N/S Passage"
	ldesc = {
		I(); "You are at one end of an immense north/south 
		passage. ";

		if (not RustyDoor.isoiled)
 			"The way north is barred by a massive, rusty, 
			iron door.";
		else
			"The way north leads through a massive, 
			rusty, iron door.";
	}
	south = In_Giant_Room
	giant = In_Giant_Room
	passage = In_Giant_Room

	enter = { return self.north; }
	cavern = { return self.north; }
	north = {
		if (RustyDoor.isoiled) {
			return In_Cavern_With_Waterfall;
		}
		else {
			"The door is extremely rusty and refuses to open.";
			return nil;
		}
	}

	//
	// Only let NPC's go through the door once it's open.
	//
	NPCexit1 = {
		if (RustyDoor.isoiled)
			return In_Cavern_With_Waterfall;
		else
			return nil;
	}
;
RustyDoor: CCR_decoration
	isoiled = nil

	sdesc = "rusty door"
	ldesc = "It's just a big iron door."
	location = In_Immense_N_S_Passage
	noun = 'door' 'hinge' 'hinges'
	adjective = 'massive' 'rusty' 'iron'

	verDoOpen(actor) = {
		if (self.oiled)
			"It's already open.";
		else
			"The hinges are quite thoroughly rusted now 
			and won't budge.";
	}
	verDoClose(actor) = {
		if (self.oiled)
			"No problem there -- it already is.";
		else
			"With all the effort it took to get the door 
			open, I wouldn't suggest closing it again.";
	}
	verDoOil(actor) = {}
	doOil(actor) = {
		if (bottle.isIn(Me))
			bottle.doPourOn(actor, self);
		else
			"You have nothing to oil it with.";
	}
;

In_Cavern_With_Waterfall: CCR_room
	sdesc = "In Cavern With Waterfall"
	ldesc = {
		I(); "You are in a magnificent cavern with a rushing 
		stream, which cascades over a sparkling waterfall 
		into a roaring whirlpool which disappears through a 
		hole in the floor.  Passages exit to the south and 
		west.";
	}
	south = In_Immense_N_S_Passage
	out = In_Immense_N_S_Passage
	giant = In_Giant_Room
	west = At_Steep_Incline_Above_Large_Room
;
Waterfall: CCR_decoration
	sdesc = "waterfall"
	ldesc = "Wouldn't want to go down in in a barrel!"
	noun = 'waterfall' 'whirpool'
	adjective = 'sparkling' 'whirling'
	location = In_Cavern_With_Waterfall
;

In_Soft_Room: CCR_room
	sdesc = "In Soft Room"
	ldesc = {
		I(); "You are in the soft room.  The walls are 
		covered with heavy curtains, the floor with a thick 
		pile carpet.  Moss covers the ceiling.";
	}
	west = In_Swiss_Cheese_Room
	out = In_Swiss_Cheese_Room
;
Carpet: CCR_decoration
	sdesc = "carpet"
	ldesc = "The carpet is quite plush."
	noun = 'carpet' 'shag' 'pile'
	adjective = 'pile' 'heavy' 'thick'
	location = In_Soft_Room
;
Curtains: CCR_decoration
	sdesc = "curtains"
	ldesc = "They seem to absorb sound very well."
	noun = 'curtain' 'curtains'
	adjective = 'heavy' 'thick'
	location = In_Soft_Room

	verifyRemove(actor) = { "Now don't go ripping up the place!"; }
	verDoLookbehind(actor) = {}
	doLookbehind(actor) = {
		"You don't find anything exciting behind the curtains.";
	}
;
Moss: CCR_decoration
	sdesc = "moss"
	ldesc = "It just looks like your typical, everyday moss."
	noun = 'moss'
	adjective = 'typical' 'everyday'
	location = In_Soft_Room

	verifyRemove(actor) = { "It's too high up for you to reach."; }
	verDoEat(actor) = { "Eeeewwwww."; }
;

In_Oriental_Room: CCR_room
	sdesc = "In Oriental Room"
	ldesc = {
		I(); "This is the oriental room.  Ancient oriental 
		cave drawings cover the walls.  A gently sloping 
		passage leads upward to the north, another passage 
		leads se, and a hands and knees crawl leads west.";
	}
	se = In_Swiss_Cheese_Room
	west = In_Large_Low_Room
	crawl = In_Large_Low_Room
	up = In_Misty_Cavern
	north = In_Misty_Cavern
	cavern = In_Misty_Cavern
;
CaveDrawings: CCR_decoration
	sdesc = "ancient oriental drawings"
	ldesc = "They seem to depict people and animals."
	noun = 'paintings' 'drawings' 'art'
	adjective = 'cave' 'ancient' 'oriental'
	location = In_Oriental_Room
;

In_Misty_Cavern: CCR_room
	sdesc = "In Misty Cavern"
	ldesc = {
		I(); "You are following a wide path around the outer 
		edge of a large cavern. Far below, through a heavy 
		white mist, strange splashing noises can be heard.  
		The mist rises up through a fissure in the ceiling.  
		The path exits to the south and west.";
	}
	south = In_Oriental_Room
	oriental = In_Oriental_Room
	west = In_Alcove
;
CeilingFissure: CCR_decoration
	sdesc = "fissure"
	ldesc = "You can't really get close enough to examine it."
	noun = 'fissure'
	location = In_Misty_Cavern
;

In_Alcove: CCR_room
	sdesc = "In Alcove"
	ldesc = {
		I(); "You are in an alcove.  A small northwest path seems 
		to widen after a short distance.  An extremely tight 
		tunnel leads east.  It looks like a very tight 
		squeeze.  An eerie light can be seen at the other 
		end.";
	}
	nw = In_Misty_Cavern
	cavern = In_Misty_Cavern
	passage = { return self.east; }
	east = {
		//
		// The player must be carrying only the emerald or
		// nothing at all to fit through the tight tunnel.
		//
		if (length(Me.contents) > 1)
			return wontfit.message;
		else if (length(Me.contents) = 1) {
			if (egg_sized_emerald.isIn(Me))
				return In_Plover_Room;
			else
				return wontfit.message;
		}
		else
			return In_Plover_Room;
	}

	//
	// Let NPC's go in the plover room regardless of what
	// they're carrying.  (Life's not fair in the Colossal Cave.)
	//
	NPCexit1 = In_Plover_Room
;

In_Plover_Room: CCR_room, lightroom
	sdesc = "In Plover Room"
	ldesc = {
		I(); "You're in a small chamber lit by an eerie green 
		light.  An extremely narrow tunnel exits to the west. 
		A dark corridor leads northeast.";
	}

	passage = { return self.west; }
	out =  { return self.west; }
	west = {
		//
		// The player must be carrying only the emerald or
		// nothing at all to fit through the tight tunnel.
		//
		if (length(Me.contents) > 1)
			return wontfit.message;
		else if (length(Me.contents) = 1) {
			if (egg_sized_emerald.isIn(Me))
				return In_Alcove;
			else
				return wontfit.message;
		}
		else
			return In_Alcove;
	}

	ne = In_Dark_Room
	dark = In_Dark_Room

 	plover = At_Y2

	//
	// Let NPC's leave the plover room regardless of what
	// they're carrying.  (Life's not fair in the Colossal Cave.)
	//
	NPCexit1 = In_Alcove
;

In_Dark_Room: CCR_room
	sdesc = "In Dark Room"
	ldesc = {
		I(); "You're in the dark-room.  A corridor leading 
		south is the only exit."; P();

		I(); StoneTablet.ldesc; 
	}
	south = In_Plover_Room
	plover = In_Plover_Room
	out = In_Plover_Room
;
StoneTablet: CCR_decoration
	sdesc = "stone tablet"
	ldesc = {
		"A massive stone tablet imbedded in the wall reads: 
		\"Congratulations on bringing light into the 
		dark-room!\"";
	}
	location = In_Dark_Room
	noun = 'tablet'
	adjective = 'massive' 'stone'
;

In_Arched_Hall: CCR_room
	sdesc = "In Arched Hall"
	ldesc = {
		I(); "You are in an arched hall.  A coral passage 
		once continued up and east from here, but is now 
		blocked by debris.  The air smells of sea water.";
	}
	down = In_Shell_Room
	shell = In_Shell_Room
	out = In_Shell_Room
;

In_Shell_Room: CCR_room
	sdesc = "In Shell Room"
	ldesc = {
		I(); "You're in a large room carved out of 
		sedimentary rock.  The floor and walls are littered 
		with bits of shells imbedded in the stone.  A shallow 
		passage proceeds downward, and a somewhat steeper one 
		leads up.  A low hands and knees passage enters from 
		the south.";
	}
	up = In_Arched_Hall
	hall = In_Arched_Hall
	down = In_Ragged_Corridor
	
	south = {
		if (giant_bivalve.isIn(Me)) {
			if (giant_bivalve.opened)
				"You can't fit this five-foot oyster 
				through that little passage!";
			else
				"You can't fit this five-foot clam 
				through that little passage!";

			return nil;
		}
		else 
			return At_Complex_Junction;
	}

	//
	// Let NPC's through.
	//
	NPCexit1 = At_Complex_Junction
;

In_Ragged_Corridor: CCR_room
	sdesc = "In Ragged Corridor"
	ldesc = {
		I(); "You are in a long sloping corridor with ragged 
		sharp walls.";
	}
	up = In_Shell_Room
	shell = In_Shell_Room
	down = In_A_Cul_De_Sac
;

In_A_Cul_De_Sac: CCR_room
	sdesc = "In a Cul-de-Sac"
	ldesc = {
		I(); "You are in a cul-de-sac about eight feet 
		across.";
	}
	up = In_Ragged_Corridor
	out = In_Ragged_Corridor
	shell = In_Shell_Room
;

In_Anteroom: CCR_room
	sdesc = "In Anteroom"
	ldesc = {
		I(); "You are in an anteroom leading to a large 
		passage to the east.  Small passages go west and up.  
		The remnants of recent digging are evident."; P();

		I(); "A sign in midair here says \"Cave under 
		construction beyond this point. Proceed at own risk.  
		[Witt Construction Company]\"";
	}
	up = At_Complex_Junction
	west = In_Bedquilt
	east = At_Witts_End
;
WittSign: CCR_decoration, readable
	sdesc = 'sign'
	ldesc = "It's hanging way above your head."
	readdesc = {
		"It says \"Cave under construction beyond this point. 
		Proceed at own risk.  [Witt Construction Company]\"";
	}
	noun = 'sign'
	adjective = 'hanging'
	location = In_Anteroom

	verifyRemove(actor) = { "No chance.  It's too far up."; }
;

/*
 * This was off limits to NPC's in the original, but I don't see
 * any reason to keep that restriction since it seemed to be
 * related to some hackery in the way the movement worked.
 *
 * It could be argued that the pirate shouldn't show up in the mazes,
 * since his taking stuff away from the player could make mapping the
 * maze a real pain.
 */
Different_Maze_1: CCR_room
	sdesc = "Maze of Twisty Little Passages, All Different"
	ldesc = {
		I(); "You are in a maze of twisty little passages, 
		all different.";
	}
	south = Different_Maze_3
	sw = Different_Maze_4
	ne = Different_Maze_5
	se = Different_Maze_6
	up = Different_Maze_7
	nw = Different_Maze_8
	east = Different_Maze_9
	west = Different_Maze_10
	north = Different_Maze_11
	down = At_West_End_Of_Long_Hall
;

At_Witts_End: CCR_room
	sdesc = "At Witt's End"
	ldesc = {
		I(); "You are at Witt's End.  Passages lead off in 
		*all* directions.";
	}
	east = {
		if (rand(100) <= 95) 
			return crawled_around.message;
		else
			return In_Anteroom;
	}
	west = {
		"You have crawled around in some little holes and 
		found your way blocked by a recent cave-in.  You are 
		now back in the main passage.";

		return nil;
	}

	north = { return self.east; }
	south = { return self.east; }
	ne = { return self.east; }
	se = { return self.east; }
	sw = { return self.east; }
	nw = { return self.east; }
	up = { return self.east; }
	down = { return self.east; }

	//
	// Let NPC's out of here with no trouble
	//
	NPCexit1 = In_Anteroom
;

In_Mirror_Canyon: CCR_room
	sdesc = "In Mirror Canyon"
	ldesc = {
		I(); "You are in a north/south canyon about 25 feet 
		across.  The floor is covered by white mist seeping 
		in from the north.  The walls extend upward for well 
		over 100 feet.  Suspended from some unseen point far 
		above you, an enormous two-sided mirror is hanging 
		parallel to and midway between the canyon walls. ";

		"("; CanyonMirror.ldesc; ")"; 

		P(); I(); "A small window can be seen in either wall, 
		some fifty feet up.";
	}
	south = In_Secret_N_S_Canyon_0
	north = At_Reservoir
	reservior = At_Reservoir
;
Mirror_1: CCR_decoration
	sdesc = "enormous mirror"
	ldesc = "It looks like an ordinary, albeit enormous, mirror."
	location = In_Mirror_Canyon
	noun = 'mirror'
	adjective = 'enormous' 'huge' 'big' 'large' 'suspended'
		'hanging' 'vanity' 'dwarvish'

	verDoBreak(actor) = { self.verifyRemove(actor); }
	verifyRemove(actor) = { "You can't reach it from here."; }
;
CanyonMirror: CCR_decoration
	sdesc = "suspended mirror"
	ldesc = {
		"The mirror is obviously provided for the use of the 
		dwarves, who as you know, are extremely vain.";
	}
	noun = 'mirror'
	adjective = 'massive' 'hanging' 'suspended' 'dwarves\'' 'two-sided'
		'two' 'sided'
	location = In_Mirror_Canyon
;

At_Window_On_Pit_2: CCR_room
	sdesc = "At Window on Pit"
	ldesc = {
		I(); "You're at a low window overlooking a huge pit, 
		which extends up out of sight.  A floor is 
		indistinctly visible over 50 feet below.  Traces of 
		white mist cover the floor of the pit, becoming 
		thicker to the left. Marks in the dust around the 
		window would seem to indicate that someone has been 
		here recently.  Directly across the pit from you and 
		25 feet away there is a similar window looking into a 
		lighted room.  A shadowy figure can be seen there 
		peering back at you.";
	}
	west = At_Junction_Of_Three_Secret_Canyons
	jump = { return broken_neck.death; }
;

Atop_Stalactite: CCR_room
	sdesc = "Atop Stalactite"
	ldesc = {
		I(); "A large stalactite extends from the roof and 
		almost reaches the floor below.  You could climb down 
		it, and jump from it to the floor, but having done so 
		you would be unable to reach it to climb back up.";
	}
	north = In_Secret_N_S_Canyon_1

	jump = { return self.down; }
	climb = { return self.down; }
	down = {
		if (rand(100) <= 40)
			return Alike_Maze_6;
		else if (rand(100) <= 50)
			return Alike_Maze_9;
		else
			return Alike_Maze_4;
	}

	//
	// Let NPC's through to the maze
	//
	NPCexit1 = Alike_Maze_6
	NPCexit2 = Alike_Maze_9
	NPCexit3 = Alike_Maze_4
;
Stalactite: CCR_decoration
	sdesc = "stalactite"
	ldesc = {
		"You could probably climb down it, but you can forget 
		coming back up.";
	}
	noun = 'stalactite' 'stalagmite' 'stalagtite'
	adjective = 'large'
	location = Atop_Stalactite

	verDoLookunder(actor) = { "Do get a grip on yourself."; }
	verDoMove(actor) = { self.verDoLookunder(actor); }
	verifyRemove(actor) = { self.verDoLookunder(actor); }
;

Different_Maze_2: CCR_room
	sdesc = "Little Maze of Twisting Passages, All Different"
	ldesc = {
		I(); "You are in a little maze of twisting passages, 
		all different.";
	}
	sw = Different_Maze_3
	north = Different_Maze_4
	east = Different_Maze_5
	nw = Different_Maze_6
	se = Different_Maze_7
	ne = Different_Maze_8
	west = Different_Maze_9
	down = Different_Maze_10
	up = Different_Maze_11
	south = Dead_End_14
;

At_Reservoir: CCR_room
	sdesc = "At Reservoir"
	ldesc = {
		I(); "You are at the edge of a large underground 
		reservoir.  An opaque cloud of white mist fills the 
		room and rises rapidly upward.  The lake is fed by a 
		stream, which tumbles out of a hole in the wall about 
		10 feet overhead and splashes noisily into the water 
		somewhere within the mist.  The only passage goes 
		back toward the south.";
	}
	south = In_Mirror_Canyon
	out = In_Mirror_Canyon

	//
	// The original had another exit, but the verb it was attached
	// to didn't exists.  I have no idea what was intended here...
	//
	// ??? = In_Mirror_Canyon
;

//
// Here's where the pirate(s) keeps his treasure (as well as any loot
// he's swiped from the player).  Once the chest has been been found
// here, turn off the pirate(s) completely.  (This is how the original
// handled it, and it's thankfully merciful so I've kept it the same.)
//
Dead_End_13: CCR_dead_end_room, NoNPC
	se = Alike_Maze_13
	out = Alike_Maze_13	// DMB: added

	ldesc = "This is the pirate's dead end."

	enterRoom(actor) = {
		if (treasure_chest.isIn(Me) and not treasure_chest.spotted) {
			P(); I(); "You've found the pirate's treasure chest!";
			unnotify(Pirates, &move);
			treasure_chest.spotted := true;
			PirateMessage.moveInto(nil);
		}

		pass enterRoom;
	}
;

On_Sw_Side_Of_Chasm: CCR_room
	sdesc = "On SW Side of Chasm"
	ldesc = {
		I(); "You are on one side of a large, deep chasm.  A 
		heavy white mist rising up from below obscures all 
		view of the far side.  A southwest path leads away 
		from the chasm into a winding corridor. ";

		RicketyBridge.xdesc;

		if (Troll.location = nil) {
			P(); I();
			"The troll is nowhere to be seen.";
		}
	}
	sw = In_Sloping_Corridor

	across = { return self.over; }
	cross = { return self.over; }
	ne = { return self.over; }
	over = {
		RicketyBridge.doCross(Me);
		return nil;
	}
	
	jump = {
		if (RicketyBridge.exists) {
			"I respectfully suggest you go across the 
			bridge instead of jumping.";

			return nil;
		}
		else
			return didnt_make_it.death;
	}

	//
	// No NPC exits because we don't want the pirate to be able
	// to go across the bridge and steal the player's return toll.
	// (All rooms on the other side of the bridge are off limits
	// to NPC's.)
	//
	// It would be OK for dwarves to show up over there, except
	// that they might run into the bear, a situation for which we don't
	// have any code.  (This is how the original was as well.)
	//
;
RicketyBridge: CCR_decoration
	exists = true

	sdesc = "rickety bridge"
	ldesc = "It just looks like an ordinary, but unstable, bridge."

	xdesc = {
		if (self.exists) {
			"A rickety wooden bridge extends across the 
			chasm, vanishing into the mist."; P();

			I(); "A sign posted on the bridge reads, 
			\"Stop! Pay troll!\"";
		}
		else {
			"The wreckage of a bridge (and a dead bear) 
			can be seen at the bottom of the chasm.";
		}
	}

	noun = 'bridge'
	adjective = 'rickety' 'unstable' 'wobbly' 'rope'

	locationOK = true	// tell compiler OK for location to be method
	location = {
		if (self.exists) {
			if (Me.isIn(On_Sw_Side_Of_Chasm))
				return On_Sw_Side_Of_Chasm;
			else
				return On_Ne_Side_Of_Chasm;
		}
		else
			return nil;
	}

	verDoCross(actor) = {}
	doCross(actor) = {
		if (self.exists) {
			if (Troll.ispaid or Troll.location = nil)
				self.cross;
			else {
				if (Troll.isIn(self.location)) {
					"The troll refuses to let you 
					cross.";
				}
				else {
					"The troll steps out from 
					beneath the bridge and blocks 
					your way.";

					Troll.moveInto(self.location);
				}
			}
		}
		else
			"There is no longer any way across the chasm.";
	}

	cross = {
		if (Bear.isfollowing) {
			"Just as you reach the other side, the bridge 
			buckles beneath the weight of the bear, which 
			was still following you around.  You scrabble 
			desperately for support, but as the bridge 
			collapses you stumble back and fall into the 
			chasm.";

			// Get rid of the bridge in case the
			// player gets reincarnated and
			// continues the game.
			self.exists := nil;

			// No more bear!
			Bear.exists := nil;

			die();
		}
		else if (Me.isIn(On_Sw_Side_Of_Chasm)) {
			Troll.ispaid := nil;
			Me.travelTo(On_Ne_Side_Of_Chasm);
		}
		else {
			Troll.ispaid := nil;
			Me.travelTo(On_Sw_Side_Of_Chasm);
		}
	}
;
Troll: Actor
	ispaid = nil

	sdesc = "burly troll"
	ldesc = {
		"Trolls are close relatives with rocks and have skin 
		as tough as that of a rhinoceros.";
	}

	actorDesc = {
		P(); I();
		"A burly troll stands by the bridge and insists you 
		throw him a treasure before you may cross.";
	}

	noun = 'troll'
	adjective = 'burly'

	location = On_Sw_Side_Of_Chasm

	verDoKick(actor) = {}
	doKick(actor) = {
		"The troll laughs alound at your pitiful attempt
		to injure him.";
	}

	verDoAttack(actor) = {
		"The troll fends off your blows effortlessly.";
	}
	verDoAttackWith(actor, io) = {}
	doAttackWith(actor, io) = {
		//
		// If the player throws the axe at the troll,
		// he just catches it.
		//
		if (io = axe)
			self.ioGiveTo(actor, io);
		else
			self.verDoAttack(actor);
	}

	verIoGiveTo(actor) = {}
	ioGiveTo(actor, dobj) = {
		if (isclass(dobj, CCR_treasure_item)) {
			"The troll catches your treasure and scurries 
			away out of sight.";

			dobj.moveInto(nil);
			self.ispaid := true;
		}
		else if( dobj = tasty_food) {
			self.doFeed(Me);
		}
		else {
			"The troll deftly catches "; dobj.thedesc;
			", examines it carefully, and tosses it back, 
			declaring, \"Good workmanship, but it's not 
			valuable enough.\"";
		}
	}

	verIoThrowAt(actor) = { self.verIoGiveTo(actor); }
	ioThrowAt(actor, dobj) = { self.ioGiveTo(actor, dobj); }
	verIoThrowTo(actor) = { self.verIoGiveTo(actor); }
	ioThrowTo(actor, dobj) = { self.ioGiveTo(actor, dobj); }

	verDoFeed(actor) = {}
	doFeed(actor) = {
		if (tasty_food.isIn(Me)) {
			"Gluttony is not one of the troll's vices. 
			Avarice, however, is.";
		}
		else {
			"You have nothing the troll wants to eat.";
		}
	}
;

In_Sloping_Corridor: CCR_room
	sdesc = "In Sloping Corridor"
	ldesc = {
		I(); "You are in a long winding corridor sloping out 
		of sight in both directions.";
	}
	down = In_Large_Low_Room
	up = On_Sw_Side_Of_Chasm
;

In_Secret_Canyon: CCR_room
	enteredfrom = nil

	sdesc = "In Secret Canyon"
	ldesc = {
		I(); "You are in a secret canyon which exits to the 
		north and east."; P();

		I();
		if (Dragon.isIn(self))
			"A huge green fierce dragon bars the way!";
		else
			DragonCorpse.ldesc;
	}
	north = {
		if (self.enteredfrom = In_Secret_N_S_Canyon_0) {
			return self.enteredfrom;
		}
		else {
			if (self.dragoncheck)
				return In_Secret_N_S_Canyon_0;
			else
				return nil;
		}
	}
	east = {
		if (self.enteredfrom = In_Secret_E_W_Canyon) {
			return self.enteredfrom;
		}
		else {
			if (self.dragoncheck)
				return In_Secret_E_W_Canyon;
			else
				return nil;
		}
	}

	forwards = {
		if (self.enteredfrom = In_Secret_N_S_Canyon_0)
			return self.east;
		else
			return self.north;
	}
	out = {
		if (self.enteredfrom = In_Secret_N_S_Canyon_0)
			return self.north;
		else
			return self.east;
	}

	dragoncheck = {
		if (Dragon.isIn(self)) {
			"The dragon looks rather nasty.  You'd best 
			not try to get by.";

			return nil;
		}
		else
			return true;
	}

	//
	// Let NPC's by the dragon without incident (they're all on
	// the same team, after all).
	//
	NPCexit1 = In_Secret_N_S_Canyon_0
	NPCexit2 = In_Secret_E_W_Canyon
;
Dragon: CCR_decoration
	rhetoricalturn = -999	// hack -- see yesVerb in ccr-verbs.t
	
	sdesc = "dragon"
	ldesc = "I wouldn't mess with it if I were you."
	location = In_Secret_Canyon
	noun = 'dragon' 'monster' 'beast' 'lizard'
	adjective = 'huge' 'green' 'fierce' 'scaly' 'giant' 'ferocious'

	verDoKick(actor) = {}
	doKick(actor) = {
		"Right idea, wrong limb.";
	}

	verDoAttack(actor) = {}
	doAttack(actor) = {
		"With what?  Your bare hands?";
		self.rhetoricalturn := global.turnsofar;
	}
	verDoAttackWith(actor, io) = {}
	doAttackWith(actor, io) = {
		if (io = axe)
			"The axe bounces harmlessly off the dragon's 
			thick scales.";
		else if (io = Hands) {
			self.kill;
		}
		else {
			"You'd probably be better off using your
			bare hands than that thing!";
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

	kill = {
		"Congratulations!  You have just vanquished a 
		dragon with your bare hands!  (Unbelievable, 
		isn't it?)";

		DragonCorpse.moveInto(self.location);
		self.moveInto(nil);
	}
;
DragonCorpse: CCR_decoration
	sdesc = "dragon"
	ldesc = {
		"The body of a huge green dead dragon is lying off to 
		one side.";
	}
	location = nil
	noun = 'dragon' 'corpse'
	adjective = 'dead'
	
	verDoKick(actor) = { "You've already done enough damage!"; }
	verDoAttack(actor) = { self.verDoKick(actor); }
	verDoAttackWith(actor, io) = { self.verDoKick(actor); }
;

On_Ne_Side_Of_Chasm: CCR_room, NoNPC
	sdesc = "On NE Side of Chasm"
	ldesc = {
		I(); "You are on the far side of the chasm.  A 
		northeast path leads away from the chasm on this 
		side. ";

		RicketyBridge.xdesc;

		if (Troll.location = nil) {
			P(); I();
			"The troll is nowhere to be seen.";
		}
	}
	ne = In_Corridor

	across = { return self.over; }
	cross = { return self.over; }
	sw = { return self.over; }
	over = {
		RicketyBridge.doCross(Me);
		return nil;
	}
	
	jump = {
		if (RicketyBridge.exists) {
			"I respectfully suggest you go across the 
			bridge instead of jumping.";

			return nil;
		}
		else
			return didnt_make_it.death;
	}

	fork = At_Fork_In_Path
	view = At_Breath_Taking_View
	barren = In_Front_Of_Barren_Room
;

In_Corridor: CCR_room, NoNPC
	sdesc = "In Corridor"
	ldesc = {
		I(); "You're in a long east/west corridor.  A faint 
		rumbling noise can be heard in the distance.";
	}
	west = On_Ne_Side_Of_Chasm
	east = At_Fork_In_Path
	fork = At_Fork_In_Path
	view = At_Breath_Taking_View
	barren = In_Front_Of_Barren_Room
;

At_Fork_In_Path: CCR_room, NoNPC
	sdesc = "At Fork in Path"
	ldesc = {
		I(); "The path forks here.  The left fork leads 
		northeast.  A dull rumbling seems to get louder in 
		that direction.  The right fork leads southeast down 
		a gentle slope.  The main corridor enters from the 
		west.";
	}
	west = In_Corridor
	ne = At_Junction_With_Warm_Walls
	left = At_Junction_With_Warm_Walls
	se = In_Limestone_Passage
	right = In_Limestone_Passage
	down = In_Limestone_Passage
	view = At_Breath_Taking_View
	barren = In_Front_Of_Barren_Room
;

At_Junction_With_Warm_Walls: CCR_room, NoNPC
	sdesc = "At Junction With Warm Walls"
	ldesc = {
		I(); "The walls are quite warm here.  From the north 
		can be heard a steady roar, so loud that the entire 
		cave seems to be trembling.  Another passage leads 
		south, and a low crawl goes east.";
	}
	south = At_Fork_In_Path
	fork = At_Fork_In_Path
	north = At_Breath_Taking_View
	view = At_Breath_Taking_View
	east = In_Chamber_Of_Boulders
	crawl = In_Chamber_Of_Boulders
;

At_Breath_Taking_View: CCR_room, NoNPC
	sdesc = "At Breath-Taking View"
	ldesc = {
		I(); "You are on the edge of a breath-taking view. Far 
		below you is an active volcano, from which great 
		gouts of molten lava come surging out, cascading back 
		down into the depths.  The glowing rock fills the 
		farthest reaches of the cavern with a blood-red 
		glare, giving everything an eerie, macabre 
		appearance. The air is filled with flickering sparks 
		of ash and a heavy smell of brimstone.  The walls are 
		hot to the touch, and the thundering of the volcano 
		drowns out all other sounds.  Embedded in the jagged 
		roof far overhead are myriad twisted formations 
		composed of pure white alabaster, which scatter the 
		murky light into sinister apparitions upon the walls. 
		To one side is a deep gorge, filled with a bizarre 
		chaos of tortured rock which seems to have been 
		crafted by the devil himself.  An immense river of 
		fire crashes out from the depths of the volcano, 
		burns its way through the gorge, and plummets into a 
		bottomless pit far off to your left.  To the right, 
		an immense geyser of blistering steam erupts 
		continuously from a barren island in the center of a 
		sulfurous lake, which bubbles ominously.  The far 
		right wall is aflame with an incandescence of its 
		own, which lends an additional infernal splendor to 
		the already hellish scene.  A dark, forboding passage 
		exits to the south.";
	}
	south = At_Junction_With_Warm_Walls
	passage = At_Junction_With_Warm_Walls
	out = At_Junction_With_Warm_Walls
	fork = At_Fork_In_Path
	jump = { return self.down; }
	down = {
		"Don't be ridiculous!";
		return nil;
	}
;
Volcano: decoration
	sdesc = "active volcano"
	ldesc = {
		"Great gouts of molten lava come surging out of the 
		volvano and go cascading back down into the depths.  
		The glowing rock fills the farthest reaches of the 
		cavern with a blood-red glare, giving everything an 
		eerie, macabre appearance.";
	}
	location = At_Breath_Taking_View
	noun = 'volcano' 'rock'
	adjective = 'active' 'glowing' 'blood' 'blood-red' 'red' 'eerie'
		'macabre'
;
Sparks: decoration
	sdesc = "sparks of ash"
	adesc = { self.sdesc; }
	ldesc = {
		"The sparks too far away for you to get a good look at 
		them.";
	}
	location = At_Breath_Taking_View
	noun = 'spark' 'sparks' 'ash' 'air'
	adjective = 'flickering'
;
JaggedRoof: decoration
	sdesc = "jagged roof"
	ldesc = {
		"Embedded in the jagged roof far overhead are myriad 
		twisted formations composed of pure white alabaster, 
		which scatter the murky light into sinister 
		apparitions upon the walls.";
	}
	location = At_Breath_Taking_View
	noun = 'roof' 'formations' 'light' 'apparaitions'
	adjective = 'jagged' 'twsited' 'murky' 'sinister'
;
DeepGorge: decoration
	sdesc = "deep gorge"
	ldesc = {
		"The gorge is filled with a bizarre chaos of tortured 
		rock which seems to have been crafted by the devil 
		himself.";
	}
	location = At_Breath_Taking_View
	noun = 'gorge' 'chaos' 'rock'
	adjective = 'deep' 'bizarre' 'tortured'
;
RiverOfFire: decoration
	sdesc = "river of fire"
	ldesc = {
		"The river of fire crashes out from the depths of the 
		volcano, burns its way through the gorge, and 
		plummets into a bottomless pit far off to your 
		left.";
	}
	location = At_Breath_Taking_View
	noun = 'river' 'fire' 'depth' 'pit'
	adjective = 'fire' 'firey' 'bottomless'
;
Geyser: decoration
	sdesc = "immense geyser"
	ldesc = {
		"The geyser of blistering steam erupts continuously 
		from a barren island in the center of a sulfurous 
		lake, which bubbles ominously.";
	}
	location = At_Breath_Taking_View
	noun = 'geyser' 'steam' 'island' 'lake'
	adjective = 'immense' 'blistering' 'barren' 'sulfrous'
		'sulferous' 'sulpherous' 'sulphrous' 'bubbling'
;

In_Chamber_Of_Boulders: CCR_room, NoNPC
	sdesc = "In Chamber of Boulders"
	ldesc = {
		I(); "You are in a small chamber filled with large 
		boulders.  The walls are very warm, causing the air 
		in the room to be almost stifling from the heat.  The 
		only exit is a crawl heading west, through which is 
		coming a low rumbling.";
	}
	west = At_Junction_With_Warm_Walls
	out = At_Junction_With_Warm_Walls
	crawl = At_Junction_With_Warm_Walls
	fork = At_Fork_In_Path
	view = At_Breath_Taking_View
;
ChamberBoulders: CCR_decoration
	sdesc = "boulders"
	ldesc = "They're just ordinary boulders.  They're warm."
	noun = 'boulder' 'boulders' 'rocks' 'stones'
	location = In_Chamber_Of_Boulders
;

In_Limestone_Passage: CCR_room, NoNPC
	sdesc = "In Limestone Passage"
	ldesc = {
		I(); "You are walking along a gently sloping 
		north/south passage lined with oddly shaped limestone 
		formations.";
	}
	north = At_Fork_In_Path
	up = At_Fork_In_Path
	fork = At_Fork_In_Path
	south = In_Front_Of_Barren_Room
	down = In_Front_Of_Barren_Room
	barren = In_Front_Of_Barren_Room
	view = At_Breath_Taking_View
;
LimestoneFormations: decoration
	sdesc = "limestone formations"
	ldesc = {
		"Every now and then a particularly strange shape
		catches your eye.";
	}
	location = In_Limestone_Passage
	noun = 'formations' 'shape' 'shapes'
	adjective = 'lime' 'limestone' 'stone' 'oddly' 'shaped'
		'oddly-shaped'
;


In_Front_Of_Barren_Room: CCR_room, NoNPC
	sdesc = "In Front of Barren Room"
	ldesc = {
		I(); "You are standing at the entrance to a large, 
		barren room.  A sign posted above the entrance reads: 
		\"Caution!  Bear in room!\"";
	}
	west = In_Limestone_Passage
	up = In_Limestone_Passage
	fork = At_Fork_In_Path
	east = In_Barren_Room
	in = In_Barren_Room
	barren = In_Barren_Room
	enter = In_Barren_Room
	view = At_Breath_Taking_View
;
BarrenSign: CCR_decoration, readable
	sdesc = "sign"
	ldesc = { self.readdesc; }
	readdesc = {
		"The sign reads, \"Caution!  Bear in room!\"";
	}

	noun = 'sign'
	adjective = 'barren' 'room'

	location = In_Front_Of_Barren_Room
;

In_Barren_Room: CCR_room, NoNPC
	sdesc = "In Barren Room"
	ldesc = {
		I(); "You are inside a barren room.  The center of 
		the room is completely empty except for some dust.  
		Marks in the dust lead away toward the far end of the 
		room.  The only exit is the way you came in.";
	}
	west = In_Front_Of_Barren_Room
	out = In_Front_Of_Barren_Room
	fork = At_Fork_In_Path
	view = At_Breath_Taking_View
;
Dust: CCR_decoration
	sdesc = "dust"
	ldesc = { "It just looks like ordinary dust."; }
	location = In_Barren_Room
	noun = 'dust' 'marks'
;
Bear: Actor
	rhetoricalturn = -999	// hack -- see yesVerb in ccr-verbs.t

	exists = true

	istame = nil		// has the bear been fed?
	isfollowing = nil	// is the bear following the player?
	wasreleased = nil	// has the bear been unchained yet?

	sdesc = "large bear"
	ldesc = {
		"The bear is extremely large, ";

		if (self.istame)
			"but appears to be friendly.";
		else
			"and seems quite ferocious!";
	}

	//
	// Can't use actorDesc because we our location is a method,
	// so we're not ever really contained in a room.  We've
	// hacked adv.t to make this work by checking the bear
	// explicitly.
	//
	actorDesc = {
		if (self.isIn(Me.location)) {
			P(); I();

			if (self.isfollowing) {
				"You are being followed by a very 
				large, tame bear.";
			}
			else if (self.istame) {
				if (not self.wasreleased and
				self.isIn(In_Barren_Room)) {

					"There is a gentle cave bear 
					sitting placidly in one 
					corner.";
				}
				else
					"There is a contented-looking 
					bear wandering about 
					nearby.";
			}
			else {
				"There is a ferocious cave bear 
				eyeing you from the far end of the 
				room!";
			}
		}
	}

	noun = 'bear'
	adjective = 'large' 'tame' 'ferocious' 'cave'

	locationOK = true	// tell compiler OK for location to be method
	location = {
		if (self.exists) {
			if (self.isfollowing)
				return Me.location;
			else
				return In_Barren_Room;
		}
		else
			return nil;
	}

	verDoKick(actor) =  {
		if (self.istame)
			self.onlyfriend;
		else
			"You obviously have not fully grasped the 
			gravity of the situation.  Do get a grip on 
			yourself.";
	}
	verDoAttack(actor) = {
		if (self.istame)
			self.onlyfriend;
		else if (not axe.isIn(Me))
			self.bearhands;
	}
	doAttack(actor) = { self.doAttackWith(actor, axe); }

	verDoAttackWith(actor, io) = {
		if (self.istame)
			self.onlyfriend;
	}
	doAttackWith(actor, io) = {
		//
		// If the player throws the axe at the bear, the
		// axe misses and becomes inaccessible.  (Doh!)
		//
		if (io = axe) {
			"The axe misses and lands near the bear where 
			you can't get at it.";

			axe.moveInto(self.location);
			axe.nograb := true;		// little hack
		}
		else if (io = Hands)
			self.nicetry;
		else
			self.verDoAttack(actor);
	}

	onlyfriend = {
		"The bear is confused; he only wants to be your 
		friend.";
	}
	bearhands = {
		"With what?  Your bare hands?  Against *his* bear 
		hands??";

		self.rhetoricalturn := global.turnsofar;
	}
	nicetry = {
		"Nice try, but sorry.";
	}
	
	verIoGiveTo(actor) = {}
	ioGiveTo(actor, dobj) = {
		if (dobj = tasty_food) {
			self.doFeed(Me);
		}
		else {
			if (self.istame)
				"The bear doesn't seem very 
				interested in your offer.";
			else
				"Uh-oh -- your offer only makes the bear 
				angrier!";
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
			"The bear eagerly wolfs down your food, after 
			which he seems to calm down considerably and 
			even becomes rather friendly.";

			tasty_food.moveInto(nil);
			self.istame := true;
			axe.nograb := nil;
		}
		else if (self.istame) {
			"You have nothing left to give the bear.";
		}
		else {
			"The bear seems more likely to eat *you*
			than anything you've got on you!";
		}
	}

	verDoDrop(actor) = {
		if (not self.isfollowing)
			"The bear isn't following you.";
	}
	doDrop(actor) = {
		if (Troll.isIn(Me.location)) {
			"The bear lumbers toward the troll, who lets 
			out a startled shriek and scurries away.  The 
			bear soon gives up the pursuit and wanders 
			back.";

			Troll.moveInto(nil);
			self.isfollowing := nil;
		}
		else {
			"The bear wanders away from you.";
		}
	}

	verDoTake(actor) = {
		if (not self.istame)
			"Surely you're joking!";
		else if (not self.wasreleased)
			"The bear is still chained to the wall.";
	}
	doTake(actor) = {
		self.isfollowing := true;
		"Ok, the bear's now following you around.";
	}
;

Different_Maze_3: CCR_room
	sdesc = "Maze of Twisting Little Passage, All Different"
	ldesc = {
		I(); "You are in a maze of twisting little passages, 
		all different.";
	}
	west = Different_Maze_1
	se = Different_Maze_4
	nw = Different_Maze_5
	sw = Different_Maze_6
	ne = Different_Maze_7
	up = Different_Maze_8
	down = Different_Maze_9
	north = Different_Maze_10
	south = Different_Maze_11
	east = Different_Maze_2
;

Different_Maze_4: CCR_room
	sdesc = "Little Maze of Twisty Passages, All Different"
	ldesc = {
		I(); "You are in a little maze of twisty passages, 
		all different.";
	}
	nw = Different_Maze_1
	up = Different_Maze_3
	north = Different_Maze_5
	south = Different_Maze_6
	west = Different_Maze_7
	sw = Different_Maze_8
	ne = Different_Maze_9
	east = Different_Maze_10
	down = Different_Maze_11
	se = Different_Maze_2
;

Different_Maze_5: CCR_room
	sdesc = "Twisting Maze of Little Passages, All Different"
	ldesc = {
		I(); "You are in a twisting maze of little passages, 
		all different.";
	}
	up = Different_Maze_1
	down = Different_Maze_3
	west = Different_Maze_4
	ne = Different_Maze_6
	sw = Different_Maze_7
	east = Different_Maze_8
	north = Different_Maze_9
	nw = Different_Maze_10
	se = Different_Maze_11
	south = Different_Maze_2
;

Different_Maze_6: CCR_room
	sdesc = "Twisting Little Maze of Passages, All Different"
	ldesc = {
		I(); "You are in a twisting little maze of passages, 
		all different.";
	}
	ne = Different_Maze_1
	north = Different_Maze_3
	nw = Different_Maze_4
	se = Different_Maze_5
	east = Different_Maze_7
	down = Different_Maze_8
	south = Different_Maze_9
	up = Different_Maze_10
	west = Different_Maze_11
	sw = Different_Maze_2
;

Different_Maze_7: CCR_room
	sdesc = "Twisty Little Maze of Passages, All Different"
	ldesc = {
		I(); "You are in a twisty little maze of passages, 
		all different.";
	}
	north = Different_Maze_1
	se = Different_Maze_3
	down = Different_Maze_4
	south = Different_Maze_5
	east = Different_Maze_6
	west = Different_Maze_8
	sw = Different_Maze_9
	ne = Different_Maze_10
	nw = Different_Maze_11
	up = Different_Maze_2
;

Different_Maze_8: CCR_room
	sdesc = "Twisty Maze of Little Passages, All Different"
	ldesc = {
		I(); "You are in a twisty maze of little passages, 
		all different.";
	}
	east = Different_Maze_1
	west = Different_Maze_3
	up = Different_Maze_4
	sw = Different_Maze_5
	down = Different_Maze_6
	south = Different_Maze_7
	nw = Different_Maze_9
	se = Different_Maze_10
	ne = Different_Maze_11
	north = Different_Maze_2
;

Different_Maze_9: CCR_room
	sdesc = "Little Twisty Maze of Passages, All Different"
	ldesc = {
		I(); "You are in a little twisty maze of passages, 
		all different.";
	}
	se = Different_Maze_1
	ne = Different_Maze_3
	south = Different_Maze_4
	down = Different_Maze_5
	up = Different_Maze_6
	nw = Different_Maze_7
	north = Different_Maze_8
	sw = Different_Maze_10
	east = Different_Maze_11
	west = Different_Maze_2
;

Different_Maze_10: CCR_room
	sdesc = "Maze of Little Twisting Passages, All Different"
	ldesc = {
		I(); "You are in a maze of little twisting passages, 
		all different.";
	}
	down = Different_Maze_1
	east = Different_Maze_3
	ne = Different_Maze_4
	up = Different_Maze_5
	west = Different_Maze_6
	north = Different_Maze_7
	south = Different_Maze_8
	se = Different_Maze_9
	sw = Different_Maze_11
	nw = Different_Maze_2
;

Different_Maze_11: CCR_room
	sdesc = "Maze of Little Twisty Passages, All Different"
	ldesc = {
		I(); "You are in a maze of little twisty passages, 
		all different.";
	}
	sw = Different_Maze_1
	nw = Different_Maze_3
	east = Different_Maze_4
	west = Different_Maze_5
	north = Different_Maze_6
	down = Different_Maze_7
	se = Different_Maze_8
	up = Different_Maze_9
	south = Different_Maze_10
	ne = Different_Maze_2
;

/*
 * We don't allow NPC's here because it would be *really* bogus
 * if the pirate stole the batteries right after the player bought
 * them.
 */
Dead_End_14: CCR_dead_end_room, NoNPC
	sdesc = "At a Dead End, in Front of a Massive Vending Machine"
	ldesc = {
		I(); "You have reached a dead end. There is a massive 
		vending machine here.";

		if (PirateMessage.isIn(self)) {
			P();
			I(); "Hmmm...  There is a message here 
			scrawled in the dust in a flowery script.";
		}
	}

	north = Different_Maze_2
	out = Different_Maze_2
;
VendingMachine: CCR_decoration, readable
	sdesc = "vending machine"
	ldesc = { self.readdesc; }
	readdesc = {
		"The instructions on the vending machine read, 
		\"Insert coins to receive fresh batteries.\"";
	}
	location = Dead_End_14
	noun = 'machine' 'slot'
	adjective = 'vending' 'massive' 'battery' 'coin'

	verIoPutIn(actor) = {}
	ioPutIn(actor, dobj) = {
		if (dobj = rare_coins) {
			"Soon after you insert the coins in the coin 
			slot, the vending machines makes a griding 
			sound, and a set of fresh batteries falls at 
			your feet.";

			dobj.moveInto(nil);
			fresh_batteries.moveInto(self.location);
		}
		else {
			"The machine seems to be designed to take 
			coins.";
		}
	}

	verDoKick(actor) = {}
	doKick(actor) = {
		"<WHUMP!> You boot the machine, but to no avail.";
	}
	verDoBreak(actor) = {}
	doBreak(actor) = {
		"The machine is quite stury and survives your attack
		without getting so much as a scratch.";
	}
	verDoAttack(actor) = { self.verDoBreak(actor); }
	doAttack(actor) = { self.doBreak(actor); }
	verDoAttackWith(actor, io) = { self.verDoAttack(actor); }
	doAttackWith(actor) = { self.doAttack(actor); }

	verDoLookbehind(actor) = {
		"You don't find anything behind the vending machine.";
	}
	verDoLookunder(actor) = {
		"You don't find anything behind the under machine.";
	}
	verDoMove(actor) = { "The vending machine is far too heavy to move."; }
;
PirateMessage: CCR_decoration, readable
	sdesc = "message in the dust"
	ldesc = {
		"The message reads, \"This is not the maze where the 
		pirate leaves his treasure chest.\"";
	}
	noun = 'message' 'scrawl' 'writing' 'script'
	adjective = 'scrawled' 'flowery'
	location = nil	// moved to Dead_End_14 when pirate spotted
;

/*
 * Endgame locations
 *
 * We make these NoNPC rooms so that dwarves and pirate don't get
 * teleported here when (if) they get stuck trying to move around
 * the cave.  (The dwarves in here aren't real actors because they
 * kill the player immediately if they're awake.)
 */
At_Ne_End: CCR_room, lightroom, NoNPC
	sdesc = "At NE End"
	ldesc = {
		I(); "You are at the northeast end of an immense 
		room, even larger than the giant room.  It appears to 
		be a repository for the \"Adventure\" program.  
		Massive torches far overhead bathe the room with 
		smoky yellow light.  Scattered about you can be seen 
		a pile of bottles (all of them empty), a nursery of 
		young beanstalks murmuring quietly, a bed of oysters, 
		a bundle of black rods with rusty stars on their 
		ends, and a collection of brass lanterns.  Off to one 
		side a great many dwarves are sleeping on the floor, 
		snoring loudly.  A sign nearby reads: \"Do not 
		disturb the dwarves!\""; P();

		I(); "An immense mirror is hanging against one wall, 
		and stretches to the other end of the room, where 
		various other sundry objects can be glimpsed dimly in 
		the distance.";
	}
	sw = At_Sw_End
;
Mirror_2: CCR_decoration
	sdesc = "enormous mirror"
	ldesc = "It looks like an ordinary, albeit enormous, mirror."
	noun = 'mirror'
	adjective = 'enormous' 'huge' 'big' 'large' 'suspended'
		'hanging' 'vanity' 'dwarvish'

	locationOK = true	// OK for location to be method
	location = {
		if (Me.isIn(At_Ne_End))
			return At_Ne_End;
		else
			return At_Sw_End;
	}

	verDoBreak(actor) = {}
	doBreak(actor) = {
		"You strike the mirror a resounding blow, whereupon 
		it shatters into a myriad tiny fragments.";

		//
		// A very bad move...
		//
		end_dwarves();
	}
	verDoAttack(actor) = { self.verDoBreak(actor); }
	doAttack(actor) = { self.doBreak(actor); }
	verDoAttackWith(actor, io) = { self.verDoAttack(actor); }
	doAttackWith(actor) = { self.doAttack(actor); }
	verDoKick(actor) = { self.verDoBreak(actor); }
	doKick(actor) = { self.doBreak(actor); }
;
RepositoryStuff_1: CCR_decoration
	sdesc = "collection of adventure game materials"
	ldesc = {
		"You've seen everything in here already, albeit
		in somewhat different contexts.";
	}
	location = At_Ne_End
	noun = 'stuff' 'junk' 'materials' 'torches' 'objects'
	adjective = 'adventure' 'repository' 'massive' 'sundry'

	verifyRemove(actor) = {
		"Realizing that by removing the loot here you'd be 
		ruining the game for future players, you leave the 
		\"Adventure\" materials where they are.";
	}
;
RepositoryDwarves: CCR_decoration
	sdesc = "sleeping dwarves"
	adesc = { self.sdesc; }
	ldesc = {
		"I wouldn't bother the dwarves if I were you.";
	}
	location = At_Ne_End
	noun = 'dwarf' 'dwarves'
	adjective = 'sleeping' 'snoring' 'dozing' 'snoozing'

	verDoWake(actor) = {}
	doWake(actor) = {
		"You prod the nearest dwarf, who wakes up grumpily, 
		takes one look at you, curses, and grabs for his 
		axe.";

		end_dwarves();
	}
	verDoAttack(actor) = {}
	doAttack(actor) = { self.doWake(actor); }
	verDoKick(actor) = {}
	doKick(actor) = { self.doWake(actor); }
;
RepositoryPlant: CCR_decoration
	location = At_Ne_End
;

At_Sw_End: CCR_room, lightroom, NoNPC
	sdesc = "At SW End"
	ldesc = {
		I(); "You are at the southwest end of the repository. 
		To one side is a pit full of fierce green snakes. On 
		the other side is a row of small wicker cages, each 
		of which contains a little sulking bird.  In one 
		corner is a bundle of black rods with rusty marks on 
		their ends.  A large number of velvet pillows are 
		scattered about on the floor. A vast mirror stretches 
		off to the northeast. At your feet is a large steel 
		grate, next to which is a sign which reads, 
		\"TREASURE VAULT. Keys in main office.\"";
	}
	ne = At_Ne_End
	down = {
		RepositoryGrate.doEnter(Me);
		return nil;
	}
;
RepositoryGrate: fixeditem, keyedLockable
	isopen = nil
	islocked = true
	sdesc = "steel grate"
	ldesc = {
		"It just looks like an ordinary steel grate.";

		" It is ";
		if (self.isopen)
			"open.";
		else if (self.islocked) 
			"closed and locked.";
		else 
			"closed.";
	}
	noun = 'grate' 'lock' 'gate' 'grille'
	adjective = 'metal' 'strong' 'steel' 'open' 'closed' 'locked'
		'unlocked'

	location = At_Sw_End

	mykey = nil	// no key for this one

	verDoEnter(actor) = {}
	doEnter(actor) = {
		if (not Grate.islocked) {
			if (not Grate.isopen) {
				"(Opening the grate first.)\b";
				Grate.isopen := true;
						
			}
			if (actor.isIn(Outside_Grate))
				actor.travelTo(Below_The_Grate);
			else
				actor.travelTo(Outside_Grate);
		}
		else {
			"You can't go through a locked steel grate!";
		}
	}
	
	verIoPutIn(actor) = { "You can't put anything in that! "; }
	verDoPick = { "You have no tools to pick the lock with."; }
;

RepositoryStuff_2: CCR_decoration
	sdesc = "collection of adventure game materials"
	ldesc = {
		"You've seen everything in here already, albeit
		in somewhat different contexts.";
	}
	location = At_Sw_End

	verifyRemove(actor) = {
		"Realizing that by removing the loot here you'd be 
		ruining the game for future players, you leave the 
		\"Adventure\" meterials where they are.";
	}

	noun = 'pit' 'snake' 'snakes' 
	adjective = 'fierce' 'green'
;

/*
 * Miscellaneous messages
 */
broken_neck: object
	death = {
		"You are at the bottom of the pit with a broken neck.";
		die();
		return nil;
	}
;
didnt_make_it: object
	death = {
		"You didn't make it.";
		die();
		return nil;
	}
;
crawled_around: object
	message = {
		"You have crawled around in some little holes and 
		wound up back in the main passage.";

		return nil;
	}
;
wontfit: object
	message = {
		"Something you're carrying won't fit through the 
		tunnel with you. You'd best take inventory and drop 
		something.";

		return nil;
	}
;

/*
 * Room feature decorations.
 * These don't give any new information, but they make the program
 * seem less brain-damaged.
 */
TheRoom: CCR_decoration
	sdesc = "room"
	ldesc = {
		// Upon "examine room" we just give the standard
		// description for the current location.
		Me.location.lookAround(true);
	}
	noun = 'room' 'anteroom' 'dark-room' 'darkroom'
	adjective = 'debris' 'low' 'twopit' 'large' 'lighted' 'slab'
		'giant' 'soft' 'oriental' 'dark' 'immense' 'barren'
		'bear-in' 'bearin'
	locationOK = true	 // tell compiler OK for location to be method
	location = {
		return Me.location;	// always where player is
	}
;
Hands: CCR_decoration	// the player's hands
	sdesc = "your hands"
	adesc = { self.sdesc; }
	thedesc = { self.sdesc; }

	ldesc = "The look pretty normal to me."

	noun = 'hands'
	adjective = 'my' 'bare' 'hands'

	locationOK = true	 // tell compiler OK for location to be method
	location = {
		return Me.location;	// always where player is
	}
;

class rfd: floatingdecoration
	ldesc = "You know as much as I do at this point."
;
Crawl: rfd
	sdesc = "crawl"
	noun = 'crawl' 'crawls'
	adjective = 'cobble' 'low' 'wide' 'higher' 'dead' 'end' 'tight'
	loclist = [
		Below_The_Grate  In_Cobble_Crawl  In_Debris_Room
		In_Dirty_Passage  On_Brink_Of_Pit
		At_West_End_Of_Hall_Of_Mists  At_East_End_Of_Long_Hall
		At_Complex_Junction  In_Large_Low_Room  Dead_End_Crawl
		In_Tall_E_W_Canyon  In_Oriental_Room
		At_Junction_With_Warm_Walls  In_Chamber_Of_Boulders
	]
;
Chamber: rfd
	sdesc = "chamber"
	noun = 'chamber'
	adjective = 'small' 'splendid' 'south' 'side' 'west' 'large'
			'low' 'circular'
	loclist = [
		Below_The_Grate  In_Bird_Chamber  In_South_Side_Chamber
		In_West_Side_Chamber  In_Slab_Room  In_Plover_Room
		In_Chamber_Of_Boulders
	]
;
Passage: rfd
	sdesc = "passage"
	noun = 'passage' 'opening' 'openings' 'corridor' 'corridors'
		'path' 'paths'
	adjective = 'low' 'wide' 'plugged' 'good' 'east' 'small' 'twisty'
		'little' 'n/s' 'e/w' 'dirty' 'broken' 'high' 'long'
		'large' 'walking' 'sizeable' 'sizable' 'cavernous'
		'blocked' 'immense' 'gently' 'sloping' 'coral'
		'shallow' 'somewhat' 'steeper' 'dark' 'forboding'
	loclist = [
		In_Cobble_Crawl In_Debris_Room 
		In_Awkward_Sloping_E_W_Canyon In_Bird_Chamber 
		At_Top_Of_Small_Pit In_Hall_Of_Mists 
		On_East_Bank_Of_Fissure In_Nugget_Of_Gold_Room 
		In_Hall_Of_Mt_King At_West_End_Of_Twopit_Room 
		In_East_Pit In_West_Pit West_Side_Of_Fissure 
		Low_N_S_Passage In_South_Side_Chamber 
		In_West_Side_Chamber At_Y2 Jumble_Of_Rock 
		At_Window_On_Pit_1 In_Dirty_Passage On_Brink_Of_Pit 
		In_Pit In_Dusty_Rock_Room 
		At_West_End_Of_Hall_Of_Mists Alike_Maze_1 
		Alike_Maze_2 Alike_Maze_3 Alike_Maze_4 Dead_End_1 
		Dead_End_2 Dead_End_3 Alike_Maze_5 Alike_Maze_6 
		Alike_Maze_7 Alike_Maze_8 Alike_Maze_9 Dead_End_4 
		Alike_Maze_10 Dead_End_5 At_Brink_Of_Pit Dead_End_6 
		At_East_End_Of_Long_Hall At_West_End_Of_Long_Hall 
		Crossover Dead_End_7 At_Complex_Junction In_Bedquilt 
		In_Swiss_Cheese_Room At_East_End_Of_Twopit_Room 
		In_Slab_Room In_Secret_N_S_Canyon_0 
		In_Secret_N_S_Canyon_1 
		At_Junction_Of_Three_Secret_Canyons In_Large_Low_Room 
		Dead_End_Crawl 
		In_Secret_E_W_Canyon In_N_S_Canyon 
		Canyon_Dead_End In_Tall_E_W_Canyon Dead_End_8 
		Alike_Maze_11 Dead_End_9 Dead_End_10 Alike_Maze_12 
		Alike_Maze_13 Dead_End_11 Dead_End_12 Alike_Maze_14 
		In_Narrow_Corridor At_Steep_Incline_Above_Large_Room 
		In_Giant_Room At_Recent_Cave_In 
		In_Immense_N_S_Passage In_Cavern_With_Waterfall 
		In_Soft_Room In_Oriental_Room In_Misty_Cavern 
		In_Alcove In_Plover_Room In_Dark_Room In_Arched_Hall 
		In_Shell_Room In_Ragged_Corridor In_A_Cul_De_Sac 
		In_Anteroom Different_Maze_1 At_Witts_End 
		In_Mirror_Canyon At_Window_On_Pit_2 Atop_Stalactite 
		Different_Maze_2 At_Reservoir Dead_End_13 At_Ne_End 
		At_Sw_End On_Sw_Side_Of_Chasm In_Sloping_Corridor 
		In_Secret_Canyon  On_Ne_Side_Of_Chasm In_Corridor 
		At_Fork_In_Path At_Junction_With_Warm_Walls 
		At_Breath_Taking_View In_Chamber_Of_Boulders 
		In_Limestone_Passage In_Front_Of_Barren_Room 
		In_Barren_Room Different_Maze_3 Different_Maze_4 
		Different_Maze_5 Different_Maze_6 Different_Maze_7 
		Different_Maze_8 Different_Maze_9 Different_Maze_10 
		Different_Maze_11 Dead_End_14
	]
;
Canyon: rfd
	sdesc = "canyon"
	noun = 'canyon' 'canyons'
	adjective = 'awkward' 'sloping' 'secret' 'e/w' 'n/s' 'tight'
			'tall' 'three'
	loclist = [
		In_Debris_Room  In_Awkward_Sloping_E_W_Canyon
		In_Bird_Chamber  In_Secret_N_S_Canyon_0
		In_Secret_N_S_Canyon_1  At_Junction_Of_Three_Secret_Canyons
		In_Secret_E_W_Canyon  In_N_S_Canyon
		Canyon_Dead_End  In_Tall_E_W_Canyon  Dead_End_8
		In_Mirror_Canyon  In_Secret_Canyon
	]
;
Walls: rfd
	sdesc = "walls"
	noun = 'wall' 'walls' 'cracks' 'ceiling' 
	adjective = 'orange' 'stone' 'swiss' 'cheese' 'cave' 'cavern'
			'ragged' 'sharp' 'canyon' 'warm' 'hot' 'building'
			'well' 'house' 'wellhouse'
	loclist = [
		Inside_Building In_Cobble_Crawl In_Debris_Room 
		In_Awkward_Sloping_E_W_Canyon In_Bird_Chamber 
		At_Top_Of_Small_Pit In_Hall_Of_Mists 
		On_East_Bank_Of_Fissure In_Nugget_Of_Gold_Room 
		In_Hall_Of_Mt_King At_West_End_Of_Twopit_Room 
		In_East_Pit In_West_Pit West_Side_Of_Fissure 
		Low_N_S_Passage In_South_Side_Chamber 
		In_West_Side_Chamber At_Y2 Jumble_Of_Rock 
		At_Window_On_Pit_1 In_Dirty_Passage On_Brink_Of_Pit 
		In_Pit In_Dusty_Rock_Room 
		At_West_End_Of_Hall_Of_Mists Alike_Maze_1 
		Alike_Maze_2 Alike_Maze_3 Alike_Maze_4 Dead_End_1 
		Dead_End_2 Dead_End_3 Alike_Maze_5 Alike_Maze_6 
		Alike_Maze_7 Alike_Maze_8 Alike_Maze_9 Dead_End_4 
		Alike_Maze_10 Dead_End_5 At_Brink_Of_Pit Dead_End_6 
		At_East_End_Of_Long_Hall At_West_End_Of_Long_Hall 
		Crossover Dead_End_7 At_Complex_Junction In_Bedquilt 
		In_Swiss_Cheese_Room At_East_End_Of_Twopit_Room 
		In_Slab_Room In_Secret_N_S_Canyon_0 
		In_Secret_N_S_Canyon_1 
		At_Junction_Of_Three_Secret_Canyons In_Large_Low_Room 
		Dead_End_Crawl 
		In_Secret_E_W_Canyon In_N_S_Canyon 
		Canyon_Dead_End In_Tall_E_W_Canyon Dead_End_8 
		Alike_Maze_11 Dead_End_9 Dead_End_10 Alike_Maze_12 
		Alike_Maze_13 Dead_End_11 Dead_End_12 Alike_Maze_14 
		In_Narrow_Corridor At_Steep_Incline_Above_Large_Room 
		In_Giant_Room At_Recent_Cave_In 
		In_Immense_N_S_Passage In_Cavern_With_Waterfall 
		In_Soft_Room In_Oriental_Room In_Misty_Cavern 
		In_Alcove In_Plover_Room In_Dark_Room In_Arched_Hall 
		In_Shell_Room In_Ragged_Corridor In_A_Cul_De_Sac 
		In_Anteroom Different_Maze_1 At_Witts_End 
		In_Mirror_Canyon At_Window_On_Pit_2 Atop_Stalactite 
		Different_Maze_2 At_Reservoir Dead_End_13 At_Ne_End 
		At_Sw_End On_Sw_Side_Of_Chasm In_Sloping_Corridor 
		In_Secret_Canyon  On_Ne_Side_Of_Chasm  In_Corridor 
		At_Fork_In_Path At_Junction_With_Warm_Walls 
		At_Breath_Taking_View In_Chamber_Of_Boulders 
		In_Limestone_Passage In_Front_Of_Barren_Room 
		In_Barren_Room Different_Maze_3 Different_Maze_4 
		Different_Maze_5 Different_Maze_6 Different_Maze_7 
		Different_Maze_8 Different_Maze_9 Different_Maze_10 
		Different_Maze_11 Dead_End_14
	]
;
DeadEnd: rfd
	sdesc = "dead end"
	noun = 'end'
	adjective = 'dead'
	loclist = [
		Dead_End_1 Dead_End_2 Dead_End_3 Dead_End_4 
		Dead_End_5 Dead_End_6 Dead_End_7 Dead_End_Crawl 
		Canyon_Dead_End Dead_End_8 Dead_End_9 Dead_End_10 
		Dead_End_11 Dead_End_12 Dead_End_13 Dead_End_14
	]
;
Hall: rfd
	sdesc = "hall"
	noun = 'hall'
	adjective = 'vast' 'long' 'featureless' 'arched'
	loclist = [
		In_Hall_Of_Mists  On_East_Bank_Of_Fissure
		In_Hall_Of_Mt_King  West_Side_Of_Fissure
		In_West_Side_Chamber  At_West_End_Of_Hall_Of_Mists
		At_East_End_Of_Long_Hall At_West_End_Of_Long_Hall
		In_Arched_Hall
	]
;
Hole: rfd
	sdesc = "hole"
	noun = 'hole' 'holes'
	adjective = 'large' 'big' 'round' 'two' 'foot' 'two-foot'
	loclist = [
		At_East_End_Of_Twopit_Room
		In_West_Pit  Low_N_S_Passage  In_Dirty_Passage
		In_Dusty_Rock_Room  At_East_End_Of_Long_Hall
		In_Bedquilt  In_Narrow_Corridor  In_Cavern_With_Waterfall
		At_Reservoir
	]
;
Junction: rfd
	sdesc = "junction"
	noun = 'junction'
	adjective = 'complex'
	loclist = [
		At_Complex_Junction  At_Junction_Of_Three_Secret_Canyons
		At_Junction_With_Warm_Walls
	]
;
Air: rfd	// If they MUST examine EVERYTHING
	sdesc = "air"
	adesc = "air"
	noun = 'air' 'environment' 'atmosphere' 'wind'
	adjective = 'sea' 'damp' 'hot' 'stifling'
	locationOK = true	 // tell compiler OK for location to be method
	location = {
		return Me.location;	// always where player is
	}
	verDoSmell(actor) = {}
	doSmell(actor) = {
		"The air smells pretty much like you would expect.";
	}
;
