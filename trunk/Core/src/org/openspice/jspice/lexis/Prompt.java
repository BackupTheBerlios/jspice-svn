package org.openspice.jspice.lexis;

import java.io.PrintWriter;

public abstract class Prompt {
    
	abstract void forcePrompt();

	abstract void clearPrompt();

	public static class PrintWriterPrompt extends Prompt {
		
		final String prompt;
		final PrintWriter printer;
		
		public PrintWriterPrompt( final String prompt, final PrintWriter printer ) {
			this.prompt = prompt;
			this.printer = printer;
		}

		@Override
		void clearPrompt() {
			if ( prompt != null ) {
				this.printer.println( "" );
				this.printer.flush();
	        }
		}

		@Override
		void forcePrompt() {
	        if ( prompt != null ) {
	        	this.printer.print( prompt );
	        	this.printer.flush();
	        }				
		}
			
	}
	
	public static class StdOutPrompt extends PrintWriterPrompt {
		public StdOutPrompt( final String prompt ) {
			super( prompt, new PrintWriter( System.out ) );
		}		
	}

}
