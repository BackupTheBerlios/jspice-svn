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
import java.io.IOException;
import java.io.Writer;

public class LineProcessWorker extends ProcessWorker {

	public LineProcessWorker( final Office office, final Process process ) {
		super( office, true, process, true );
	}

	public LineProcessWorker( final Office office, final String[] args ) {
		super( office, true, args, true );
	}

	public Letter readLetterFrom( final Reader reader ) throws IOException {
		return this.lineReadLetterFrom( reader );
	}


	public void writeLetterTo( final Writer writer, final Letter letter ) throws IOException {
		this.lineWriteLetterTo( writer, letter );
	}


}
