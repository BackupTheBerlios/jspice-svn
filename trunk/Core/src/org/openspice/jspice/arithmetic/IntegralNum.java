package org.openspice.jspice.arithmetic;

import java.math.BigInteger;

public abstract class IntegralNum extends RationalNum {

	public boolean isIntegral() {
		return true;
	}

	public IntegralNum intOf() {
		return this;
	}

	public static final BigInteger MIN = new BigInteger( Integer.MIN_VALUE + "" );
	public static final BigInteger MAX = new BigInteger( Integer.MAX_VALUE + "" );

	public static final IntegralNum make( final BigInteger n ) {
		if ( MIN.compareTo( n ) <= 0 && n.compareTo( MAX ) <= 0 ) {
			return new IntegerNum( n.intValue() );
		} else {
			return new BigIntegerNum( n );
		}
	}

}
