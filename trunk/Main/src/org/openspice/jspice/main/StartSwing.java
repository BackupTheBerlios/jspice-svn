package org.openspice.jspice.main;

import java.awt.BorderLayout;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.UnsupportedEncodingException;

import javax.swing.JFrame;

import org.openspice.jspice.boxes.AbsStdio;
import org.openspice.jspice.boxes.Stdio;
import org.openspice.tools.ReaderLineReader;

import bsh.util.JConsole;


public class StartSwing {
	
	static final class InterpreterThread extends Thread {
		
		final Interpreter interpreter;
		final Reader reader;
		
		public InterpreterThread( final Interpreter interpreter, final Reader reader) {
			this.interpreter = interpreter;
			this.reader = reader;
		}

		public synchronized void start() {
			this.interpreter.interpret( "jconsole", this.reader ); 
		}
		
	}
	
	static final class SwingMain extends Main {
		
		private JConsole jconsole;
		private JFrame jframe;

		private void initJConsole() {
			this.jframe = new JFrame();
			this.jframe.setBounds( 50,50, 640, 480 );
			this.jconsole = new JConsole();
			this.jframe.getContentPane().add( "Center", this.jconsole );
			this.jframe.setVisible( true );
		}

		@Override
		protected void init( final CmdLineOptions cmd ) {
			super.init( cmd );
//			this.interpreter.getDynamicConf().setIsDebugging( true );
			this.initJConsole();
		}
		
		@Override
		protected void interpret( final CmdLineOptions cmd ) {
			final Reader r = jconsole.getIn();
			final PrintWriter pout = new PrintWriter( jconsole.getOut() );
			final PrintWriter perr = new PrintWriter( jconsole.getErr() );
			final Stdio stdio = new AbsStdio( new ReaderLineReader( r ), pout, perr );
			this.interpreter.getVM().setStdio( stdio );
			new InterpreterThread( this.interpreter, r ).start();
		}
		
	}
	
	public static void main( final String[] args ) {
		final CmdLineOptions cmd = new CmdLineOptions();
		cmd.process( args );
		main( cmd );
	}

	public static final void main( final CmdLineOptions cmd ) {
		final Main main = new SwingMain();
		main.perform( cmd );		
	}
	
}
