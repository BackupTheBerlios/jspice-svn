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

import org.openspice.jspice.alert.Alert;
import org.openspice.jspice.tools.StringBufferConsumer;
import org.openspice.jspice.tools.PrintTools;

public class Description {

	private final String name;
	private final String signature;
	private final String comment;

	public Description( String name, String signature, String comment ) {
		if ( signature != null && signature.indexOf( "%p" ) < 0 ) {
			new Alert( "Missing %p in signature string" ).culprit( "name", name ).culprit( "signature", signature ).warning();
		}
		this.name = name;
		this.signature = signature;
		this.comment = comment;
	}

	public String getName() {
		return name;
	}

	public String getSignature() {
		return signature;
	}

	public String getComment() {
		return comment;
	}

	public final String summary( final String variable_name ) {
		{
			final String local_name = getName();
			if ( local_name != null && !local_name.equals( variable_name ) ) {
				return variable_name + " synonym for " + local_name;
			}
		}
		final String s = getSignature();
		final String c = getComment();
		final StringBufferConsumer sbc = new StringBufferConsumer();
		PrintTools.formatTo( sbc, ( s != null ? s : "%p" ), new Object[] { variable_name } );
		return sbc.closeAsString() + ( c != null ? "  # " + c : "" );
	}

}
