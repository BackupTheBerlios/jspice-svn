/**
 *	JSpice, an Open Spice interpreter and library.
 *	Copyright (C) 2003, Stephen F. K. Leach
 *
 * 	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 * 	the Free Software Foundation; either version 2 of the License, or
 * 	(at your option) any later version.
 *
 * 	This program is distributed in the hope that it will be useful,
 * 	but WITHOUT ANY WARRANTY; without even the implied warranty of
 * 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 * 	along with this program; if not, write to the Free Software
 *	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
package org.openspice.jspice.datatypes;

import org.openspice.jspice.alert.Alert;

import java.util.List;
import java.util.Map;

public abstract class SpiceObjectNonMap extends SpiceObject {

	public final boolean isEmpty() {
		throw new Alert( "Cannot determine if this is empty" ).culprit( "this", this ).mishap();
	}

	public final boolean isMapLike() {
		return false;
	}

	public final boolean isListLike() {
		return false;
	}

	public final List convertToList() {
		throw new Alert( "Cannot convert Termin into a List" ).mishap();
	}

	public final Map convertToMap() {
		throw new Alert( "Cannot convert Termin into a Map" ).mishap();
	}

	public final SpiceObject convertFromList( final List list ) {
		throw Alert.unreachable();
	}

	public final SpiceObject convertFromMap( final Map map ) {
		throw Alert.unreachable();
	}

}
