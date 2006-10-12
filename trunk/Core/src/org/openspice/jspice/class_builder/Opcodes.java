/**
 *	JSpice, an Open Spice interpreter and library.
 *	Copyright (C) 2005, Stephen F. K. Leach
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

public interface Opcodes {

	int LDC = 0x12;
	int GETFIELD = 0xb4;
	int CHECKCAST = 0xc0;
	int DUP = 0x59;
	int GETSTATIC = 0xb2;
	int SIPUSH = 0x11;
	int ACONST_NULL = 0x1;
	int BIPUSH = 0x10;
	int ICONST_0 = 0x03;
	int INVOKE_SPECIAL = 0xb7;
	int INVOKE_STATIC = 0xb8;
	int INVOKE_VIRTUAL = 0xb6;
	int ISTORE_0 = 0x3b;
	int ISTORE = 0x36;
	int PUTFIELD = 0xb5;
	int RETURN = 0xb1;
	int NEW = 0xbb;
	int ALOAD = 0x2a;
	int ASTORE_0 = 0x4b;
	int ASTORE = 0x3a;
	
}
