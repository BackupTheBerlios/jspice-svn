package org.openspice.jspice.run;

import java.io.PrintWriter;

import org.openspice.tools.LineReader;

public interface Stdio {
	PrintWriter getOut();
	PrintWriter getErr();
	LineReader getIn();
}
