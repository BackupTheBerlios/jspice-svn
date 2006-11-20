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
 *	Columbia, MD 21044 USA
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
 * 20-Apr-93	dmb	Fixed a bug with the treasures: you could
 *			get points for a treasure without being able
 *			to carry it.
 */

/*
 * This file defines all carryable items in the game.
 */
class CCR_item: item;

/*
 * Important notes about treasures:
 *
 * If you want to add treasures, use the CCR_treasure_item class.  Take
 * care to call the original doDrop and pass doTake if you override the
 * doDrop or doTake methods, because it is in these methods that we
 * handle the scoring.
 *
 * Each treasure is worth self.takepoints points when taken for the
 * first time, and an additional self.depositpoints when deposited
 * in the bulding.  Be sure to update global.maxscore and scoreRank
 * if you add treasures (or anything else that gives the player points,
 * for that matter).
 *
 * The proper way to check if an object is a treasure is:
 *
 * 	if (isclass(obj, CCR_treasure_item))
 *		...
 *
 */
class CCR_treasure_item: CCR_item
	plural = 'treasures' 'goodies' 'loot'

	takepoints = 2		// points for taking this treasure
	depositpoints = 12	// points for putting in building

	awardedpointsfortaking = nil
	awardedpointsfordepositing = nil
	
	doTake(actor) = {
		inherited.doTake(actor);

		//
		// If we didn't get the object (e.g., if the actor's carrying
		// too much), don't give points.
		//
		if (not self.isIn(actor))
			return;

		//
		// Give the player some points for taking the treasure
		// the first time.
		//
		// If the player removes a treasure from the bulding
		// floor, reduce his score by the value of that
		// treasure.  (This is to prevent him from dropping
		// a treasure off, getting the points, and then giving
		// it to the troll or otherwise losing it.) 
		//
		if (not self.awardedpointsfortaking) {
			incscore(self.takepoints);
			self.awardedpointsfortaking := true;
		}
		if (self.awardedpointsfordepositing) {
			if (self.isIn(Inside_Building)) {
				incscore(-1 * self.depositpoints);
				self.awardedpointsfordepositing := nil;

				// That's one more treasure to deposit.
				global.treasures := global.treasures + 1;
			}
		}
	}
	doDrop(actor) = {
		self.checkpoints;
		pass doDrop;
	}

	checkpoints = {
		//
		// Award points for putting treasure in building (unless
		// we've already awarded the points for depositing this
		// treasure).
		//
		if (Me.isIn(Inside_Building)) {
			if (not self.awardedpointsfortaking) {
				//
				// This shouldn't happen, but just in case...
				//
				incscore(self.takepoints);
				self.awardedpointsfortaking := true;
			}
			else if (not self.awardedpointsfordepositing) {
				incscore(self.depositpoints);
				self.awardedpointsfordepositing := true;

				// That's one less treasure to deposit.
				global.treasures := global.treasures - 1;
			} 
		}
	}
;

set_of_keys: CCR_item, keyItem
	sdesc = "set of keys"
	ldesc = "It's just a normal-looking set of keys."
	location = Inside_Building
	noun = 'keys' 'key' 'keyring' 'set'
	adjective = 'key'
;

