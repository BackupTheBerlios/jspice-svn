/**
 *	JSpice, an Open Spice interpreter and library.
 *	Copyright (C) 2003, Stephen F. K. Leach
 *
 * 	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 * 	the Free Software Foundation; either version 2 of the License, or
 * 	(at your option) any later version.
 *
 * 	This program is distributed in the hope that it will be useful,
 * 	but WITHOUT ANY WARRANTY; without even the implied warranty of
 * 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 * 	along with this program; if not, write to the Free Software
 *	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
package org.openspice.jspice.boxes;

import org.openspice.jspice.conf.DynamicConf;
import org.openspice.vfs.VFile;
import org.openspice.vfs.file.FileVVolume;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import javax.servlet.ServletConfig;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.File;


public class CommandLineBoxServlet extends HttpServlet {

	DynamicConf jspice_conf;

	public void init( final ServletConfig c ) throws ServletException {
		super.init( c );    		//	To change body of overridden methods use File | Settings | File Templates.
		this.jspice_conf = (DynamicConf)c.getServletContext().getAttribute( "JSpiceConf" );
	}

//	static class Example extends CmdBox {
//		public void goBuddyGo() {
//			System.err.println( "cute starts" );
//			this.println( "Welcome to Example" );
//			for (;;) {
//				System.err.println( "this should be flushed: " + buffer.toString() );
//				final String s = this.getLine();
//				if ( s.intern() == "quit" ) break;
//				System.err.println( s );
//				this.println( s.toUpperCase() );
//				this.flush();
//			}
//			System.err.println( "cute is finished" );
//			this.println( "Thank you and goodnight" );
//		}
//	}

	public static final String attr = "activity";

	protected void doGet( final HttpServletRequest req, final HttpServletResponse resp ) throws ServletException, IOException {
		final HttpSession session = req.getSession( true );
		CuteActivity activity = (CuteActivity)session.getAttribute( attr );
		resp.setContentType( "text/html" );
		PrintWriter out = resp.getWriter();
		out.println( "<html>" );
		out.println( "<head><title>Game</title></head>" );
		out.println( "<body>" );
		String message;

		if ( activity == null ) {
			//	Horrible, horrible hack to get the examples code started.
			final VFile game_file = FileVVolume.getVFile( new File( "inventory/tads2.jpkg/public.auto/ccr.gam" ) );
			activity = new CuteActivity( new GameBox( game_file ) );
			session.setAttribute( attr, activity );
			activity.start();
			message = activity.message();
		} else {
			activity.command( req.getParameter( "command" ) );
			message = activity.message();
		}

		if ( message == null ) {
			out.println( "removing attribute" );
			session.setAttribute( attr, null );
			out.println( "<div>So long, and thanks for all the fish!</div>" );
		} else {
			out.println( "<pre>");
			out.println( message );
			out.println( "</pre>");
			if ( ! activity.isShutdown() ) {
				out.println( "<hr>" );
				out.println( "<form method=\"post\" action=\"ccr\">" );
				out.println( "command: <input type=\"text\" name=\"command\">" );
				out.println( "</form>" );
			}
		}

		out.println( "</body>" );
		out.println( "</html>" );
	}

	protected void doPost( HttpServletRequest req, HttpServletResponse resp ) throws ServletException, IOException {
		this.doGet( req, resp );
	}

}
