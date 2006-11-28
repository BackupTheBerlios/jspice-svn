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
package org.openspice.jspice.main;

import java.io.File;
import java.io.IOException;

import jline.Completor;
import jline.ConsoleReader;
import jline.ConsoleReaderInputStream;
import jline.History;
import jline.MultiCompletor;

import org.openspice.jspice.conf.StaticConf;
import org.openspice.jspice.lexis.Prompt;
import org.openspice.jspice.run.jline_stuff.PragmaCompletor;
import org.openspice.jspice.run.jline_stuff.SmartCompletor;

public class MainWithJLine extends Main {

	public MainWithJLine(CmdLineOptions cmd) {
		super(cmd);
	}

	public MainWithJLine(String[] args) {
		super(args);
	}

	protected void interpret() {
		this.init();
		try {
			// Setup the input stream.
			final ConsoleReader reader = new ConsoleReader();
			reader.setHistory( new History( new File( System.getProperty( "user.home" ), ".jline-" + StaticConf.getPropertyName( "history" ) ) ) );
			reader.addCompletor(
				new MultiCompletor(
					new Completor[] {
						new PragmaCompletor( this.jspice_conf ),
						new SmartCompletor( this.interpreter ) 
					}
				)
			);
			final String p = this.getCommandLineOptions().prompt;
			ConsoleReaderInputStream.setIn( reader, p != null ? p : this.jspice_conf.getPrompt() );

			this.interpreter.interpret( new Prompt.StdOutPrompt( "" ) );
			this.shutdown();
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		}
	}
	
}



