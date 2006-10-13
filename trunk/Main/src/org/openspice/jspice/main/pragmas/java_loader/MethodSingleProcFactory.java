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
import org.openspice.jspice.vm_and_compiler.VM;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.lang.reflect.InvocationTargetException;

final class MethodSingleProcFactory extends MethodProcFactory {
	final Method method;
	final Arity in_arity;
	final Arity out_arity;
	final int nparams;
	final int nargs;
	final Class rtype;
	final boolean is_static;
	final int nres;

	private static final Object[] nullArgs = new Object[ 0 ];

	public MethodSingleProcFactory( final Method method ) {
		this.method = method;
		this.rtype = this.method.getReturnType();
		this.is_static = Modifier.isStatic( this.method.getModifiers() );
		this.nres = ( this.rtype == Void.TYPE ? 0 : 1 );		//	How many results.
		this.out_arity = ( this.nres == 0 ? Arity.ZERO : Arity.ONE );
		final Class[] params = this.method.getParameterTypes();
		this.nparams = params.length;
		this.nargs = this.nparams + ( is_static ? 0 : 1 );
		this.in_arity = Arity.checkedMake( nargs, false );
	}

	private Proc makeIsStaticNres0() {
		if ( nparams == 0 ) {
			return(
				new MethodProc( this.in_arity, this.out_arity ) {
					public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
						method.invoke( null, nullArgs );
						return tos;
					}
				}
			);
		} else {
			return(
				new MethodProc( this.in_arity, this.out_arity ) {
					public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
						vm.push( tos );
						final Object[] args = vm.popArray( nparams );
						method.invoke( null, args );
						return vm.pop();
					}
				}
			);
		}
	}

	private Proc makeIsStaticNres1() {
		if ( nparams == 0 ) {
			return(
				new MethodProc( this.in_arity, this.out_arity ) {
					public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
						vm.push( tos );
						return method.invoke( null, nullArgs );
					}
				}
			);
		} else {
			return(
				new MethodProc( this.in_arity, this.out_arity ) {
					public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
						vm.push( tos );
						final Object[] args = vm.popArray( nparams );
						return method.invoke( null, args );
					}
				}
			);
		}
	}

	private Proc makeDynamicNres0() {
		if ( nparams == 0 ) {
			return(
				new MethodProc( this.in_arity, this.out_arity ) {
					public Object fastCall( final Object tos, final VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
						method.invoke( tos, nullArgs );
						return vm.pop();
					}
				}
			);
		} else {
			return(
				new MethodProc( this.in_arity, this.out_arity ) {
					public Object fastCall( final Object tos, final VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
						vm.push( tos );
						final Object[] args = vm.popArray( nparams );
						method.invoke( vm.pop(), args );
						return vm.pop();
					}
				}
			);
		}
	}

	private Proc makeDynamicNres1() {
		if ( nparams == 0 ) {
			return(
				new MethodProc( this.in_arity, this.out_arity ) {
					public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
						return method.invoke( tos, nullArgs );
					}
				}
			);
		} else {
			return(
				new MethodProc( this.in_arity, this.out_arity ) {
					public Object fastCall( Object tos, VM vm, int nargs ) throws IllegalAccessException, InvocationTargetException {
						vm.push( tos );
						final Object[] args = vm.popArray( nparams );
						return method.invoke( vm.pop(), args );
					}
				}
			);
		}
	}


	public Proc make() {
		Proc proc;
		if ( is_static ) {
			proc = nres == 0 ? makeIsStaticNres0() : makeIsStaticNres1();
		} else {
			proc = nres == 0 ? makeDynamicNres0() : makeDynamicNres1();
		}
		proc.setDescription( this.method.getName(), null, null );
		return proc;
	}


}
