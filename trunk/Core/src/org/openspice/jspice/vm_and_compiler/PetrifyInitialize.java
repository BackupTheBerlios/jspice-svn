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
package org.openspice.jspice.vm_and_compiler;

import org.openspice.jspice.lib.AbsentLib;
import org.openspice.jspice.expr.Expr;
import org.openspice.jspice.expr.cases.NamedExpr;
import org.openspice.jspice.expr.cases.NameExpr;
import org.openspice.jspice.expr.cases.AnonExpr;
import org.openspice.jspice.namespace.NameExprVisitor;
import org.openspice.jspice.vm_and_compiler.PetrifyAssign;
import org.openspice.jspice.vm_and_compiler.VM;

//	Usage:	PetrifyInitialize.petrify( Expr.NamedExpr name_expr, Pebble src_pebble )
public final class PetrifyInitialize extends NameExprVisitor {

	final boolean initializing;

	public PetrifyInitialize( boolean initializing ) {
		this.initializing = initializing;
	}

	public static Pebble petrify( final NameExpr name_expr, final Pebble _src_pebble, final boolean initializing ) {
		return (Pebble)name_expr.visit( new PetrifyInitialize( initializing ), _src_pebble );
	}

	public Object visitNamedExpr( final NamedExpr nme, final Object src_pebble ) {
		final Pebble pebb = PetrifyAssign.petrify( nme, (Pebble)src_pebble, this.initializing );
		if ( nme.isType3() ) {
			final int n = nme.getOffset();
			return (
				new Pebble() {
					Object run( final Object tos, final VM vm ) {
						//PrintTools.debugln( "Initializing type-3: " + nme.getTitle() + " at offset " + n );
						vm.store( n, new Ref( AbsentLib.ABSENT ) );
						return pebb.run( tos, vm );
					}
				}
			);
		} else {
			return pebb;
		}
	}

	public Object visitAnonExpr( final AnonExpr nme, final Object src_pebble ) {
		return PetrifyAssign.petrify( nme, (Pebble)src_pebble, this.initializing );
	}

}
