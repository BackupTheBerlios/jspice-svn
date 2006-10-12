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
package org.openspice.jspice.datatypes.proc;

import org.openspice.jspice.datatypes.Arity;
import org.openspice.jspice.vm_and_compiler.VM;
import org.openspice.jspice.alert.Alert;

public abstract class Binary1InvokeProc extends BinaryFastProc {

	{
		setDescription( null, "%p( a, b ) -> r", null );
	}

	public abstract Object invoke( Object x, Object y );

	public Arity outArity() {
		return Arity.ONE;
	}

	public Object fastCall( final Object tos, final VM vm, final int nargs ) {
		return this.invoke( vm.pop(), tos );
	}

	public Object fastCallBinary( Object x, Object y, VM vm ) {
		throw Alert.unreachable();
	}

}
