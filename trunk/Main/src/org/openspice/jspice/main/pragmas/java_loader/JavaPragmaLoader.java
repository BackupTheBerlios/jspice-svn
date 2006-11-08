package org.openspice.jspice.main.pragmas.java_loader;

import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;

import org.openspice.alert.Alert;
import org.openspice.jspice.main.Interpreter;
import org.openspice.jspice.main.InterpreterMixin;

public class JavaPragmaLoader extends InterpreterMixin {
	
	public JavaPragmaLoader( Interpreter interpreter ) {
		super( interpreter );
	}

	/**
	 * Load the method class or package specified into the current package.
	 * @param args List< String >
	 */
	public void load( final List args ) {
		//	The first argument should be "method", "class" or "package".
		try {
			final Iterator it = args.iterator();
			final String what = ((String)it.next()).intern();
			JavaLoader j;
			if ( what == "class" ) {
				j = new ClassJavaLoader( this );
			} else if ( what == "method" ) {
				j = new MethodJavaLoader( this );
			} else {
				throw new Alert( "Invalid java scope specifier", "Should be method or class" ).culprit( "scope", what ).mishap();
			}
			while ( it.hasNext() ) {
				final String arg = (String)it.next();
				j.load( arg );
			}
		} catch ( final NoSuchElementException e ) {
			new Alert( "Invalid java command" ).mishap();
		}
	}
	
}