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

/**
 * TwoStageFinish is really a mixin - however Java does not support this basic concept.
 * As a consequence, OutTrays are needlessly two stage finishers - which is just a nuisance.
 */
public abstract class TwoStageFinish {

	private final static byte ACTIVE = 0;
	private final static byte FINISHING = 1;
	private final static byte FINISHED = 2;

	private byte status = ACTIVE;

	protected abstract void stageOneMain();
	protected abstract void stageTwoMain();

	public final void finishStageOne() {
		if ( status < FINISHING ) {
//			System.err.println( "Starting stage one ...." + this.getClass().getName() );
			this.status = FINISHING;
//			System.err.println( "Stage one main ...." + this.getClass().getName() );
			this.stageOneMain();
//		} else {
//			System.err.println( "Already finishing off ... " + this.getClass().getName() ); 	//	todo: get rid of this instrumentation line.
		}
	}

	public final void finishStageTwo() {
		if ( this.status < FINISHED ) {
//			System.err.println( "Starting stage two .... " + this.getClass().getName() );
			this.status = FINISHED;
//			System.err.println( "Stage two main ...." + this.getClass().getName() );
			this.stageTwoMain();
//		} else {
//			System.err.println( "Already finished off .... " + this.getClass().getName() );		//	todo: instrumentation
		}
	}

	public final boolean isFinished() {
		return this.status == FINISHED;
	}

	public final boolean isFinishing() {
		return this.status == FINISHING;
	}

	public final boolean isActive() {
		return this.status == ACTIVE;
	}

}
