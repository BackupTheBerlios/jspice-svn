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

import org.openspice.jspice.conf.StaticConf;

public abstract class NameGenerator {

	//	--- Internal names ---

	private static final String dynld_pname = StaticConf.package_root + ".dynld";



	public static final String getDynPackagePrefix() {
		return dynld_pname;
	}

	private static int name_counter = 0;

	public static String getNewDynPackageName() {
		return getDynPackagePrefix() + "class" + name_counter++;
	}

	public static String getNewFieldName() {
		return "field" + name_counter++;
	}

	public static final String getHiddenStaticName() {
		return "__hidden__static__" + name_counter++;
	}

}
