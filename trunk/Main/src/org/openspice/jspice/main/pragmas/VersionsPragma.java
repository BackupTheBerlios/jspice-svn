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

import org.openspice.jspice.run.Pragma;
import org.openspice.jspice.run.PragmaAction;
import org.openspice.jspice.run.gestalt.Gestalt;

import java.util.Iterator;

public class VersionsPragma implements PragmaAction {

	public void invoke() {
		for ( Iterator it = Gestalt.versions().iterator(); it.hasNext(); ) {
			final Gestalt.GestaltVersion v = (Gestalt.GestaltVersion)it.next();
			System.out.println( v.format( "%p\t: %p %p" ) );
		}
	}

	public void doAction( final Pragma pragma ) {
		this.invoke();
	}

	public String[] names() {
		return new String[] { "version" };
	}

}
