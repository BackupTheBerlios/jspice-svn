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
package org.openspice.jspice.datatypes.proc;

import org.openspice.jspice.datatypes.Arity;
import org.openspice.jspice.vm_and_compiler.VM;

public interface ProcIntf {

	Arity inArity();

	Arity outArity();

	Object call( Object tos, VM vm, int nargs );

	Description getDescription();

	Proc inverse();

	Arity keysUArity();

	Arity valsUArity();

	Object ucall( Object tos, VM vm, int vargs, int kargs );
}
