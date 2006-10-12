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

import java.io.InputStream;
import java.io.OutputStream;

/**
 * The OfficeIntf is a <i>scaffolding</i> interface that has no useful meaning
 * except to the developer of the package.
 * @see Office
 */
public interface OfficeIntf {

	void addRunnable( final Runnable runnable );

	public Worker findByName( String name );
	public Worker findByRole( String role );

	public Thread getAutomaticThread();

}
