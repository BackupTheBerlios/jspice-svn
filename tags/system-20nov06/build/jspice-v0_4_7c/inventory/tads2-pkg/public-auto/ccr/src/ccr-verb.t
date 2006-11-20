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
 * 20-Apr-93	dmb	Added a few verbs for regression testing.
 *
 */

/*
 * This file defines new verbs, including the myriad new travel verbs.
 */

/*
 * system verbs
 */
spaceVerb: deepverb
	sdesc = "space"
	verb = 'space'
 	action(actor) = {
		if (global.doublespace) {
			"Now single-spacing text.";
			global.doublespace := nil;
		}
		else {
			"Now double-spacing text.";
			global.doublespace := true;
		}

		abort;	/* doesn't count as a turn */
 	}
;
indentVerb: deepverb
	sdesc = "indent"
	verb = 'indent'
 	action(actor) = {
		if (global.indent) {
			"Paragraph indentation now off.";
			global.indent := nil;
		}
		else {
			"Paragraph indentation now on.";
			global.indent := true;
		}
		
		abort;	/* doesn't count as a turn */
 	}
;
deterministicverb: deepverb
	verb = 'deterministic' 'norandom' 'norandomize'
	action(actor) = { global.nondeterministic := nil; }
;
nodwarves: deepverb
	verb = 'nodwarf' 'nodwarves'
	action(actor) = {
		Dwarves.loclist := [];
		Pirates.loclist := [];
		"\b*** Dwarves and pirates disabled. ***\n";
		treasure_chest.moveInto(Dead_End_13);
	}
;
 
/*
 * Special and/or magic verbs
 */
yesVerb: deepverb
	//
	// This is a hack to allow the following:
	//
	// >kill dragon
	// With what, your bare hands?
	// >yes
	//
	sdesc = "answer yes to"
	verb = 'yes' 'uh-huh' 'uhuh' 'yea' 'yeah' 'yup' 'sure' 'yep'

	action(actor) = {
		//
		// If we asked "with your bear hands?" last turn,
		// do special stuff.
		//
		if (Dragon.rhetoricalturn = global.turnsofar - 1)
			Dragon.kill;
		else if (Bear.rhetoricalturn = global.turnsofar - 1)
			Bear.nicetry;
		else if (Dwarves.rhetoricalturn = global.turnsofar - 1)
			Dwarves.nicetry;
		else
			"You're sounding awfully positive!";
	}
;

feeVerb: deepverb
	said = nil

	sdesc = "fee"
	verb = 'fee'
	action(actor) = {
		if (self.said)
			self.fail;
		else {
			"Ok!";
			fieVerb.tcount := global.turnsofar + 1;
			foeVerb.tcount := global.turnsofar + 2;
			fooVerb.tcount := global.turnsofar + 3;
			self.said := true;
			fieVerb.said := nil;
			foeVerb.said := nil;
		}
	}

	fail = {
		if (self.said) {
			"What's the matter, can't you read?  Now 
			you'd best start over. ";
		}
		else {
			"Nothing happens.";
		}

		self.reset;
	}

	reset = {
		fieVerb.tcount := -1;
		foeVerb.tcount := -1;
		fooVerb.tcount := -1;

		self.said := nil;
		fieVerb.said := nil;
		foeVerb.said := nil;
	}
;
fieVerb: deepverb
	said = nil
	tcount = -1
	sdesc = "fie"
	verb = 'fie'
	action(actor) = {
		if (self.tcount = global.turnsofar) {
			self.said := true;
			"Ok!";
		}
		else
			feeVerb.fail;
	}
;
foeVerb: deepverb
	said = nil
	tcount = -1
	sdesc = "foe"
	verb = 'foe'
	action(actor) = {
		if (not fieVerb.said)
			feeVerb.fail;
		else if (self.tcount = global.turnsofar) {
			self.said := true;
			"Ok!";
		}
		else
			feeVerb.fail;
	}
;
fooVerb: deepverb
	tcount = -1
	sdesc = "foo"
	verb = 'foo'
	action(actor) = {
		if (not foeVerb.said)
			feeVerb.fail;
		else if (self.tcount = global.turnsofar) {
			if (golden_eggs.isIn(In_Giant_Room))
				"Nothing happens.";
			else {
				if (golden_eggs.isIn(Me.location))
					"The nest of golden eggs has 
					vanished!";
				else
					"Done!";

				golden_eggs.moveInto(In_Giant_Room);

				if (golden_eggs.isIn(Me.location)) {
					P(); I();
					"A large nest full of golden 
					eggs suddenly appears out of 
					nowhere!";
				}
			}

			feeVerb.reset;
		}
		else
			feeVerb.fail;
	}
;
fumVerb: deepverb
	sdesc = "fum"
	verb = 'fum'
	action(actor) = {
		feeVerb.fail;
	}
;

