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
 * The Office class acts as the registry for all workers and their shared resources.
 * The functions of the post office are to provide:-
 * <ol>
 * <li> a registry for workers
 * <li> a thread for executing queued messages
 * </ol>
 *
 */
public class Office implements OfficeIntf {

	static final class OfficeThread extends Thread {

		final private Office office;

		public OfficeThread( Office po ) {
			this.office = po;
		}

		public void run() {
			for (;;) {
				final Runnable r = this.office.next();
				if ( r == null ) return;
				r.run();
			}
		}

	}

	/**
	 * This variable is THREAD SHARED so all access MUST be synchronized for it to be safe.
	 * When it is null, this means either that there is no active worker or that the worker
	 * thread is in the process of tear-down and useless.
	 */
	private Thread automaticThread = null;

	/**
	 * Returns the thread maintained by an office for executing
	 * message sending.
	 * @return the office thread
	 */
	public Thread getAutomaticThread() {
		return this.automaticThread;
	}


	//	THREAD SHARED all access MUST be synchronized.
	//	List< Runnable >
	private final LinkedList runnable_list = new LinkedList();
	
	synchronized Runnable next() {
		if ( this.runnable_list.isEmpty() ) {
			this.automaticThread = null;
			return null;
		}
		return (Runnable)this.runnable_list.removeFirst();
	}

	synchronized public void addRunnable( final Runnable runnable ) {
		this.runnable_list.add( runnable );
		if ( automaticThread == null ) {
			( this.automaticThread = new OfficeThread( this ) ).start();
		}
	}

	final HashSet registered = new HashSet();

	/**
	 * Searches the registry for a Worker with a matching name.
	 * @param name the name to match
	 * @return the worker or null if cannot be found
	 */
	public Worker findByName( final String name ) {
		if ( name == null ) {
			return null;
		}
		for ( Iterator it = this.registered.iterator(); it.hasNext(); ) {
			final Worker w = (Worker)it.next();
			if ( name.equals( w.getName() ) ) {
				return w;
			}
		}
		return null;
	}

	/**
	 * Searches the registry of Workers for one with a matching
	 * role.
	 * @param role the role to match
	 * @return the worker or null if not found
	 */
	public Worker findByRole( final String role ) {
		if ( role == null ) {
			return null;
		}
		for ( Iterator it = this.registered.iterator(); it.hasNext(); ) {
			final Worker w = (Worker)it.next();
			if ( role.equals( w.getRole() ) ) {
				return w;
			}
		}
		return null;
	}

}
