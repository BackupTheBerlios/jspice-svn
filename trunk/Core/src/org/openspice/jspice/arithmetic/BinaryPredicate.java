package org.openspice.jspice.arithmetic;

public abstract class BinaryPredicate {

	public abstract Boolean applyNum( final Num x, final Num y );

	public final Boolean apply( final Number x, final Number y ) {
		if ( x instanceof Num ) {
			if ( y instanceof Num ) {
				return this.applyNum( (Num)x, (Num)y );
			} else {
				return this.apply( x, Num.toNum( y ) );
			}
		} else {
			return this.apply( Num.toNum( x ), y );
		}
	}

}

