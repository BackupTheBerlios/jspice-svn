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
 * Print some helpful information.  (Called by helpVerb, in ccr-verb.t)
 */
help: function
{
	I(); "I know of places, actions, and things.  You can guide 
	me using commands that are complete sentences. To move, try 
	commands like \"forest,\" \"building,\" \"downstream,\" 
	\"enter,\" \"east,\" \"west,\" \"north,\" \"south,\" \"up,\" 
	\"down,\" \"enter building,\" \"climb pole,\" etc."; P();

	I(); "I know about a few special objects, like a black rod 
	hidden in the cave.  These objects can be manipulated using 
	some of the action words that I know.  Usually you will need 
	to give a verb followed by an object (along with descriptive 
	adjectives when desired), but sometimes I can infer the 
	object from the verb alone.  Some objects also imply verbs; 
	in particular, \"inventory\" implies \"take inventory\", 
	which causes me to give you a list of what you're carrying. 
	The objects have side effects; for instance, the rod scares 
	the bird."; P();

	I(); "Many commands have abbreviations.  For example, you can 
	type \"i\" in place of \"inventory,\" \"x object\" instead of 
	\"examine object,\" etc."; P();

	I(); "Usually people having trouble moving just need to try a 
	few more words.  Usually people trying unsuccessfully to 
	manipulate an object are attempting something beyond their 
	(or my!) capabilities and should try a completely different 
	tack."; P();

	I(); "To speed the game you can sometimes move long distances 
	with a single word.  For example, \"building\" usually gets 
	you to the building from anywhere above ground except when 
	lost in the forest. Also, note that cave passages turn a lot, 
	and that leaving a room to the north does not guarantee 
	entering the next from the south."; P();

	I(); "If you want to end your adventure early, type \"quit\". 
	 To suspend your adventure such that you can continue later, 
	type \"save,\" and to resume a saved game, type \"restore.\"	
	To see how well you're doing, type \"score\".  To get full 
	credit for a treasure, you must have left it safely in the 
	building, though you get partial credit just for locating it. 
	 You lose points for getting killed, or for quitting, though 
	the former costs you more. There are also points based on how 
	much (if any) of the cave you've managed to explore; in 
	particular, there is a large bonus just for getting in (to 
	distinguish the beginners from the rest of the pack), and 
	there are other ways to determine whether you've been through 
	some of the more harrowing sections."; P();

	I(); "If you think you've found all the treasures, just keep 
	exploring for a while.  If nothing interesting happens, you 
	haven't found them all yet. If something interesting *does* 
	happen, it means you're getting a bonus and have an 
	opportunity to garner many more points in the master's 
	section."; P();

	I(); "You can control the way I format my messages with the 
	\"space\" and \"indent\" commands. These turn on and off 
	blank spaces between paragraphs and indentation at the 
	beginnings of paragraphs. Finally, you may specify \"brief\", 
	which tells me never to repeat the full description of a 
	place unless you explicitly ask me to.  (The \"verbose\" 
	command turns this off.)"; P();

	I(); "Good luck!";		
}
