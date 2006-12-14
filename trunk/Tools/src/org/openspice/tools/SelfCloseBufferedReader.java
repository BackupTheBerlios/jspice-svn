package org.openspice.tools;

import java.io.BufferedReader;
import java.io.Reader;

public class SelfCloseBufferedReader extends BufferedReader {
	
	public SelfCloseBufferedReader( final Reader in ) {
		super( in );
	}

	@Override
	protected void finalize() throws Throwable {
		this.close();
	}
	
}

