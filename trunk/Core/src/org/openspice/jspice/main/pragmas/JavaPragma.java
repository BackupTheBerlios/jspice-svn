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

import org.openspice.jspice.alert.Alert;
import org.openspice.jspice.main.pragmas.java_loader.MethodJavaLoader;
import org.openspice.jspice.main.pragmas.java_loader.ClassJavaLoader;
import org.openspice.jspice.main.pragmas.java_loader.JavaLoader;
import org.openspice.jspice.main.InterpreterMixin;
import org.openspice.jspice.main.Interpreter;

import java.util.List;
import java.util.Iterator;
import java.util.NoSuchElementException;


public class JavaPragma extends InterpreterMixin {

	public JavaPragma( Interpreter interpreter ) {
		super( interpreter );
	}

	/**
	 * Load the method class or package specified into the current package.
	 * @param args List< String >
	 */
	public void load( final List args ) {
		//	The first argument should be "method", "class" or "package".
		try {
			final Iterator it = args.iterator();
			final String what = ((String)it.next()).intern();
			JavaLoader j;
			if ( what == "class" ) {
				j = new ClassJavaLoader( this );
			} else if ( what == "method" ) {
				j = new MethodJavaLoader( this );
			} else {
				throw new Alert( "Invalid java scope specifier", "Should be method or class" ).culprit( "scope", what ).mishap();
			}
			while ( it.hasNext() ) {
				final String arg = (String)it.next();
				j.load( arg );
			}
		} catch ( final NoSuchElementException e ) {
			new Alert( "Invalid java command" ).mishap();
		}
	}

}