brass_lantern: CCR_item, lightsource
	turnsleft = 330		// expert mode (default)
	sdesc = "brass lantern"
	ldesc = {
		"It is a shiny brass lamp";

		if (self.islit) {
			if (self.turnsleft <= 30)
				", glowing dimly.";
			else
				", glowing brightly.";
		}
		else
			".  It is not currently lit.";
	}
	location = Inside_Building
	noun = 'lamp' 'headlamp' 'headlight' 'lantern' 'light'

	ison = nil
	islit = {
		if (self.ison and self.turnsleft > 0)
			return true;
		else
			return nil;
	}	
	
	verDoRub(actor) = {}
	doRub(actor) = {
		"Rubbing the electric lamp is not particularly 
		rewarding.  Anyway, nothing exciting happens.";
	}

	verDoTurnon(actor) = {
		if (self.ison)
			"It's already on.";
	}
	doTurnon(actor) = {
		"The lamp is now on.";
		self.ison := true;

		if (self.turnsleft > 0)
			notify(self, &wearbatteries, 0);
		else
			"  Unfortunately, the batteries seem to
			be dead.";
	}
	verDoTurnoff(actor) = {
		if (not self.ison)
			"It's already off.";
	}
	doTurnoff(actor) = {
		"The lamp is now off.";
		self.turnoff;
	}
	verDoLight(actor) = { self.verDoTurnon(actor); }
	doLight(actor) = { self.doTurnon(actor); }

	verIoPutIn(actor) = {}
	ioPutIn(actor, dobj) = {
		if (dobj = old_batteries)
			"Those batteries are dead; they won't
			do any good at all.";
		else if (dobj = fresh_batteries)
			self.do_replace;
		else
			"The only thing you might successfully put in 
			the lamp is a fresh pair of batteries.";
	}

	// The following method is called when the player gets resurrected.
	turnoff = {
		if (self.ison) {
			self.ison := nil;
			unnotify(self, &wearbatteries);
		}
	}

	wearbatteries = {
		self.turnsleft := self.turnsleft - 1;

		if (self.turnsleft < 1) {
			P(); I();
			"Your lamp has run out of power. ";

			if (self.replace_batteries) {
				// do nothing
			}
			else if (Me.location.isoutside) {
				"There's not much point in wandering 
				around out here, and you can't 
				explore the cave without a lamp. So 
				let's just call it a day.";

				call_it_a_day();
			}
		}
		else if (self.turnsleft = 30) {
			P(); I();
			"Your lamp is getting dim. ";

			if (self.replace_batteries) {
				// do nothing.
			}
			else if (fresh_batteries.used) {
				// DMB: changed the wording of this
				// slightly for convenience.
				"You're also out of spare batteries.  
				You'd best start wrapping this up.";
			}
			else if (fresh_batteries.location <> nil) {
				"You'd best go back for those 
				batteries.";
			}
			else {
				"You'd best start wrapping this up, 
				unless you can find some fresh 
				batteries. I seem to recall there's a 
				vending machine in the maze.  Bring 
				some coins with you.";
			}
		}
	}

	replace_batteries = {
		if (fresh_batteries.isIn(Me.location)) {
			" I'm taking the liberty of replacing the
			batteries.";

			self.do_replace;

			return true;
		}
		else
			return nil;
	}

	do_replace = {
		fresh_batteries.used := true;
		fresh_batteries.moveInto(nil);
		old_batteries.moveInto(Me.location);
		self.turnsleft := 2500;
	}
;

black_rod: CCR_item
	sdesc = "black rod"
	ldesc = "It's a three foot black rod with a rusty star on an end."
	location = In_Debris_Room
	noun = 'rod' 'star'
	adjective = 'black' 'rusty' 'star'

	verDoWave(actor) = {}
	doWave(actor) = {
		if (self.isIn(West_Side_Of_Fissure) or
			self.isIn(On_East_Bank_Of_Fissure)) {

			if (global.closed) {
				"Peculiar.  Nothing happens.";
			}
			else {
				if (CrystalBridge.exists) {
					"The crystal bridge has 
					vanished!";
					CrystalBridge.exists := nil;
				}
				else {
					"A crystal bridge now spans 
					the fissure.";
					CrystalBridge.exists := true;
				}
			}
		}
		else
			"Nothing happens.";
	}
;

wicker_cage: CCR_item, container
	sdesc = "wicker cage"
	ldesc = {
		"It's a small wicker cage.";
	}
	location = In_Cobble_Crawl
	noun = 'cage'
	adjective = 'small' 'wicker' 'bird'

	verDoPutIn(actor) = {}
	doPutIn(actor, io) = {
		if (io <> little_bird) {
			caps(); self.thedesc; " isn't big enough
			to hold "; io.thedesc; ".";
		}
		else
			pass doPutIn;
	}
;

/*
 * The following rod is actually an explosive.  Don't ask ME how anyone
 * is supposed to figure this out from the description.  I've left it
 * the way it was even though I think it's pretty bogus.
 *
 * I've added the words 'explosive' and 'dynamite' as nouns and adjectives,
 * and 'blast' as an adjective.  Perhaps this will give some lucky soul
 * a clue.
 */
black_mark_rod: CCR_item
	sdesc = "marked rod"
	ldesc = {
		"It's a three foot black rod with a rusty mark on an end.";
	}
	location = At_Sw_End
	noun = 'rod' 'mark' 'explosive' 'dynamite'
	adjective = 'black' 'rusty' 'mark' 'blast' 'explosive' 'dynamite'

	verDoWave(actor) = {}
	doWave(actor) = { "Nothing happens."; }

	verDoBlastWith(actor) = {}
	doBlastWith(actor) = { endpuzzle(); }
