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
package org.openspice.jspice.office.examples;

import org.openspice.tools.XMLTools;
import org.openspice.jspice.office.*;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Node;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import java.io.StringReader;


public class PoplogExample {

	private static final Document exampleDoc() {
		try {
			final DOMImplementation documentImplementation = DocumentBuilderFactory.newInstance().newDocumentBuilder().getDOMImplementation();
			final Document document = documentImplementation.createDocument( "", "message", null );
			final Element root = document.getDocumentElement();
			root.setAttribute( "status", "ok" );
			final Element c = (Element)root.appendChild( document.createElement( "foo" ) );
			c.setAttribute( "answer", "is 42" );
			return document;
		} catch ( ParserConfigurationException e ) {
			throw new RuntimeException( e );
		}
	}

	static class PoplogServerWorker extends SocketWorker {

		final PushableReader pushableReader;

		public PoplogServerWorker( final Office office, final String host, final int port ) {
			super( office, false, host, port );
			this.pushableReader = new PushableReader( this.getReader() );
			this.init();
		}

		public Letter readLetterFrom( final Reader reader ) {
			final Document doc = XMLTools.read( new UpToBoundaryReader( this.pushableReader, "<?xml " ) );
			return this.newOutTrayLetter( "XML Document" ).add( doc );
		}

		public void writeLetterTo( final Writer writer, final Letter letter ) {
			XMLTools.print( (Document)letter.get(), writer );
		}

	}

	public static void main( final String[] args ) {
//		XMLTools.print( exampleDoc(), System.out );

		final Office office = new Office();
		final Worker worker = new PoplogServerWorker( office, "192.168.1.13", 1082 );
		final ThreadInTray lbox = new ThreadInTray( office );
		worker.getOutTray().connectTo( lbox );

		lbox.newLetterTo( worker, "open" ).add( exampleDoc() ).send();

		final Letter letter = lbox.receive();
		System.out.println( "Subject: " + letter.getSubject() );
		System.out.println( "Arg:     " + letter.get() );
		XMLTools.print( (Document)letter.get(), System.out );

		worker.finishOff();
	}

}
