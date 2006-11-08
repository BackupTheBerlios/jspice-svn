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
package org.openspice.jspice.arithmetic;

import org.openspice.jspice.tools.SysAlert;
import org.openspice.jspice.tools.Consumer;

import java.math.BigInteger;

public final class RatioNum extends RationalNum {

	private final BigInteger numerator;		//	must have no common divisor
	private final BigInteger denominator;	//	must be +ve, nonzero

	//	Danger!  This is an unsafe constructor.
	private RatioNum( final BigInteger n, final BigInteger d  ) {
		this.numerator = n;
		this.denominator = d;
	}

	public static final RatioNum widen( final BigIntegerNum n ) {
		return new RatioNum( n.getBigInteger(), BigInteger.ONE );
	}

	public RationalNum canonize() {
		final BigInteger c = this.numerator.gcd( this.denominator );
		if ( c.compareTo( BigInteger.ONE ) == 0 ) return this;
		return make( this.numerator, this.denominator );
	}

	public static Num make( final int a, final int b ) {
		return make( BigInteger.valueOf( a ), BigInteger.valueOf( b ) );
	}

	public static Num make( final Integer a, final Integer b ) {
		return make( BigInteger.valueOf( a.longValue() ), BigInteger.valueOf( b.longValue() ) );
	}

	public static RationalNum make( BigInteger n, BigInteger d  ) {
		final int dsign = d.compareTo( BigInteger.ZERO );

		//	Sort out signs.
		if ( dsign == 0 ) {
			new SysAlert( "Divide by zero", "Rational numbers must have non-zero denominator" ).mishap();
		} else if ( dsign < 0 ) {
			n = n.negate();
			d = d.negate();
		}

		final BigInteger c = n.gcd( d );
		if ( c.compareTo( BigInteger.ONE ) > 0 ) {
			n = n.divide( c );
			d = d.divide( c );
		}
		if ( d.compareTo( BigInteger.ONE ) == 0 ) {
			return new BigIntegerNum( n );
		} else {
			return new RatioNum( n, d );
		}
	}

	public BigInteger getNumerator() {
		return numerator;
	}

	public BigInteger getDenominator() {
		return denominator;
	}

	public static final int determinant( final RatioNum x, final RatioNum y) {
		final BigInteger nx = x.getNumerator();
		final BigInteger dx = x.getDenominator();
		final BigInteger ny = y.getNumerator();
		final BigInteger dy = y.getDenominator();

//		 nx     ny         nx * dy - ny * dx
//		---- - ----  ;     -----------------
//		 dx     dy              dx * dy

		final BigInteger nxdy = nx.multiply( dy );
		final BigInteger nydx = ny.multiply( dx );
		final int sign_dxdy = dx.signum() * dy.signum();
		final int nxdy_nydx = nxdy.compareTo( nydx );
		return sign_dxdy * nxdy_nydx;
	}

	//	---oooOOOooo---

	public int intValue() {
		return (int)( this.numerator.doubleValue() / this.denominator.doubleValue() );
	}

	public long longValue() {
		return (long)( this.numerator.doubleValue() / this.denominator.doubleValue() );
	}

	public float floatValue() {
		return (float)( this.numerator.doubleValue() / this.denominator.doubleValue() );
	}

	public double doubleValue() {
		return this.numerator.doubleValue() / this.denominator.doubleValue();
	}

	//	---oooOOOooo---

	public Num abs() {
		return new RatioNum( this.numerator.abs(), this.denominator );
	}

	public IntegralNum intOf() {
		return BigIntegerNum.make( this.numerator.abs().divide( this.denominator ).multiply( this.denominator ) );
	}

	public Num negate() {
		return new RatioNum( this.getNumerator().negate(), this.getDenominator() );
	}

	public Num sqrt() {
		return sqrtDouble( this.doubleValue() );
	}

    //	---oooOOOooo---

	public Num add( final Num num ) {
		if ( num instanceof RatioNum ) {
			final RatioNum that = (RatioNum)num;
			final BigInteger nx = this.getNumerator();
			final BigInteger dx = this.getDenominator();
			final BigInteger ny = that.getNumerator();
			final BigInteger dy = that.getDenominator();

	//		nx * dy + ny * dx		( nx * dy + ny * dx )
	//		-------   -------- = 	---------------------
	//		dx * dy   dy * dx				dx * dy

			return RatioNum.make( nx.multiply( dy ).add( ny.multiply( dx ) ), dx.multiply( dy ) );
		} else {
			return this.addThenCanonize( num );
		}
	}

	public RealNum addReal( final RealNum that ) {
		return (RealNum)this.add( that );
	}



