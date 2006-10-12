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

import org.openspice.jspice.main.pragmas.JavaPragma;
import org.openspice.jspice.alert.Alert;
import org.openspice.jspice.datatypes.proc.Unary1FastProc;
import org.openspice.jspice.datatypes.proc.Proc;
import org.openspice.jspice.vm_and_compiler.VM;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.lang.reflect.Constructor;
import java.util.*;

public class ClassJavaLoader extends JavaLoader {

	public ClassJavaLoader( final JavaPragma parent ) {
		super( parent );
	}

	/**
	 *  Group the methods by name for class
	 * @param c class who methods ar e to be grouped
	 * @return HashMap< String, List< String > >
	 */
	private HashMap< String, List< Method > > groupMethodsByName( final Class c ) {
		final HashMap< String, List< Method > > mname_table = new HashMap< String, List< Method > >();
		final Method[] methods = c.getMethods();
		for ( int i = 0; i < methods.length; i++ ) {
			final Method m = methods[ i ];
			final String mname = m.getName();
			List< Method > list = mname_table.get( mname );
			if ( list == null ) {
				list = new LinkedList< Method >();
				mname_table.put( mname, list );
			}
			list.add( m );
		}
		return mname_table;
	}

	public void loadMethods( final Class c ) {
		final HashMap< String, List< Method > > mname_table = this.groupMethodsByName( c );
		for ( Map.Entry< String, List< Method > > me : mname_table.entrySet() ) {
			final String name = (String)me.getKey();
			final List< Method > mlist = me.getValue();		//	List< String >
			this.define( name, this.methodToProc( name, mlist ) );
		}
	}

	private static String createName( final String prefix, final Class c ) {
		final String s = c.getName();
		final int n = s.lastIndexOf( '.' );
		return prefix + s.substring( n + 1 );	//	works even when n = -1
	}

	public void loadConstructors( final Class c ) {
		final Constructor[] cs = c.getConstructors();

		if ( cs.length == 0 ) return;

		final int mods = c.getModifiers();
		final boolean normal = !Modifier.isAbstract( mods ) || !Modifier.isInterface( mods );
		if ( normal ) {
			this.define( createName( "new", c ), new ConstructorArrayProcFactory( cs ) );
		}
	}

	public void loadRecognizer( final Class c ) {
		final Proc proc = (
			new Unary1FastProc() {
				public Object fastCall( Object tos, VM vm, int nargs ) {
					return Boolean.valueOf( tos != null && tos.getClass() == c );
				}
			}
		);
		final String name = createName( "is", c );
		proc.setDescription( name, null, null );
		this.define( name, proc );
	}

	public void load( final String cname ) {
		try {
			final Class c = Class.forName( cname );
			this.loadMethods( c );
			this.loadConstructors( c );
			this.loadRecognizer( c );
		} catch ( final ClassNotFoundException e ) {
			new Alert( "No such class" ).culprit( "class name", cname ).mishap();
		}
	}

}
