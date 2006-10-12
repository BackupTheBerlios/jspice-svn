package org.openspice.jspice.loader;

import org.openspice.jspice.namespace.NameSpace;
import org.openspice.vfs.VFile;

import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.stream.StreamSource;

public class XslLoaderBuilder  extends ValueLoaderBuilder {

	static final class XslLoader extends ValueLoader {

		private XslLoader( final ValueLoaderBuilder vlb, final NameSpace ns ) {
			super( vlb, ns );
		}

	}

	public ValueLoader newValueLoader( final NameSpace current_ns ) {
		return new XslLoader( this, current_ns );
	}

	public Object loadValueFromVFile( final VFile file ) {
		final Source src = new StreamSource( file.inputStreamContents() );
		try {
			return TransformerFactory.newInstance().newTransformer( src );
		} catch ( TransformerConfigurationException e ) {
			throw new RuntimeException( e );	//	todo: I guess I need to catch these
		}
	}

}
