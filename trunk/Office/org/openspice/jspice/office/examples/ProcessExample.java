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

public class ProcessExample {

	public static final void main( final String[] args ) {
		final Office office = new Office();
		final ProcessWorker worker = new LineProcessWorker( office, new String[] { "/usr/bin/tr", "abcd", "dcba" } );

		final ThreadInTray lbox = new ThreadInTray( office );
		worker.connectTo( lbox );

		lbox.newLetterTo( worker, "open" ).add( "xyz bad cab zyx\n" ).send();
		worker.finishOff();

		final Letter letter = lbox.receive();
		System.out.println( "Subject: " + letter.getSubject() );
		System.out.println( "Arg:     " + letter.get() );
	}

}
