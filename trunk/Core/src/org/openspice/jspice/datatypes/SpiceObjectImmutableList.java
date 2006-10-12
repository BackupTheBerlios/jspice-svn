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

import java.util.List;
import java.util.Iterator;
import java.util.Collection;
import java.util.ListIterator;

public abstract class SpiceObjectImmutableList extends SpiceObject implements List {

	public boolean contains( final Object o ) {
		return this.indexOf( o ) >= 0;
	}

	public Iterator iterator() {
		final int n = this.size();
		return (
			new Iterator() {
				int i = 0;

				public boolean hasNext() {
					return i < n;
				}

				public Object next() {
					return org.openspice.jspice.datatypes.SpiceObjectImmutableList.this.get( i++ );
				}

				public void remove() {
					throw new UnsupportedOperationException();
				}
			}
		);
	}

	public Object[] toArray() {
		final int n = this.size();
		final Object[] a = new Object[ n ];
		for ( int i = 0; i < n; i++ ) {
			a[ i ] = this.get( i );
		}
		return a;
	}

	public Object[] toArray( Object[] objects ) {
		final int n = this.size();
		final int m = objects.length;
		if ( n > m ) return this.toArray();		//	Horrible - but that's the spec.
		for ( int i = 0; i < n; i++ ) {
			objects[ i ] = this.get( i );
		}
		if ( n < m ) {
			objects[ n ] = null;				//	Vile - but that's the spec.
		}
		return objects;
	}

	public boolean add( Object o ) {
		throw new UnsupportedOperationException();
	}

	public boolean remove( Object o ) {
		throw new UnsupportedOperationException();
	}

	public boolean containsAll( final Collection collection ) {
		for ( Iterator it = collection.iterator(); it.hasNext(); ) {
			final Object x = it.next();
			if ( !this.contains( x ) ) return false;
		}
		return true;
	}

	public boolean addAll( Collection collection ) {
		throw new UnsupportedOperationException();
	}

	public boolean addAll( int i, Collection collection ) {
		throw new UnsupportedOperationException();
	}

	public boolean removeAll( Collection collection ) {
		throw new UnsupportedOperationException();
	}

	public boolean retainAll( Collection collection ) {
		throw new UnsupportedOperationException();
	}

	public void clear() {
		throw new UnsupportedOperationException();
	}

	public Object set( int i, Object o ) {
		throw new UnsupportedOperationException();
	}

	public void add( int i, Object o ) {
		throw new UnsupportedOperationException();
	}

	public Object remove( int i ) {
		throw new UnsupportedOperationException();
	}

	public int indexOf( final Object o ) {
		final int n = this.size();
		for ( int i = 0; i < n; i++ ) {
			final Object x = this.get( i );
			if ( o == null ) {
				if ( x == null ) return i;
			} else if ( o.equals( x ) ) {
				return i;
			}
		}
		return -1;
	}

	public int lastIndexOf( Object o ) {
		final int n = this.size();
		for ( int i = n - 1; i >= 0; i -= 1 ) {
			final Object x = this.get( i );
			if ( o == null ) {
				if ( x == null ) return i;
			} else if ( o.equals( x ) ) {
				return i;
			}
		}
		return -1;
	}

	public ListIterator listIterator() {
		return this.listIterator( 0 );
	}

	public ListIterator listIterator( final int offset ) {
		final int n = this.size();
		return(
			new ListIterator() {
				int i = offset;

				public boolean hasNext() {
					return i < n;
				}

				public Object next() {
					return org.openspice.jspice.datatypes.SpiceObjectImmutableList.this.get( i++ );
				}

				public boolean hasPrevious() {
					return i > 0;
				}

				public Object previous() {
					return org.openspice.jspice.datatypes.SpiceObjectImmutableList.this.get( --i );
				}

				public int nextIndex() {
					return i;
				}

				public int previousIndex() {
					return i - 1;
				}

				public void remove() {
					throw new UnsupportedOperationException();
				}

				public void set( Object o ) {
					throw new UnsupportedOperationException();
				}

				public void add( Object o ) {
					throw new UnsupportedOperationException();
				}

			}
		);
	}

	public List subList( final int i, final int i1 ) {
		return new org.openspice.tools.SubList( this, i, i1 );
	}

	public boolean isEmpty() {
		return this.size() == 0;
	}

	public boolean isMapLike() {
		return true;
	}

	public boolean isListLike() {
		return true;
	}

	public List convertToList() {
		return this;
	}

}
