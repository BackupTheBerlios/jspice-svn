/**
 * 
 */
package org.openspice.jspice.run;

import java.io.Reader;

public class InterpreterThread extends WorldThread {
	
	final Interpreter interpreter;
	final Reader reader;
	
	public InterpreterThread( final Interpreter interpreter, final Reader reader) {
		this.interpreter = interpreter;
		this.reader = reader;
	}
	
	public void run() {
		this.interpreter.interpret( 
			"jconsole", 
			this.reader
		); 
	}
	

}