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
package org.openspice.jspice.datatypes;

import org.openspice.jspice.tools.Consumer;
import org.openspice.jspice.tools.StringBufferConsumer;
import org.openspice.jspice.tools.PrintTools;
import org.openspice.jspice.tools.Showable;
import org.openspice.jspice.alert.Alert;
import org.openspice.jspice.built_in.inspect.FieldAdder;
import org.openspice.jspice.datatypes.proc.Proc;

import java.util.*;

public abstract class SpiceObject implements Showable {

	public abstract void showTo( final Consumer cuchar );
	public abstract void printTo( final Consumer cuchar );
	public abstract List convertToList();
	public abstract Map convertToMap();
	public abstract SpiceObject convertFromList( List list );
	public abstract SpiceObject convertFromMap( Map map );
	public abstract void addInstanceFields( FieldAdder adder );
	public abstract boolean isEmpty();
	public abstract boolean isMapLike();
	public abstract boolean isListLike();

	public Proc asProc() {
		throw new Alert( "Cannot apply this item" ).culprit( "item", this ).mishap();
	}

	//	Make this abstract when we are about to embark on hacking the summaries.
	public String summary( final String variable_name ) {
		final String std_name = this.getName();
		if ( std_name != null && !std_name.equals( variable_name ) ) {
			return variable_name + " synonym for " + std_name;
		} else {
			return variable_name + " " + this.getComment();
		}
	}

	public String getName() {
		return null;
	}

	private static final int mxlen = 64;

	public String getComment() {
		String s = PrintTools.showToString( this );
		if ( s.length() > mxlen ) {
			s = s.substring( 0, mxlen - 4 ) + " ...";
		}
		return " = " + s;
	}

	public String showToString() {
		final StringBufferConsumer sbc = new StringBufferConsumer();
		this.showTo( sbc );
		return (String)sbc.close();
	}
	
	public String printToString() {
		final StringBufferConsumer sbc = new StringBufferConsumer();
		this.printTo( sbc );
		return (String)sbc.close();
	}

	public final List getInstanceFields() {
		final List fields = new ArrayList();		//	List< Pair< String, Object > >
		this.addInstanceFields( new FieldAdder( fields ) );
		return fields;
	}

}

