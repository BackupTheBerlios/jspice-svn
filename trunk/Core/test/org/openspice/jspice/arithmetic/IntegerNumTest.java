package org.openspice.jspice.arithmetic;

import junit.framework.TestCase;

public class IntegerNumTest extends TestCase {
	
	
	public void testMulSmall() {
		final IntegerNum m = new IntegerNum( 99 );
		final IntegerNum n = new IntegerNum( 88 );
		final Num r = m.mul( n );
		assertEquals( 99 * 88, r.longValue() );
	}

	public void testMulBig() {
		final IntegerNum m = new IntegerNum( 100000 );
		final IntegerNum n = new IntegerNum( 100000 );
		final Num r = m.mul( n );
		assertEquals( "10000000000", r.toString() );
	}

	public void testMulMixed() {
		final IntegerNum i = new IntegerNum( 100000 );
		final IntegerNum j = new IntegerNum( 100000 );
		final IntegerNum k = new IntegerNum( 100000 );
		final Num r = j.mul( j.mul( k ) );
		assertEquals( "1000000000000000", r.toString() );
	}

	public void testAddSmall() {
		final IntegerNum m = new IntegerNum( 99 );
		final IntegerNum n = new IntegerNum( 88 );
		final Num r = m.add( n );
		assertEquals( 99 + 88, r.longValue() );
	}

	public void testAddBig() {
		final IntegerNum m = new IntegerNum( Integer.MAX_VALUE );
		final IntegerNum n = new IntegerNum( Integer.MAX_VALUE );
		final Num r = m.add( n );
		assertTrue( r instanceof BigIntegerNum );
		assertEquals( 2L * (long)Integer.MAX_VALUE, r.longValue() );
	}

	public void testAddBigNeg() {
		final IntegerNum m = new IntegerNum( Integer.MIN_VALUE );
		final IntegerNum n = new IntegerNum( Integer.MIN_VALUE );
		final Num r = m.add( n );
		assertTrue( r instanceof BigIntegerNum );
		assertEquals( 2L * (long)Integer.MIN_VALUE, r.longValue() );
	}

	public void testAddMixed() {
		final IntegerNum i = new IntegerNum( 100000 );
		final IntegerNum j = new IntegerNum( 100000 );
		final IntegerNum k = new IntegerNum( 100000 );
		final Num r = j.add( j.mul( k ) );
		assertEquals( "10000100000", r.toString() );
	}

}
