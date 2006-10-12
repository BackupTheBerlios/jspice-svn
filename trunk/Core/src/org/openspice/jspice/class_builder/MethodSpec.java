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
package org.openspice.jspice.class_builder;

import org.openspice.tools.ReflectionTools;

import java.io.IOException;
import java.lang.reflect.Field;
import java.util.List;
import java.util.LinkedList;
import java.util.Iterator;

public class MethodSpec {

	final ClassBuilder builder;
	final ConstantPool pool;
	final int modifiers;
	final PoolEntry name;
	final String name_string;	//	Used for debugging.
	final PoolEntry descriptor;
	final int maxlocals;
	final int maxstack;

	final MaxTracker locals_tracker = new MaxTracker( this );
	MaxTracker stack_tracker = new MaxTracker( this );
	final List< MaxTracker > stack_tracker_dump = new LinkedList< MaxTracker >();

	final private void recordStackTracker() {
		this.stack_tracker_dump.add( this.stack_tracker );
		this.stack_tracker = new MaxTracker( this );
	}

	final DataSink code = new DataSink();

	String debugName() {
		return this.builder.getClassName() + "." + this.name_string;
	}


	private void initLocalsTracker( final String desc ) {
//		System.err.println( "Calculating locals for " + this.debugName() );
//		System.err.println( "  modifiers = " + modifiers + " (static = " + Constants.ACC_STATIC + ", public = " + Constants.ACC_PUBLIC + ")" );
//		System.err.println( "  static? " + ( ( modifiers & Constants.ACC_STATIC ) != 0 ) );
		if ( ( modifiers & Constants.ACC_STATIC ) == 0 ) {
			//	todo: calculate local parameters.
//			System.err.println( "  Add 1 for being instance (non-static)" );
			this.locals_tracker.inc();
		} else {
//			System.err.println( "  Add 0 for being static" );
		}
		final int nargs = DescriptorTools.numInputs( desc );
//		System.err.println( "  Add " + nargs + " for descriptor " + desc );
		this.locals_tracker.delta( nargs, null );

	}

	public MethodSpec( final ClassBuilder builder, final int modifiers, String name, final String descriptor, final int maxlocals, final int maxstack ) {
		this.builder = builder;
		this.pool = builder.pool;
		this.modifiers = modifiers;
		this.name = pool.newPoolEntry( name );
		this.name_string = name;
		this.descriptor = pool.newPoolEntry( descriptor );
		this.maxlocals = maxlocals;
		this.maxstack = maxstack;
		this.initLocalsTracker( descriptor );
	}

	final PoolEntry getName() {
		return this.name;
	}

	public PoolEntry getDescriptor() {
		return descriptor;
	}

	public void verifyMaxLocals() {
		if ( this.maxlocals != this.locals_tracker.getMax() ) {
			System.err.println( "verifyMaxLocals: do not agree in " + this.debugName() );
			System.err.println( "	maxlocals  = " + maxlocals );
			System.err.println( "   calculated = " + this.locals_tracker.getMax() );
		} else {
			System.err.println( "verifyMaxLocals: passed " + this.debugName() );
		}
	}

	public void verifyMaxStack() {
		int max = 0;
		for ( Iterator it = stack_tracker_dump.iterator(); it.hasNext(); ) {
			final MaxTracker m = (MaxTracker)it.next();
			max = Math.max( max, m.getMax() );
		}
		if ( this.maxstack != max ) {
			System.err.println( "verifyMaxStack: do not agree in " + this.debugName() );
			System.err.println( "	maxstack   = " + maxstack );
			System.err.println( "   calculated = " + max );
		} else {
			System.err.println( "verifyMaxStack: passed " + this.debugName() );
		}
	}

