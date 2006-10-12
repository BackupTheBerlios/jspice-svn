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

import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;

public abstract class MethodWorker extends StandardWorker {

	public MethodWorker( final Office office ) {
		super( office );
	}

	public void handleLetter( final Letter letter ) {
		try {
			final Method m = (Method)letter.getSubject();
			final Object[] args = letter.posnArray();
			try {
				m.invoke( this, args );
			} catch ( IllegalArgumentException e ) {
				System.err.println( "method name: " + m.getName() );
				System.err.println( "nargs: " + args.length );
				for ( int i = 0; i < args.length; i++ ) {
					System.err.println( "arg[" + i + "]: " + args[ i ] );
				}
				throw new RuntimeException( "invalid arguments for method: " + m.getName() );
			}
		} catch ( IllegalAccessException e ) {
			throw new RuntimeException( e );
		} catch ( InvocationTargetException e ) {
			throw new RuntimeException( e );
		}
	}

	public void handleFinish() {
		//	Skip.
	}

}
