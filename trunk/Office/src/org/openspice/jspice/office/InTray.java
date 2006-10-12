/**
 *	JSpice, an Open Spice interpreter and library.
 *	Copyright (C) 2005, Stephen F. K. Leach
 *
 * 	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 * 	the Free Software Foundation; either version 2 of the License, or
 * 	(at your option) any later version.
 *
 * 	This program is distributed in the hope that it will be useful,
 * 	but WITHOUT ANY WARRANTY; without even the implied warranty of
 * 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 * 	along with this program; if not, write to the Free Software
 *	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
package org.openspice.jspice.office;

public abstract class InTray extends TrayImpl implements InTrayIntf {

	public InTray( final Worker worker ) {
		super( worker );
	}

	protected InTray( final Office office ) {
		super( office );
	}

	//	--- CLOSURE ---

	protected void stageOneMain() {
		final Worker w = this.tryGetOwner();
		if ( w != null ) w.finishStageOne();
//		System.err.println( "Sending the dismissal letter!" );		//	todo: instrumentation
		this.sendOne( Letter.DISMISSAL_LETTER );		//	 This triggers stage two.
	}

	protected void stageTwoMain() {
		final Worker w = this.tryGetOwner();
		if ( w != null ) w.finishStageTwo();
	}

	//	--- NOTIFICATIONS ---

	public void noteWasConnected() {
		final Worker w = this.tryGetOwner();
		if ( w != null ) w.noteInTrayConnected();
	}

	public void noteWasDisconnected() {
		final Worker w = this.tryGetOwner();
		if ( w != null ) w.noteInTrayDisconnected();
	}

	public void noteNoLongerConnected() {
		final Worker w = this.tryGetOwner();
		if ( w != null ) w.noteInTrayNoLongerConnected();
	}

}
