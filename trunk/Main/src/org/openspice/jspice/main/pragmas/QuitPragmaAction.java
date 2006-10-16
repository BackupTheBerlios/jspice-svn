package org.openspice.jspice.main.pragmas;

import org.openspice.jspice.main.Pragma;
import org.openspice.jspice.main.PragmaAction;

public class QuitPragmaAction implements PragmaAction {

	public void doAction(Pragma pragma) {
		System.exit( 0 );
	}

	public String[] names() {
		return new String[] { "quit", "exit" };
	}

}
