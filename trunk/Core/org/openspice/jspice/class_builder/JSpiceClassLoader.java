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
package org.openspice.jspice.class_builder;

import java.util.Map;
import java.util.HashMap;
import java.security.SecureClassLoader;

public class JSpiceClassLoader extends SecureClassLoader {

	public JSpiceClassLoader( ClassLoader classLoader ) {
		super( classLoader );
	}

	public JSpiceClassLoader() {
	}

	private Map< String, Class< ? extends Object > > load_classes = new HashMap< String, Class< ? extends Object > >();

	/**
	 *  This is the method where the task of class loading
	 *  is delegated to our custom loader.
	 *
	 * @param  name the name of the class
	 * @return the resulting <code>Class</code> object
	 * @exception ClassNotFoundException if the class could not be found
	 */
	protected Class< ? extends Object > findClass( String name ) throws ClassNotFoundException {
		final Class< ? extends Object > c = load_classes.get( name );
		if ( c == null ) throw new ClassNotFoundException();
		return c;
	}

	Class loadClassFromBytes( final String name, final byte[] bytes ) {
		final Class< ? extends Object > answer = this.defineClass( name, bytes, 0, bytes.length );
		this.load_classes.put( name, answer );
		return answer;
	}

	public ClassBuilder newClassBuilder( final String class_name, final String super_class_name ) {
		return new ClassBuilder( this, class_name, super_class_name );
	}

	public ClassBuilder newClassBuilder( final String class_name, final Class super_class ) {
		return new ClassBuilder( this, class_name, super_class.getName() );
	}

}
