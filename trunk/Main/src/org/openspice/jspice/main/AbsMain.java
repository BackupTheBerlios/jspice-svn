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

import org.openspice.jspice.main.conf.AppDynamicConf;
import org.openspice.jspice.main.pragmas.RegisterPragmas;
import org.openspice.jspice.run.Pragma;
import org.openspice.jspice.run.WorldThread;
import org.openspice.jspice.tools.Hooks;

public abstract class AbsMain extends WorldThread {
	
	private final CmdLineOptions commandLineOptions;
	
	public AbsMain( final CmdLineOptions cmd ) {
		this.commandLineOptions = cmd;
	}
	
	public AbsMain( final String[] args ) {
		final CmdLineOptions cmd = new CmdLineOptions();
		cmd.process( args );
		this.commandLineOptions = cmd;
	}
	
	
	
	public CmdLineOptions getCommandLineOptions() {
		return this.commandLineOptions;
	}

	abstract void init();
	abstract void interpret();
	
	protected void shutdown() {
		Hooks.SHUTDOWN.ping();
	}
	

	public final void run() {
		if ( this.getCommandLineOptions().version ) {
			StartVersion.printVersion( "JSpice Version %p.%p.%p" );
		} else if ( this.getCommandLineOptions().help ) {
			new Pragma( new AppDynamicConf(), "help jspice" ).perform();
		} else {
			this.startUp();
		}
	}

	final void startUp() {
		this.init();
		this.interpret();
		this.shutdown();
	}
	
	static {
		//	Bind all pragmas.
		RegisterPragmas.register();
	}

}
