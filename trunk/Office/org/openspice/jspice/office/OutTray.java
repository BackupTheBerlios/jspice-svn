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

import java.util.Set;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Collection;

public class OutTray extends TrayImpl implements OutTrayIntf {

	String name = "";

	public OutTray( final Office office ) {
		super( office );
	}

	public OutTray( final Worker worker) {
		super( worker );
	}

	public String getName() {
		return name;
	}

	public void setName( final String name ) {
		this.name = name;
	}

	public final synchronized void sendOne( final Letter letter ) {
		if ( this.isOpen() ) this.forwardOne( letter );
	}

	//	Collection< Letter >
	public final synchronized void sendMany( final Collection letters ) {
		if ( this.isOpen() ) this.forwardMany( letters );
	}

	//	Set< TrayImpl >
	Set subscribers = new HashSet();

	public synchronized void connectTo( final Tray abs ) {
		if ( this.isOpen() ) {
			this.subscribers.add( abs );
			abs.notifyConnected( 1 );
		}
	}

	public synchronized void disconnectFrom( final Tray abs ) {
		this.subscribers.remove( abs );
	}

	final synchronized void forwardOne( final Letter x ) {
		if ( this.isClosed() ) return;
		for ( Iterator it = subscribers.iterator(); it.hasNext(); ) {
			final Tray lbox = (Tray)it.next();
			if ( lbox.isClosed() ) {
				it.remove();
			} else {
				lbox.sendOne( x );
			}
		}
	}

	//	Collection< Letter >
	final synchronized void forwardMany( final Collection x ) {
		if ( this.isClosed() ) return;
		for ( Iterator it = subscribers.iterator(); it.hasNext(); ) {
			final Tray lbox = (Tray)it.next();
			if ( lbox.isClosed() ) {
				it.remove();
			} else {
				lbox.sendMany( x );
			}
		}
	}

	//	OutTrays need no preparation.
	protected void stageOneMain() {
		this.finishStageTwo();
	}

	//	Now perform the disconnections.
	protected void stageTwoMain() {
		final Set s = this.subscribers;
		this.subscribers = null;								//	defensive release of references.
		for ( Iterator it = s.iterator(); it.hasNext(); ) {
			final Tray b = (TrayImpl)it.next();
			b.notifyConnected( -1 );
		}
	}

}
