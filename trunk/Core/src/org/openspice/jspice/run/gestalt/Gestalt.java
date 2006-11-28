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
package org.openspice.jspice.run.gestalt;

import org.openspice.jspice.tools.PrintTools;
import org.openspice.jspice.conf.JSpiceGestaltVersion;

import java.util.List;
import java.util.ArrayList;

public class Gestalt {

	public static abstract class GestaltVersion {

		public abstract String title();

		public abstract String version();

		public String comment() {
			return null;
		}

		public String format( final String control ) {
			final String c = this.comment();
			final Object[] args = new Object[] { this.title(), this.version(), ( c == null ? "" : ( "(" + c + ")" ) ) };
			return PrintTools.formatToString( control, args );
		}

	}

	public static abstract class MultiPartGestaltVersion extends GestaltVersion {

		public abstract int[] parts();

		public int getMajorVersion() {
			return this.parts()[ 0 ];
		}

		public int getMinorVersion() {
			return this.parts()[ 1 ];
		}

		public int getIncrementalVersion() {
			return this.parts()[ 2 ];
		}

		protected Object[] partsAsIntegers() {
			final int[] p = this.parts();
			final int n = p.length;
			final Object[] args = new Object[ n ];
			for ( int i = 0; i < n; i++ ) {
				args[ i ] = new Integer( p[ i ] );
			}
			return args;
		}

		public String formatVersion( final String control ) {
			return PrintTools.formatToString( control, this.partsAsIntegers() );
		}

		public String version() {
			return this.formatVersion( "%p.%p.%p" );
		}

	}

	//	List< Version >
	public static final List< GestaltVersion > versions() {
		final List< GestaltVersion > list = new ArrayList< GestaltVersion >();
		list.add( JSpiceGestaltVersion.VERSION );
		list.add( JettyGestaltVersion.VERSION );
		list.add( BFIGestaltVersion.VERSION );
		list.add( JLineGestaltVersion.VERSION );
		list.add( TADS2GestaltVersion.VERSION );
		list.add( JVMGestaltVersion.VERSION );
		return list;
	}

}