;

little_bird: CCR_item
	sdesc = {
		if (not self.isIn(wicker_cage))
			"cheerful ";
		
		"little bird";
	}
	ldesc = {
		if (self.isIn(wicker_cage))
			"The little bird looks unhappy in the cage.";
		else
			"The cheerful little bird is sitting here singing.";
	}
	location = In_Bird_Chamber
	noun = 'bird'

	verDoFeed(actor) = {}
	doFeed(actor) = {
		"It's not hungry. (It's merely pinin' for the fjords). 
		 Besides, you have no bird seed.";
	}
	verIoGiveTo(actor) = {
		"I suspect it would prefer bird seed.";
	}

	/*
	 * Catch any attempt to remove the bird.  It won't cooperate
	 * When the player has the rod with the star on the end.
	 */
	verifyRemove(actor) = {
		if (self.isIn(Me)) {
			"You already have the little bird.  If
			you take it out of the cage it will likely
			fly away from you.";
		}
		else if (black_rod.isIn(Me)) {
			"The bird was unafraid when you entered, but 
			as you approach it becomes disturbed and you 
			cannot catch it.";
		}
		else
			pass verifyRemove;
	}

	verDoTake(actor) = {
		if (not wicker_cage.isIn(Me))
			"You can catch the bird, but you cannot carry it.";
		else
			pass verDoTake;
	}
	doTake(actor) = {
		self.doPutIn(Me, wicker_cage);
	}

	verDoPutIn(actor) = {}
	doPutIn(actor, io) = {
		if (io <> wicker_cage) {
			"Don't put the poor bird in "; io.thedesc; "!";
		}
		else
			pass doPutIn;
	}

	verDoAttack(actor) = {
		if (self.isIn(wicker_cage)) 
			"Oh, leave the poor unhappy bird alone.";
		else {
			"The little bird is now dead.  Its body disappears.";
			self.moveInto(nil);
		}
	}

	verDoDrop(actor) = {}
	doDrop(actor) = {
		if (self.isIn(Snake.location)) {
			"The little bird attacks the green snake, and 
			in an astounding flurry drives the snake 
			away.";

			Snake.moveInto(nil);
			self.moveInto(Me.location);
		}
		else if (self.isIn(Dragon.location)) {
			"The little bird attacks the green dragon, 
			and in an astounding flurry gets burnt to a 
			cinder.  The ashes blow away.";

			self.moveInto(nil);
		}
		else
			pass doDrop;
	}

	doTakeOut(actor, io) = {
		// Drop ourselves automatically.  (The bird flies away
		// when taken out of a container.)
		self.doDrop(actor);
	}
;

velvet_pillow: CCR_item
	sdesc = "velvet pillow"
	ldesc = "It's just a small velvet pillow."
	location = In_Soft_Room
	noun = 'pillow'
	adjective = 'velvet' 'small'
;

