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
package org.openspice.tools;

import java.util.List;
import java.util.AbstractList;

public class SubList extends AbstractList {

	final int lo;	//	inclusive
	final int hi;	//	exclusive

	final List list;

	public SubList( final List list, final int lo, final int hi ) {
		this.list = list;
		this.lo = lo;
		this.hi = hi;
	}

	public Object get( final int i ) {
		return this.list.get( i + lo );
	}

	public int size() {
		return this.hi - this.lo;
	}

}
