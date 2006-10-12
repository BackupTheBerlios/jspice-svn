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

import java.io.*;
import java.util.*;
import java.lang.reflect.Field;

public class ClassBuilder {

	final JSpiceClassLoader class_loader;
	final ConstantPool pool = new ConstantPool();

	//	---oooOOOooo---

	final String class_name;
	final String super_class_name;
	final List< FieldSpec > field_spec_list = new ArrayList< FieldSpec >();
	final List< MethodSpec > method_spec_list = new ArrayList< MethodSpec >();
	final Map< String, Object > runtime_constants = new HashMap< String, Object >();

	String getHiddenStaticField( final Object initial_value ) {
		final String answer = NameGenerator.getHiddenStaticName();
		this.runtime_constants.put( answer, initial_value );
		return answer;
	}

	public static final String translate( final Class c ) {
		return PoolEntry.translate( c.getName() );
	}

	/**
	 * Returns the name of the class being constructed.
	 * @return name of class under construction
	 */
	String getClassName() {
		return this.class_name;
	}

	/**
	 * Returns the name of the superclass of the class currently being constructed.
	 * @return name of superclass of class under construction
	 */
	String getSuperClassName() {
		return this.super_class_name;
	}

	List< FieldSpec > getFieldSpecs() {
		return this.field_spec_list;
	}

	List< MethodSpec > getMethodSpecs() {
		return this.method_spec_list;
	}

	public MethodSpec newInstanceMethodSpec( final String name, final String descriptor, final int maxlocals, final int maxstack ) {
		final MethodSpec ms = new MethodSpec( this, Constants.ACC_PUBLIC, name, descriptor, maxlocals, maxstack );
		this.method_spec_list.add( ms );
		return ms;
	}

	public MethodSpec defineConstantInstanceMethod( final String name, final Object x ) {
		final String descriptor = translate( x.getClass() );
		final MethodSpec ms = new MethodSpec( this, Constants.ACC_PUBLIC, name, descriptor, 1, 1 );
		ms.plantAConst( x );
		ms.plantAReturn();
		return ms;
	}
//	public MethodSpec newSimpleConstantInstanceMethodSpec( final String name, final String descriptor, final int maxlocals, final int maxstack ) {
//		final MethodSpec ms = new MethodSpec( this, Constants.ACC_PUBLIC, name, descriptor, maxlocals, maxstack );
////		this.method_spec_list.add( ms );
////		return ms;
//	}

	public MethodSpec newStaticMethodSpec( final String name, final String descriptor, final int maxlocals, final int maxstack ) {
		final MethodSpec ms = new MethodSpec( this, Constants.ACC_PUBLIC | Constants.ACC_STATIC, name, descriptor, maxlocals, maxstack );
		this.method_spec_list.add( ms );
		return ms;
	}

	public FieldSpec newFieldSpec( String name, String descriptor ) {
		final FieldSpec answer = new FieldSpec( this.pool, name, descriptor );
		this.field_spec_list.add( answer );
		return answer;
	}

	final PoolEntry class_info;
	final PoolEntry super_class_info;

	public ClassBuilder( final JSpiceClassLoader class_loader, final String cn, final String scn ) {
		this.class_loader = class_loader;
		this.class_name = cn;
		this.super_class_name = scn;
		this.class_info = this.pool.newClassInfoPoolEntry( cn );
		this.super_class_info = this.pool.newClassInfoPoolEntry( scn );
	}

	//	---oooOOOooo---

	public void defineDefaultConstructor() {
		final MethodSpec init = this.newInstanceMethodSpec( "<init>", "()V", 1, 1 );
		init.plantALoad( 0 );
		init.plantInvokeSpecial( this.super_class_name, "<init>", "()V" );
		init.plantReturn();
	}


	//	---ooOOOooo---



