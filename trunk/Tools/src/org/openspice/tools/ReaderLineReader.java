package org.openspice.tools;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;

public class ReaderLineReader implements LineReader {

	final BufferedReader reader;
	
	public ReaderLineReader( final BufferedReader reader ) {
		this.reader = reader;
	}

	public ReaderLineReader( final Reader reader ) {
		this.reader = reader instanceof BufferedReader ? (BufferedReader)reader : new BufferedReader( reader );
	}

	public String readLine() {
		try {
			return this.reader.readLine();
		} catch ( final IOException e ) {
			throw new RuntimeException( e );
		}
	}
	
}
