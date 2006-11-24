package org.openspice.jspice.boxes;

import java.io.PrintWriter;

import org.openspice.tools.LineReader;

public interface Stdio {
	PrintWriter getOut();
	PrintWriter getErr();
	LineReader getIn();
}
