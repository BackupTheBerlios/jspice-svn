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
package org.openspice.jspice.office;

import java.io.Reader;
import java.io.Writer;
import java.io.IOException;
import java.io.BufferedReader;

public abstract class ReaderWriterWorker extends ThreadBasedWorker {

	public abstract Letter readLetterFrom( Reader reader ) throws IOException;
	public abstract void writeLetterTo( Writer writer, Letter letter ) throws IOException;

	Reader reader;
	Writer writer;

	public ReaderWriterWorker( final Office office, final boolean start_flag, final Reader reader, final Writer writer ) {
		super( office, start_flag );
		this.reader = reader;
		this.writer = writer;
	}

	public Reader getReader() {
		return reader;
	}

	public Writer getWriter() {
		return writer;
	}

	public void handleLetter( final Letter letter ) {
		try {
			this.writeLetterTo( this.writer, letter );
			this.writer.flush();
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		}
	}

	public void handleFinish() {
		try {
			this.writer.close();
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		}
	}

	Letter repeat() {
		try {
			return this.readLetterFrom( this.reader );
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		}
	}


	//	---- Mixin overloads ----

	private static final String sep = System.getProperty( "line.separator" );

	protected void lineWriteLetterTo( final Writer writer, final Letter letter ) throws IOException {
		writer.write( letter.get().toString() );
		writer.write( sep );
	}

	protected Letter lineReadLetterFrom( final Reader reader ) throws IOException {
		final String line = ((BufferedReader)reader).readLine();
		if ( line == null ) return null;
		return this.newOutTrayLetter( "line" ).add( line );
	}

}
