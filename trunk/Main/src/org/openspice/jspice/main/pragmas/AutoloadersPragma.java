/**
 *	JSpice, an Open Spice interpreter and library.
 *	Copyright (C) 2003, Stephen F. K. Leach
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
package org.openspice.jspice.main.pragmas;

import org.openspice.jspice.conf.DynamicConf;
import org.openspice.jspice.conf.LoaderBuilderRecord;
import org.openspice.jspice.run.Pragma;
import org.openspice.jspice.run.PragmaAction;

import java.util.Iterator;

public class AutoloadersPragma implements PragmaAction {

	private void list( final DynamicConf jspice_conf ) {
		for ( Iterator it = jspice_conf.getAutoloaders().iterator(); it.hasNext(); ) {
			final LoaderBuilderRecord r = (LoaderBuilderRecord)it.next();
			final String extn = r.getExtension();
			System.out.print( extn );
			final int len = 4 - extn.length();
			for ( int i = 0; i < len; i++ ) {
				System.out.print( " " );
			}
 			System.out.println( "\t: " + r.getComment() );

		}
	}

	public void doAction( final Pragma pragma ) {
		this.list( pragma.getDynamicConf() );
		//new AutoloadersPragma( pragma.getDynamicConf() ).list();
	}
	
	public String[] names() {
		return new String[] { "autoloaders" };
	}
	
}
