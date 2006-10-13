package org.openspice.jspice.alert;

public abstract class ShowCulprit {
	
	public abstract String showToString( final Object x );

	private static ShowCulprit theShowCulprit = (
		new ShowCulprit() {
			public String showToString( final Object x ) {
				return "" + x;
			}		
		}
	);
	
	public static ShowCulprit getShowCulprit() {
		return theShowCulprit;
	}
	
	private static ShowCulprit thePrintCulprit = (
		new ShowCulprit() {
			public String showToString( final Object x ) {
				return "" + x;
			}		
		}
	);
	
	public static ShowCulprit getPrintCulprit() {
		return thePrintCulprit;
	}
	
	
}
