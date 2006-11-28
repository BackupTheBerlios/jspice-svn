/**
 * 
 */
package org.openspice.jspice.run;

import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;

import org.openspice.tools.LineReader;
import org.openspice.tools.ReaderLineReader;


public class InterpreterThread extends WorldThread {
	
	final Interpreter interpreter;
	final Reader reader;
	
	public InterpreterThread( final Interpreter interpreter, final Reader reader) {
		this.interpreter = interpreter;
		this.reader = reader;
	}
	
	public static WorldThread currentWorld() {
		try {
			return (WorldThread)Thread.currentThread();
		} catch ( ClassCastException _ ) {
			return null;
		}
	}

	public synchronized void start() {
		this.interpreter.interpret( "jconsole", this.reader ); 
	}
	
	private PrintWriter ERR = null;

	@Override
	public PrintWriter getErr() {
		if ( this.ERR == null ) {
			this.ERR = new PrintWriter( System.err );
		}
		return this.ERR;
	}

	private LineReader IN = null;
	
	@Override
	public LineReader getIn() {
		if ( this.IN == null ) {
			this.IN = new ReaderLineReader( new InputStreamReader( System.in ) );
		}
		return this.IN;
	}
	
	private PrintWriter OUT = null;

	@Override
	public PrintWriter getOut() {
		if ( this.OUT == null ) {
			this.OUT = new PrintWriter( System.out );
		}
		return this.OUT;
	}

	@Override
	public void setErr( final PrintWriter pw ) {
		this.ERR = pw;
	}

	@Override
	public void setIn( final LineReader r ) {
		this.IN = r;
	}

	@Override
	public void setOut( final PrintWriter pw ) {
		this.OUT = pw;
	}

}