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


import org.openspice.jspice.tools.Consumer;
import org.openspice.jspice.tools.SysAlert;
import org.openspice.tools.IntegerTools;


public final class ComplexNum extends Num {
	
	private static final long serialVersionUID = 4714949670458535996L;
	
	private final RealNum real_part;
	private final RealNum imag_part;

	//	Danger! - Num must not be complex!
	ComplexNum( final RealNum r, final RealNum i  ) {
		this.real_part = r;
		this.imag_part = i;
	}

	public static Num make( final RealNum r, final RealNum i  ) {
		if ( NumEqual.equal( i, IntegerTools.ZERO ) ) {
			return r;
		} else {
			return new ComplexNum( r, i );
		}
	}

	public RealNum getRealPart() {
		return real_part;
	}

	public RealNum getImagPart() {
		return imag_part;
	}

	public boolean isExact() {
		return this.real_part.isExact() && this.imag_part.isExact();
	}

	public ComplexNum conjugate() {
		//	This cast will be superfluous in Java 5 because of the covariants return types.
		return new ComplexNum( this.real_part, (RealNum)this.imag_part.negate() );
	}

	private double magnitude() {
		final double r = this.real_part.doubleValue();
		final double i = this.imag_part.doubleValue();
		return Math.sqrt( r * r + i * i );
	}

	public Num abs() {
		return new DoubleNum( this.magnitude() );
	}

	public Double phase() {
		final double r = this.real_part.doubleValue();
		final double i = this.imag_part.doubleValue();
		return new Double( Math.atan2( i, r ) );
	}

	public Num reciprocal() {
		final double r = this.real_part.doubleValue();
		final double i = this.imag_part.doubleValue();
		final double abs2 = r * r + i * i;
		return make( new DoubleNum( r / abs2 ), new DoubleNum( -i/abs2 ) );
	}

	public Num sqrt() {
		final double r = this.real_part.doubleValue();
		final double i = this.imag_part.doubleValue();
		final double theta = Math.atan2( i, r ) / 2.0;
		final double mag = Math.sqrt( Math.sqrt( r * r + i * i ) );
		return make( new DoubleNum( mag * Math.cos( theta ) ), new DoubleNum( mag * Math.sin( theta ) ) );
	}


	public Num negate() {
		//	Should be able to eliminate this in Java 5 with co-variant return types.
		return ComplexNum.make( (RealNum)this.getRealPart().negate(), (RealNum)this.getImagPart() );
	}

	//	---oooOOOooo---

	public Num add( final Num num ) {
		if ( num instanceof ComplexNum ) {
			final ComplexNum y = (ComplexNum)num;
			return (
				ComplexNum.make(
					this.getRealPart().addReal( y.getRealPart() ),
					this.getImagPart().addReal( y.getImagPart() )
				)
			);
		} else {
			return this.addThenCanonize( num );
		}
	}

	public Num intOf() {
		return (
			ComplexNum.make(
				(RealNum)this.getRealPart().intOf(),
				(RealNum)this.getImagPart().intOf()
			)
		);
	}

	/*
		divid  div  divis  ->  quot
            intof(divid / divis) -> quot
    */
    public Num div( final Num num ) {
		return this.divide( num ).intOf();
    }


	public Num mod( final Num num ) {
		return this.sub( this.div( num ).mul( num ) );
	}



	public Num divide( Num num ) {
		if ( num instanceof ComplexNum ) {
			return Mul.MUL.apply( this, ((ComplexNum)num).reciprocal() );
		} else {
			return this.divideThenCanonize( num );
		}
	}

	public Num mul( final Num num ) {
		if ( num instanceof ComplexNum ) {
			final ComplexNum that = (ComplexNum)num;
			final RealNum rx = this.getRealPart();
			final RealNum ix = this.getImagPart();
			final RealNum ry = that.getRealPart();
			final RealNum iy = that.getImagPart();
			return(
				ComplexNum.make(
					rx.mulReal( ry ).subReal( ix.mulReal( iy ) ),
					rx.mulReal( iy ).addReal( ix.mulReal( ry ) )
				)
			);
		} else {
			return this.mulThenCanonize( num );
		}
	}

	public Num sub( final Num num ) {
		if ( num instanceof ComplexNum ) {
			final ComplexNum y = (ComplexNum)num;
			return (
				ComplexNum.make(
					(RealNum)this.getRealPart().sub( y.getRealPart() ),
					(RealNum)this.getImagPart().sub( y.getImagPart() )
				)
			);
		} else {
			return this.subThenCanonize( num );
		}
	}

	private static final RuntimeException oops( final Num x, final Num y ) {
		throw new SysAlert( "Trying to compare complex numbers" ).culprit( "left operand", x ).culprit( "right operand", y ).mishap();
	}

	public boolean isGreaterThan( final Num that ) {
		throw oops( this, that );
	}

	public boolean isLessThan( final Num that ) {
		throw oops( this, that );
	}

	public boolean isGreaterThanOrEqualTo( final Num that ) {
		throw oops( this, that );
	}

	public boolean isLessThanOrEqualTo( final Num that ) {
		throw oops( this, that );
	}

	public boolean isNumEquals( final Num that ) {
		if ( that instanceof ComplexNum ) {
			final ComplexNum num = (ComplexNum)that;
			return(
				this.real_part.numEquals( num.real_part ).booleanValue() &&
				this.imag_part.numEquals( num.imag_part ).booleanValue()
			);
		} else {
			return this.widenThenNumEquals( that );
		}
	}

	public Boolean numNotEquals( final Num that ) {
		return !this.numEquals( that );
	}

	//	---oooOOOooo---

	public int intValue() {
		return this.abs().intValue();
	}

	public long longValue() {
		return this.abs().longValue();
	}

	public float floatValue() {
		return this.abs().floatValue();
	}

	public double doubleValue() {
		return this.abs().doubleValue();
	}

	//	---oooOOOooo---

	public Num widenTo( final Num n ) {
		return this;
	}

	public Num widenExactly() {
		return this;
	}

	public Num widenInexactly() {
		return this;
	}

	//	---oooOOOooo---

	public void showTo( Consumer cuchar ) {
		cuchar.outObject( this.real_part );
		cuchar.out( '+' );
		cuchar.outObject( this.imag_part );
		cuchar.out( 'i' );
	}

	public static final ComplexNum I = new ComplexNum( IntegerNum.ZERO, IntegerNum.ONE );
}
