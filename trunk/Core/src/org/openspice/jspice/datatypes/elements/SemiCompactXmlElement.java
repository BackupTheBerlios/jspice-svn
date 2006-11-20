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

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.openspice.jspice.datatypes.*;
import org.openspice.jspice.built_in.inspect.FieldAdder;


import org.openspice.tools.EmptyMap;

public final class SemiCompactXmlElement extends ArrayKidsXmlElement {

	Map attributes;		//	todo: Cannot make private until we fix XmlElementFactory

	public Object lookup( final Object key ) {
		return this.attributes.get( key );
	}

	public Map attributesMap( boolean copy_flag ) {
		return copy_flag ? new TreeMap( this.attributes ) : this.attributes;
	}

	public int attributesCount() {
		return this.attributes.size();
	}

	static final Map EMPTY_MAP = new EmptyMap();
	static final Object[] EMPTY_ARRAY = new Object[ 0 ];
	
	//	Default visibility - NOT PUBLIC!
	public SemiCompactXmlElement( final Symbol _name, final Map _map, final Object[] _children ) {
		this.typeSymbol = _name;
		this.attributes = _map;
		this.children = _children;
	}
	
	private SemiCompactXmlElement( final Symbol _name, final Map _map, final List _list ) {
		this.typeSymbol = _name;
		this.attributes = _map.isEmpty() ? EMPTY_MAP : new TreeMap( _map );
		if ( _list.isEmpty() ) {
			this.children = EMPTY_ARRAY;
		} else {
			this.children = (
				(
					_list instanceof ArrayList ?
					(ArrayList)_list :
					new ArrayList( _list )
				).toArray()
			);
		}
	}

	//	This constructor is only to be used by Factory, exclusively.
	private SemiCompactXmlElement() {
	}

	public static final SemiCompactXmlElement makeSemiCompact( final Symbol _name, final Map _map, final List _list ) {
		return new SemiCompactXmlElement( _name, _map, _list );
	}

	//	----





	public void addInstanceFields( final FieldAdder adder ) {
    	adder.add( "name", this.typeSymbol );
   		adder.add( "attributes", this.attributes );
    	adder.add( "children", this.children );
	}

}
