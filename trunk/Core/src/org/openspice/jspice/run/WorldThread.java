package org.openspice.jspice.run;

import java.io.InputStreamReader;
import java.io.PrintWriter;

import org.openspice.jspice.tools.SysAlert;
import org.openspice.tools.LineReader;
import org.openspice.tools.ReaderLineReader;

public abstract class WorldThread extends Thread {

	
	public static WorldThread tryCurrent() {
		try {
			return (WorldThread)Thread.currentThread();
		} catch ( ClassCastException _e ) {
			return null;
		}
	}
	
	public static WorldThread current() {
		try {
			return (WorldThread)Thread.currentThread();
		} catch ( ClassCastException _e ) {
			throw SysAlert.unreachable();
		}
	}
	
	private PrintWriter ERR = null;

	public PrintWriter getErr() {
		if ( this.ERR == null ) {
			this.ERR = new PrintWriter( System.err );
		}
		return this.ERR;
	}

	private LineReader IN = null;
	
	public LineReader getIn() {
		if ( this.IN == null ) {
			this.IN = new ReaderLineReader( new InputStreamReader( System.in ) );
		}
		return this.IN;
	}
	
	private PrintWriter OUT = null;

	public PrintWriter getOut() {
		if ( this.OUT == null ) {
//			System.err.println( this.getClass() );
//			System.err.println( "SETTING OUTPUT TO STDOUT" );
//			new Exception().printStackTrace( System.err );
			this.OUT = new PrintWriter( System.out );
		}
		return this.OUT;
	}

	public void setErr( final PrintWriter pw ) {
		this.ERR = pw;
	}

	public void setIn( final LineReader r ) {
		this.IN = r;
	}

	public void setOut( final PrintWriter pw ) {
		this.OUT = pw;
	}

}
