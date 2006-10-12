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

import org.openspice.jspice.datatypes.SpiceObject;
import org.openspice.jspice.datatypes.Symbol;
import org.openspice.jspice.datatypes.proc.Proc;
import org.openspice.jspice.datatypes.proc.Unary1FastProc;
import org.openspice.jspice.datatypes.maps.XmlElementAsMap;
import org.openspice.jspice.datatypes.lists.XmlElementAsList;
import org.openspice.jspice.tools.Consumer;
import org.openspice.jspice.tools.PrintTools;
import org.openspice.jspice.vm_and_compiler.VM;
import org.openspice.jspice.lib.CastLib;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.ParserConfigurationException;
import java.util.*;
import java.io.InputStream;
import java.io.IOException;


public abstract class XmlElement extends SpiceObject implements XmlElementIntf {

	public abstract Symbol getTypeSymbol();
	public abstract String getTypeString();

	public abstract Object get( int n );
	public abstract int size();

	public abstract Object lookup( final Object key );
	public abstract int attributesCount();
	public abstract Map attributesMap( boolean copy_flag );


	public Iterator childrenIterator( boolean copy_flag ) {
		return this.childrenList( copy_flag ).iterator();
	}

	public Iterator attributesIterator( boolean copy_flag ) {					//	Iterator< Map.Entry< Object, Object > >
		return this.attributesMap( copy_flag ).entrySet().iterator();
	}

	private boolean eqKids( final XmlElement that ) {
		final int N = this.size();
		if ( N != that.size() ) return false;
		for ( int i = 0; i < N; i++ ) {
			final Object x = this.get( i );
			final Object y = that.get( i );
			if ( x == null ) {
				if ( y != null ) return false;
			} else {
				if ( ! x.equals( y ) ) return false;
			}
		}
		return true;
	}

	private boolean eqAttributes( final XmlElement that ) {
		final int N = this.attributesCount();
		if ( N != that.attributesCount() ) return false;
		for ( Iterator it = this.attributesIterator( false ); it.hasNext(); ) {
			final Map.Entry me = (Map.Entry)it.next();
			final Object v = that.lookup( me.getKey() );
			if ( v == null ) {
				if ( me.getValue() != null ) return false;
			} else {
				if ( ! v.equals( me.getValue() ) ) return false;
			}
		}
		return true;
	}

	public boolean equals( final Object x ) {
		if ( this == x ) return true;
		if ( ! ( x instanceof XmlElement ) ) return false;
		final XmlElement that = (XmlElement)x;
		return (
			this.getTypeSymbol() == that.getTypeSymbol() &&
			this.eqKids( that ) &&
			this.eqAttributes( that )
		);
	}


	public boolean isEmpty() {
		return this.size() == 0;
	}

	public void printTo( final Consumer cuchar ) {
		cuchar.out( '<' );
		PrintTools.printTo( cuchar, this.getTypeString() );

		for ( Iterator it = this.attributesIterator( false ); it.hasNext(); ) {
			final Map.Entry e = (Map.Entry)it.next();
			cuchar.out( ' ' );
			cuchar.outCharSequence( ((Symbol)e.getKey()).getInternedString() );
			cuchar.out( '=' );
			cuchar.out( '"' );
			PrintTools.printTo( cuchar, e.getValue() );
			cuchar.out( '"' );
		}

		if ( this.isEmpty() ) {
			cuchar.outCharSequence( "/>" );
		} else {
			cuchar.out( '>' );

			{
				String gap = "";
				for ( int i = 0; i < this.size(); i++ ) {
					final Object x = this.get( i );
					cuchar.outCharSequence( gap );
					gap = ", ";
					PrintTools.printTo( cuchar, x );
				}
			}

			cuchar.outCharSequence( "</" );
			cuchar.outCharSequence( this.getTypeSymbol().getInternedString() );
			cuchar.out( '>' );
		}
	}

	public void showTo( final Consumer cuchar ) {
		cuchar.out( '<' );
		cuchar.outCharSequence( this.getTypeString() );

		for ( Iterator it = this.attributesIterator( false ); it.hasNext(); ) {
			final Map.Entry e = (Map.Entry)it.next();
			cuchar.out( ' ' );
			if ( ! ( e.getKey() instanceof Symbol)) {
				System.err.println( "key = '" + e.getKey() + "' (" + e.getKey().getClass().getName() + ")" );
				System.err.println( "val = '" + e.getValue() + "' (" + e.getValue().getClass().getName() + ")" );
			}
			cuchar.outCharSequence( ((Symbol)e.getKey()).getInternedString() );
			cuchar.out( '=' );
			PrintTools.show( e.getValue() );
		}

		if ( this.isEmpty() ) {
			cuchar.outCharSequence( "/>" );
		} else {
			cuchar.out( '>' );

			{
				String gap = "";
				for ( int i = 0; i < this.size(); i++ ) {
					final Object x = this.get( i );
					cuchar.outCharSequence( gap );
					gap = ", ";
					PrintTools.showTo( cuchar, x );
				}
			}

			cuchar.outCharSequence( "</" );
			cuchar.outCharSequence( this.getTypeString() );
			cuchar.out( '>' );
		}
	}

	public Proc asProc() {
		return(
			new Unary1FastProc() {
				public Object fastCall( Object tos, VM vm, int nargs ) {
					return XmlElement.this.get( CastLib.to_int( tos ) - 1 );
				}
			}
		);
	}

	public boolean isListLike() {
		return true;
	}

	public boolean isMapLike() {
		return true;
	}

	public List convertToList() {
		return new XmlElementAsList( this );
	}

	public Map convertToMap() {
		return new XmlElementAsMap( this );
	}

	public SpiceObject convertFromList( final List list ) {
		return CompactXmlElement.makeCompactXmlElement( this.getTypeSymbol(), this.attributesMap( false ), list );
	}

	public SpiceObject convertFromMap( final Map map ) {
		return CompactXmlElement.makeCompactXmlElement( this.getTypeSymbol(), map, this.childrenList( false ) );
	}

	public static final XmlElement makeXmlElement( final Symbol t, final Map a, final List c ) {
		return CompactXmlElement.makeCompactXmlElement( t, a, c );
	}

		//	todo: how do we handle qualified names, local names etc etc etc.
	static TreeMap attributesToMap( final Attributes attributes ) {
		final TreeMap map = new TreeMap();
		final int len = attributes.getLength();
		for ( int i = 0; i < len; i++ ) {
			final String localName = attributes.getLocalName( i );
			final String value = attributes.getValue( i );
			map.put( Symbol.make( localName ), value );
		}
		return map;
	}

		//	todo:	This is very free with the items it allocates, I suspect.  Review.
	static public XmlElement readXmlElement( final InputStream inputStream ) {
		final InputSource inputSrc = new InputSource( inputStream );
		final SAXParserFactory parserFactory = SAXParserFactory.newInstance();
		try {
			final SAXParser parser = parserFactory.newSAXParser();
			final XmlElementHandler h = new XmlElementHandler();
			parser.parse( inputSrc, h );
			return h.giveItUp();
		} catch ( final IOException e ) {
			throw new RuntimeException( e );
		} catch ( final ParserConfigurationException e ) {
			throw new RuntimeException( e );
		} catch ( final SAXException e ) {
			throw new RuntimeException( e );
		}
	}
}
