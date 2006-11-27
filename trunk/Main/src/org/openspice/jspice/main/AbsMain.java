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
import org.openspice.jspice.tools.Hooks;

public abstract class AbsMain {
	
	abstract void init( CmdLineOptions cmd );
	abstract void interpret( CmdLineOptions cmd );
	
	protected void shutdown() {
		Hooks.SHUTDOWN.ping();
	}

	public final void perform( final String[] args ) {
		final CmdLineOptions cmd = new CmdLineOptions();
		cmd.process( args );
		this.perform( cmd );
	}

	public final void perform( final CmdLineOptions cmd ) {
		if ( cmd.version ) {
			StartVersion.printVersion( "JSpice Version %p.%p.%p" );
		} else if ( cmd.help ) {
			new Pragma( new AppDynamicConf(), "help jspice" ).perform();
		} else {
			this.startUp( cmd );
		}
	}

	final void startUp( final CmdLineOptions cmd ) {
		this.init( cmd );
		this.interpret( cmd );
		this.shutdown();
	}
	
	static {
		//	Bind all pragmas.
		RegisterPragmas.register();
	}

}
