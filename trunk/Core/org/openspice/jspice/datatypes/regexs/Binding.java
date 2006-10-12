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
package org.openspice.jspice.datatypes.regexs;

import org.openspice.jspice.datatypes.SpiceObject;
import org.openspice.jspice.datatypes.SpiceObjectImmutableList;
import org.openspice.jspice.datatypes.maps.ListAsMap;
import org.openspice.jspice.tools.Consumer;
import org.openspice.jspice.built_in.inspect.FieldAdder;
import org.openspice.jspice.alert.Alert;

import java.util.regex.Matcher;
import java.util.List;
import java.util.Map;

public class Binding extends SpiceObjectImmutableList {

	@SuppressWarnings("unused")
	private final CharSequence original;
	private final int size;
	private final String[] groups;
	private final int[] starts;
	private final int[] ends;

	public Binding( final CharSequence original, final Matcher m ) {
		this.original = original;
		this.size = m.groupCount();
		final int n = m.groupCount() + 1;
		this.groups = new String[ n ];
		this.starts = new int[ n ];
		this.ends = new int[ n ];
		for ( int i = 0; i < n; i++ ) {
			this.groups[ i ] = m.group( i );
			this.starts[ i ] = m.start( i );
			this.ends[ i ] = m.end( i );
		}
	}

	public int size() {
		return this.groups.length - 1;
	}

	public Object get( int i ) {
		return this.groups[ i + 1 ];
	}

	public void addInstanceFields( final FieldAdder adder ) {
		adder.add( "size", this.size );
		adder.add( "groups", this.groups );
		adder.add( "starts", this.starts );
		adder.add( "ends", this.ends );
	}

	public void showTo( final Consumer cuchar ) {
		cuchar.outCharSequence( "[binding " + this.groups[ 0 ] + "]" );
	}

	public void printTo( final Consumer cuchar ) {
		cuchar.outCharSequence( this.groups[ 0 ] );
	}

	public Map convertToMap() {
		return new ListAsMap( (List)this );
	}

	public SpiceObject convertFromList( final List list ) {
		throw new Alert( "Cannot convert from list to binding" ).culprit( "list", list ).mishap();
	}

	public SpiceObject convertFromMap( Map map ) {
		throw new Alert( "Cannot convert from map to binding" ).culprit( "map", map ).mishap();
	}

	public final  String getMatched() {
		return this.groups[ 0 ];
	}

	public final int getStart() {
		return this.starts[ 0 ];
	}

	public final int getEnd() {
		return this.ends[ 0 ];
	}

	public final  String getMatched( final int i ) {
		return this.groups[ i ];
	}

	public final int getStart( final int i ) {
		return this.starts[ i ];
	}

	public final int getEnd( final int i ) {
		return this.ends[ i ];
	}


}
