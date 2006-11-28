/**
 *	JSpice, n Open Spice interpreter and library.
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
package org.openspice.jspice.run;

import org.openspice.alert.AlertException;
import org.openspice.jspice.conf.DynamicConf;
import org.openspice.jspice.vm_and_compiler.VM;
import org.openspice.jspice.namespace.NameSpaceManager;
import org.openspice.jspice.namespace.NameSpace;
import org.openspice.jspice.namespace.FacetSet;
import org.openspice.jspice.namespace.Var;
import org.openspice.jspice.tools.SysAlert;
import org.openspice.jspice.loader.LoaderBuilder;
import org.openspice.jspice.loader.Accumulator;
import org.openspice.jspice.loader.ValueLoaderBuilder;
import org.openspice.tools.Print;
import org.openspice.vfs.VItem;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

/**
 * The purpose of this class is to generate interpreters for all
 * the different languages/formats.
 */
public final class SuperLoader {

	final DynamicConf dyn_conf;
	final NameSpaceManager name_space_manager;
	VM vm;

	public SuperLoader( final DynamicConf _jconf ) {
		this.dyn_conf = _jconf;
		this.name_space_manager = new NameSpaceManager( this );
		this.vm = new VM( _jconf );
	}

	public DynamicConf getDynamicConf() {
		return this.dyn_conf;
	}

	public NameSpaceManager getNameSpaceManager() {
		return this.name_space_manager;
	}

	public NameSpace getNameSpace( final String name ) {
		return this.name_space_manager.get( name );
	}

	public VM getVM() {
		return this.vm;
	}

	public void setVM( final VM _vm ) {
		this.vm = _vm;
	}

	public final String getExtension( final File file ) {
		final char ch = this.dyn_conf.getExtensionChar( file );
		final String fname = file.getName();
		final int whereDot = fname.lastIndexOf( ch );
		if ( 0 < whereDot && whereDot <= fname.length() - 2 ) {
			return fname.substring( whereDot + 1 );
		} else {
			return "";
		}
	}

	public String getNameWithoutExtension( final File file ) {
		final char ch = this.dyn_conf.getExtensionChar( file );
		final String fname = file.getName();
		final int whereDot = fname.lastIndexOf( ch );
		if ( 0 < whereDot && whereDot <= fname.length() - 2 ) {
			return fname.substring( 0, whereDot );
		} else {
			return fname;
		}
	}

	private AlertException failToLoad( final Exception exn, final String loader_builder_class_name  ) {
		return new SysAlert( exn, "Cannot construct loader" ).culprit( "class name", loader_builder_class_name ).mishap();
	}

	private LoaderBuilder newLoaderBuilder( final String loader_builder_class_name ) {
		try {
			final Class loader_builder_class = Class.forName( loader_builder_class_name );
			final Constructor con = loader_builder_class.getConstructor( new Class[] {} );
			return ((LoaderBuilder)con.newInstance( new Object[] {} )).init( this.getDynamicConf() );
		} catch ( ClassNotFoundException e ) {
			throw failToLoad( e, loader_builder_class_name );
		} catch ( NoSuchMethodException e ) {
			throw failToLoad( e, loader_builder_class_name );
		} catch ( SecurityException e ) {
			throw  failToLoad( e, loader_builder_class_name );
		} catch ( InstantiationException e ) {
			throw  failToLoad( e, loader_builder_class_name );
		} catch ( IllegalAccessException e ) {
			throw  failToLoad( e, loader_builder_class_name );
		} catch ( IllegalArgumentException e ) {
			throw  failToLoad( e, loader_builder_class_name );
		} catch ( InvocationTargetException e ) {
			throw  failToLoad( e, loader_builder_class_name );
		}
	}

	private LoaderBuilder findLoaderBuilder( final VItem file ) {
		final String extn = file.getExt();
		final String loader_builder_class_name = this.dyn_conf.getLoaderBuilderClassName( extn, false );
		final LoaderBuilder loader_builder = this.newLoaderBuilder( loader_builder_class_name );
		return loader_builder;
	}

	public void autoloadFileAsNamedValue( final VItem file, final NameSpace current_ns, final Accumulator accumulator ) {
		final LoaderBuilder loader_builder = this.findLoaderBuilder( file );
		final String name = file.getNam();
		accumulator.add(
			name,
			loader_builder.newLoader( current_ns ).autoloadFileForValue( name, file )
		);
	}

	public void autoloadFile( final VItem file, final NameSpace current_ns, final Var.Perm perm, final FacetSet facets ) {
		final LoaderBuilder loader_builder = this.findLoaderBuilder( file );
		loader_builder.newLoader( current_ns ).autoloadVItem( file, perm, facets );
	}

	public void loadFile( final VItem file, final NameSpace current_ns ) {
		final LoaderBuilder loader_builder = this.findLoaderBuilder( file );
		loader_builder.newLoader( current_ns ).loadVItem( file );
	}

	public Object loadValueFromVItem( final VItem file ) {
		final LoaderBuilder loader_builder = this.findLoaderBuilder( file );
		if ( loader_builder instanceof ValueLoaderBuilder ) {
			try {
				return ((ValueLoaderBuilder)loader_builder).loadValueFromVItem( file );
			} catch ( IOException e ) {
				throw new RuntimeException( e );
			}
		} else {
			throw new SysAlert( "Cannot load this file" ).culprit( "file", file ).mishap();
		}
	}

	public boolean couldLoadVItem( final VItem file ) {
		final String extn = file.getExt();
		Print.println( Print.AUTOLOAD, "extension: " + extn );
		return this.dyn_conf.getLoaderBuilderClassName( extn, true ) != null;
	}

}
