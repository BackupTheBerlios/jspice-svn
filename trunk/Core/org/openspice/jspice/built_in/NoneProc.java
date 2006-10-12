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
package org.openspice.jspice.built_in;

import org.openspice.jspice.datatypes.Arity;
import org.openspice.jspice.datatypes.proc.Proc;
import org.openspice.jspice.datatypes.proc.Proc;
import org.openspice.jspice.vm_and_compiler.VM;

public final class NoneProc extends Proc {

	{
		setDescription(
			"none",
			"%p( a1, ..., aN ) -> ()",
			"ignores its arguments and returns no results"
		);
	}

	public Arity inArity() {
		return Arity.ZERO_OR_MORE;
	}

	public Arity outArity() {
		return Arity.ZERO;
	}

	public Object call( final Object tos, final VM vm, int nargs ) {
		if ( nargs > 0 ) {
			//	Repeat nargs-1 times.
			vm.drop( nargs - 1 );
			return vm.pop();
		} else {
			return tos;
		}
	}

	static public Proc NONE_PROC = new NoneProc();

}
