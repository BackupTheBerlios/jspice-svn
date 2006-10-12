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
import org.xml.sax.Attributes;

import java.util.*;

public class FatMutableXmlElement extends TypeSymbolXmlElement {

	private final TreeMap attributes;
	private final ArrayList children;

	private FatMutableXmlElement( final Symbol _name, final TreeMap _map ) {
		this.typeSymbol = _name;
		this.attributes = _map;
		this.children  = new ArrayList();
	}

	private FatMutableXmlElement( final Symbol _name ) {
		this( _name, new TreeMap() );
	}

	public static final FatMutableXmlElement makeFatMutableXmlElement( final Symbol name ) {
		return new FatMutableXmlElement( name );
	}

	public static final FatMutableXmlElement make( final Symbol name, final Attributes attributes ) {
		return new FatMutableXmlElement( name, XmlElement.attributesToMap( attributes ) );
	}

	public CompactXmlElement toCompactXmlElement() {
		return CompactXmlElement.makeCompactXmlElement( this.typeSymbol, this.attributes, this.children );
	}

	public void putAttributes( final Map m ) {
		this.attributes.putAll( m );
	}

	public void addChildren( final Collection c ) {
		this.children.addAll( c );
	}

	public Object get( int n ) {
		return this.children.get( n );
	}

	public int size() {
		return this.children.size();
	}

	public List childrenList( final boolean copy_flag ) {
		return copy_flag ? new ArrayList( this.children ) : this.children;
	}

	public Object lookup( Object key ) {
		return this.attributes.get( key );
	}

	public int attributesCount() {
		return this.attributes.size();
	}

	public Map attributesMap( final boolean copy_flag ) {
		return copy_flag ? new TreeMap( this.attributes ) : this.attributes;
	}

	public void addInstanceFields( final FieldAdder adder ) {
    	adder.add( "name", this.typeSymbol );
   		adder.add( "attributes", this.attributes );
    	adder.add( "children", this.children );
	}

}
