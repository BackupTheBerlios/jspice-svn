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

/**
 * This trivial example shows how to create an Office, a single Worker, and
 * how to send it a letter.
 */ 
public class TrivialExample {

	/**
	 * TrivialWorker simply prints the subject of its letters to
	 * the standard output.  It illustrates the simplest way to
	 * create a worker - subclassing StandardWorker.
	 */
	static public class TrivialWorker extends StandardWorker {

		public TrivialWorker( final Office office ) {
			super( office );
		}

		/**
		 * This method is invoked on the receipt of a letter.
		 * @param letter
		 */
		public void handleLetter( final Letter letter ) {
			System.out.println( "Subject: " + letter.getSubject() );
		}

		/**
		 * This method is invoked when the worker is shutdown.  In
		 * this case it is not shut down cleanly.
		 */
		public void handleFinish() {
			System.out.println( "Finished" );
		}

	}

	public static final void main( final String[] args ) {
		final Office office = new Office();					//	Create the office.
		final Worker worker = new TrivialWorker( office );	//	And a trivial worker.
		worker.newLetterToSelf( "hello, world" ).send();	//	Create and send letter.
	}

}
