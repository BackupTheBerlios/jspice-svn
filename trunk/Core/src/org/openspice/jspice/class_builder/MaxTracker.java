/**
 *	JSpice, an Open Spice interpreter and library.
 *	Copyright (C) 2005, Stephen F. K. Leach
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
package org.openspice.jspice.class_builder;

import org.openspice.tools.ConsToFrontList;
import org.openspice.tools.EmptyList;

import java.util.List;
import java.util.LinkedList;
import java.util.Iterator;

final class MaxTracker {
	boolean debug;
	int maxsofar = 0;
	int cached_final_result = -1;
	int current = 0;
	final List comeFrom = new LinkedList();
	final MethodSpec parent;

	public MaxTracker( MethodSpec parent ) {
		this.parent = parent;
	}

	private int getMax( final List excluded ) {
		if ( this.cached_final_result >= 0 ) return this.cached_final_result;
		int max = 0;
		for ( Iterator it = this.comeFrom.iterator(); it.hasNext(); ) {
			final MaxTracker m = (MaxTracker)it.next();
			if ( !excluded.contains( this ) ) {
				max = Math.max( max, m.getMax( new ConsToFrontList( this, excluded ) ) );
			}
		}
		return this.cached_final_result = this.maxsofar + max;
	}

	public int getMax() {
		return this.getMax( EmptyList.EMPTY_LIST );
	}

	void delta( final int d, final String reason ) {
		if ( this.debug ) System.err.println( "Stack count delta: " + d + " in " + this.parent.debugName() );
		if ( this.debug ) if ( reason != null ) System.err.println( "  reason: " + reason );
		if ( this.debug ) System.err.println( "  current before: " + this.current );
		if ( this.debug ) System.err.println( "  maxsofar before: " + this.maxsofar );
		this.current += d;
		assert this.current >= 0;
		this.maxsofar = Math.max( this.maxsofar, this.current );
		if ( this.debug ) System.err.println( "  current after: " + this.current );
		if ( this.debug ) System.err.println( "  maxsofar after: " + this.maxsofar );
	}

	void inc() {
		this.delta( 1, null );
	}

	void inc( final String reason ) {
		this.delta( 1, reason );
	}

	void dec() {
		this.delta( -1, null );
	}

	void dec( final String reason ) {
		this.delta( -1, reason );
	}

}
