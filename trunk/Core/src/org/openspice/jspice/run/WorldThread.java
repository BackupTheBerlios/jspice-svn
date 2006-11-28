package org.openspice.jspice.run;

import java.io.PrintWriter;

import org.openspice.tools.LineReader;

public abstract class WorldThread extends Thread {
	abstract PrintWriter getOut();
	abstract PrintWriter getErr();
	abstract LineReader getIn();
	
	abstract void setOut( PrintWriter _ );
	abstract void setErr( PrintWriter _ );
	abstract void setIn( LineReader _ );
}
