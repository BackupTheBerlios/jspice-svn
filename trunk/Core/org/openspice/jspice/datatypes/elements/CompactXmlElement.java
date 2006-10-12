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
import org.openspice.jspice.built_in.inspect.FieldAdder;
import org.openspice.jspice.lib.CastLib;
import org.openspice.jspice.lib.AbsentLib;


import java.util.*;

public class CompactXmlElement extends ArrayKidsXmlElement {

	private Object[] attributes;	//	key-value list of even length.  Symbols alternate with Objects.

	private CompactXmlElement( final Symbol s, final Object[] a, final Object[] c ) {
		this.typeSymbol = s;
		this.attributes = a;
		this.children = c;
	}

	public static final CompactXmlElement makeCompactXmlElement( final Symbol s, final Object[] a, final Object[] c ) {
		return new CompactXmlElement( s, (Object[])a.clone(), (Object[])c.clone() );
	}

	public static final CompactXmlElement makeCompactXmlElement( final Symbol s, final Map a, final List c ) {
		final Object[] assoc = new Object[ 2 * a.size() ];
		int i = 0;
		for ( Iterator it = a.entrySet().iterator(); it.hasNext(); ) {
			final Map.Entry me = (Map.Entry)it.next();
			assoc[ i++ ] = me.getKey();
			assoc[ i++ ] = me.getValue();
		}
		return new CompactXmlElement( s, assoc, c.toArray() );
	}

	public Object lookup( final Object key ) {
		int hi = this.attributes.length / 2;
		if ( hi == 0 ) return AbsentLib.ABSENT;
		final Symbol k = CastLib.toSymbol( key );
		int lo = 0;
		for (;;) {
			final int mid = ( lo + hi ) / 2;
			final int mid2 = mid * 2;
			final Symbol k1 = (Symbol)this.attributes[ mid2 ];
			final int c = k1.compareTo( k );
			if ( c == 0 ) return this.attributes[ mid2 + 1 ];
			if ( mid == lo || mid == hi ) return AbsentLib.ABSENT;
			if ( c < 0 ) {
				hi = mid - 1;
			} else {
				lo = mid + 1;
			}
		}
	}

	public Map attributesMap( final boolean copy_flag ) {
		final Map m = new TreeMap();					//	Always copies.
		final int N = this.attributes.length;
		for ( int i = 0; i < N; i += 2 ) {
			m.put( this.attributes[ i ], this.attributes[ i + 1 ] );
		}
		return m;
	}


	public int attributesCount() {
		return this.attributes.length / 2;
	}

	public void addInstanceFields( FieldAdder adder ) {
		adder.add( "name", this.typeSymbol );
   		adder.add( "attributes", this.attributes );
    	adder.add( "children", this.children );
	}

}
