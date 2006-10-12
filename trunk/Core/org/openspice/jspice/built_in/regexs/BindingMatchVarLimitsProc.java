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
package org.openspice.jspice.built_in.regexs;

import org.openspice.jspice.datatypes.proc.Unary1InvokeProc;
import org.openspice.jspice.datatypes.proc.Binary1InvokeProc;
import org.openspice.jspice.datatypes.proc.BinaryFastProc;
import org.openspice.jspice.datatypes.regexs.Binding;
import org.openspice.jspice.datatypes.Arity;
import org.openspice.jspice.lib.CastLib;
import org.openspice.jspice.vm_and_compiler.VM;

public class BindingMatchVarLimitsProc extends BinaryFastProc {

	{
		setDescription( "bindingMatchVarLimits", "%p( B:Binding, N:Int ) -> ( lo:Int, hi:Int )", "Returns the start and end (inclusive) of the match represented by the binding" );
	}

	public Object fastCallBinary( final Object binding, final Object index, final VM vm ) {
		final Binding b = CastLib.toBinding( binding );
		final int i = CastLib.to_int( index );
		final int lo = b.getStart( i );
		final int hi = b.getEnd( i );
		vm.push( new Integer( lo ) );
		return new Integer( hi - 1 );
	}

	public Arity outArity() {
		return Arity.TWO;
	}

	public static final BindingMatchVarLimitsProc BINDING_MATCH_VAR_LIMITS_PROC = new BindingMatchVarLimitsProc();

}
