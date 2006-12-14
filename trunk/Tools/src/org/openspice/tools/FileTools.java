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
package org.openspice.tools;

import java.io.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;

public final class FileTools {
	
	public static void close( final Reader r ) {
		try {
			if ( r != null ) r.close();
		} catch ( IOException _ ) {
			//	do nothing.
		}
	}

	public static final String fileAsString( final File file ) {
		Reader rdr = null;
		try {
			final StringBuffer b = new StringBuffer();
			rdr = new FileReader( file );
			final char[] cbuff = new char[ 1024 ];		//	just a random guess.
			for (;;) {
				final int n = rdr.read( cbuff );
				if ( n < 0 ) break;						//	defensive.
				b.append( cbuff, 0, n );
			}
			return b.toString();
		} catch ( final FileNotFoundException ex ) {
			throw new RuntimeException( ex );
		} catch ( final IOException ex ) {
			throw new RuntimeException( ex );
		} finally {
			FileTools.close( rdr );
		}
	}
	
	public static final List fileAsCSV( final File file, final String regexp_delimiter ) {
		BufferedReader r = null;
		try {
			r = new BufferedReader( new FileReader( file ) );
			final List< List< String > > list = new ArrayList< List< String > >();
			for(;;) {
				final String s = r.readLine();
				if ( s == null ) break;
				list.add( Arrays.asList( s.split( regexp_delimiter ) ) );
			}
			return list;
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		} finally {
			close( r );
		}
	}

	
}
