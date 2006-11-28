package org.openspice.jspice.main.pragmas;

import org.openspice.jspice.run.Pragma;
import org.openspice.jspice.run.PragmaAction;

public class QuitPragmaAction implements PragmaAction {

	public void doAction(Pragma pragma) {
		System.exit( 0 );
	}

	public String[] names() {
		return new String[] { "quit", "exit" };
	}

}