losingmagicVerb: deepverb
	sdesc = "foobar"
	verb = 'sesame' 'open-sesame' 'opensesame' 'abracadabra'
		'shazam' 'shazzam' 'hocus' 'pocus' 'hokus' 'pokus'
		'hocuspocus' 'hocus-pocus' 'hokuspokus' 'hokus-pokus'
		'foobar'
	action(actor) = {
		"Good try, but that is an old worn-out magic word.";
	}
;

/*
 * new general-purpose verbs.
 */
helpVerb: deepverb
	sdesc = "help"
	verb = 'help' 'info' 'information'
	action(actor) = { help(); }
;
waveVerb: deepverb
	sdesc = "wave"
	verb = 'wave' 'shake'
	doAction = 'Wave'
;

breakVerb: deepverb
	sdesc = "break"
	verb = 'break' 'destroy' 'damage' 'bust' 'mangle' 'smash'
	doAction = 'Break'
;

smellVerb: deepverb
	sdesc = "smell"
	verb = 'smell' 'sniff' 'waft'
	doAction = 'Smell'
;

rubVerb: deepverb
	sdesc = "rub"
	verb = 'rub' 'caress' 'fondle' 'pat' 'pet' 'hug' 'cuddle' 'squeeze'
	doAction = 'Rub'
;

countVerb: deepverb
	verb = 'count'
	sdesc = "count"
	doAction = 'Count'
;

tieVerb: deepverb
	sdesc = "tie"
	verb = 'tie' 'knot'
	doAction = 'Tie'
;

untieVerb: deepverb
	sdesc = "untie"
	verb = 'untie' 'unknot'
	doAction = 'Untie'
;

pourVerb: deepverb
	sdesc = "pour"
	verb = 'pour' 'dump'
	prepDefault = onPrep
	ioAction(onPrep) = 'PourOn'
;
douseVerb: deepverb
	sdesc = "douse"
	verb = 'douse' 'drench'
	prepDefault = withPrep
	ioAction(withPrep) = 'DouseWith'
;

oilVerb: deepverb
	sdesc = "oil"
	verb = 'oil' 'grease' 'lubricate'
	doAction = 'Oil'
;

waterVerb: deepverb
	sdesc = "water"
	verb = 'water'
	doAction = 'Water'
;

kickVerb: deepverb
	sdesc = "kick"
	verb = 'kick' 'knee'
	doAction = 'Kick'
;

singVerb: deepverb
	sdesc = "sing"
	verb = 'sing' 'whistle'
	doAction = 'Sing'
	action(actor) = { "You don't sound half bad.	But don't quit your day job."; }
;

useVerb: deepverb
	sdesc = "use"
	verb = 'use' 'utilize' 'employ'
	doAction = 'Use'
;

lightVerb: deepverb
	sedsc = "light"
	verb = 'light'
	doAction = 'Light'
;

pickVerb: deepverb
	sdesc = "pick"
	verb = 'pick'
	doAction = 'Pick'
;

wakeVerb: deepverb
	sdesc = "wake"
	verb = 'wake' 'awaken' 'wake up' 'disturb'
	doAction = 'Wake'
;

digVerb: deepverb
	sdesc = "dig"
	verb = 'dig' 'burrow'
	action(actor) = {
		"Digging without a shovel is quite impractical.  Even 
		with a shovel progress is unlikely.";
	}
;

blastVerb: deepverb
	sdesc = "blast"
	verb = 'blast' 'blast with'
	action(actor) = {
		if (Me.isIn(At_Ne_End) or Me.isIn(At_Sw_End))
			black_mark_rod.doBlastWith(actor);
		else
			"Blasting requires dynamite.";
	}
	doAction = 'BlastWith'
;

feedVerb: deepverb
	sdesc = "feed"
	verb = 'feed' 'stuff' 'fatten'
	doAction = 'Feed'
;

fillVerb: deepverb
	sdesc = "fill"
	verb = 'fill'
	doAction = 'Fill'
;

emptyVerb: deepverb
	sdesc = "empty"
	verb = 'empty'
	doAction = 'Empty'
;

/*
 * Do this later.
 */
backVerb: travelVerb
	verb = 'back' 'return' 'retreat'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.back);
	}
;

/*
 * From here until the end of the file we define the new direction verbs.
 * Not very exciting reading.
 */
jumpVerb: travelVerb	// this is normally defined in adv.t
	verb = 'jump' 'leap'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.road);
	}
;

roadVerb: travelVerb
	verb = 'road' 'hill'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.road);
	}
;

upstreamVerb: travelVerb
	verb = 'upstream'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.upstream);
	}
;

downstreamVerb: travelVerb
	verb = 'downstream'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.downstream);
	}
;

forestVerb: travelVerb
	verb = 'forest'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.forest);
	}
;

forwardsVerb: travelVerb
	verb = 'forwards' 'continue' 'onward'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.forwards);
	}
;

valleyVerb: travelVerb
	verb = 'valley'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.valley);
	}
;

