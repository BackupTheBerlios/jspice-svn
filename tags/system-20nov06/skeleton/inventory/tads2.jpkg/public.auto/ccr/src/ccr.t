/*
 * Colossal Cave Revisited
 *
 * A remake of Willie Crowther and Don Woods' classic Adventure.
 * Converted from Donald Ekman's PC port of the original FORTRAN source.
 * TADS version by David M. Baggett for ADVENTIONS.
 *
 * Colossal Cave Revisited and its accompanying source code are
 * Copyright (C) 1993 David M. Baggett.
 *
 *---------------------------------------------------------------------------
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of version 2 of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *---------------------------------------------------------------------------
 *
 * Please document all changes in the history (here as well as in the
 * appropriate source files) so we know who did what.
 *
 *---------------------------------------------------------------------------
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
 * 20-Apr-93    dmb     Version 1.0 release.
 *
 *  9-Jul-93	dmb	Widespread version 1.0 release for all supported
 *			machines.
 *
 */
#include "history.t"

#include "ccr-adv.t"
#include "format.t"
#include "preparse.t"
#include "ccr-std.t"
#include "ccr-room.t"
#include "ccr-item.t"
#include "ccr-verb.t"
#include "ccr-npc.t"
#include "help.t"
#include "close.t"
