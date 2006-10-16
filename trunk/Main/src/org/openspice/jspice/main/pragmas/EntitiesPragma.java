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
package org.openspice.jspice.main.pragmas;


import java.util.List;
import java.util.Iterator;

public class EntitiesPragma implements PragmaAction {

	//	List.
	public void doAction( final Pragma pragma ) {
		final List list = pragma.getDynamicConf().listEntities( pragma.getArgList().isEmpty() ? ".*" : (String)pragma.getArgList().get( 0 ) );
		int count = 0;
		for ( Iterator it = list.iterator(); it.hasNext(); count++ ) {
			final String ent = (String)it.next();
			final StringBuffer b = new StringBuffer();
			b.append( count );
			b.append( '.' );
			while ( b.length() < 4 ) {
				b.append( ' ' );
			}
			b.append( ent );
			System.out.println( b );
		}
	}

	public String[] names( ) {
		return new String[] { "entities" };
	}
	
}
