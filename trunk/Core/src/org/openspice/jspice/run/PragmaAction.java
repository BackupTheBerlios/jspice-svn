package org.openspice.jspice.run;


public interface PragmaAction {
	void doAction( final Pragma pragma );
	String[] names();
}
