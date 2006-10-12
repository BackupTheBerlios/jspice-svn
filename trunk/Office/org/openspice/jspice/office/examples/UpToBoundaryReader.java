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
package org.openspice.jspice.office.examples;

import java.io.Reader;
import java.io.IOException;

public class UpToBoundaryReader extends Reader {

	final PushableReader reader;
	final char[] boundary;
	boolean have_read_some = false;

	public UpToBoundaryReader( final PushableReader reader, final String boundary ) {
		this.reader = reader;
		this.boundary = boundary.toCharArray();
	}

	public String readAll() {
//		System.err.println( "readAll" );
		final StringBuffer buffer = new StringBuffer();
		for (;;) {
			final int ich;
			try {
				ich = this.read();
			} catch ( IOException e ) {
				throw new RuntimeException( e );
			}
			if ( ich == -1 ) return buffer.toString();
			buffer.append( (char)ich );
		}
	}

	public int read() throws IOException {
		final boolean some = this.have_read_some;
		this.have_read_some = true;
		if ( some && this.reader.matches( this.boundary ) ) {
			return -1;
		}
		return this.reader.read();
	}

	public int read( char[] cbuf, int off, int len ) throws IOException {
		for ( int i = 0; i < len; i++ ) {
			final int ich = this.read();
			if ( ich == -1 ) return i <= 0 ? -1 : i;	//	defensive
			cbuf[ off + i ] = (char)ich;
		}
		return len;
	}

	public void close() throws IOException {
		this.reader.close();
	}



}
