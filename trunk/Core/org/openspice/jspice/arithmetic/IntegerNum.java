package org.openspice.jspice.arithmetic;

import org.openspice.jspice.tools.Consumer;

public class IntegerNum extends IntegralNum {

	final private int value;

	public IntegerNum( final int value ) {
		this.value = value;
	}

	//  Literal integers from (say) -32 to 31 are shared.
    private final static int width = 32;
    private final static IntegerNum[] integers = new IntegerNum[ 2 * width ];

    static {
        for ( int i = 0-width; i < width; i++ ) {
            integers[ i + width ] = new IntegerNum( i );
        }
    }

    public static IntegerNum make( final int n ) {
        return (
            -width <= n && n < width ? integers[ width + n ] :
            new IntegerNum( n )
        );
    }

	public Num widenTo( final Num n ) {
		if ( n instanceof IntegerNum ) {
			return this;
		} else if ( n.isExact() ) {
			return this.widenExactly().widenTo( n );
		} else {
			return this.widenInexactly().widenTo( n );
		}
	}

	public RealNum widenToReal( final RealNum that ) {
		if ( that instanceof IntegerNum ) {
			return this;
		} else if ( that.isExact() ) {
			return this.widenExactly().widenToReal( that );
		} else {
			return this.widenInexactly().widenToReal( that );
		}
	}

	public RealNum widenExactly() {
		return new BigIntegerNum( this.value );
	}

	public RealNum widenInexactly() {
		return new DoubleNum( this.value );
	}

	public Num abs() {
		//	Note that Math.abs( Integer.MIN_VALUE ) really is a special case.
		if ( this.value == Integer.MIN_VALUE ) return BigIntegerNum.INT_MIN_VALUE.abs();
		return new IntegerNum( Math.abs( this.value ) );
	}

	public Num negate() {
		if ( this.value == Integer.MIN_VALUE ) {
			return BigIntegerNum.INT_MIN_VALUE.negate();
		} else {
			return new IntegerNum( -this.value );
		}
	}



	public Num add( final Num num ) {
		if ( num instanceof IntegerNum ) {
			final long r = this.longValue() + num.longValue();
			if ( Integer.MIN_VALUE <= r && r <= Integer.MAX_VALUE ) {
				return new IntegerNum( (int)r );
			} else {
				return new BigIntegerNum( r );
			}
		} else {
			return this.addThenCanonize( num );
		}
	}

	public RealNum addReal( final RealNum that ) {
		if ( that instanceof IntegerNum ) {
			final long r = this.longValue() + that.longValue();
			if ( Integer.MIN_VALUE <= r && r <= Integer.MAX_VALUE ) {
				return new IntegerNum( (int)r );
			} else {
				return new BigIntegerNum( r );
			}
		} else {
			return this.addRealThenCanonize( that );
		}

	}

	public Num sub( final Num num ) {
		if ( num instanceof IntegerNum ) {
			final long r = this.longValue() - num.longValue();
			if ( Integer.MIN_VALUE <= r && r <= Integer.MAX_VALUE ) {
				return new IntegerNum( (int)r );
			} else {
				return new BigIntegerNum( r );
			}
		} else {
			return this.subThenCanonize( num );
		}
	}

	public RealNum subReal( final RealNum that ) {
		if ( that instanceof IntegerNum ) {
			final long r = this.longValue() - that.longValue();
			if ( Integer.MIN_VALUE <= r && r <= Integer.MAX_VALUE ) {
				return new IntegerNum( (int)r );
			} else {
				return new BigIntegerNum( r );
			}
		} else {
			return this.subRealThenCanonize( that );
		}
	}

	public Num mod( final Num num ) {
		if ( num instanceof IntegerNum ) {
			return new IntegerNum( this.intValue() % num.intValue() );
		} else {
			return this.modThenCanonize( num );
		}
	}


    public Num div( final Num num ) {
        if ( num instanceof IntegerNum ) {
            return new IntegerNum( this.intValue() / num.intValue() );
        } else {
            return this.divThenCanonize( num );
        }
    }

	public RealNum divReal( final RealNum that ) {
		if ( that instanceof IntegerNum ) {
			return new IntegerNum( this.intValue() / that.intValue() );
		} else {
			return this.divRealThenCanonize( that );
		}

	}

	public Num divide( Num num ) {
		if ( num instanceof IntegerNum ) {
			return RatioNum.make( this.value, ((IntegerNum)num).value );
		} else {
			return this.divideThenCanonize( num );
		}
	}

	public Num mul( Num num ) {
		if ( num instanceof IntegerNum ) {
			final long r = this.longValue() * num.longValue();
			if ( Integer.MIN_VALUE <= r && r <= Integer.MAX_VALUE ) {
				return new IntegerNum( (int)r );
			} else {
				return new BigIntegerNum( r );
			}
		} else {
			return this.addThenCanonize( num );
		}

	}

	public RealNum mulReal( final RealNum that ) {
		if ( that instanceof IntegerNum ) {
			final long r = this.longValue() * that.longValue();
			if ( Integer.MIN_VALUE <= r && r <= Integer.MAX_VALUE ) {
				return new IntegerNum( (int)r );
			} else {
				return new BigIntegerNum( r );
			}
		} else {
			return this.addRealThenCanonize( that );
		}
	}

	public Num sqrt() {
		return sqrtDouble( this.value );
	}

	public boolean isGreaterThan( Num that ) {
		if ( that instanceof IntegerNum ) {
			return this.value > ((IntegerNum)that).value;
		} else {
			return this.widenThenGreaterThan( that );
		}

	}

	public boolean isGreaterThanOrEqualTo( Num that ) {
		if ( that instanceof IntegerNum ) {
			return this.value >= ((IntegerNum)that).value;
		} else {
			return this.widenThenGreaterThanOrEqual( that );
		}

	}

	public boolean isLessThan( Num that ) {
		if ( that instanceof IntegerNum ) {
			return this.value < ((IntegerNum)that).value;
		} else {
			return this.widenThenLessThan( that );
		}

	}

	public boolean isLessThanOrEqualTo( Num that ) {
		if ( that instanceof IntegerNum ) {
			return this.value <= ((IntegerNum)that).value;
		} else {
			return this.widenThenLessThanOrEqual( that );
		}
	}

	public boolean isNumEquals( final Num that ) {
		if ( that instanceof IntegerNum ) {
			return this.value == ((IntegerNum)that).value;
		} else {
			return this.widenThenNumEquals( that );
		}
	}

	public int intValue() {
		return this.value;
	}

	public long longValue() {
		return this.value;
	}

	public float floatValue() {
		return this.value;
	}

	public double doubleValue() {
		return this.value;
	}

	public void showTo( Consumer cuchar ) {
		cuchar.outCharSequence( Integer.toString( this.value ) );
	}

	public static final IntegerNum MINUS_ONE = new IntegerNum( -1 );
	public static final IntegerNum ZERO = new IntegerNum( 0 );
	public static final IntegerNum ONE = new IntegerNum( 1 );

}
