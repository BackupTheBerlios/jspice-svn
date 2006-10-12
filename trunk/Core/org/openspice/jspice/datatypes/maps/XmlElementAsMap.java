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
package org.openspice.jspice.datatypes.maps;

import org.openspice.jspice.datatypes.elements.XmlElement;
import org.openspice.jspice.datatypes.maplets.Maplet;
import org.openspice.jspice.lib.AbsentLib;

import java.util.Set;
import java.util.AbstractSet;
import java.util.Iterator;

public final class XmlElementAsMap extends PseudoMap {
	private final XmlElement xml_element;

	public XmlElementAsMap( final XmlElement _xml_element ) {
		this.xml_element = _xml_element;
	}

	public Object getObject() {
		return this.xml_element;
	}

	public Set entrySet() {
		return new XmlElementAsMapSet( this.xml_element );
	}

	public Object get( final Object key ) {
		try {
			return this.xml_element.get( ((Integer)key).intValue() - 1 );
		} catch ( final ClassCastException exn ) {
			return AbsentLib.ABSENT;
		}
	}

	public boolean isEmpty() {
		return this.xml_element.isEmpty();
	}

	public int size() {
		return this.xml_element.size();
	}

	static final class XmlElementAsMapSet extends AbstractSet {
		final XmlElement xml_element;

		XmlElementAsMapSet( final XmlElement _xml_element ) {
			this.xml_element = _xml_element;
		}

		public int size() {
			return this.xml_element.size();
		}

		public Iterator iterator() {
			final Iterator it = xml_element.childrenIterator( false );

			return(
				new Iterator() {
					int n = 0;

					public boolean hasNext() {
						return it.hasNext();
					}

					public Object next() {
						return (
							new Maplet(
								new Integer( ++this.n ),	//	Spice is 1-indexed.
								it.next()
							)
						);
					}

					public void remove() {
						throw new UnsupportedOperationException();
					}
				}
			);
		}
	}
}
