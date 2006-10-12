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
package org.openspice.jspice.arithmetic;



public abstract class BinaryArithmeticOperator {

	public abstract Num applyNum( Num x, Num y );

	public final Num apply( final Number x, final Number y ) {
		if ( x instanceof Num ) {
			if ( y instanceof Num ) {
				return this.applyNum( (Num)x, (Num)y );
			} else {
				return this.apply( x, Num.toNum( y ) );
			}
		} else {
			return this.apply( Num.toNum( x ), y );
		}
	}

}
