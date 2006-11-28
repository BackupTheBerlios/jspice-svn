package org.openspice.jspice.main.pragmas;

import org.openspice.alert.Alert;
import org.openspice.jspice.run.Pragma;
import org.openspice.jspice.run.PragmaAction;
import org.openspice.tools.Print;

public class DebugPragma implements PragmaAction {

	public void doAction( final Pragma pragma ) {
		//	#debug [on|off]

			final String t2 = pragma.arg( 0 );
			boolean is_debugging = pragma.getDynamicConf().isDebugging();
			if ( t2 != null ) {
				if ( "on".equals( t2 ) ) {
					is_debugging = true;
				} else if ( "off".equals( t2 ) ) {
					is_debugging = false;
				} else {
					new Alert( "Unrecognized argument for debug pragma" ).culprit( "arg", t2 ).mishap();
				}
				pragma.getDynamicConf().setIsDebugging( is_debugging );
			}
			Print.println( "debugging is " + ( is_debugging ? "on" : "off" ) );
	}

	public String[] names() {
		return new String[] { "debug" };
	}
	
}
