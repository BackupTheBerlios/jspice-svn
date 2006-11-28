package org.openspice.jspice.run;

import java.io.PrintWriter;

import org.openspice.tools.LineReader;

public abstract class WorldThread extends Thread {
	public abstract PrintWriter getOut();
	public abstract PrintWriter getErr();
	public abstract LineReader getIn();
	
	public abstract void setOut( PrintWriter _ );
	public abstract void setErr( PrintWriter _ );
	public abstract void setIn( LineReader _ );
	
	public static WorldThread current() {
		try {
			return (WorldThread)Thread.currentThread();
		} catch ( ClassCastException _e ) {
			return null;
		}
	}
}
