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

public class PushableReader extends Reader {

	final Reader reader;
	final StringBuffer buffer = new StringBuffer();

	public PushableReader( Reader reader ) {
		this.reader = reader;
	}

	public int peek( final int i ) throws IOException {
		final int n = this.buffer.length();
		if ( i < n ) {
			return this.buffer.charAt( i );
		} else {
			while ( i >= this.buffer.length() ) {
				final int ich = this.reader.read();
				if ( ich == -1 ) return -1;
				this.buffer.append( (char)ich );
			}
			return this.buffer.charAt( i );
		}
	}

	public boolean matches( final char[] separator ) {
		for ( int i = 0; i < separator.length; i++ ) {
			try {
				if ( this.peek( i ) != separator[ i ] ) return false;
			} catch ( IOException e ) {
				throw new RuntimeException( e );
			}
		}
		return true;
	}

//	public int length() {
//		for ( int i = 0; true; i++ ) {
//			try {
//				if ( this.peek( i ) == -1 ) return i;
//			} catch ( IOException e ) {
//				throw new RuntimeException( e );
//			}
//		}
//	}
//
//	public char charAt( int i ) {
//		final int ich;
//		try {
//			ich = this.peek( i );
//		} catch ( IOException e ) {
//			throw new RuntimeException( e );
//		}
//		if ( ich == -1 ) throw new IndexOutOfBoundsException();
//		return (char)ich;
//	}
//
//	public CharSequence subSequence( int i, int i1 ) {
//		try {
//			final int ich = this.peek( i1 - 1 );
//			return this.buffer.subSequence( i, i1 );
//		} catch ( IOException e ) {
//			throw new RuntimeException( e );
//		}
//	}

	public void pushback( final char ch ) {
		this.buffer.append( ch );
	}

	public void pushback( final char[] chars ) {
		this.buffer.append( chars );
	}

	public void pushback( final String s ) {
		this.buffer.append( s );
	}

	public int read( final char[] cbuf, final int offset, final int length ) throws IOException {
		//	Transfer as many chars from the buffer as possible.
		final int n = Math.min( length, buffer.length() );
		if ( n > 0 ) {				//	efficiency
			for ( int i = 0; i < n; i++ ) {
				cbuf[ offset + i ] = buffer.charAt( i );
			}
			this.buffer.delete( 0, n );
		}

		//
		//	The following examples is theorectically redundant.  However, I worry about the
		//	standard of coding in the Java libraries.  Perhaps programmers haven't
		//	considered the case when the length parameter is less than or equal to zero?
		//	We'll do that for them.
		//
		if ( n >= length ) {		//	defensive, == would be enough.
			return n;				//	efficient and protects against 0-length coding errors.
		} else {
			//	Note that n is guaranteed to be positive and less than length.
			return this.reader.read( cbuf, offset + n, length - n );
		}
	}

	public void close() throws IOException {
		this.reader.close();
	}

	public int read() throws IOException {
		//	Just read a single character - important to make this efficient.
		if ( this.buffer.length() == 0 ) {
			return this.reader.read();
		} else {
			final char ch = this.buffer.charAt( 0 );
			this.buffer.delete( 0, 1 );
			return ch;
		}
	}



}
