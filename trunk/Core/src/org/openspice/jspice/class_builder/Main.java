///**
// *	JSpice, an Open Spice interpreter and library.
// *	Copyright (C) 2003, Stephen F. K. Leach
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
//package org.openspice.jspice.class_builder;
//
//import org.openspice.jspice.datatypes.proc.Proc;
//import org.openspice.jspice.datatypes.proc.*;
//import org.openspice.jspice.vm_and_compiler.VM;
//import org.openspice.jspice.conf.DynamicConf;
//import org.openspice.jspice.arithmetic.LessThanOrEqual;
//import org.openspice.tools.IntegerTools;
//
//import java.lang.reflect.InvocationTargetException;
//
//public class Main {
//
//	public static final void main( final String[] args ) throws IllegalAccessException, InstantiationException {
//		final JSpiceClassLoader jcl = new JSpiceClassLoader();
//
//
//
//		{
//			final ClassBuilder b = jcl.newClassBuilder( "Baz", Object.class );
//			b.defineDefaultConstructor();
//			final MethodSpec p = b.newInstanceMethodSpec( "push99", "()Ljava/lang/Integer;", 1, 1 );
//			p.plantAConst( new Integer( 99 ) );
//			p.plantAReturn();
//
//			final Class c = b.newClass();
//			final Object x = c.newInstance();
//			try {
//				System.err.println( "should be 99: " + c.getMethod( "push99", new Class[] {} ).invoke( x, new Object[] {} ) );
//			} catch ( InvocationTargetException e ) {
//				throw new RuntimeException( e );
//			} catch ( NoSuchMethodException e ) {
//				throw new RuntimeException( e );
//			}
//		}
//
//		Class c;
//		{
//			final ClassBuilder b = jcl.newClassBuilder( "Foo", "java.lang.Object" );
//			b.newFieldSpec( "aByteField", "B" );
//			{
//				final MethodSpec init = b.newInstanceMethodSpec( "<init>", "()V", 1, 1 );
//				init.plantALoad( 0 );
//				init.plantInvokeSpecial( "java.lang.Object.<init>.()V" );
//				init.plantReturn();
//			}
//
//			final MethodSpec downcast = b.newStaticMethodSpec( "downcast", "(Ljava/lang/Object;)LFoo;", 1, 1 );
//			downcast.plantALoad( 0 );
//			downcast.plantCheckCast( "Foo" );
//			downcast.plantAReturn();
//
//			c = b.newClass();
//		}
//
//		{
//			//	nfib( n ) => if n <= 1 then 1 else nfib( n - 1 ) + nfib( n - 2 ) + 1 endif
//			//	nfib( 15 ) = 1973
//			final ClassBuilder b = jcl.newClassBuilder( "Nfib", Unary1FastProc.class );
//			b.defineDefaultConstructor();
//			//		public abstract Object fastCall( final Object tos, final VM vm, final int nargs );
//			final MethodSpec nfib = b.newInstanceMethodSpec( "invoke", "(Ljava/lang/Object;Lorg/openspice/jspice/vm_and_compiler/VM;I)Ljava/lang/Object;", 4, 1 );
//
//			//	ENTRY: Pop n
//			//	n <= 1? :
//
//
//			//	Push top of stack
//			nfib.plantALoad( 2 );				//	vm
//			nfib.plantALoad( 1 );				//	tos
//			nfib.plantInvokeVirtual( VM.class.getName(), "push", "(Ljava/lang/Object;)V" );
//
//			//	LTE 1
//			nfib.plantGetStatic( LessThanOrEqual.class.getName(), "LESS_THAN_OR_EQUAL", "Lorg/openspice/jspice/datatypes/proc;" );
//			nfib.plantAConst( IntegerTools.ONE );
//			nfib.plantALoad( 2 );				//	vm
//			nfib.plantLdc( 2 );					//	nargs for LTE
//
//
//		}
//
//		Proc getWabbleProc;
//		{
//			final ClassBuilder pc = jcl.newClassBuilder( "GetByteProc", Unary1InvokeProc.class );
//			{
//				final MethodSpec init = pc.newInstanceMethodSpec( "<init>", "()V", 1, 1 );
//				init.plantALoad( 0 );
//				init.plantInvokeSpecial( Unary1InvokeProc.class.getName(), "<init>", "()V" );
//				init.plantReturn();
//			}
//
//			final MethodSpec p = pc.newInstanceMethodSpec( "invoke", "(Ljava/lang/Object;)Ljava/lang/Object;", 2, 3 );
//			p.plantNew( "java.lang.Byte" );
//			p.plantDup();
//			p.plantALoad( 1 );
//			p.plantInvokeStatic( "Foo.downcast.(Ljava/lang/Object;)LFoo;" );
//			p.plantGetField( "Foo", "aByteField", "B" );
//			p.plantInvokeSpecial( "java.lang.Byte", "<init>", "(B)V" );
//			p.plantAReturn();														//
//
//			System.err.println( "modifiers: " + c.getModifiers() );
//			System.err.println( "instance : " + c.newInstance() );
//			try {
//				System.err.println( c.getMethod( "downcast", new Class[] {Object.class} ).invoke( c.newInstance(), new Object[] { c.newInstance() } ) );
//			} catch ( IllegalAccessException e ) {
//				throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
//			} catch ( IllegalArgumentException e ) {
//				throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
//			} catch ( InvocationTargetException e ) {
//				throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
//			} catch ( NoSuchMethodException e ) {
//				throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
//			} catch ( SecurityException e ) {
//				throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
//			}
//			getWabbleProc = (Proc)pc.newClass().newInstance();
//		}
//
//		final VM vm = new VM( new DynamicConf() );
//		System.err.println( getWabbleProc.call( c.newInstance(), vm, 1 ) );	//	Should print 0 (new Byte( 0 ))
//
//
//	}
//
//}
