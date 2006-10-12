/**
 *	JSpice, an Open Spice interpreter and library.
 *	Copyright (C) 2005, Stephen F. K. Leach
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
package org.openspice.jspice.class_builder;

/**
 * This is a placeholder class for utilities for discovering details about Java
 * type descriptors.  A typical method spec:
 * 		(SF[Ljava/lang/Thread;)I
 * 		int foo( short x, float y, Thread[] z )
 */
public class DescriptorTools {

	public static final String translate( final String cname ) {
		return cname.replace( '.', '/' );		
	}

	public static final String descriptor( final Class c ) {
		return "L" + translate( c.getName() ) + ";";
	}

	/**
	 * Returns the number of results that a descriptor says that a method will return.
	 * @param desc type descriptor
	 * @return 0 or 1
	 */
	public static final int numOutputs( final String desc ) {
		assert desc != null && desc.length() > 0 && desc.charAt( 0 ) == '(';
		final char lastch = desc.charAt( desc.length() - 1 );
		return lastch == 'V' ? 0 : 1;
	}

	/**
	 * Returns the number of inputs that a descriptor says that a method
	 * requires.
	 * @param desc type descriptor
	 * @return number of inputs
	 */
	public static final int numInputs( final String desc ) {
		assert desc != null && desc.length() > 0 && desc.charAt( 0 ) == '(';
		int count = 0;
		boolean looking_for_closing_semi = false;
		//	Start from 1 to skip initial '('
		for ( int n = 1; n < desc.length(); n++ ) {
			final char ch = desc.charAt( n );
			if ( looking_for_closing_semi ) {
				looking_for_closing_semi = ( ch != ';' );
			} else if ( ch == ')' ) {
				//	Found end of args.
				return count;
			} else if ( ch == 'L' ) {
				count += 1;
				looking_for_closing_semi = true;
			} else if ( ch != '[' ) {
				//	Ignore array but everything else adds 1.
				count += 1;
			}
		}
		throw new RuntimeException( "Malformed method descriptor: " + desc );
	}

	public static final int calcDelta( final MethodReference mref ) {
		final String desc = mref.getDescriptor();
		final int inputs = numInputs( desc );
		final int outputs = numOutputs( desc );
		return outputs - inputs;
	}

}