	private void writeConstantPool( final DataSink dios ) {
		try {
			dios.writeShort( this.pool.count() );			//	constant pool count (element 0 is fake, so add 1).
			for ( Iterator it = this.pool.iterator(); it.hasNext(); ) {
				final PoolEntry pe = (PoolEntry)it.next();
				dios.write( pe.toByteArray() );
			}
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
	}

	private void writeIndex( final DataSink dios, final PoolEntry pe ) {
		try {
			dios.writeShort( pe.getIndex() );
		} catch ( final IOException ex ) {
			throw new RuntimeException( ex );
		}
	}

	private void writeAccessFlags( final DataSink dios ) {
		try {
			dios.writeShort( Constants.ACC_FINAL | Constants.ACC_PUBLIC | Constants.ACC_SUPER );		//	ACC_PUBLIC ACC_FINAL ACC_SUPER
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
	}

	private void writeThisClass( final DataSink dios  ) {
		this.writeIndex( dios, this.class_info );
	}

	private void writeSuperClass( final DataSink dios ) {
		this.writeIndex( dios, this.super_class_info );
	}

	private void writeInterfaces( final DataSink dios ) {
		try {
			dios.writeShort( 0 );			//	todo:	just a quick hack
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
	}

	private void writeFields( final DataSink dios ) throws IOException {
		final List fslist = this.field_spec_list;
		dios.writeShort( fslist.size() );
		for ( final Iterator it = fslist.iterator(); it.hasNext(); ) {
			final FieldSpec fs = (FieldSpec)it.next();
			dios.writeShort( fs.getFlags() );
			this.writeIndex( dios, fs.getNamePoolEntry() );
			this.writeIndex( dios, fs.getDescriptorPoolEntry() );
			dios.writeShort( 0 );										//	todo: attributes - quick hack
		}
	}

	private void writeMethods( final DataSink dios ) {
		try {
			dios.writeShort( this.method_spec_list.size() );
			for ( Iterator it = this.method_spec_list.iterator(); it.hasNext(); ) {
				final MethodSpec ms = (MethodSpec)it.next();
//				dios.writeShort( Constants.ACC_PUBLIC );
//				this.writeIndex( dios, ms.getName() );
//				this.writeIndex( dios, ms.getDescriptor() );
//
//				//	----
//				dios.writeShort( 1 );		//	Just the code attribute for the moment
//				this.writeIndex( dios, this.code_pe );
//				final IntMark mark = dios.newIntMark();
//				ms.write( dios );
//				mark.set();
				ms.write( dios );
			}
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
	}

	private void writeAttributes( final DataSink dios ) {
		try {
			dios.writeShort( 0 );				//	todo:	just a quick hack
		} catch ( IOException e ) {
			throw new RuntimeException( e );	//To change body of catch statement use Options | File Templates.
		}
	}

	void write( final DataSink dios ) {
		try {
			dios.writeInt( 0xCAFEBABE );	//	magic
			dios.writeShort( 3 );			//	minor version number
			dios.writeShort( 45 );			//	major version number
			this.writeConstantPool( dios );
			this.writeAccessFlags( dios );
			this.writeThisClass( dios );
			this.writeSuperClass( dios );
			this.writeInterfaces( dios );
			this.writeFields( dios );
			this.writeMethods( dios );
			this.writeAttributes( dios );
		} catch ( final IOException ex ) {
			throw new RuntimeException( ex );
		}
	}

	public Class newClass() {
		final DataSink dsink = new DataSink();
		this.write( dsink );
		final byte[] bytes = dsink.toByteArray();

		final Class answer = class_loader.loadClassFromBytes( this.class_name, bytes );

		//	Now set the deferred values .... should really do this in the class constructor.
		for ( Iterator it = this.runtime_constants.entrySet().iterator(); it.hasNext(); ) {
			final Map.Entry me = (Map.Entry)it.next();
			final String hname = (String)me.getKey();
			final Object init_value = me.getValue();
			try {
				final Field f = answer.getField( hname );
				try {
					f.set( null, init_value );
				} catch ( IllegalAccessException e ) {
					throw new RuntimeException( e );
				}
			} catch ( NoSuchFieldException e ) {
				throw new RuntimeException( e );
			}
		}

		return answer;
	}

	//	I'm not sure why I arranged for sclassname to be passed in - as the super class
	//	name MUST be set up on entry.
//	public final void addDefaultConstructor( final String sclassname ) {
//		final MethodSpec init = this.newInstanceMethodSpec( "<init>", "()V", 1, 1 );
//		init.plantALoad( 0 );
//		init.plantInvokeSpecial( sclassname, "<init>", "()V" );
//		init.plantReturn();
//	}
	public final void addDefaultConstructor() {
		final MethodSpec init = this.newInstanceMethodSpec( "<init>", "()V", 1, 1 );
		init.plantALoad( 0 );
		init.plantInvokeSpecial( this.super_class_name, "<init>", "()V" );
		init.plantReturn();
	}

}
