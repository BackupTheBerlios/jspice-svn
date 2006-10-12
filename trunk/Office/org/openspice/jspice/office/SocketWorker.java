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

import java.net.Socket;
import java.io.*;

public abstract class SocketWorker extends ReaderWriterWorker {

	final Socket socket;

	private static Socket newSocket( final String host, final int port ) {
		try {
			return new Socket( host, port );
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		}
	}

	private static Reader socketReader( final Socket socket ) {
		try {
			return new InputStreamReader( socket.getInputStream() );
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		}
	}

	private static Writer socketWriter( final Socket socket ) {
		try {
			return new OutputStreamWriter( socket.getOutputStream() );
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		}
	}

	public SocketWorker( final Office office, final boolean start_flag, final Socket socket, final boolean buffered ) {
		super( office, start_flag, socketReader( socket ), socketWriter( socket ) );
		this.socket = socket;
		if ( buffered ) {
			this.reader = new BufferedReader( this.reader );
		}
	}

	public SocketWorker( final Office office, final boolean start_flag, final Socket socket ) {
		this( office, start_flag, socket, false );
	}

	public SocketWorker( final Office office, final boolean start_flag, final String host, final int port, final boolean buffered ) {
		this( office, start_flag, newSocket( host, port ), buffered );
	}

	public SocketWorker( final Office office, final boolean start_flag, final String host, final int port ) {
		this( office, start_flag, newSocket( host, port ), false );
	}

	public void handleFinish() {
		try {
			if ( !this.socket.isClosed() ) this.socket.shutdownInput();
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		}
	}

}