	public Num sub( final Num num ) {
		if ( num instanceof RatioNum ) {
			final RatioNum that = (RatioNum)num;
			final BigInteger nx = this.getNumerator();
			final BigInteger dx = this.getDenominator();
			final BigInteger ny = that.getNumerator();
			final BigInteger dy = that.getDenominator();

	//		nx * dy - ny * dx		( nx * dy - ny * dx )
	//		-------   -------- = 	---------------------
	//		dx * dy   dy * dx				dx * dy

			return RatioNum.make( nx.multiply( dy ).subtract( ny.multiply( dx ) ), dx.multiply( dy ) );
		} else {
			return this.subThenCanonize( num );
		}
	}

	public RealNum subReal( final RealNum that ) {
		return (RealNum)this.sub( that );
	}

	public Num mul( final Num num ) {
		if ( num instanceof RatioNum ) {
			final RatioNum that = (RatioNum)num;
			final BigInteger nx = this.getNumerator();
			final BigInteger dx = this.getDenominator();
			final BigInteger ny = that.getNumerator();
			final BigInteger dy = that.getDenominator();
			return make( nx.multiply( ny ), dx.multiply( dy ) );
		} else {
			return this.mulThenCanonize( num );
		}
	}

	public RealNum mulReal( final RealNum that ) {
		return (RealNum)this.mul( that );
	}


    public Num div( final Num num ) {
		if ( num instanceof RatioNum ) {
			final RatioNum that = (RatioNum)num;
			final BigInteger nx = this.getNumerator();
			final BigInteger dx = this.getDenominator();
			final BigInteger ny = that.getNumerator();
			final BigInteger dy = that.getDenominator();

			//	( nx * dy ) div dx * ny

			return IntegralNum.make( nx.multiply( dy ).divide( dx.multiply( ny ) ) );
		} else {
			return this.divThenCanonize( num );
		}
	}

	public Num divide( final Num num ) {
		if ( num instanceof RatioNum ) {
			final RatioNum that = (RatioNum)num;
			final BigInteger nx = this.getNumerator();
			final BigInteger dx = this.getDenominator();
			final BigInteger ny = that.getNumerator();
			final BigInteger dy = that.getDenominator();

	//		nx * dy
	//		-------
	//		dx * ny

			return RatioNum.make( nx.multiply( dy ), dx.multiply( ny ) );
		} else {
			return this.divideThenCanonize( num );
		}
	}

	//	---oooOOOooo---


	public RealNum divReal( final RealNum that ) {
		return (RealNum)this.div( that );

	}

	public RealNum widenToReal( final RealNum that ) {
		if ( that.isExact() ) {
			return this;
		} else {
			return new DoubleNum( this.doubleValue() );
		}
	}


	//	---oooOOOooo---

	private int compare( final RatioNum num ) {
		final RatioNum that = (RatioNum)num;
		final BigInteger nx = this.getNumerator();
		final BigInteger dx = this.getDenominator();
		final BigInteger ny = that.getNumerator();
		final BigInteger dy = that.getDenominator();

//		nx * dy > ny * dx 		because dx > 0 and dy > 0

		return nx.multiply( dy ).compareTo( ny.multiply( dx ) );

	}


	public boolean isGreaterThan( final Num num ) {
		if ( num instanceof RatioNum ) {
			return this.compare( (RatioNum)num ) > 0;
		} else {
			return this.widenThenGreaterThan( num );
		}
	}

	public boolean isGreaterThanOrEqualTo( Num that ) {
		if ( that instanceof RatioNum ) {
			return this.compare( (RatioNum)that ) > 0;
		} else {
			return this.widenThenGreaterThanOrEqual( that );
		}
	}

	public boolean isLessThan( Num that ) {
		if ( that instanceof RatioNum ) {
			return this.compare( (RatioNum)that ) > 0;
		} else {
			return this.widenThenLessThan( that );
		}
	}

	public boolean isLessThanOrEqualTo( Num that ) {
		if ( that instanceof RatioNum ) {
			return this.compare( (RatioNum)that ) > 0;
		} else {
			return this.widenThenLessThanOrEqual( that );
		}
	}

	public boolean isNumEquals( final Num that ) {
		if ( that instanceof RatioNum ) {
			final RatioNum r = (RatioNum)that;
			return this.numerator.equals( r.numerator ) && this.denominator.equals( r.denominator );
		} else {
			return this.widenThenNumEquals( that );
		}
	}

    //	---oooOOOooo---

	public Num widenTo( final Num n ) {
		if ( n instanceof RationalNum ) {
			return this;
		} else if ( n.isExact() ) {
			return this.widenExactly().widenTo( n );
		} else {
			return this.widenInexactly().widenTo( n );
		}
	}

	public Num widenExactly() {
		return new ComplexNum( this, IntegerNum.ONE );
	}

	public Num widenInexactly() {
		return new DoubleNum( this.doubleValue() );
	}

	//	---oooOOOooo---

	public void showTo( Consumer cuchar ) {
		cuchar.outObject( this.numerator );
		cuchar.out( '/' );
		cuchar.outObject( this.denominator );
	}

}
