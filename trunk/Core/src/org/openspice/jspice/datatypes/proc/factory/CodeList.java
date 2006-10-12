///**
// *	JSpice, an Open Spice interpreter and library.
// *	Copyright (C) 2005, Stephen F. K. Leach
// *
// * 	This program is free software; you can redistribute it and/or modify
// *	it under the terms of the GNU General Public License as published by
// * 	the Free Software Foundation; either version 2 of the License, or
// * 	(at your option) any later version.
// *
// * 	This program is distributed in the hope that it will be useful,
// * 	but WITHOUT ANY WARRANTY; without even the implied warranty of
// * 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// *	GNU General Public License for more details.
// *
// *	You should have received a copy of the GNU General Public License
// * 	along with this program; if not, write to the Free Software
// *	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
// */
//package org.openspice.jspice.datatypes.proc.factory;
//
//import org.openspice.jspice.class_builder.JSpiceClassLoader;
//import org.openspice.jspice.class_builder.ClassBuilder;
//import org.openspice.jspice.class_builder.NameGenerator;
//import org.openspice.jspice.class_builder.MethodSpec;
//import org.openspice.jspice.datatypes.proc.Proc;
//import org.openspice.jspice.datatypes.proc.Description;
//import org.openspice.jspice.vm_and_compiler.VM;
//
///**
// * Proc's fundamental interface is:
// * 		Object call( Object tos, VM vm, int nargs );
// * 		0 = self
// * 		1 = tos
// * 		2 = vm
// * 		3 = nargs
// */
//public abstract class CodeList {
//
//	private final ProcFactory procFactory;
//	private final ClassBuilder classBuilder;
//	private final MethodSpec methodSpec;
//
//	final int self;
//	final int tos;
//	final int vm;
//	final int nargs;
//
//	protected CodeList( final ProcFactory procFactory ) {
//		this.procFactory = procFactory;
//		final JSpiceClassLoader jscl = this.procFactory.getJSpiceConf().getClassLoader();
//		this.classBuilder = jscl.newClassBuilder( NameGenerator.getNewDynPackageName(), Proc.class.getName() );
//		final Description d = this.procFactory.getDescription();
//		final String name = d.getName();
//		final String desc = d.getSignature();
//		this.methodSpec = this.classBuilder.newInstanceMethodSpec( name, desc, 4, 4 );
//
//		//	Arguments.
//		this.self = 0;
//		this.tos = 1;
//		this.vm = 2;
//		this.nargs = 3;
//	}
//
//	protected abstract boolean isReady();
//
//	private void pushTOS() {
//		this.methodSpec.plantALoad( this.tos );				//	tos
//	}
//
//	private void pushVM() {
//		this.methodSpec.plantALoad( this.vm );				//	vm
//	}
//
//	private void popTOS() {
//		this.methodSpec.plantAStore( this.tos );			//	tos
//	}
//
//	//	Stack requirement: 2
//	public void sysPUSHQ( final Object x ) {
//		//	Push top of stack
//		this.pushVM();
//		this.pushTOS();
//		this.methodSpec.plantInvokeVirtual( VM.class.getName(), "push", "(Ljava/lang/Object;)V" );
//		this.methodSpec.plantAConst( x );
//		this.popTOS();
//	}
//
//	//	Stack requirement: 4
//	public void sysCALLQ( final Proc p, final int nargs ) {
//		this.methodSpec.plantAConst( p );					//	subject
//		this.pushTOS();
//		this.pushVM();
//		this.methodSpec.plantIConst( nargs );
//		this.methodSpec.plantInvokeVirtual( Proc.class.getName(), "call", "(Ljava/lang/Object;Ljava/lang/Object;I)Ljava/lang/Object;" );
//		this.popTOS();
//	}
//
//	public void sysIFNOT( final Label label ) {
//		if ( this.usingShortLabels() ) {
//			//	jump if the top of the stack is Boolean.FALSE
//			this.pushTOS();
//			this.methodSpec.plantGetStatic( Boolean.class, "FALSE" );
//			this.methodSpec.plantIfACmpEq( label );
//		} else {
//
//		}
//	}
//
//}
