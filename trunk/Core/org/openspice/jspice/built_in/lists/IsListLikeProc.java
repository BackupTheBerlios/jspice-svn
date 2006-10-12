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
package org.openspice.jspice.built_in.lists;

import org.openspice.jspice.datatypes.proc.Unary1InvokeProc;
import org.openspice.jspice.lib.IsLib;
import org.openspice.jspice.built_in.maps.IsMapLikeProc;


public class IsListLikeProc extends Unary1InvokeProc {

	{
		setDescription(
			"isListLike",
			"%p( object ) -> boolean",
			"returns true if object is  list flavoured, otherise false"
		);
	}

	public Object invoke( final Object x ) {
		return Boolean.valueOf( IsLib.isListFlavour( x ) );
	}

	public static final IsListLikeProc IS_LIST_LIKE_PROC = new IsListLikeProc();

}