giant_bivalve: CCR_item
	opened = nil

	sdesc = {
		if (self.opened)
			"giant oyster";
		else
			"giant clam";

		if (self.isIn(Me))
			" >grunt!<";
	}
	thedesc = {
		if (self.opened)
			"the giant oyster";
		else
			"the giant clam";
	}
	
	ldesc = {
		"It's an enormous clam with its shell tightly closed.";

		// During the endgame, the oyster has something
		// written on it.
		if (self.isIn(At_Ne_End) or self.isIn(At_Sw_End)) {
			"Interesting.  There seems to be something 
			written on the underside of the oyster.";
		}
	}
	location = In_Shell_Room
	noun = 'clam' 'oyster' 'bivalve' 'shell'
	adjective = 'giant' 'enormous' 'massive' 'big' 'huge' 'tightly'
		'closed' 'five' 'foot' 'five-foot' '5-foot'

	verDoOpen(actor) = { self.verDoOpenWith(actor, nil); }
	doOpen(actor) = {
		if (trident.isIn(Me)) {
			//
			// In the original, "open clam" would work
			// ask long as you were carrying the trident,
			// but this seems very prone to accidental
			// solving, and since we aren't limited to
			// two word parsing, I've just taken the
			// liberty of forcing the player to type
			// "open clam with trident."
			//
			"You'll need to be a bit more specific that 
			that, I'm afraid.";
		}
		else {
			"You don't have anything strong enough to 
			open "; self.thedesc; ".";
		}
	}
	verDoOpenWith(actor, io) = {
		if (self.isIn(Me)) {
			"I advise you to put down "; self.thedesc;
			" before opening it.  >Strain!<";
		}
	}
	doOpenWith(actor, io) = {
		if (io = trident) {
			if (self.opened) {
				"The oyster creaks open, revealing nothing 
				but oyster inside.  It promptly snaps shut 
				again.";  
			}
			else {
				"A glistening pearl falls out of the clam and 
				rolls away.  Goodness, this must really be an 
				oyster.  (I never was very good at 
				identifying bivalves.)  Whatever it is, it 
				has now snapped shut again.";

				self.opened := true;
				pearl.moveInto(In_A_Cul_De_Sac);
			}
		}
		else {
			caps(); io.thedesc; " isn't strong enough to 
			open "; self.thedesc; ".";
		}
	}
	verDoBreak(actor) = {
		"The shell is very strong and is impervious to 
		attack.";
	}
	verDoAttack(actor) = { self.verDoBreak(actor); }
	verDoAttackWith(actor, io) = { self.verDoBreak(actor); }

	//
	// The oyster has a hint written on its underside once
	// the cave's closed.  (Look, don't ask me, I'm just
	// porting this game!)
	//
	verDoRead(actor) = {
		if (not self.isIn(At_Ne_End) and not self.isIn(At_Sw_End))
			"You're babbling -- snap out of it!";
	}
	doRead(actor) = {
		//
		// This is supposed to be a hint (i.e., it's supposed
		// to cost points), but I've put it in as a freebie
		// because I think the final puzzle is absurdly
		// difficult even with the free hint.
		//
		"It says, \"There is something strange about this 
		place, such that one of the words I've always known 
		now has a new effect.\"";
	}
;

spelunker_today: CCR_item, readable
	sdesc = "recent issues of \"Spelunker Today\""
	adesc = { self.sdesc; }
	ldesc = { self.readdesc; }
	readdesc = {
		// This said "magazine is written" in the original,
		// which is obviously wrong given the sdesc.

		"I'm afraid the magazines are written in Dwarvish.";
	}

	location = In_Anteroom
	plural = 'magazines'
	noun = 'magazine' 'issue' 'issue' 'spelunker'
		'today' 'dwarvish'
	adjective = 'spelunker' 'today' 'dwarvish'

	doDrop(actor) = {
		if (Me.isIn(At_Witts_End))
			silent_incscore(global.wittpoints);

		pass doDrop;
	}
	doTake(actor) = {
		if (Me.isIn(At_Witts_End))
			silent_incscore(-1 * global.wittpoints);

		pass doTake;
	}
;

tasty_food: CCR_item, fooditem
	sdesc = "some tasty food"
	adesc = { self.sdesc; }
	thedesc = "the tasty food"
	ldesc = "Sure looks yummy!"
	location = Inside_Building
	noun = 'food' 'ration' 'rations' 'tripe'
	adjective = 'yummy' 'tasty' 'delicious' 'scrumptious'
;

bottle: CCR_item
	haswater = true
	hasoil = nil

	sdesc = {
		if (self.haswater)
			"small bottle of water";
		else if (self.hasoil)
			"small bottle of oil";
		else
			"small empty bottle";
	}
	location = Inside_Building
	noun = 'bottle' 'jar' 'flask'

	verIoPutIn(actor) = {}
	ioPutIn(actor, dobj) = {
		if (self.haswater)
			"The bottle is already full of water.";
		else if (self.hasoil)
			"The bottle is already full of oil.";
		else if (dobj = Stream) {
			"The bottle is now full of water.";
			self.haswater := true;
		}
		else if (dobj = Oil) {
			"The bottle is now full of oil.";
			self.hasoil := true;
		}
		else {
			"I'm not sure how to do that.";
		}
	}

	verDoFill(actor) = {}
	doFill(actor) = {
		if (self.isIn(Stream.location))
			self.ioPutIn(actor, Stream);
		else if (self.isIn(Oil.location))
			self.ioPutIn(actor, Oil);
		else
			"There is nothing here with which to fill the 
			bottle.";
	}

	verDoEmpty(actor) = {}
	doEmpty(actor) = {
		if (self.haswater or self.hasoil)
			"Your bottle is now empty and the ground is 
			now wet.";
		else
			"The bottle is already empty!";

		self.empty;
	}

	verDoPourOn(actor, io) = {}
	doPourOn(actor, io) = {
		if (io = RustyDoor) {
			if (self.hasoil) {
				"The oil has freed up the hinges so that the 
				door will now move, although it requires some 
				effort.";

				RustyDoor.isoiled := true;
			}
			else if (self.haswater) {
				"The hinges are quite thoroughly 
				rusted now and won't budge.";
			}
			else {
				"The bottle is empty.";
			}

			self.empty;
		}
		else if (io = Plant) {
			if (self.haswater) {
				Plant.water;
			}
			else if (self.hasoil) {
				"The plant indignantly shakes the oil 
				off its leaves and asks, \"Water?\"";
			}
			else {
				"The bottle is empty.";
			}

			self.empty;
		}
		else if (io = theFloor)
			self.doEmpty(actor);
		else
			"That doesn't seem productive.";
	}

	verDoDrink(actor) = {
		if (not self.hasoil and not self.haswater)
			"The bottle is empty.";

		if (self.hasoil)
			"Don't drink the oil, you fool!";
	}
	doDrink(actor) = {
		"The bottle is now empty.";
		self.empty;
	}

	empty = {
		self.haswater := nil;
		self.hasoil := nil;
	}
