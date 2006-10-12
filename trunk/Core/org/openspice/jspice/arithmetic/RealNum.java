package org.openspice.jspice.arithmetic;

public abstract class RealNum extends Num {

	public boolean isReal() {
		return true;
	}

	public abstract RealNum intOf();

	public abstract RealNum addReal( final RealNum that );
	public abstract RealNum subReal( final RealNum that );
	public abstract RealNum mulReal( final RealNum that );
	public abstract RealNum divReal( final RealNum that );

	public abstract RealNum widenToReal( final RealNum that );

	public RealNum canonize() {
		return this;
	}

	public final RealNum addRealThenCanonize( final RealNum num ) {
		return this.widenToReal( num ).addReal( num.widenToReal( this ) ).canonize();
	}

	public final RealNum subRealThenCanonize( final RealNum num ) {
		return this.widenToReal( num ).subReal( num.widenToReal( this ) ).canonize();
	}

	public final RealNum mulRealThenCanonize( final RealNum num ) {
		return this.widenToReal( num ).mulReal( num.widenToReal( this ) ).canonize();
	}

	public final RealNum divRealThenCanonize( final RealNum num ) {
		return this.widenToReal( num ).divReal( num.widenToReal( this ) ).canonize();
	}

}
