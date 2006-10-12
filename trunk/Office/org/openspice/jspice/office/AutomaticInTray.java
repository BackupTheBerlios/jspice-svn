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
import java.util.Iterator;

public class AutomaticInTray extends InTray implements AutomaticInTrayIntf {

	static abstract class Thunk implements Runnable {
		final AutomaticInTray agent;

		public Thunk( final AutomaticInTray agent ) {
			this.agent = agent;
		}
	}

	static class DoCloseThunk extends Thunk {
		public DoCloseThunk( final AutomaticInTray agent ) {
			super( agent );
		}

		public void run() {
			this.agent.doClose();
		}
	}

	static class DoHandlerLetterThunk extends Thunk {
		final Letter letter;

		public DoHandlerLetterThunk( final AutomaticInTray agent, final Letter letter ) {
			super( agent );
			this.letter = letter;
		}

		public void run() {
			this.agent.doHandleLetter( this.letter );
		}
	}

	public AutomaticInTray( final AutomaticWorker worker ) {
		super( worker );
	}

	public AutomaticWorker getAutoWorker() {
		return (AutomaticWorker)this.tryGetOwner();
	}

	/**
	 * The auto-reply action.
	 * @param letter The letter to reply to.
	 */
	final void doHandleLetter( final Letter letter ) {
		if ( letter.isDismissal() ) {
			//	OK - the queue of letters is now emptied, we can now initiate stage 2.
			this.getAutoWorker().handleFinish();
			this.finishStageTwo();
		} else {
			this.getAutoWorker().handleLetter( letter );
		}
	}

	final void doClose() {
		super.close();
	}

	final public void close() {
		this.getOffice().addRunnable( new DoCloseThunk( this ) );
	}

	private void autoReply( final Letter letter ) {
		if ( this.isOpen() || this.isFinishing() && letter.isDismissal() ) {
			final Runnable runnable = new DoHandlerLetterThunk( this, letter );
			this.getOffice().addRunnable( runnable );
		}
	}

	public final synchronized void sendMany( final Collection letters ) {
		if ( this.isOpen() ) {
			for ( Iterator it = letters.iterator(); it.hasNext(); ) {
				final Letter letter = (Letter)it.next();
				this.autoReply( letter );
			}
		}
	}

	public final synchronized void sendOne( final Letter letter ) {
		this.autoReply( letter );
	}

}
