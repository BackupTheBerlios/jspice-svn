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
package org.openspice.jspice.office.examples;

import org.openspice.jspice.office.*;

public class SocketExample {

	public static final void main( final String[] args ) {
		final Office office = new Office();
		final Worker worker = new LineSocketWorker( office, "192.168.1.13", 1080 );
		final ThreadInTray lbox = new ThreadInTray( worker );
		worker.getOutTray().connectTo( lbox );

		worker.newOutTrayLetter( "open" ).add( "xyz bad cab zyx\n" ).send();

		final Letter letter = lbox.receive();
		System.out.println( "Subject: " + letter.getSubject() );
		System.out.println( "Arg:     " + letter.get() );

		worker.finishOff();
	}

}
