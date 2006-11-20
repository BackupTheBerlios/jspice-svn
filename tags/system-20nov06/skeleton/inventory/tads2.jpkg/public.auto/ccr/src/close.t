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
 * This file defines a few game-specific functions for the cave closing.
 * Don't read any of this unless you want to spoil the ending!
 */

/*
 * This function is called every turn to see if it's time to start
 * closing the cave.
 */
check_for_closing: function(parm)
{
	//
	// If there are no more treasures left to be found, count
	// down the cave closing counter whenever the player is
	// well inside but not at Y2.
	//
	if (global.closingtime > 0 and global.treasures = 0) {
		if (not Me.location.notfarin and not Me.isIn(At_Y2)) {
			global.closingtime := global.closingtime - 1;
			if (global.closingtime < 1)
				start_closing();
		}
	}
}

/*
 * This function is called every turn to see if it's time to start
 * the final puzzle.
 */
check_for_endgame: function(parm)
{
	if (global.closed and global.bonustime > 0) {
		global.bonustime := global.bonustime - 1;
		if (global.bonustime < 1) {
			// Start the final puzzle
			start_endgame();
		}
	}
}

start_closing: function
{	P();
	I(); "A sepulchral voice reverberating through the cave says, 
	\"Cave closing soon.  All adventurers exit immediately 
	through main office.\"";

	incscore(global.closingpoints);

	global.closed := true;

	CrystalBridge.exists := nil;	// destroy the bridge
	Grate.islocked := true;		// lock the grate ...
	Grate.mykey := nil;		// ...and throw away the key
	Dwarves.loclist := [];		// nuke dwarves...
	Pirates.loclist := [];		// ...and pirate(s)
	Troll.moveInto(nil);		// vaporize troll
	Bear.exists := nil;		// ditto for bear

	// This was listed in the original as being too much trouble
	// to bother with, but why not:
	Dragon.moveInto(nil);		// nuke the dragon too
}

start_endgame: function
{
	P();
	I(); "The sepulchral voice intones, \"The cave is now 
	closed.\" As the echoes fade, there is a blinding flash of 
	light (and a small puff of orange smoke).\ .\ .\ .  As your 
	eyes refocus, you look around and find that you're...\b";

	//
	// Vaporize everyting the player's carrying.
	//
	while (length(Me.contents) > 0)
		Me.contents[1].moveInto(nil);

	//
	// Stock the northeast end
	//
	bottle.moveInto(At_Ne_End);
	bottle.empty;	// don't want to worry about watering the plants
	giant_bivalve.moveInto(At_Ne_End);
	brass_lantern.moveInto(At_Ne_End);
	black_rod.moveInto(At_Ne_End);

	//
	// Stock the southwest end
	//
	little_bird.moveInto(At_Sw_End);
	wicker_cage.moveInto(At_Sw_End);
	black_mark_rod.moveInto(At_Sw_End);
	velvet_pillow.moveInto(At_Sw_End);

	//
	// Move the player
	//
	Me.travelTo(At_Ne_End);

	incscore(global.endpoints);
}

/*
 * Determine how the player fares in the final puzzle.
 */
endpuzzle: function
{
	if (black_mark_rod.isIn(At_Ne_End) and Me.isIn(At_Sw_End)) {
		incscore(global.winpoints);

		I(); "There is a loud explosion, and a twenty-foot 
		hole appears in the far wall, burying the dwarves in 
		the rubble.  You march through the hole and find 
		yourself in the main office, where a cheering band of 
		friendly elves carry the conquering adventurer off 
		into the sunset."; P();

		win();
	}
	else if (black_mark_rod.isIn(At_Sw_End) and Me.isIn(At_Ne_End)) {
		incscore(global.almostpoints);

		I(); "There is a loud explosion, and a twenty-foot 
		hold appears in the far wall, burying the snakes in 
		the rubble.  A river of molten lava pours in through 
		the hole, destroying everything in its path, 
		including you!"; P();

		win();
	}
	else if (black_mark_rod.isIn(Me.location)) {
		incscore(global.wrongpoints);

		"There is a loud explosion, and you are suddenly 
		splashed across the walls of the room."; P();

		win();
	}
}

/*
 * The player resolves the endgame by disturbing the dwarves.
 */
end_dwarves: function
{
	P();
	I(); "The resulting ruckus has awakened the dwarves.  There 
	are now several threatening little dwarves in the room with 
	you! Most of them throw knives at you!  All of them get 
	you!"; P();

	win();
}
