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
package org.openspice.tools;

import java.util.NoSuchElementException;
import java.util.ListIterator;

public class EmptyListIterator implements ListIterator {

	public boolean hasNext() {
		return false;
	}

	public Object next() {
		throw new NoSuchElementException();
	}

	public boolean hasPrevious() {
		return false;
	}

	public Object previous() {
		throw new NoSuchElementException();
	}

	public int nextIndex() {
		return 0;
	}

	public int previousIndex() {
		return -1;
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

	public static final EmptyListIterator EMPTY_LIST_ITERATOR = new EmptyListIterator();

}
