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
package org.openspice.jspice.main.pragmas.java_loader;

import org.openspice.alert.Alert;

import java.lang.reflect.Method;
import java.util.List;
import java.util.ArrayList;

public class MethodJavaLoader extends JavaLoader {

	public MethodJavaLoader( final JavaPragmaLoader parent ) {
		super( parent );
	}

	private static Method[] filterByName( final String mname, final Method[] methods ) {
		final List< Method > list = new ArrayList< Method >();
		for ( int i = 0; i < methods.length; i++ ) {
			final Method m = methods[ i ];
			if ( m.getName().equals( mname ) ) {
				list.add( m );
			}
		}
		final Method[] answer = new Method[ list.size() ];
		list.toArray( answer );
		return answer;
	}

	public void load( final String arg ) {
		final int n = arg.lastIndexOf( '.' );
		if ( n == -1 ) {
			new Alert( "Invalid java method name" ).culprit( "name", arg ).mishap();
		}
		final String cname = arg.substring( 0, n );
		final String mname = arg.substring( n + 1 );
		try {
			final Class c = Class.forName( cname );
			final Method[] methods = filterByName( mname, c.getMethods() );
			if ( methods.length == 0 ) {
				new Alert( "No matching method name in class" ).culprit( "method name", mname ).culprit( "class name", cname ).mishap();
			} else {
				this.define( mname, MethodProcFactory.newInstance( methods ).make() );
			}
		} catch ( ClassNotFoundException e ) {
			throw new Alert( "Invalid class name" ).culprit( "class name", cname ).mishap();
		}
	}

}
