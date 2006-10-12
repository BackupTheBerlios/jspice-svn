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
package org.openspice.jspice.datatypes.elements;

import org.openspice.jspice.datatypes.Symbol;

import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;

public abstract class ArrayKidsXmlElement extends TypeSymbolXmlElement {

	protected Object[] children;

	public final Object get( int n ) {
		return this.children[ n ];
	}

	public final int size() {
		return this.children.length;
	}

	public final List childrenList( final boolean copy_flag ) {
		if ( copy_flag ) {
			return new ArrayList( this.childrenList( false ) );
		} else {
			return Arrays.asList( this.children );
		}
	}

}
