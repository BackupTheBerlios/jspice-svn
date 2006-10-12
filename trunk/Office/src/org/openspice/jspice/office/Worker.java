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

import java.util.*;

/**
 * <p>
 * The Worker class is responsible for encapsulating the processing of {@link Letter}s.
 * Each worker has a single {@link InTray} for receiving Letters and is effectively
 * identified by it.  Different types of workers react quite differently to incoming
 * mail, however.
 * <p>
 * In contrast, workers can have as many {@link OutTray}s as they wish.  These are
 * less significant, being used for managing "static" connections.
 */
public abstract class Worker extends TwoStageFinish implements WorkerIntf {

	//	---oooOOOooo--- Owning Office ---oooOOOooo---

	protected Office office;

	protected Worker( final Office office ) {
		this.office = office;
	}

	public Office getOffice() {
		return this.office;
	}


	//	---ooOOOooo--- In and Out Trays ---oooOOOooo---

	protected InTray inTray;
	protected LinkedList outTrayList = new LinkedList();


	public InTray getInTray() {
		return this.inTray;
	}

	public OutTray getOutTray() {
		if ( this.outTrayList.isEmpty() ) {
			this.outTrayList.add( new OutTray( this ) );
		}
		return (OutTray)this.outTrayList.getFirst();
	}

	public List allOutTray() {
		return new ArrayList( this.outTrayList );
	}

	public OutTray findByName( String name ) {
		name = name.intern();
		for ( Iterator it = this.outTrayList.iterator(); it.hasNext(); ) {
			final OutTray outTray = (OutTray)it.next();
			final String s = outTray.getName();
			if ( name == s ) return outTray;
		}
		return null;
	}

	public OutTray newOutTray( String name ) {
		name = name.intern();
		final OutTray outTray = new OutTray( this );
		outTray.setName( name );
		this.outTrayList.add( outTray );
		return outTray;
	}

	public void connectTo( final Worker dst ) {
		this.getOutTray().connectTo( dst.inTray );
	}

	public void connectTo( final Tray tray ) {
		this.getOutTray().connectTo( tray );
	}

	public void disconnectFrom( final Worker dst ) {
		this.getOutTray().disconnectFrom( dst.inTray );
	}

	public void disconnectFrom( final Tray tray ) {
		this.getOutTray().disconnectFrom( tray );
	}

	//	---ooOOOooo--- Name and Role ---oooOOOooo---

	private String name;
	private String role;

	public String getName() {
		return name;
	}

	public void setName( String name ) {
		this.name = name;
	}

	public String getRole() {
		return role;
	}

	public void setRole( String role ) {
		this.role = role;
	}


	//	---ooOOOooo--- Creating Letters ---oooOOOooo---

	public Letter newOutTrayLetter( final OutTray to, final Object subject ) {
		return new Letter( this.getInTray(), to, subject );
	}

	public Letter newOutTrayLetter( final Object subject ) {
		return new Letter( this.getInTray(), this.getOutTray(), subject );
	}

	public Letter newReplyTo( final Letter letter, final Object subject ) {
		return new Letter( this.getInTray(), letter.getFrom(), subject );
	}

	public Letter newLetterTo( final Worker to, final Object subject ) {
		return new Letter( this.getInTray(), to.getInTray(), subject );
	}

	public Letter newLetterToSelf( final Object subject ) {
		return new Letter( null, this.getInTray(), subject );
	}

	//	---oooOOOooo--- LifeCycle and Callbacks  ---oooOOOooo---

	public void finishOff() {
		this.inTray.finishStageOne();
	}

	protected void stageOneMain() {
		//	Skip.
	}

	protected void closeOutTrays() {
		//	Close all out-trays.
		for ( Iterator it = this.outTrayList.iterator(); it.hasNext(); ) {
			final OutTray outTray = (OutTray)it.next();
			outTray.finishStageTwo();
		}
	}

	//  ---- Finish Off on Last Disconnect ----

	protected void noteInTrayConnected() {}

	protected void noteInTrayDisconnected() {}

	protected boolean finishOffOnLastDisconnect = false;

	public boolean isFinishOffOnLastDisconnect() {
		return finishOffOnLastDisconnect;
	}

	public void setFinishOffOnLastDisconnect( boolean finishOffOnLastDisconnect ) {
		this.finishOffOnLastDisconnect = finishOffOnLastDisconnect;
	}

	public Worker finishOffOnLastDisconnect() {
		this.finishOffOnLastDisconnect = true;
		return this;
	}

	protected void noteInTrayNoLongerConnected() {
		if ( this.finishOffOnLastDisconnect ) {
			this.finishOff();
		}
	}



}