;
water_in_the_bottle: CCR_decoration
	sdesc = "water in the bottle"
	adesc = "water"
	ldesc = "It looks like ordinary water to me."
	locationOK = true	// tell compiler OK for location to be method
	location = {
		if (bottle.haswater)
			return bottle.location;
		else
			return nil;
	}
	noun = 'water' 'h2o'

	verDoPourOn(actor, io) = {}
	doPourOn(actor, io) = { bottle.doPourOn(actor, io); }
	verDoDrink(actor) = { bottle.verDoDrink(actor); }
	doDrink(actor) = { bottle.doDrink(actor); }
;
oil_in_the_bottle: CCR_decoration
	sdesc = "oil in the bottle"
	adesc = "oil"
	ldesc = "It looks like ordinary oil to me."
	locationOK = true	// tell compiler OK for location to be method
	location = {
		if (bottle.hasoil)
			return bottle.location;
		else
			return nil;
	}
	noun = 'oil' 'lubricant' 'grease'

	verDoPourOn(actor, io) = {}
	doPourOn(actor, io) = { bottle.doPourOn(actor, io); }
	verDoDrink(actor) = { bottle.verDoDrink(actor); }
	doDrink(actor) = { bottle.doDrink(actor); }
;

axe: CCR_item
	nograb = nil	// hack for when you attack the bear with it

	sdesc = "dwarf's axe"
	ldesc = {
		if (self.nograb)
			"It's lying beside the bear.";
		else
			"It's just a little axe.";
	}
	location = nil		// created when first dwarf attacks
	noun = 'axe'
	adjective = 'little' 'dwarf' 'dwarvish' 'dwarven' 'dwarf\'s'

	verifyRemove(actor) = {
		if (self.nograb)
			"No chance.  It's lying beside the ferocious 
			bear, quite within harm's way.";
	}
;

fresh_batteries: CCR_item
	used = nil	// used in lamp yet?

	sdesc = "fresh batteries"
	ldesc = {
		"They look like ordinary batteries.  (A sepulchral 
		voice says, \"Still going!\")";
	}
	noun = 'batteries' 'battery' 'duracel' 'duracell' 'duracels'
		'duracells' 'energizer' 'energizers' 'everready'
		'everreadies' 'eveready' 'evereadies'
	adjective = 'fresh'

	location = nil
;

old_batteries: CCR_item
	sdesc = "worn-out batteries"
	ldesc = {
		"They look like ordinary batteries.";
	}
	noun = 'batteries' 'battery' 'duracel' 'duracell' 'duracels'
		'duracells' 'energizer' 'energizers' 'everready'
		'everreadies' 'eveready' 'evereadies'
	adjective = 'worn' 'out' 'worn-out' 'dead' 'empty' 'dry' 'old'

	location = nil
;

/*
 * Treasures
 */
large_gold_nugget: CCR_treasure_item
	depositpoints = 10
	sdesc = "large gold nugget"
	ldesc = "It's a large sparkling nugget of gold!"
	location = In_Nugget_Of_Gold_Room
	noun = 'gold' 'nugget'
	adjective = 'gold' 'large'
