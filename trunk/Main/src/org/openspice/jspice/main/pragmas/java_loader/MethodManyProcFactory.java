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

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.lang.reflect.InvocationTargetException;

final class MethodManyProcFactory extends MethodProcFactory {

	final Method[] methods;
	final Arity in_arity;
	final Arity out_arity;
	final boolean is_static;

	public MethodManyProcFactory( final Method[] methods ) {
		assert methods.length >= 1;
		this.methods = methods;
		this.is_static = Modifier.isStatic( methods[0].getModifiers() );
		this.out_arity = this.outArity( methods );	//( this.nres == 0 ? Arity.ZERO : Arity.ONE );
		this.in_arity = this.inArity( methods );
	}

	private Arity inArity( final Method[] methods ) {
		int least = methods[ 0 ].getParameterTypes().length;
		int most = least;
		for ( int i = 1; i < methods.length; i++ ) {
			final Method m = methods[ i ];
			final int n = m.getParameterTypes().length;
			if ( n < least ) least = n;
			if ( n > most ) most = n;
		}
		return Arity.checkedMake( least, least != most );
	}

	private Arity outArity( final Method[] methods  ) {
		boolean zero = false;
		boolean one = false;
		for ( int i = 0; i < methods.length; i++ ) {
			final Method m = methods[ i ];
			final int nres = ( m.getReturnType() == Void.TYPE ? 0 : 1 );
			zero |= ( nres == 0 );
			one |= ( nres == 1 );
		}
		return zero ? ( one ? Arity.ZERO_OR_MORE : Arity.ZERO ) : ( one ? Arity.ONE : Arity.ZERO_OR_MORE );
	}

	private Proc makeIsStaticNres0() {
		return(
			new MethodProc( this.in_arity, this.out_arity ) {
				public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
					vm.push( tos );
					final Object[] args = vm.popArray( nargs );
					for ( int i = 0; i < methods.length; i++ ) {
						try {
							methods[ i ].invoke( null, args );
							return vm.pop();
						} catch ( final IllegalArgumentException ex ) {
						}
					}
					throw new Alert( "No matching methods" ).culprit( "args", args ).mishap();
				}
			}
		);
	}

	private Proc makeIsStaticNres1() {
		return(
			new MethodProc( this.in_arity, this.out_arity ) {
				public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
					vm.push( tos );
					final Object[] args = vm.popArray( nargs );
					for ( int i = 0; i < methods.length; i++ ) {
						try {
							return methods[ i ].invoke( null, args );
						} catch ( final IllegalArgumentException ex ) {
						}
					}
					throw new Alert( "No matching methods" ).culprit( "args", args ).mishap();
				}
			}
		);
	}

	private Proc makeIsStaticNres01() {
		return(
			new MethodProc( this.in_arity, this.out_arity ) {
				public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
					vm.push( tos );
					final Object[] args = vm.popArray( nargs );
					for ( int i = 0; i < methods.length; i++ ) {
						try {
							final Object result = methods[ i ].invoke( null, args );
							if ( methods[ i ].getReturnType() == Void.TYPE ) return vm.pop();
							return result;
						} catch ( final IllegalArgumentException ex ) {
						}
					}
					throw new Alert( "No matching methods" ).culprit( "args", args ).mishap();
				}
			}
		);
	}

	private Proc makeDynamicNres0() {
		return(
			new MethodProc( this.in_arity, this.out_arity ) {
				public Object fastCall( final Object tos, final VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
					vm.push( tos );
					final Object[] args = vm.popArray( nargs );
					for ( int i = 0; i < methods.length; i++ ) {
						try {
							methods[ i ].invoke( null, args );
							return vm.pop();
						} catch ( final IllegalArgumentException ex ) {
						}
					}
					throw new Alert( "No matching methods" ).culprit( "args", args ).mishap();
				}
			}
		);
	}

	private Proc makeDynamicNres1() {
		return(
			new MethodProc( this.in_arity, this.out_arity ) {
				public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
					vm.push( tos );
					final Object[] args = vm.popArray( nargs );
					for ( int i = 0; i < methods.length; i++ ) {
						try {
							return methods[ i ].invoke( null, args );
						} catch ( final IllegalArgumentException ex ) {
						}
					}
					throw new Alert( "No matching methods" ).culprit( "args", args ).mishap();
				}
			}
		);
	}

	private Proc makeDynamicNres01() {
		return(
			new MethodProc( this.in_arity, this.out_arity ) {
				public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
					vm.push( tos );
					final Object[] args = vm.popArray( nargs );
					for ( int i = 0; i < methods.length; i++ ) {
						try {
							final Object result = methods[ i ].invoke( null, args );
							if ( methods[ i ].getReturnType() == Void.TYPE ) return vm.pop();
							return result;
						} catch ( final IllegalArgumentException ex ) {
						}
					}
					throw new Alert( "No matching methods" ).culprit( "args", args ).mishap();
				}
			}
		);
	}

	public Proc make() {
			Proc proc;
			if ( this.is_static ) {
				proc = (
					this.out_arity.hasFixedCount( 0 ) ? makeIsStaticNres0() :
					this.out_arity.hasFixedCount( 1 ) ? makeIsStaticNres1() :
					makeIsStaticNres01()
				);
			} else {
				proc = (
					this.out_arity.hasFixedCount( 0 ) ? makeDynamicNres0() :
					this.out_arity.hasFixedCount( 1 ) ? makeDynamicNres1() :
					makeDynamicNres01()
				);
			}
			proc.setDescription( this.methods[0].getName(), null, null );
			return proc;
	}

}
