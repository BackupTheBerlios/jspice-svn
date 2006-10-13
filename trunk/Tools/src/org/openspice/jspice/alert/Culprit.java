package org.openspice.jspice.alert;

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


class Culprit {
	final String desc;
	final Object arg;
	final boolean typed;
	final ShowCulprit showCulprit;

	Culprit( final String desc1, final Object arg1, final boolean typed1, final ShowCulprit showCulprit ) {
		this.desc = desc1;
		this.arg = arg1;
		this.typed = typed1;
		this.showCulprit = showCulprit;
	}

	Culprit( final String desc1, final Object arg1, final ShowCulprit s ) {
		this( desc1, arg1, false, s );
	}

	static Culprit hint( final String hint_text, final ShowCulprit s ) {
		return new Culprit( "hint", hint_text, false, s );
	}

	static Culprit typedCulprit( final String desc, final Object arg, final ShowCulprit s ) {
		return new Culprit( desc, arg, true, s );
	}

	String keepShort( final Object x, final int mx_len, final int filemxlen ) {
		final int mxlen = mx_len > 5 ? mx_len : 5;
		final String s = this.showCulprit.showToString( x );
		if ( s.length() > mxlen ) {
			if ( s.charAt( 0 ) == '/' && s.length() < filemxlen ) {
				return s;
			} else {
				return s.substring( 0, mxlen - 4 ) + " ...";
			}
		} else {
			return s;
		}
	}

	static final int maxlen = 60;
	static final int filemaxlen = 256;

	String keepShort( final Object x ) {
		return this.keepShort( x, maxlen, filemaxlen );
	}

	static final int min_pad_width = 8;

	void output() {
		final String d = this.desc.toUpperCase();
		Output.print( d );
		for ( int i = d.length(); i < min_pad_width; i++ ) {
			Output.print( " " );
		}
		Output.print( " : " );
		Output.println( this.keepShort( this.arg ) );
	}

}
