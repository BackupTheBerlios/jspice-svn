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

public class FieldSpec {

	private final String orig_name;
	private final String orig_descriptor;
	private final PoolEntry name;
	private final PoolEntry descriptor;
	private int flags;

	public FieldSpec( final ConstantPool pool, String name, String descriptor, int flags ) {
		this.orig_name = name;
		this.orig_descriptor = descriptor;
		this.name = pool.newPoolEntry( name );
		this.descriptor = pool.newPoolEntry( descriptor );
		this.flags = flags;
	}

	public FieldSpec( final ConstantPool pool, String name, String descriptor ) {
		this( pool, name, descriptor, Constants.ACC_PUBLIC );
	}

	public PoolEntry getNamePoolEntry() {
		return this.name;
	}

	public PoolEntry getDescriptorPoolEntry() {
		return this.descriptor;
	}

	public String getNameString() {
		return orig_name;
	}

	public String getDescriptorString() {
		return orig_descriptor;
	}

	public int getFlags() {
		return flags;
	}

	public void setFlags( int flags ) {
		this.flags = flags;
	}

}
