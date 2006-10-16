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

import org.openspice.jspice.main.Interpreter;
import org.openspice.jspice.datatypes.proc.Proc;
import org.openspice.jspice.namespace.NameSpace;
import org.openspice.jspice.namespace.Var;
import org.openspice.jspice.namespace.Location;

import java.util.List;
import java.lang.reflect.Method;

public abstract class JavaLoader {

	final JavaPragmaLoader parent;

	protected JavaLoader( final JavaPragmaLoader parent ) {
		this.parent = parent;
	}

	public abstract void load( final String arg );

	protected void define( final String name, final Object value ) {
		final Interpreter interpreter = this.parent.getInterpreter();
		final NameSpace cns = interpreter.getCurrentNameSpace();
		final Var.Perm p = cns.declareVal( name );
		final Location loc = p.getLocation();
		loc.setValue( value );
//		System.out.println( "DEFINED: " + name );
	}

	/**
	 *
	 * @param mlist List< Method >
	 * @return Proc
	 */
	protected Proc methodToProc( final String name, final List< Method > mlist ) {
		final Method[] methods = new Method[ mlist.size() ];
		mlist.toArray( methods );
		return MethodProcFactory.newInstance( methods ).make();
	}

}
