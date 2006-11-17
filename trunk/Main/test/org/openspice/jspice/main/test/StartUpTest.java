package org.openspice.jspice.main.test;

import java.io.File;

import junit.framework.TestCase;

public class StartUpTest extends TestCase {
	
	public void testStartUp() {
		System.out.println( System.getProperty( "user.dir" ) );
		System.out.println( new File( "" ).getAbsolutePath() );
	}
	
}
