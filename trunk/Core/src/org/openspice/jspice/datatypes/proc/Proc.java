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


import org.openspice.alert.AlertException;
import org.openspice.jspice.vm_and_compiler.*;
import org.openspice.jspice.tools.SysAlert;
import org.openspice.jspice.datatypes.Arity;
import org.openspice.jspice.datatypes.SpiceObjectNonMap;
import org.openspice.jspice.built_in.inspect.FieldAdder;
import org.openspice.jspice.tools.Consumer;

import java.util.*;

public abstract class Proc extends SpiceObjectNonMap implements ProcIntf {

	public void addInstanceFields( FieldAdder adder ) {
		//	Skip.
	}

	public Proc asProc() {
		return this;
	}


	private Description description = new Description( null, null, null );

	public Description getDescription() {
		return description;
	}

	public final String summary( final String variable_name ) {
		return this.description.summary( variable_name );
	}

	/**
	 * Wrong.  This should almost certainly invoke itself.  Problem - there is
	 * no virtual machine available.
	 * @param cuchar
	 */
	public void printTo( final Consumer cuchar ) {
		cuchar.outCharSequence( "[procedure " + ( this.description.getName() == null ? "-" : this.description.getName() ) + "]" );
	}

	public void showTo( final Consumer cuchar ) {
		cuchar.outCharSequence( "[procedure " + ( this.description.getName() == null ? this.getClass().getName() : this.description.getName() ) + "]" );
	}

	public Proc inverse() {
		return null;
	}
	
	public Arity keysUArity() {
		return this.inArity();
	}
	
	public Arity valsUArity() {
		return this.outArity();
	}

	public final AlertException fail_updater( final String complaint, final String explanation, final Object tos, final VM vm, final int vargs, final int kargs ) {
		vm.push( tos );

		final LinkedList keys = new LinkedList();
		for ( int i = 0; i < kargs; i++ ) {
			keys.addFirst( vm.pop() );
		}

		final LinkedList values = new LinkedList();
		for ( int i = 0; i < vargs; i++ ) {
			values.addFirst( vm.pop() );
		}

		final SysAlert alert = new SysAlert( complaint, explanation );

		alert.culprit( "procedure", this );
		{
			int k = 0;
			for ( Iterator it = keys.iterator(); it.hasNext(); k++ ) {
				alert.culprit( "key" + k, it.next() );
			}
		}
		{
			int v = 0;
			for ( Iterator it = values.iterator(); it.hasNext(); v++ ) {
				alert.culprit( "value" + v, it.next() );
			}
		}

		return alert.mishap( 'E' );
	}

	public Object ucall( final Object tos, final VM vm, final int vargs, final int kargs ) {
		throw this.fail_updater( "Invalid updater", "A procedure is being called in update mode that has no updater", tos, vm, vargs, kargs );
	}

	public void setDescription( final String name, final String signature, final String comment ) {
		this.description = new Description( name, signature, comment );
	}

}


