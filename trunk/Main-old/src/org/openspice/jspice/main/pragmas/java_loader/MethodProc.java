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

import org.openspice.jspice.datatypes.proc.Proc;
import org.openspice.jspice.datatypes.Arity;
import org.openspice.jspice.vm_and_compiler.VM;

import java.lang.reflect.InvocationTargetException;

abstract class MethodProc extends Proc {
	final Arity in_arity;
	final Arity out_arity;

	public MethodProc( Arity in_arity, Arity out_arity ) {
		this.in_arity = in_arity;
		this.out_arity = out_arity;
	}

	public Arity inArity() {
		return this.in_arity;
	}

	public Arity outArity() {
		return this.out_arity;
	}

	public abstract Object fastCall( final Object tos, final VM vm, final int nargs )
		throws IllegalAccessException, InvocationTargetException;

	public Object call( final Object tos, final VM vm, final int nargs ) {
		this.inArity().check( nargs );
		try {
			return this.fastCall( tos, vm, nargs );
		} catch ( IllegalAccessException e ) {
			throw new RuntimeException( e );
		} catch ( InvocationTargetException e ) {
			throw new RuntimeException( e );
		}
	}
}