;
several_diamonds: CCR_treasure_item
	depositpoints = 10
	sdesc = "several diamonds"
	adesc = { self.sdesc; }
	thedesc = "the diamonds"
	ldesc = "They look to be of the highest quality!"
	location = West_Side_Of_Fissure
	noun = 'diamond' 'diamonds'
	adjective = 'several' 'high' 'quality' 'high-quality'
;
bars_of_silver: CCR_treasure_item
	depositpoints = 10
	sdesc = "bars of silver"
	adesc = { self.sdesc; }
	ldesc = "They're probably worth a fortune!"
	location = Low_N_S_Passage
	noun = 'silver' 'bars'
	adjective = 'silver'
;
precious_jewelry: CCR_treasure_item
	depositpoints = 10
	sdesc = "precious jewelry"
	adesc = { self.sdesc; }
	ldesc = "It's all quite exquisite!"
	location = In_South_Side_Chamber
	noun = 'jewel' 'jewels' 'jewelry'
	adjective = 'precious' 'exquisite'
;
rare_coins: CCR_treasure_item
	depositpoints = 10
	sdesc = "rare coins"
	adesc = { self.sdesc; }
	ldesc = "They're a numismatist's dream!"
	location = In_West_Side_Chamber
	noun = 'coins'
	adjective = 'rare'
;
treasure_chest: CCR_treasure_item
	spotted = nil	// found yet?  See also Dead_End_13 in ccr-room.t

	depositpoints = 12
	sdesc = "treasure chest"
	ldesc = {
		"It's the pirate's treasure chest, filled with
		riches of all kinds!";
	}
	location = nil
	noun = 'chest' 'box' 'treasure' 'riches'
	adjective = 'pirate' 'pirate\'s' 'treasure'     
;
golden_eggs: CCR_treasure_item
	depositpoints = 14
	sdesc = "nest of golden eggs"
	ldesc = "The nest is filled with beautiful golden eggs!"
	location = In_Giant_Room
	noun = 'eggs' 'egg' 'nest'
	adjective = 'golden' 'beautiful'
;
trident: CCR_treasure_item
	depositpoints = 14
	sdesc = "jeweled trident"
	ldesc = "The trident is covered with fabulous jewels!"
	location = In_Cavern_With_Waterfall
	noun = 'trident'
	adjective = 'jeweled' 'jewel-encrusted' 'encrusted' 'fabulous'

	verIoOpenWith(actor) = {}
	ioOpenWith(actor, dobj) = {
		dobj.doOpenWith(actor, self);
	}
;
ming_vase: CCR_treasure_item
	depositpoints = 14
	sdesc = "ming vase"
	ldesc = {
		"It's a delicate, previous, ming vase!";
	}
	location = In_Oriental_Room
	noun = 'vase' 'ming' 'shards' 'pottery'

	doDrop(actor) = {
		if (velvet_pillow.isIn(Me.location)) {
			"The vase is now resting, delicately, on a 
			velvet pillow.";

			self.moveInto(Me.location);
			
			self.checkpoints;	// make sure we count points
						// for putting this in building
		}
		else {
			"The ming vase drops with a delicate crash.";
			self.shatter;
		}
	}

	verIoPutIn(actor) = {}
	ioPutIn(actor, dobj) = {
		if (dobj = Stream or dobj = Oil) {
			"The sudden change in temperature has 
			delicately shattered the vase.";

			self.shatter;
		}
		else {
			"I'm not sure how to do that.";
		}
	}

	verDoFill(actor) = {}
	doFill(actor) = {
		if (self.isIn(Stream.location))
			self.ioPutIn(actor, Stream);
		else if (self.isIn(Oil.location))
			self.ioPutIn(actor, Oil);
		else
			"There is nothing here with which to fill the 
			vase.";
	}

	verDoBreak(actor) = {}
	doBreak(actor) = {
		"You have taken the vase and hurled it delicately to 
		the ground.";

		self.shatter;
	}

	shatter = {
		self.moveInto(nil);
		shards.moveInto(Me.location);
	}
;
shards: CCR_item
	sdesc = "some worthless shards of pottery"
	adesc = { self.sdesc; }
	ldesc = {
		"They're just worthless shards of pottery"; 

		if (self.location = Me.location)	// not in a container
			", littered everywhere.";
		else
			".";

		" They look to be the remains of what was once a
		beautiful vase.  I guess some oaf must have dropped it.";
	}

	noun = 'pottery' 'shards'
	adjective = 'worthless'
