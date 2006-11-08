package org.openspice.jspice.arithmetic;

import org.openspice.jspice.tools.Consumer;
import org.openspice.jspice.tools.SysAlert;

import java.math.BigDecimal;
import java.math.BigInteger;


public class DoubleNum extends RealNum {

	final private double value;

	public DoubleNum( final double value ) {
		this.value = value;
	}

	public Num abs() {
		return new DoubleNum( Math.abs( this.value ) );
	}

	public IntegralNum intOf() {
		return (
			BigIntegerNum.make(
				new BigInteger(
					String.valueOf(
						this.value < 0 ? Math.ceil( this.value ) : Math.floor( this.value )
					)
				)
			)
		);
	}

	public Num negate() {
		return new DoubleNum( -this.value );
	}

	public Num sqrt() {
		return sqrtDouble( this.value );
	}

	public Num add( final Num num ) {
		if ( num instanceof DoubleNum ) {
			return new DoubleNum( this.doubleValue() + ((DoubleNum)num).doubleValue() );
		} else {
			return this.addThenCanonize( num );
		}
	}

	public RealNum addReal( final RealNum num ) {
		if ( num instanceof DoubleNum ) {
			return new DoubleNum( this.doubleValue() + ((DoubleNum)num).doubleValue() );
		} else {
			return this.addRealThenCanonize( num );
		}
	}

	public Num sub( final Num num ) {
		if ( num instanceof DoubleNum ) {
			return new DoubleNum( this.doubleValue() - ((DoubleNum)num).doubleValue() );
		} else {
			return this.subThenCanonize( num );
		}
	}

	public RealNum subReal( final RealNum num ) {
		if ( num instanceof DoubleNum ) {
			return new DoubleNum( this.doubleValue() - ((DoubleNum)num).doubleValue() );
		} else {
			return this.subRealThenCanonize( num );
		}
	}

	public Num mul( final Num num ) {
		if ( num instanceof DoubleNum ) {
			return new DoubleNum( this.doubleValue() * ((DoubleNum)num).doubleValue() );
		} else {
			return this.divThenCanonize( num );
		}

	}

	public RealNum mulReal( final RealNum num ) {
		if ( num instanceof DoubleNum ) {
			return new DoubleNum( this.doubleValue() * ((DoubleNum)num).doubleValue() );
		} else {
			return this.divRealThenCanonize( num );
		}

	}

	public Num mod( final Num num ) {
		if ( num instanceof DoubleNum ) {
			return new BigIntegerNum( new BigDecimal( this.value % ((DoubleNum)num).value ).toBigInteger() );
		} else {
			return this.modThenCanonize( num );
		}
	}

	public Num div( final Num num ) {
	   if ( num instanceof DoubleNum ) {
		   return new BigIntegerNum( new BigDecimal( this.value / ((DoubleNum)num).value ).toBigInteger() );
	   } else {
		   return this.divThenCanonize( num );
	   }
   }

	public RealNum divReal( final RealNum num ) {
	   if ( num instanceof DoubleNum ) {
		   return new BigIntegerNum( new BigDecimal( this.value / ((DoubleNum)num).value ).toBigInteger() );
	   } else {
		   return this.divRealThenCanonize( num );
	   }
   }

	public Num divide( final Num num ) {
		if ( num instanceof DoubleNum ) {
			return new DoubleNum( this.doubleValue() / ((DoubleNum)num).doubleValue() );
		} else {
			return this.divideThenCanonize( num );
		}
	}

	public boolean isGreaterThan( final Num that ) {
		if ( that instanceof DoubleNum ) {
			return this.value > ((DoubleNum)that).value;
		} else {
			return this.widenThenGreaterThan( that );
		}
	}

	public boolean isGreaterThanOrEqualTo( final Num that ) {
		if ( that instanceof DoubleNum ) {
			return this.value >= ((DoubleNum)that).value;
		} else {
			return this.widenThenGreaterThanOrEqual( that );
		}
	}

	public boolean isLessThan( final Num that ) {
		if ( that instanceof DoubleNum ) {
			return this.value < ((DoubleNum)that).value;
		} else {
			return this.widenThenLessThan( that );
		}
	}

	public boolean isLessThanOrEqualTo( final Num that ) {
		if ( that instanceof DoubleNum ) {
			return this.value <= ((DoubleNum)that).value;
		} else {
			return this.widenThenLessThanOrEqual( that );
		}
	}

	public boolean isNumEquals( final Num that ) {
		if ( that instanceof DoubleNum ) {
			return this.value == ((DoubleNum)that).value;
		} else {
			return this.widenThenNumEquals( that );
		}

	}

	public int intValue() {
		return (int)this.value;
	}

	public long longValue() {
		return (long)this.value;
	}

	public float floatValue() {
		return (float)this.value;
	}

	public double doubleValue() {
		return this.value;
	}

	public Num widenTo( final Num n ) {
		if ( n instanceof RealNum ) {
			return this;
		} else {
			return this.widenInexactly().widenTo( n );
		}
	}

	public RealNum widenToReal( final RealNum n ) {
		return this;
	}

	public Num widenExactly() {
		throw SysAlert.unreachable();
	}

	public Num widenInexactly() {
		return new ComplexNum( this, DoubleNum.ONE );
	}

	public boolean isExact() {
		return false;
	}

	public void showTo( Consumer cuchar ) {
		cuchar.outCharSequence( Double.toString( this.value ) );
	}

	public static final DoubleNum ONE = new DoubleNum( 1.0 );

}
