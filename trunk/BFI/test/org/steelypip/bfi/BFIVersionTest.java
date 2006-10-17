package org.steelypip.bfi;

import org.steelypip.bfi.BFIVersion;

import junit.framework.TestCase;

public class BFIVersionTest extends TestCase {
	
	public void testVersion() {
		assertSame( 3, BFIVersion.VERSION.length );
	}

}
