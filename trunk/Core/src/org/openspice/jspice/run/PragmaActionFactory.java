package org.openspice.jspice.run;

public abstract class PragmaActionFactory {

	public abstract PragmaAction newInstance( final Pragma pragma, final String command );
	
}
