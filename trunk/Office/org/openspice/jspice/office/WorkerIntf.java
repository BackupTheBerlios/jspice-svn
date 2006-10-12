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
import java.util.List;

/**
 * The WorkerIntf is a <i>scaffolding</i> interface that has no useful meaning
 * except to the developer of the package.
 * @see Worker
 */
public interface WorkerIntf {

	public String getName();
	public void setName( String name );

	public String getRole();
	public void setRole( String role );

	public InTray getInTray();
	public OutTray getOutTray();
	public OutTray findByName( String name );
	public List allOutTray();
	public OutTray newOutTray( String name );

	public void connectTo( Worker dst );
	public void connectTo( Tray tray );
	public void disconnectFrom( Worker dst );
	public void disconnectFrom( Tray tray );

	public void finishOff();
	public boolean isFinished();
	public boolean isFinishing();
	public boolean isActive();

	public boolean isFinishOffOnLastDisconnect();
	public void setFinishOffOnLastDisconnect( boolean finishOffWhenNoConnections );
	public Worker finishOffOnLastDisconnect();

	public Letter newOutTrayLetter( OutTray to, Object subject );
	public Letter newOutTrayLetter( Object subject );
	public Letter newReplyTo( Letter letter, Object subject );
	public Letter newLetterTo( Worker to, Object subject );

}
