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
package org.openspice.jspice.main.test;

import java.util.ArrayList;
import java.util.List;

import org.openspice.jspice.arithmetic.IntegerNum;
import org.openspice.tools.IntegerTools;
import junit.framework.Test;
import junit.framework.TestSuite;

public class TestLiteralEvaluation extends SpiceTestBase {

	public TestLiteralEvaluation() {
	}

	public final static Test suite() {
		return new TestSuite( TestLiteralEvaluation.class );
	}

	public void testNullInput() {
		assertEquals( new ArrayList(), interpret( "" ) );
	}

	public void testJustZero() {
		final List< Object > list = interpret( "0" );
		assertSame( 1, list.size() );
		final Number num = (Number)list.get( 0 );
		assertTrue( num.longValue() == 0 );
	}

	public void testJustOne() {
		final List< Object > list = interpret( "1" );
		assertSame( 1, list.size() );
		final Number num = (Number)list.get( 0 );
		assertTrue( num.longValue() == 1 );
	}

	public void testJustLiteralString() {
		assertEquals( one( "fred" ), interpret( "\"fred\"" ) );
	}

	public void testJustLiteralCharacters() {
		assertEquals( two( new Character( 'p' ), new Character( 'q' ) ), interpret( "'pq'" ) );
	}

	public void testJustTrue() {
		assertEquals( one( Boolean.TRUE ), interpret( "true" ) );
	}



}
