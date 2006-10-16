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

import org.openspice.jspice.alert.Alert;
import org.openspice.jspice.conf.DynamicConf;
import org.openspice.jspice.main.manual.Manual;
import org.openspice.jspice.main.manual.SearchPhrase;
import org.openspice.jspice.main.jline_stuff.PrefixFilterAccumulator;
import org.openspice.jspice.namespace.NameSpaceManager;
import org.openspice.jspice.namespace.NameSpace;

import java.util.*;

public class Pragma {

	Interpreter interpreter;				//	may be null .... for limited use .... a design bug ... todo:
	private final DynamicConf jspice_conf;
	private final String input_string;
	private String command;
	private final List< String > arg_list;

	public Pragma( final DynamicConf jconf, final String input_string ) {
		this.jspice_conf = jconf;
		this.input_string = input_string;
		this.command = null;
		this.arg_list = new ArrayList< String >();
		{
			final StringTokenizer tok = new StringTokenizer( input_string );
			while ( tok.hasMoreTokens() ) {
				if ( this.command == null ) {
					this.command = tok.nextToken();
				} else {
					this.arg_list.add( tok.nextToken() );
				}
			}
		}
	}

	public Pragma( final Interpreter interpreter, final String input_string ) {
		this( interpreter.getDynamicConf(), input_string );
		this.interpreter = interpreter;
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.main.pragmas.PragmaInterface#getDynamicConf()
	 */
	public DynamicConf getDynamicConf() {
		return this.jspice_conf;
	}
	
	public Interpreter getInterpreter() {
		return this.interpreter;
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.main.pragmas.PragmaInterface#getNameSpace()
	 */
	public NameSpace getNameSpace() {
		return this.interpreter.getCurrentNameSpace();
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.main.pragmas.PragmaInterface#getNameSpaceManager()
	 */
	public NameSpaceManager getNameSpaceManager() {
		return this.interpreter.getCurrentNameSpace().getNameSpaceManager();
	}

	public String command() {
		return this.command;
	}

	public String arg( final int n ) {
		try {
			return (String)this.arg_list.get( n );
		} catch ( java.lang.IndexOutOfBoundsException e ) {
			return null;
		}
	}

	public List getArgList() {
		return this.arg_list;
	}

	//	#hXXXXX WHITESPACE [TOPIC]
	private void manualPragma( final Manual manual ) {
		final SearchPhrase t = new SearchPhrase();
		for ( String s : this.arg_list ) {
			t.add( s );
		}
		new ManualPragma().help( manual, t );
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.main.pragmas.PragmaInterface#perform()
	 */
	public void perform() {
		final String c = this.command();
		final PragmaAction a = registered.get( c );
		if ( a != null ) {
			a.doAction( this );
		} else {
			final Manual manual = this.getDynamicConf().getManualByName( c );
			if ( manual != null ) {
				this.manualPragma( manual );
			} else {
				throw new Alert( "Invalid pragma after #" ).culprit( "line", this.input_string ).mishap();
			}
		}
	}
	
	private static Map< String, PragmaAction > registered = new HashMap< String, PragmaAction >(); 
	
	public static void register( final PragmaAction a ) {
		final String[] ns = a.names();
		for ( int i = 0; i < ns.length; i++ ) {
			registered.put( ns[ i ], a );
		}
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.main.pragmas.PragmaInterface#findPragmaCompletions(org.openspice.jspice.main.jline_stuff.PrefixFilterAccumulator)
	 */
	public void findPragmaCompletions( final PrefixFilterAccumulator acc ) {
		for ( String s : registered.keySet() ) {
			acc.add( s );
		}
		this.getDynamicConf().findManualCompletions( acc );
	}
	
}
