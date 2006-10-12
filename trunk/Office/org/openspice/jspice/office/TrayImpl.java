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

import java.util.Collection;

/**
 * The TrayImpl class implements the {@link Tray} interface.
 */
public abstract class TrayImpl extends TwoStageFinish implements Tray {

	public abstract void sendOne( Letter letter );
	public abstract void sendMany( Collection letters );

	//	---- State ----

	private Office office;
	private Worker owner;

	protected TrayImpl( final Worker worker ) {
		assert worker != null;
		this.office = worker.getOffice();
		this.owner = worker;
	}

	protected TrayImpl( final Office office ) {
		this.office = office;
		this.owner = null;
	}

	/**
	 * Returns the office to which the TrayImpl belongs
	 * @return its office
	 */
	public final Office getOffice() {
		return office;
	}

	/**
	 * Returns the {@link Worker} that owns this TrayImpl or null
	 * if the tray has no owner.
	 * @return the owner
	 */
	public Worker tryGetOwner() {
		return this.owner;
	}



	//	---- Letters ----


	/**
	 * Creates a new {@link Letter} with this TrayImpl as the originator and the
	 * dst Letter as the destination or recipient.  (Unusually the destination
	 * may be null as explained in the main package.)
	 * @param dst the recipient
	 * @param subject the subject of the new letter
	 * @return the new Letter
	 */
	public final Letter newLetterTo( Tray dst, final String subject ) {
		return new Letter( this, dst, subject );
	}

	/**
	 * Creates a new {@link Letter} with this TrayImpl as the originator and the
	 * in-tray of the {@link Worker} dst as the destination or recipient.
	 * @param dst the recipient
	 * @param subject the subject of the new letter
	 * @return the new Letter
	 */
	public final Letter newLetterTo( final Worker dst, final String subject ) {
		return new Letter( this, dst.getInTray(), subject );
	}

	/**
	 * Creates a new letter with this TrayImpl as the originator and recipient
	 * set to the originator of the {@link Letter} letter.
	 * @param letter the letter used to specify the recipient
	 * @param subject the subject of the new letter
	 * @return the new letter
	 */
	public final Letter newReplyTo( final Letter letter, final String subject ) {
		return new Letter( this, letter.getFrom(), subject );
	}

	//  --- CLOSURE ---

	/**
	 * Returns true if this TrayImpl is still accepting Letters.
	 * @return true if accepting letters
	 */
	public final boolean isOpen() {
		return this.isActive();
	}

	/**
	 * Returns true if this TrayImpl is no longer accepting letters.
	 * @return true if no longer accepting letters.
	 */
	public final boolean isClosed() {
		return !this.isActive();
	}

	/**
	 * Initiates the tear-down process.  Immediately after this
	 * call the TrayImpl will no longer accept any messages.  However
	 * the actual closure of the TrayImpl may be delayed an arbitrarily
	 * long time.
	 */
	public void close() {
		this.finishStageOne();
	}


	//	--- SUBSCRIPTION NOTIFICATION ---

	/**
	 * The reference count of the number of connections of which
	 * this tray is an end-point.
	 */
	protected int subscriptionCount = 0;

	/**
	 * Used to increase or decrease the reference count.
	 * @param n the change in the reference count
	 */
	final public void notifyConnected( final int n ) {
		this.subscriptionCount += n;
		if ( n > 0 ) {
			this.noteWasConnected();
		} else if ( n < 0 ) {
			this.noteWasDisconnected();
		}
		if ( this.subscriptionCount <= 0 ) {
			this.noteNoLongerConnected();
		}
	}

	public void noteWasConnected() {}

	public void noteWasDisconnected() {}

	public void noteNoLongerConnected() {}

}
