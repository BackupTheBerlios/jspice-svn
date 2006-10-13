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

import org.openspice.jspice.expr.cases.NamedExpr;
import org.openspice.jspice.expr.cases.NameExpr;
import org.openspice.jspice.expr.cases.AnonExpr;
import org.openspice.jspice.namespace.Location;
import org.openspice.jspice.namespace.NameExprVisitor;
import org.openspice.tools.Print;

public final class PetrifyAssign extends NameExprVisitor {

	final boolean initializing;

	public PetrifyAssign( boolean initializing ) {
		this.initializing = initializing;
	}

	static public Pebble petrify( final NameExpr name_expr, final Pebble pebble, boolean initializing ) {
		return (Pebble)name_expr.visit( new PetrifyAssign( initializing ), pebble );
	}
	
	public Object visitNamedExpr( final NamedExpr nme, final Object the_pebble ) {
		if ( !this.initializing ) nme.checkAssignable();
		final Pebble pebble = (Pebble)the_pebble;
		if ( nme.isGlobal() ) {
			final Location r = nme.getPerm().getLocation();
			if ( r.referenceCheck() ) {
				return(
					new Pebble() {
						Object run( final Object tos, final VM vm ) {
							r.setValue( pebble.run( tos, vm ) );
							return vm.pop();
						}
					}
				);
			} else {
				return(
					new Pebble() {
						boolean do_set = true;
						Object run( final Object tos, final VM vm ) {
							r.setValue( pebble.run( tos, vm ) );
							if ( this.do_set ) {
								r.makeSet();
								this.do_set = false;
							}
							return vm.pop();
						}
					}
				);
			}
		} else {
			final int offset = nme.getOffset();
			if ( nme.isType1() ) {
				Print.println( Print.PARSE, "petrifying type-1 local " + nme.getTitle() );
				return(
					new Pebble() {
						Object run( final Object tos, final VM vm ) {
							vm.store( offset, pebble.run( tos, vm ) );
							return vm.pop();
						}
					}
				);
			} else {
				assert nme.isType3();
				Print.println( Print.PARSE, "petrifying type-3 local " + nme.getTitle() );
				return(
					new Pebble() {
						Object run( final Object tos, final VM vm ) {
							((Ref)vm.load( offset )).cont = pebble.run( tos, vm );
							return vm.pop();
						}
					}
				);			
			}
		}
	}
	
	public Object visitAnonExpr( final AnonExpr nme, final Object the_pebble ) {
		final Pebble pebble = (Pebble)the_pebble;
		return(
			new Pebble() {
				Object run( final Object tos, final VM vm ) {
					pebble.run( tos, vm );
					return vm.pop();
				}
			}
		);		
	}
}