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
 * The Tray interface supports the arrival of letters.  Both {@link InTray} and {@link OutTray}
 * share the fundamental ability to be sent {@link Letter}s.
 */
public interface Tray {

	public void sendOne( Letter letter );
	public void sendMany( Collection letterList );
	public void close();
	public boolean isOpen();
	public boolean isClosed();
	public Office getOffice();
	public Worker tryGetOwner();

	void notifyConnected( final int n );
	public void noteWasConnected();
	public void noteWasDisconnected();
	public void noteNoLongerConnected();

	/**
	 * Creates a new {@link Letter} with this TrayImpl as the originator and the
	 * dst Letter as the destination or recipient.  (Unusually the destination
	 * may be null as explained in the main package.)
	 * @param dst the recipient
	 * @param subject the subject of the new letter
	 * @return the new Letter
	 */
	public Letter newLetterTo( Tray dst, final String subject );

	/**
	 * Creates a new {@link Letter} with this TrayImpl as the originator and the
	 * in-tray of the {@link Worker} dst as the destination or recipient.
	 * @param dst the recipient
	 * @param subject the subject of the new letter
	 * @return the new Letter
	 */
	public Letter newLetterTo( final Worker dst, final String subject ) ;

	/**
	 * Creates a new letter with this TrayImpl as the originator and recipient
	 * set to the originator of the {@link Letter} letter.
	 * @param letter the letter used to specify the recipient
	 * @param subject the subject of the new letter
	 * @return the new letter
	 */
	public Letter newReplyTo( final Letter letter, final String subject );

}
