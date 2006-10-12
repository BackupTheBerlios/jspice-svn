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
package org.openspice.jspice.built_in.regexs;

import org.openspice.jspice.datatypes.proc.Binary1InvokeProc;
import org.openspice.jspice.datatypes.proc.Proc;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class IsPrefixMatchProc extends Binary1InvokeProc {

	{
		setDescription( "isPrefixMatch", "%p( R:RegEx, S:String ) -> Bool", "Returns true if S starts with a match for R, else false" );
	}

	public static final IsPrefixMatchProc IS_PREFIX_MATCH_PROC = new IsPrefixMatchProc();

	public Object invoke( final Object regexp, final Object str ) {
		final Matcher x = ((Pattern)regexp).matcher( (CharSequence)str );
		return x.lookingAt() ? Boolean.TRUE : Boolean.FALSE;
	}

}
