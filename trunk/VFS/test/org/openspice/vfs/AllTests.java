package org.openspice.vfs;

import org.openspice.vfs.zip.ZipVVolumeTest;

import junit.framework.Test;
import junit.framework.TestSuite;

public class AllTests {

	public static Test suite() {
		final TestSuite suite = new TestSuite( "Test for org.openspice.vfs" );
		suite.addTestSuite( ZipVVolumeTest.class );
		//$JUnit-BEGIN$

		//$JUnit-END$
		return suite;
	}

}
