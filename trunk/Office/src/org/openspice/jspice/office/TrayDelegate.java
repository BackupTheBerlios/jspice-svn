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

public class TrayDelegate implements Tray {

	final Tray trayDelegate;

	public TrayDelegate( Tray trayDelegate ) {
		this.trayDelegate = trayDelegate;
	}

	public void sendOne( Letter letter ) {
		trayDelegate.sendOne( letter );
	}

	public void sendMany( Collection letters ) {
		trayDelegate.sendMany( letters );
	}

	public Office getOffice() {
		return trayDelegate.getOffice();
	}

	public Worker tryGetOwner() {
		return trayDelegate.tryGetOwner();
	}

	public Letter newLetterTo( Tray dst, final String subject ) {
		return trayDelegate.newLetterTo( dst, subject );
	}

	public Letter newLetterTo( final Worker dst, final String subject ) {
		return trayDelegate.newLetterTo( dst, subject );
	}

	public Letter newReplyTo( final Letter letter, final String subject ) {
		return trayDelegate.newReplyTo( letter, subject );
	}

	public boolean isOpen() {
		return trayDelegate.isOpen();
	}

	public boolean isClosed() {
		return trayDelegate.isClosed();
	}

	public void close() {
		trayDelegate.close();
	}

	public void notifyConnected( final int n ) {
		trayDelegate.notifyConnected( n );
	}

	public void noteWasConnected() {
		trayDelegate.noteWasConnected();
	}

	public void noteWasDisconnected() {
		trayDelegate.noteWasDisconnected();
	}

	public void noteNoLongerConnected() {
		trayDelegate.noteNoLongerConnected();
	}

//	public void stageOneMain() {
//		trayDelegate.stageOneMain();
//	}
//
//	public void stageTwoMain() {
//		trayDelegate.stageTwoMain();
//	}
//
//	public void finishStageOne() {
//		trayDelegate.finishStageOne();
//	}
//
//	public void finishStageTwo() {
//		trayDelegate.finishStageTwo();
//	}
//
//	public boolean isFinished() {
//		return trayDelegate.isFinished();
//	}
//
//	public boolean isFinishing() {
//		return trayDelegate.isFinishing();
//	}
//
//	public boolean isActive() {
//		return trayDelegate.isActive();
//	}

}
