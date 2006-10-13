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
package org.openspice.jspice.main.pragmas.java_loader;

import org.openspice.jspice.datatypes.Arity;
import org.openspice.jspice.datatypes.proc.Proc;
import org.openspice.jspice.alert.Alert;
import org.openspice.jspice.vm_and_compiler.VM;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Constructor;

final class ConstructorArrayProcFactory {
	final Constructor[] constructors;
	final Arity in_arity;
	final Arity out_arity;

	public ConstructorArrayProcFactory( final Constructor[] constructors ) {
		assert constructors.length >= 1 ;
		this.constructors = constructors;
		this.out_arity = this.outArity( this.constructors );	//( this.nres == 0 ? Arity.ZERO : Arity.ONE );
		this.in_arity = this.inArity( this.constructors );
	}

	private Arity inArity( final Constructor[] constructors ) {
		int least = constructors[ 0 ].getParameterTypes().length;
		int most = least;
		for ( int i = 1; i < constructors.length; i++ ) {
			final Constructor con = constructors[ i ];
			final int n = con.getParameterTypes().length;
			if ( n < least ) least = n;
			if ( n > most ) most = n;
		}
		return Arity.checkedMake( least, least != most );
	}

	private Arity outArity( final Constructor[] constructors  ) {
		return Arity.ONE;
	}

	public static final Object[] nullArgs = new Object[ 0 ];

	private Proc makeNargs0() {
		return(
			new MethodProc( this.in_arity, this.out_arity ) {
				public Object fastCall( final Object tos, final VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
					vm.push( tos );
					final Object[] args = vm.popArray( nargs );
					for ( int i = 0; i < constructors.length; i++ ) {
						try {
							return constructors[ i ].newInstance( nullArgs );
						} catch ( final InstantiationException e ) {
							throw new Alert( "Constructor cannot be used to create instances", "Constructor belongs to abstract class" ).culprit( "constructor", constructors[ i ] ).mishap();
						} catch ( final IllegalArgumentException ex ) {
						}
					}
					throw new Alert( "No matching constructors" ).culprit( "args", args ).mishap();
				}
			}
		);
	}

	private Proc makeNargsGTE1() {
		return(
			new MethodProc( this.in_arity, this.out_arity ) {
				public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
					vm.push( tos );
					final Object[] args = vm.popArray( nargs );
					for ( int i = 0; i < constructors.length; i++ ) {
						try {
							return constructors[ i ].newInstance( args );
						} catch ( final InstantiationException e ) {
							throw new Alert( "Constructor cannot be used to create instances", "Constructor belongs to abstract class" ).culprit( "constructor", constructors[ i ] ).mishap();
						} catch ( final IllegalArgumentException ex ) {
						}
					}
					throw new Alert( "No matching constructors" ).culprit( "args", args ).mishap();
				}
			}
		);
	}


	Proc make() {
		Proc proc;
		if ( this.in_arity.hasFixedCount( 0 ) ) {
			proc = this.makeNargs0();
		} else {
			proc = this.makeNargsGTE1();
		}
		proc.setDescription( this.constructors[0].getName(), null, null );
		return proc;
	}

}
