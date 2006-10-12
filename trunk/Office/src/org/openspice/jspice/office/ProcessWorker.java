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

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.BufferedReader;

public abstract class ProcessWorker extends ReaderWriterWorker {

	final Process process;

	protected ProcessWorker( final Office office, final boolean start_flag, final Process process, final boolean buffered ) {
		super( office, start_flag, new InputStreamReader( process.getInputStream() ), new OutputStreamWriter( process.getOutputStream() ) );
		this.process = process;
		if ( buffered ) {
			this.reader = new BufferedReader( this.reader );
		}
	}

	protected ProcessWorker( final Office office, final Process process ) {
		this( office, false, process, true );
	}


	private static Process exec( final String[] args ) {
		try {
			return Runtime.getRuntime().exec( args );
		} catch ( final IOException e ) {
			throw new RuntimeException( e );
		}
	}

	public ProcessWorker( final Office office, final boolean start_flag, final String[] args, final boolean buffered ) {
		this( office, start_flag, exec( args ), buffered );
	}

	public ProcessWorker( final Office office, final boolean start_flag, final String[] args ) {
		this( office, start_flag, args, false );
	}

	public Process getProcess() {
		return this.process;
	}

}
