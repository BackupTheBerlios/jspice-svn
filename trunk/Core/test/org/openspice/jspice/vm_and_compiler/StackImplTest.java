package org.openspice.jspice.vm_and_compiler;

import junit.framework.TestCase;

public class StackImplTest extends TestCase {

	public void testLimits() {
		final VM.ValueStack s = new VM.ValueStack();
		for ( int i = 0; i < 1000; i++ ) {
			s.push( "foo" );
		}
		assertEquals( "foo", s.pop() );
		assertEquals( 999, s.size() );
	}
	
}