stairsVerb: travelVerb
	verb = 'stairs'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.stairs);
	}
;

buildingVerb: travelVerb
	verb = 'building' 'house'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.building);
	}
;

gullyVerb: travelVerb
	verb = 'gully'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.gully);
	}
;

streamVerb: travelVerb
	verb = 'stream'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.stream);
	}
;

rockVerb: travelVerb
	verb = 'rock'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.rock);
	}
;

bedVerb: travelVerb
	verb = 'bed'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.bed);
	}
;

crawlVerb: travelVerb
	verb = 'crawl'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.crawl);
	}
;

cobbleVerb: travelVerb
	verb = 'cobble'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.cobble);
	}
;

surfaceVerb: travelVerb
	verb = 'surface'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.tosurface);
	}
;

darkVerb: travelVerb
	verb = 'dark'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.dark);
	}
;

passageVerb: travelVerb
	verb = 'passage' 'tunnel'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.passage);
	}
;

lowVerb: travelVerb
	verb = 'low'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.low);
	}
;

canyonVerb: travelVerb
	verb = 'canyon'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.canyon);
	}
;

awkwardVerb: travelVerb
	verb = 'awkward'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.awkward);
	}
;

giantVerb: travelVerb
	verb = 'giant'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.giant);
	}
;

viewVerb: travelVerb
	verb = 'view'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.view);
	}
;

pitVerb: travelVerb
	verb = 'pit'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.pit);
	}
;

outdoorsVerb: travelVerb
	verb = 'outdoors'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.outdoors);
	}
;

crackVerb: travelVerb
	verb = 'crack'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.crack);
	}
;

stepsVerb: travelVerb
	verb = 'steps'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.steps);
	}
;

domeVerb: travelVerb
	verb = 'dome'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.dome);
	}
;

leftVerb: travelVerb
	verb = 'left'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.left);
	}
;

rightVerb: travelVerb
	verb = 'right'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.right);
	}
;

hallVerb: travelVerb
	verb = 'hall'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.hall);
	}
;

barrenVerb: travelVerb
	verb = 'barren'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.barren);
	}
;

overVerb: travelVerb
	verb = 'over'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.over);
	}
;

acrossVerb: travelVerb
	verb = 'across'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.across);
	}
;

debrisVerb: travelVerb
	verb = 'debris'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.debris);
	}
;

holeVerb: travelVerb
	verb = 'hole'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.hole);
	}
;

wallVerb: travelVerb
	verb = 'wall'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.wall);
	}
;

brokenVerb: travelVerb
	verb = 'broken'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.broken);
	}
;

y2Verb: travelVerb
	verb = 'y2'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.y2);
	}
;

floorVerb: travelVerb
	verb = 'floor'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.floor);
	}
;

roomVerb: travelVerb
	verb = 'room'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.toroom);
	}
;

slitVerb: travelVerb
	verb = 'slit'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.slit);
	}
;

slabVerb: travelVerb
	verb = 'slab' 'slabroom'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.slab);
	}
;

xyzzyVerb: travelVerb
	verb = 'xyzzy'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.xyzzy);
	}
;

depressionVerb: travelVerb
	verb = 'depression' 'grate'	// DMB: added 'grate'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.depression);
	}
;

entranceVerb: travelVerb
	verb = 'entrance'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.entrance);
	}
;

plughVerb: travelVerb
	verb = 'plugh'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.plugh);
	}
;

secretVerb: travelVerb
	verb = 'secret'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.secret);
	}
;

caveVerb: travelVerb
	verb = 'cave'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.cave);
	}
;

crossVerb: travelVerb
	verb = 'cross'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.cross);
	}
	doAction = 'Cross'
;

bedquiltVerb: travelVerb
	verb = 'bedquilt'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.bedquilt);
	}
;

ploverVerb: travelVerb
	verb = 'plover'
 	action(actor) = {
		local	loc;

		//
		// If the player teleports by using the plover
		// magic word while holding the emerald, the
		// emerald goes back to its original source.
		//
		loc := actor.location;
		actor.travelTo(self.travelDir(actor));
		if (loc <> actor.location and egg_sized_emerald.isIn(Me))
			egg_sized_emerald.moveInto(In_Plover_Room);
	}
	travelDir(actor) = {
		return(actor.location.plover);
	}
;

orientalVerb: travelVerb
	verb = 'oriental'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.oriental);
	}
;

cavernVerb: travelVerb
	verb = 'cavern'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.cavern);
	}
;

shellVerb: travelVerb
	verb = 'shell'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.shell);
	}
;

reservoirVerb: travelVerb
	verb = 'reservoir'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.reservoir);
	}
;

mainVerb: travelVerb
	verb = 'main' 'office'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.main);
	}
;

forkVerb: travelVerb
	verb = 'fork'
 	action(actor) = {
		actor.travelTo(self.travelDir(actor));
	}
	travelDir(actor) = {
		return(actor.location.fork);
	}
;
