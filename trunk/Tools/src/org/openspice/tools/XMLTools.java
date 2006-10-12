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
package org.openspice.tools;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;
import org.xml.sax.InputSource;

import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.ParserConfigurationException;
import java.io.*;

public final class XMLTools {

	public static final void print( final Document doc, final Writer writer ) {
		print( doc, new StreamResult( writer ) );
	}

	public static final void print( final Document doc, final OutputStream out ) {
		print( doc, new StreamResult( out ) );
	}

	public static final void print( final Document document, final StreamResult streamResult ) {
		try {
			final TransformerFactory tf = TransformerFactory.newInstance();
			final Transformer t = tf.newTransformer();
			t.transform( new DOMSource( document ), streamResult );
		} catch ( TransformerException e ) {
			throw new RuntimeException( e );
		}
	}

	public static final Document read( final InputSource inputSource ) {
		try {
			final DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
			final DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
			return documentBuilder.parse( inputSource );
		} catch ( ParserConfigurationException e ) {
			throw new RuntimeException( e );
		} catch ( SAXException e ) {
			throw new RuntimeException( e );
		} catch ( IOException e ) {
			throw new RuntimeException( e );
		}
	}

	public static final Document read( final InputStream in ) {
		return read( new InputSource( in ) );
	}

	public static final Document read( final Reader reader ) {
		return read( new InputSource( reader ) );
	}

}
