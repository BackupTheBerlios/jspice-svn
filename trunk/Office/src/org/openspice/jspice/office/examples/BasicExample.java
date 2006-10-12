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

import org.openspice.jspice.office.Office;
import org.openspice.jspice.office.Letter;
import org.openspice.jspice.office.MethodWorker;

import java.lang.reflect.Method;

/**
 * 
 */
public class BasicExample {

	public static final Method getMethod( Class c, String mname ) {
		Method answer = null;
		final Method[] ms = c.getMethods();
		for ( int i = 0; i < ms.length; i++ ) {
			final Method m = ms[ i ];
			if ( m.getName().equals( mname ) ) {
				if ( answer == null ) {
					answer = m;
				} else {
					throw new RuntimeException( "ambiguous: " + mname );
				}
			}
		}
		if ( answer == null ) throw new RuntimeException( "no such method: " + mname );
		return answer;
	}


	static public class Questioner extends MethodWorker {

		private static final Method ADD =  getMethod( Answerer.class, "add" );

		private int task;
		private int sofar;

		private void ask() {
			System.out.println( "task = " + this.task );
			System.out.println( "sofar = " + this.sofar );
			if ( this.task <= 1 ) {		//	defensive
				System.out.println( "Answer is " + this.sofar );
			} else {
				final Letter question = this.newOutTrayLetter( ADD );
				question.add( sofar );
				question.add( task );
				question.send();
			}
		}

		public void start( final int n ) {
			this.task = n;
			this.sofar = 1;
			this.ask();
		}

		public void answer( final int n ) {
			this.sofar = n;
			this.task = this.task - 1;
			this.ask();
		}

		public Questioner( final Office office ) {
			super( office );
		}
	}

	static public class Answerer extends MethodWorker {

		private static final Method ANSWER = getMethod( Questioner.class, "answer" );

		public void add( final int x, final int y ) {
			final Letter reply = this.newOutTrayLetter( ANSWER );
			System.out.println( "Adding " + x + " to " + y );
			reply.add( x + y );
			reply.send();
		}

		public Answerer( final Office office ) {
			super( office );
		}

	}

	public static final void main( final String[] args ) {
		final Office office = new Office();
		final Questioner questioner = new Questioner( office );
		final Answerer answerer = new Answerer( office );
		questioner.connectTo( answerer );
		answerer.connectTo( questioner );
		final Letter letter = questioner.newLetterTo( questioner, getMethod( Questioner.class, "start" ) );
		letter.add( 6 );
		letter.send();
	}

}
