package org.openspice.jspice.main;


public interface PragmaAction {
	void doAction( final Pragma pragma );
	String[] names();
}