;

egg_sized_emerald: CCR_treasure_item
	depositpoints = 14
	sdesc = "emerald the size of a plover's egg"
	adesc = { "an "; self.sdesc; }
	ldesc = "Plover's eggs, by the way, are quite large."
	location = In_Plover_Room
	noun = 'emerald'
	adjective = 'egg-sized'
;
platinum_pyramid: CCR_treasure_item
	depositpoints = 14
	sdesc = "platinum pyramid"
	ldesc = "The platinum pyramid is 8 inches on a side!"
	location = In_Dark_Room
	noun = 'platinum' 'pyramid'
	adjective = 'platinum' 'pyramidal'
;
pearl: CCR_treasure_item
	depositpoints = 14
	sdesc = "glistening pearl"
	ldesc = "It's incredibly large!"
	location = nil
	noun = 'pearl'
	adjective = 'glistening' 'incredible' 'incredibly' 'large'
;
persian_rug: CCR_treasure_item
	depositpoints = 14
	sdesc = {
		"Persian rug";

		if (self.isIn(Dragon.location))
			" (upon which the dragon is sprawled out)";
	}
	adesc = {
		"a "; self.sdesc; 
	}
	ldesc = {
		if (self.isIn(Dragon.location))
			"The dragon is sprawled out on the Persian rug!!";
		else if (not self.isIn(Me))
			"The Persian rug is spread out on the floor here.";
		else
			"The Persian rug is the finest you've ever seen!";
	}
	location = In_Secret_Canyon
	noun = 'rug' 'persian'
	adjective = 'persian' 'fine' 'finest' 'dragon\'s'

	verifyRemove(actor) = {
		if (self.isIn(Dragon.location))
			"You'll need to get the dragon to move first!";
	}
;
rare_spices: CCR_treasure_item
	depositpoints = 14
	sdesc = "rare spices"
	adesc = { self.sdesc; }
	ldesc = "They smell wonderfully exotic!"
	location = In_Chamber_Of_Boulders
	noun = 'spices' 'spice'
	adjective = 'rare' 'exotic'

	verDoSmell(actor) = {}
	doSmell(actor) = { self.ldesc; }
;
golden_chain: CCR_treasure_item, keyedLockable
	depositpoints = 14
	isfixed = {
		if (self.islocked)
			return true;
		else
			return nil;
	}
	isListed = { return not self.isfixed; }

	mykey = set_of_keys	// pretty handy, those!
	islocked = true		// locked meaning "locked to the wall."
	isopen = nil		// need this since we're keyedLockable

	sdesc = "golden chain"
	ldesc = {
		"The chain has thick links of solid gold!";

		if (self.islocked) {
			if (Bear.wasreleased)
				"It's locked to the wall!";
			else
				" The bear is chained to the wall with it!";
		}
	}
	heredesc = {
		if (self.isfixed) {
			P(); I();
			if (Bear.wasreleased)
				"There is a golden chain here, locked 
				to the wall.";
			else
				"There is a golden chain here, and a 
				large cave bear is locked to the wall 
				with it!";
		}
	}
	
	location = In_Barren_Room
	noun = 'chain' 'links' 'shackles'
	adjective = 'solid' 'gold' 'golden' 'thick'

	verDoLock(actor) = {
		if (not self.isIn(In_Barren_Room)) {
			"There is nothing here to which the chain can 
			be locked.";
		}
		else
			pass verDoLock;
	}
	verDoLockWith(actor, io) = {
		self.verDoLock(actor);	// -> pass verDoLock (OK?)
		pass verDoLockWith;
	}

	verDoUnlock(actor) = {
		if (not Bear.wasreleased and not Bear.istame) {
			"There is no way to get past the bear to 
			unlock the chain, which is probably just as 
			well.";
		}
		else
			pass verDoUnlock;
	}
	verDoUnlockWith(actor, io) = {
		self.verDoUnlock(actor);
		pass verDoUnlockWith;
	}

	// inherit proper doUnlock from keyedLockable
	doUnlockWith(actor, io) = {
		Bear.wasreleased := true;
		pass doUnlockWith;
	}
	
	verifyRemove(actor) = {
		if (not Bear.wasreleased) {
			if (Bear.istame)
				"It's locked to the friendly bear.";
			else
				"It's locked to the ferocious bear!";
		}
		else if (self.islocked)
			"The chain is still locked to the wall.";
	}
;
