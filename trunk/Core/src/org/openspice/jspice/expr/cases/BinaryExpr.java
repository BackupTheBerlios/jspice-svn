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

package org.openspice.jspice.expr.cases;

import org.openspice.jspice.expr.Expr;
import org.openspice.jspice.expr.ExprBase;
import org.openspice.jspice.expr.iterators.ExprIterator;

abstract class BinaryExpr extends ExprBase {
	protected Expr lhs;
	protected Expr rhs;

	protected BinaryExpr( final Expr _lhs, final Expr _rhs ) {
		this.lhs = _lhs;
		this.rhs = _rhs;
	}

	public Expr getLeft() {
		return this.lhs;
	}

	public Expr getRight() {
		return this.rhs;
	}

	public Expr getFirst() {
		return this.lhs;
	}

	public Expr getSecond() {
		return this.rhs;
	}

	public ExprIterator getAllKids() {
		return ExprIterator.make2( this.lhs, this.rhs );
	}

}
