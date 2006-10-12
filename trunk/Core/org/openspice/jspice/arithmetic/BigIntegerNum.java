package org.openspice.jspice.arithmetic;

import org.openspice.jspice.tools.Consumer;

import java.math.BigInteger;


public class BigIntegerNum extends IntegralNum {


	private static final long serialVersionUID = 3173959050725126887L;
	final private BigInteger bigInteger;

	public BigIntegerNum( BigInteger bigInteger ) {
		this.bigInteger = bigInteger;
	}

	public BigIntegerNum( final long n ) {
		this.bigInteger = BigInteger.valueOf( n );
	}

	public BigIntegerNum( final String s ) {
		this.bigInteger = new BigInteger( s );
	}

	public BigInteger getBigInteger() {
		return this.bigInteger;
	}

	public DoubleNum toDoubleNum() {
		return new DoubleNum( this.bigInteger.doubleValue() );
	}

	public Num widenTo( final Num n ) {
		if ( n instanceof IntegralNum ) {
			return this;
		} else if ( n.isExact() ) {
			return this.widenExactly().widenTo( n );
		} else {
			return this.widenInexactly().widenTo( n );
		}
	}

	public RealNum widenToReal( final RealNum n ) {
		if ( n instanceof IntegralNum ) {
			return this;
		} else if ( n.isExact() ) {
			return this.widenExactly().widenToReal( n );
		} else {
			return this.widenInexactly().widenToReal( n );
		}
	}

	public RatioNum widenExactly() {
		return RatioNum.widen( this );
	}

	public DoubleNum widenInexactly() {
		return new DoubleNum( this.doubleValue() );
	}

	public int intValue() {
		return bigInteger.intValue();
	}

	public long longValue() {
		return bigInteger.longValue();
	}

	public float floatValue() {
		return bigInteger.floatValue();
	}

	public double doubleValue() {
		return bigInteger.doubleValue();
	}

	public byte byteValue() {
		return bigInteger.byteValue();
	}

	public short shortValue() {
		return bigInteger.shortValue();
	}

	public void showTo( Consumer cuchar ) {
		cuchar.outObject( this.bigInteger );
	}

	public Num abs() {
		return new BigIntegerNum( this.bigInteger.abs() );
	}

	public Num negate() {
		return new BigIntegerNum( this.bigInteger.negate() );
	}

	public Num sqrt() {
		return sqrtDouble( this.bigInteger.doubleValue() );
	}

	public Num add( final Num num ) {
        if ( num instanceof BigIntegerNum ) {
            return new BigIntegerNum( this.bigInteger.add( ((BigIntegerNum)num).bigInteger ) );
		} else {
			return this.addThenCanonize( num );
		}
	}

	public RealNum addReal( final RealNum num ) {
        if ( num instanceof BigIntegerNum ) {
            return new BigIntegerNum( this.bigInteger.add( ((BigIntegerNum)num).bigInteger ) );
		} else {
			return this.addRealThenCanonize( num );
		}
	}

	public Num mod( final Num num ) {
		if ( num instanceof BigIntegerNum ) {
			return new BigIntegerNum( this.bigInteger.mod( ((BigIntegerNum)num).bigInteger ) );
		} else {
			return this.modThenCanonize( num );
		}
	}

	public Num div( final Num num ) {
		if ( num instanceof BigIntegerNum ) {
			return new BigIntegerNum( this.bigInteger.divide( ((BigIntegerNum)num).bigInteger ) );
		} else {
			return this.divThenCanonize( num );
		}
	}

	public RealNum divReal( final RealNum num ) {
		if ( num instanceof BigIntegerNum ) {
			return new BigIntegerNum( this.bigInteger.divide( ((BigIntegerNum)num).bigInteger ) );
		} else {
			return this.divRealThenCanonize( num );
		}
	}

	public RealNum div( final RealNum num ) {
		if ( num instanceof BigIntegerNum ) {
			return new BigIntegerNum( this.bigInteger.divide( ((BigIntegerNum)num).bigInteger ) );
		} else {
			return this.divRealThenCanonize( num );
		}
	}

	public Num divide( final Num num ) {
		if ( num instanceof BigIntegerNum ) {
			return new DoubleNum( this.doubleValue() / num.doubleValue() );
		} else {
			return this.divThenCanonize( num );
		}
	}

	public Num mul( final Num num ) {
		if ( num instanceof BigIntegerNum ) {
			return new BigIntegerNum( this.bigInteger.multiply( ((BigIntegerNum)num).bigInteger ) );
		} else {
			return this.mulThenCanonize( num );
		}
	}

	public RealNum mulReal( final RealNum num ) {
		if ( num instanceof BigIntegerNum ) {
			return new BigIntegerNum( this.bigInteger.multiply( ((BigIntegerNum)num).bigInteger ) );
		} else {
			return this.mulRealThenCanonize( num );
		}
	}

	public Num sub( final Num num ) {
        if ( num instanceof BigIntegerNum ) {
            return new BigIntegerNum( this.bigInteger.subtract( ((BigIntegerNum)num).bigInteger ) );
		} else {
			return this.subThenCanonize( num );
		}
	}

	public RealNum subReal( final RealNum num ) {
        if ( num instanceof BigIntegerNum ) {
            return new BigIntegerNum( this.bigInteger.subtract( ((BigIntegerNum)num).bigInteger ) );
		} else {
			return this.subRealThenCanonize( num );
		}
	}

	public boolean isGreaterThan( final Num that ) {
		if ( that instanceof BigIntegerNum ) {
			final int c = this.bigInteger.compareTo( ((BigIntegerNum)that).bigInteger );
			return c > 0;
		} else {
			return this.widenThenGreaterThan( that );
		}

	}

	public boolean isGreaterThanOrEqualTo( final Num that ) {
		if ( that instanceof BigIntegerNum ) {
			final int c = this.bigInteger.compareTo( ((BigIntegerNum)that).bigInteger );
			return c >= 0;
		} else {
			return this.widenThenGreaterThanOrEqual( that );
		}

	}

	public boolean isLessThan( final Num that ) {
		if ( that instanceof BigIntegerNum ) {
			final int c = this.bigInteger.compareTo( ((BigIntegerNum)that).bigInteger );
			return c < 0;
		} else {
			return this.widenThenLessThan( that );
		}

	}

	public boolean isLessThanOrEqualTo( final Num that ) {
		if ( that instanceof BigIntegerNum ) {
			final int c = this.bigInteger.compareTo( ((BigIntegerNum)that).bigInteger );
			return c <= 0;
		} else {
			return this.widenThenLessThanOrEqual( that );
		}

	}

	public boolean isNumEquals( final Num that ) {
		if ( that instanceof BigIntegerNum ) {
			return this.equals( that );
		} else {
			return this.widenThenNumEquals( that );
		}

	}

	public Boolean numNotEquals( Num that ) {
		return !this.numEquals( that );
	}


	public static final BigIntegerNum INT_MIN_VALUE = new BigIntegerNum( BigInteger.valueOf( Integer.MIN_VALUE ) );
	public static final BigIntegerNum INT_MAX_VALUE = new BigIntegerNum( BigInteger.valueOf( Integer.MAX_VALUE ) );
	public static final BigIntegerNum ONE = new BigIntegerNum( 1 );

}
