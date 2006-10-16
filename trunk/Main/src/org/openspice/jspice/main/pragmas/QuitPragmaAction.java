package org.openspice.jspice.main.pragmas;

public class QuitPragmaAction implements PragmaAction {

	public void doAction(Pragma pragma) {
		System.exit( 0 );
	}

	public String[] names() {
		return new String[] { "quit", "exit" };
	}

}
