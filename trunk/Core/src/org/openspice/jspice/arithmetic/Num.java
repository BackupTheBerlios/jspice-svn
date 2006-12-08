package org.openspice.jspice.arithmetic;

import org.openspice.jspice.tools.Consumer;
import org.openspice.jspice.tools.Printable;
import org.openspice.jspice.tools.Showable;
import org.openspice.jspice.tools.SysAlert;

import java.math.BigInteger;
import java.math.BigDecimal;

/*
 * The tower of exact numbers is fairly complicated in Java.
 * 		Byte -> Short -> Integer -> Long -> BigInteger
 * And inexacts look like this
 * 		Float -> Double -> BigDecimal
 *
 * In order to map this into Spice's number system we will
 * utilize Integer and BigInteger for exact numbers, coercing
 * up as required, and Double for inexact numbers.  Then we
 * will create Rationals for exacts.  And lastly Complex.
 */

/*
 * Tower of number types
 * 		Integer		} Integral	}			}
 * 		BigInteger	}			} Rational	}
 * 		Ratio					}			} Real
 * 		Double								}
 * 		Complex
 */

/**
 * The purpose of the Num class is to provide a full
 * implementation of arithmetic - while inheriting from
 * Number so that interfacing with Java is not too tricky.
 * Because Number is an abstract class rather than an
 * interface, this constrains Num to being a non-interface
 * too.
 */
public abstract class Num extends Number implements Showable, Printable {
	
	public void printTo( final Consumer cuchar ) {
		this.showTo( cuchar );
	}

	public static final Num toNum( final Number x ) {
		if ( x instanceof Integer ) {
			return new IntegerNum( x.intValue() );
		} else if ( x instanceof Double ) {
			return new DoubleNum( ((Double)x).doubleValue() );
		} else if ( x instanceof BigInteger ) {
			//	Standard representation.
			return new BigIntegerNum( (BigInteger)x );
		} else if ( x instanceof Byte || x instanceof Short ) {
			return new IntegerNum( x.intValue() );
		} else if ( x instanceof Long || x instanceof BigDecimal ) {
			return new DoubleNum( x.doubleValue() );
		} else if ( x instanceof Num ) {
			return (Num)x;
		} else {
			//	I'm not entirely sure this is the way to handle this problem ....
			new SysAlert( "Converting unrecognized number type to Double" ).culprit( "number", x ).warning();
			return new DoubleNum( x.doubleValue() );
		}
	}

	protected Num sqrtDouble( final double d ) {
		if ( d >= 0 ) return new DoubleNum( Math.sqrt( d ) );
		return ComplexNum.make( IntegerNum.ZERO, new DoubleNum( Math.sqrt( -d ) ) );
	}

	public boolean isReal() {
		return false;
	}

	public boolean isIntegral() {
		return false;
	}

	public boolean isRational() {
		return false;
	}

	public boolean isExact() {
		return true;
	}

	public abstract Num abs();
	public abstract Num intOf();
	public abstract Num negate();
	public abstract Num sqrt();

	public Num canonize() {
		return this;
	}

	public abstract Num widenTo( Num n );

	public abstract Num widenExactly();
	public abstract Num widenInexactly();

	public abstract Num add( final Num num );

	public final Num addThenCanonize( final Num num ) {
		return this.widenTo( num ).add( num.widenTo( this ) ).canonize();
	}

	public abstract Num div( final Num num );

	public final Num divThenCanonize( final Num num ) {
		return this.widenTo( num ).div( num.widenTo( this ) ).canonize();
	}

	public abstract Num mul( final Num num );

	public final Num mulThenCanonize( final Num num ) {
		return this.widenTo( num ).mul( num.widenTo( this ) ).canonize();
	}

	/*
		divid  mod  divis  ->  mod                                  [operator 2]
        	Returns divid modulo  divis, where  both numbers  must be  real.
        	This is defined as

            divid rem divis -> rem;
            if (divis > 0 and rem < 0) or (divis < 0 and rem >= 0) then
                rem+divis -> mod
            else
                rem -> mod
            endif

        (i.e. the result always has the same sign as the divisor).
	*/
	public Num mod( final Num num ) {
		final Num rem = this.rem( num );
		if (
			num.greaterThan( Num.ZERO ).booleanValue() && rem.lessThan( Num.ZERO ).booleanValue() ||
			num.lessThan( Num.ZERO ).booleanValue() && rem.greaterThanOrEqualTo( Num.ZERO ).booleanValue()
		) {
			return rem.add( num );
		}
		return rem;
	}

	public final Num modThenCanonize( final Num num ) {
		return this.widenTo( num ).mod( num.widenTo( this ) ).canonize();
	}

	/*
		divid  rem  divis  ->  rem
        	divid - (quot * divis) -> rem
	*/
	public Num rem( final Num num ) {
		return this.sub( this.div( num ).mul( num ) );
	}

	public abstract Num divide( final Num num );

	public final Num divideThenCanonize( final Num num ) {
		return this.widenTo( num ).divide( num.widenTo( this ) ).canonize();
	}

	public abstract Num sub( final Num num );

	public final Num subThenCanonize( final Num num ) {
		return this.widenTo( num ).sub( num.widenTo( this ) ).canonize();
	}

	public abstract boolean isGreaterThan( final Num that );

	public final Boolean greaterThan( final Num that ) {
		return Boolean.valueOf( this.isGreaterThan( that ) );
	}

	public final boolean widenThenGreaterThan( final Num num ) {
		return this.widenTo( num ).isGreaterThan( num.widenTo( this ) );
	}

	public abstract boolean isGreaterThanOrEqualTo( final Num that );

	public final Boolean greaterThanOrEqualTo( final Num that ) {
		return Boolean.valueOf( this.isGreaterThanOrEqualTo( that ) );
	}

	public final boolean widenThenGreaterThanOrEqual( final Num num ) {
		return this.widenTo( num ).isGreaterThanOrEqualTo( num.widenTo( this ) );
	}

	public abstract boolean isLessThan( final Num that );

	public final Boolean lessThan( final Num that ) {
		return Boolean.valueOf( this.isLessThan( that ) );
	}

	public final boolean widenThenLessThan( final Num num ) {
		return this.widenTo( num ).isLessThan( num.widenTo( this ) );
	}

	public abstract boolean isLessThanOrEqualTo( final Num that );

	public final boolean lessThanOrEqualTo( final Num that ) {
		return this.isLessThanOrEqualTo( that );
	}

	public final boolean widenThenLessThanOrEqual( final Num num ) {
		return this.widenTo( num ).isLessThanOrEqualTo( num.widenTo( this ) );
	}

	public abstract boolean isNumEquals( Num that );

	public final Boolean numEquals( final Num that ) {
		return this.isNumEquals( that );
	}

	public boolean widenThenNumEquals( final Num that ) {
		return this.widenTo( that ).isNumEquals( that.widenTo( this ) );
	}

	public Boolean numNotEquals( final Num that ) {
		return !this.numEquals( that );
	}

	public static final IntegerNum ZERO = IntegerNum.ZERO;
}
