package org.openspice.jspice.run;


import org.mortbay.http.*;
import org.mortbay.jetty.servlet.*;
import org.mortbay.util.MultiException;
import org.openspice.jspice.boxes.CommandLineBoxServlet;
import org.openspice.jspice.conf.DynamicConf;
import org.openspice.jspice.tools.Hooks;
import java.util.Observer;
import java.util.Observable;

/**
 * Scratch code for messing around with Jetty.
 */
public class ServerMain implements Observer {

	HttpServer server;

	public void update( final Observable obs, final Object arg ) {
		try {
			server.stop();
		} catch ( InterruptedException e ) {
		}
	}

	public final HttpServer startUp( final DynamicConf jconf ) {

		//	Horror show!  We have to set the Jetty logging via the system property!
//		System.setProperty( "LOG_CLASSES", "org.mortbay.util.NullLogSink" );

		// 	Create the server.
		this.server = new HttpServer();

		// 	Create a port listener.
		final SocketListener listener = new SocketListener();
		listener.setPort( 8181 );
		server.addListener( listener );

		// 	Create a context - this aggregates handlers e.g. ServletHandlers.
		final HttpContext context = new HttpContext();
		context.setContextPath( "/games/*" );
		server.addContext( context );

		// 	Create a servlet container.
		final ServletHandler servlets = new ServletHandler();
		context.addHandler( servlets );
		context.setAttribute( "JSpiceConf", jconf );

		// 	Map a servlet onto the container.
		servlets.addServlet( "Dump", "/Dump/*", "org.mortbay.servlet.Dump" );
		final ServletHolder holder = servlets.addServlet( "CCR", "/ccr/*", CommandLineBoxServlet.class.getName() );



		// Serve static content from the context.
		//	Commented out because I cannot guarantee that there is any real filing system!

//		context.setResourceBase( new File( jconf.getHome().getFile(), "tut" ).getPath() + "/" );
//		context.addHandler( new ResourceHandler() );

		// Start the http server.
		try {
			server.start();
		} catch ( MultiException e ) {
			throw new RuntimeException( e );
		}

		return server;
	}

	public void start( final DynamicConf jconf) {
		this.startUp( jconf );
		Hooks.SHUTDOWN.addObserver( this );		//	Horrible temporary hack.
	}

}

