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
import java.util.LinkedList;

/**
 * This class is suitable for use as a pick-up point by client threads.  It can also
 * be used for one client to sendOne directly to another.   It is the central concept
 * of this implementation.
 */
public class ThreadInTray extends InTray implements ThreadInTrayIntf {

	private int maxsize = Integer.MAX_VALUE;		//	Block when the queue gets this big.  0 = don't block.
	private long timeout = 0;						//	0 = don't timeout.
	private boolean throw_on_timeout = false;
	private Letter timeout_default = null;
	private boolean is_interruptible = false;

	private LinkedList queue = new LinkedList();	//	Should really be a priority queue - but that's too much like hard work.

	public ThreadInTray( final Worker worker ) {
		super( worker );
	}

	public ThreadInTray( final Office office ) {
		super( office );
	}

	//	---- RECEIVING

	private boolean isAvailable() {
		return this.isOpen() && !this.queue.isEmpty();
	}

	private boolean isUnavailable() {
		return !this.isOpen() || this.queue.isEmpty();
	}

	private Letter doReceive() {
		final Letter result = (Letter)queue.remove( 0 );
		// notify Producer that value has been retrieved
		this.notifyAll();
		if ( result.isDismissal() ) {
			//	Initiate stage 2.
			this.finishStageTwo();
			//	And return null.
			return null;
		} else {
			return result;
		}
	}

	public synchronized Letter receive() {
		while ( this.isUnavailable() ) {
			try {
				// wait for Producer to putOne value
				this.wait( this.timeout );
				if ( this.isUnavailable() ) {
					if ( this.throw_on_timeout ) throw new ThreadLetterBoxTimeOutException();
					return this.timeout_default;
				}
			} catch ( InterruptedException e ) {
				if ( this.is_interruptible ) throw new ThreadLetterBoxInterruptedException( e );
			}
		}
		return this.doReceive();
	}


	//	---- SENDING

	private boolean hasNoRoom() {
		return queue.size() >= this.maxsize;
	}

	private void doNotifyAll() {
		if ( this.isAvailable() ) {
			this.notifyAll();
		}
	}

	private void waitForRoom() {
		while ( this.hasNoRoom() ) {
			try {
				// wait for Consumer to get value
				this.wait();
				if ( this.hasNoRoom() ) throw new ThreadLetterBoxTimeOutException();
			} catch ( InterruptedException e ) {
				if ( this.is_interruptible ) throw new ThreadLetterBoxInterruptedException( e );
			}
		}
	}

	private void doPut( final Letter value ) {
		queue.add( value );
		this.doNotifyAll();
	}

	private void putOne( final Letter value ) {
		this.waitForRoom();
		this.doPut( value );
	}

	private void doPutMany( final Collection value ) {
		queue.addAll( value );
		this.doNotifyAll();
	}

	private void putMany( final Collection value ) {
		this.waitForRoom();
		this.doPutMany( value );
	}


	//	---oooOOOooo---

	public synchronized void sendOne( final Letter letter ) {
		if ( this.isOpen() ) {
			this.putOne( letter );
		}
	}

	//	Collection< Letter >
	public synchronized void sendMany( final Collection letters ) {
		if ( this.isOpen() ) {
			this.putMany( letters );
		}
	}

}
