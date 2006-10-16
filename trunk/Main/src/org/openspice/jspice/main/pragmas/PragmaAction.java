package org.openspice.jspice.main.pragmas;

public interface PragmaAction {
	void doAction( final Pragma pragma );
	String[] names();
}
