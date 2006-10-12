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
package org.openspice.jspice.namespace;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.StringTokenizer;


class Title extends LinkedList< String > {

	private static final long serialVersionUID = 3635291767668080216L;

	Title( final String s ) {
		final StringTokenizer toks = new StringTokenizer( s , "." );
		while ( toks.hasMoreTokens() ) {
			this.add( toks.nextToken() );
		}
	}

	String compact() {
		final Iterator it = this.iterator();
		String sofar = it.next().toString();
		while ( it.hasNext() ) {
			sofar = sofar + "." + it.next();
		}
		return sofar;
	}
	
	String last() {
		return this.getLast();
	}
}


