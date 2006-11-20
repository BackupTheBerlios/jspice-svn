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
 * This file is #included in adv.t and defines extensions to the thing
 * class.
 */

// Default actions for new verbs.
// These are #included into the thing class definition.

	verDoKick(actor) = { "Feeling violent?"; }
	verDoSmell(actor) = { "It smells like an ordinary "; self.sdesc; "."; }
	verDoWave(actor) = {
		"Waving "; self.thedesc; " doesn't seem to do much.";
	}
	verDoBreak(actor) = { "I see no obvious way to do that."; }
	verDoRub(actor) = { "Ok, you just rubbed "; self.thedesc; "."; }
	verDoCount(actor) = { "I see one (1) "; self.sdesc; "."; }
	verDoUse(actor) = {
		"You'll have to be a bit more explicit than that.";
	}
	verDoLight(actor) = {
		"I don't know how to light "; self.thesdesc; ".";
	}
	verDoPick(actor) = { "You're babbling, man!  Snap out of it!"; }
	verDoWake(actor) = { caps(); self.thedesc; " is not asleep."; }
	verDoBlastWith(actor) = { "Been eating those funny brownies again?"; }
	verDoOil(actor) = { "Yuck."; }
	verDoWater(actor) = { "I don't see any point to that."; }
	verIoOpenWith(actor) = {
		"You can't use that to open anything.";
	}

	/*
	 * Map douse x with y to pour y on x
	 */
	verDoDouseWith(actor) = { self.verIoPourOn(actor); }
	doDouseWith(actor, io) = { io.doPourOn(actor, self); }
	verIoDouseWith(actor) = { self.verDoPourOn(actor); }
	ioDouseWith(actor, dobj) = { dobj.ioPourOn(actor, self); }

	verDoPourOn(actor, io) = {
		caps(); self.thedesc; " is going to have to undergo
		a major state change first.";
	}
	doPourOn(actor, io) = {
		"This shouldn't happen.";
	}
	verIoPourOn(actor) = {}
	ioPourOn(actor, dobj) = { dobj.doPourOn(actor, self); }
