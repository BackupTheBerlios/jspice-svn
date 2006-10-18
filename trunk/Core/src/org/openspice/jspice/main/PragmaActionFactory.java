package org.openspice.jspice.main;

public abstract class PragmaActionFactory {

	public abstract PragmaAction newInstance( final Pragma pragma, final String command );
	
}
