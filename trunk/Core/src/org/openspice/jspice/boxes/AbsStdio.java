package org.openspice.jspice.boxes;

import java.io.PrintWriter;

import org.openspice.tools.LineReader;

public class AbsStdio implements Stdio {
	
	final LineReader in;
	final PrintWriter out;
	final PrintWriter err;
		
	public AbsStdio( final LineReader in, final PrintWriter out, final PrintWriter err ) {
		this.in = in;
		this.out = out;
		this.err = err;
	}

	public PrintWriter getErr() {
		return err;
	}

	public LineReader getIn() {
		return in;
	}

	public PrintWriter getOut() {
		return out;
	}

}
