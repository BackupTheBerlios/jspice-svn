package org.openspice.tools;

import java.io.File;
import java.io.FileDescriptor;
import java.io.FileNotFoundException;
import java.io.FileReader;

public class SelfCloseFileReader extends FileReader {

	public SelfCloseFileReader( final File arg0 ) throws FileNotFoundException {
		super( arg0 );
	}

	public SelfCloseFileReader( final FileDescriptor arg0 ) {
		super( arg0 );
	}

	public SelfCloseFileReader( final String arg0 ) throws FileNotFoundException {
		super( arg0 );
	}

	@Override
	protected void finalize() throws Throwable {
		this.close();
	}

}