	void write( final DataSink ds ) {
		this.verifyMaxLocals();
		this.verifyMaxStack();
		try {
			ds.writeShort( this.modifiers );
			ds.writeIndex( this.getName() );
			ds.writeIndex( this.getDescriptor() );
			ds.writeShort( 1 );							//	Just the single code attribute for the moment

			//	----
			ds.writeIndex( this.pool.fetchCodeAttribute() );
			final IntMark attmark = ds.newIntMark();

			ds.writeShort( this.maxstack );				//	max stack
			ds.writeShort( this.maxlocals );			//	max locals
			final IntMark mark = ds.newIntMark();
			ds.writeDataSink( this.code );
			mark.set();
			ds.writeShort( 0 );							//	exception table
			ds.writeShort( 0 );							//	attributes table

			attmark.set();
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
	}

	//	---oooOOOooo---

	//	Code planting methods.

	public void plantAConstNull() {
		try {
			this.code.writeByte( Opcodes.ACONST_NULL );
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.stack_tracker.inc();
	}


	public void plantAString( final String s ) {
		final PoolEntry pe = this.pool.newClassInfoPoolEntry( s );
		try {
			this.code.writeByte( Opcodes.LDC );
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		}
		this.code.writeRef( pe );
	}

	public void plantAConst( final Object x ) {
		if ( x instanceof String ) {
			this.plantAString( (String)x );
		} else {
			final String hname = this.builder.getHiddenStaticField( x );
			final List< FieldSpec > fieldSpecs = this.builder.getFieldSpecs();
			final FieldSpec fs = new FieldSpec( this.pool, hname, DescriptorTools.descriptor( x.getClass() ), Constants.ACC_PUBLIC | Constants.ACC_STATIC );
			fieldSpecs.add( fs );
			this.plantGetStatic( fs );
		}
	}

	public void plantALoad( final int n ) {
		try {
			if ( 0 <= n && n < 4 ) {
				this.code.writeByte( Opcodes.ALOAD + n );
			} else {
				throw new RuntimeException( "out of range: " + n );
			}
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		} catch ( RuntimeException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.stack_tracker.inc( "plantALoad" );
	}

	public void plantAReturn() {
		try {
			this.code.writeByte( Opcodes.GETFIELD );
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.recordStackTracker();
	}

	public void plantAStore( final int n ) {
		try {
			if ( 0 <= n && n < 4 ) {
				this.code.writeByte( Opcodes.ASTORE_0 + n );	//	astore_[0-3]
			} else {
				this.code.writeByte( Opcodes.ASTORE );		//	astore
				this.code.writeByte( n );
			}
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.stack_tracker.dec( "plantAStore" );
	}

	public void plantCheckCast( final String s ) {
		try {
			final PoolEntry e = this.pool.newClassInfoPoolEntry( s );
			this.code.writeByte( Opcodes.CHECKCAST );
			this.code.writeRef( e );
		} catch ( IOException e1 ) {
			throw new RuntimeException( e1 );	//To change body of catch statement use Options | File Templates.
		}
	}

	public void plantCheckCast( final Class c ) {
		this.plantCheckCast( c.getName() );
	}

	public void plantDup() {
		try {
			this.code.writeByte( Opcodes.DUP );
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.stack_tracker.inc( "plantDup" );
	}

	public void plantGetField( final String name ) {
		try {
			final FieldReference ref = new FieldReference( name );
			this.code.writeByte( Opcodes.GETFIELD );
			this.code.writeRef( ref.poolEntry( this.pool ) );
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
	}

	public void plantGetField( final String cname, final String mname, final String desc ) {
		try {
			final FieldReference ref = new FieldReference( cname, mname, desc );
			this.code.writeByte( Opcodes.GETFIELD );
			this.code.writeRef( ref.poolEntry( this.pool ) );
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
	}

	public void plantGetField( final Class clss, final int n ) {
		final String cname = clss.getName();
		final Field f = clss.getFields()[ n ];
		final String fn = f.getName();
		final String fd = ReflectionTools.descriptor( f.getType() );
		this.plantGetField( cname, fn, fd );
	}

	public void plantGetStatic( final Class c, final String fname ) {
		try {
			this.plantGetStatic( c.getField( fname ) );
		} catch ( NoSuchFieldException e ) {
			throw new RuntimeException( e );
		}
	}

	public void plantGetStatic( final java.lang.reflect.Field f ) {
		this.plantGetStatic( f.getDeclaringClass(), f.getName(), DescriptorTools.descriptor( f.getType() ) );
	}

	public void plantGetStatic( final Class c, final String mname, final String desc ) {
		this.plantGetStatic( c.getName(), mname, desc );
	}

	public void plantGetStatic( final String cname, final String mname, final String desc ) {
		try {
			final FieldReference ref = new FieldReference( cname, mname, desc );
			this.code.writeByte( Opcodes.GETSTATIC );
			this.code.writeRef( ref.poolEntry( this.pool ) );
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.stack_tracker.inc( "plantGetStatic" );
	}

	public void plantGetStatic( final FieldSpec fs ) {
		final FieldReference ref = new FieldReference( this.builder.getClassName(), fs.getNameString(), fs.getDescriptorString() );
		try {
			this.code.writeByte( Opcodes.GETSTATIC );
			this.code.writeRef( ref.poolEntry( this.pool ) );
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.stack_tracker.inc( "plantGetStatic" );
	}

	public void plantIConst( final int n ) {
		try {
			if ( 0 <= n && n <= 5 ) {
				final byte b = (byte)( Opcodes.ICONST_0 + n );			//	iconst_(0-5)
				this.code.writeByte( b );
			} else if ( -128 <= n && n <= 127 ) {
				this.code.writeByte( Opcodes.BIPUSH );				//	bipush
				this.code.writeByte( n );
			} else if ( -32768 <= n && n <= 32767 ) {
				this.code.writeByte( Opcodes.SIPUSH );				//	sipush
				this.code.writeShort( n );
			} else {
				this.code.writeByte( Opcodes.LDC );				//	ldc
				this.pool.newPoolEntry( n );
			}
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		}
	}

	public void plantIfACmpEq( final Label label ) {
        throw new RuntimeException( "to be done" ); //  todo
//		if ( label.positionKnown() ) {
//			final int posn = label.position();
//			final int here = this.code.
//		} else if ( this.tryShortLabels() ) {
//
//		} else {
//
//		}
	}


	private void plantMiscInvoke( final int instr, final MethodReference mref, final boolean nonstatic ) {
		try {
			this.code.writeByte( instr );
			this.code.writeRef( mref.poolEntry( this.pool ) );
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.stack_tracker.delta( DescriptorTools.calcDelta( mref ) - ( nonstatic ? 1 : 0 ), "miscInvoke" );
		//	todo: use descriptor to calculate stack change
	}

	private void plantMiscInvoke( final int instr, final String name, final boolean nonstatic ) {
		this.plantMiscInvoke( instr, new MethodReference( name ), nonstatic );
	}

	private void plantMiscInvoke( final int instr, final String cname, final String mname, final String desc, final boolean nonstatic ) {
		 this.plantMiscInvoke( instr, new MethodReference( cname, mname, desc ), nonstatic );
	}

	//	example - java.lang.Object.equals(Ljava.lang.Object;)Z
	public void plantInvokeSpecial( final String name ) {
		this.plantMiscInvoke( Opcodes.INVOKE_SPECIAL, name, true );
	}

	public void plantInvokeSpecial( final String cname, final String mname, final String desc ) {
		this.plantMiscInvoke( Opcodes.INVOKE_SPECIAL, cname, mname, desc, true );
	}

	public void plantInvokeStatic( final String name ) {
		this.plantMiscInvoke( Opcodes.INVOKE_STATIC, name, false );
	}

	public void plantInvokeVirtual( final String name ) {
		this.plantMiscInvoke( Opcodes.INVOKE_VIRTUAL, name, true );
	}

	public void plantInvokeVirtual( final String cname, final String mname, final String desc  ) {
		this.plantMiscInvoke( Opcodes.INVOKE_VIRTUAL, cname, mname, desc, true );
	}


	public void plantIStore( final int n ) {
		try {
			if ( 0 <= n && n < 4 ) {
				this.code.writeByte( Opcodes.ISTORE_0 + n );	//	istore_[0-3]
			} else {
				this.code.writeByte( Opcodes.ISTORE );		//	istore
				this.code.writeByte( n );
			}
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.stack_tracker.dec();
	}

	public void plantNew( final String cname ) {
		try {
			this.code.writeByte( Opcodes.NEW );		//	new
			this.code.writeRef( this.pool.newClassInfoPoolEntry( cname ) );
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.stack_tracker.inc();
	}

	public void plantReturn() {
		try {
			this.code.writeByte( Opcodes.RETURN );		//	return
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.recordStackTracker();
	}

	public void plantPutField( final String cname, final String mname, final String desc ) {
		try {
			final FieldReference ref = new FieldReference( cname, mname, desc );
			this.code.writeByte( Opcodes.PUTFIELD );	//	putfield
			this.code.writeRef( ref.poolEntry( this.pool ) );
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
		this.stack_tracker.dec();	//	todo: double word
	}


	//	DERIVED
	public void plantPutField( final Class clss, final int n ) {
		final String cname = clss.getName();
		final Field f = clss.getFields()[ n ];
		final String fn = f.getName();
		final String fd = ReflectionTools.descriptor( f.getType() );
		this.plantPutField( cname, fn, fd );
	}



}
