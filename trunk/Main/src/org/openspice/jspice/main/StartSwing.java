package org.openspice.jspice.main;

import java.io.PrintWriter;
import java.io.Reader;

import javax.swing.JFrame;

import org.openspice.jspice.run.InterpreterThread;
import org.openspice.tools.ReaderLineReader;

import bsh.util.JConsole;


public class StartSwing {
	
	static final class SwingMain extends Main {
		
		public SwingMain( final CmdLineOptions cmd ) {
			super( cmd );
		}

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
		protected void init() {
			super.init();
//			this.interpreter.getDynamicConf().setIsDebugging( true );
			this.initJConsole();
		}
		
		@Override
		protected void interpret() {
			final Reader r = jconsole.getIn();
			final PrintWriter pout = new PrintWriter( jconsole.getOut() );
			final PrintWriter perr = new PrintWriter( jconsole.getErr() );
//			final Stdio stdio = new AbsStdio( new ReaderLineReader( r ), pout, perr );
//			this.interpreter.getVM().setStdio( stdio );
			final InterpreterThread t = new InterpreterThread( this.interpreter, r );
			t.setIn( new ReaderLineReader( jconsole.getIn() ) );
			t.setOut( pout );
			t.setErr( perr );
			t.start();
		}
		
	}
	
	public static void main( final String[] args ) {
		final CmdLineOptions cmd = new CmdLineOptions();
		cmd.process( args );
		main( cmd );
	}

	public static final void main( final CmdLineOptions cmd ) {
		final Main main = new SwingMain( cmd );
		main.start();		
	}
	
}
