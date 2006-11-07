package org.openspice.jspice.alert;

import java.util.Iterator;
import java.util.LinkedList;

class AlertBase {

	private int index = 0;								//	index into list of culprits.
	private LinkedList< Culprit > culprits = new LinkedList< Culprit >();

	protected void add( final Culprit culprit ) {
		this.culprits.add( this.index++, culprit );
	}

	protected Iterator culprit_iterator() {
		return this.culprits.iterator();
	}

	public void resetIndex() {
		this.index = 0;
	}

}
