package org.openspice.jspice.tools;

import java.io.PrintStream;

public class PrintStreamConsumer extends ConsumerImpl {

	private final PrintStream out;
	
	public PrintStreamConsumer(final PrintStream out) {
		this.out = out;
	}

	public void out( final char ch ) {
		this.out.print( ch );
	}

	public void ln() {
		this.out.println( "" );
	}

	public void outCharSequence( final CharSequence s ) {
		this.out.print( s );
	}

	public void outObject( final Object obj ) {
		this.out.print( obj );
	}

	public Object close() {
		return null;
	}

}