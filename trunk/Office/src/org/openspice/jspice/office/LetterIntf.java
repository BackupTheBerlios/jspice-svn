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
package org.openspice.jspice.office;

import java.util.List;
import java.util.Map;

/**
 * The LetterIntf is a <i>scaffolding</i> interface that has no useful meaning
 * except to the developer of the package.
 * @see Letter
 */
public interface LetterIntf {

	public Tray getTo();
	public Tray getFrom();
	public Object getSubject();

	public Letter add( Object value );
	public Letter add( boolean value );
	public Letter add( int value );
	public Letter put( Object key, Object value );
	public Object get();
	public int getInt();
	public boolean getBoolean();
	public Object get( int index );
	public int getInt( int index );
	public boolean getBoolean( int index );
	public Object get( Object key );
	public int getInt( Object key );
	public boolean getBoolean( Object key );
	public Object[] posnArray();
	public List posnList();
	public Map keyedMap();
	public int posnSize();
	public int keyedSize();

	public void send();

}
