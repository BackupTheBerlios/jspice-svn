package org.openspice.jspice.run;

import java.io.InputStreamReader;
import java.io.PrintWriter;

import org.openspice.tools.ReaderLineReader;

public class StdStdio extends AbsStdio {
	
	public StdStdio() {
		super(
			new ReaderLineReader( new InputStreamReader( System.in ) ),
			new PrintWriter( System.out ),
			new PrintWriter( System.err )
		);
	}

}
