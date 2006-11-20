package org.openspice.vfs.zip;

import java.io.File;
import java.io.IOException;
import java.util.zip.ZipFile;

import org.openspice.vfs.VFile;
import org.openspice.vfs.VVolume;

import junit.framework.TestCase;

public class ZipVVolumeTest extends TestCase {

	public void testZipVFS() throws IOException {
//		System.out.println( System.getProperty( "user.dir" ) );
//		System.out.println( this.getClass().getResource( ) );
		assertTrue( "check zip file exists", new File( "../system/test/jspice.zip" ).exists() );
		final VVolume vvol = new ZipVVolume( new ZipFile( "../system/test/jspice.zip" ) );
		final VFile vfile = vvol.getVFileFromPath( ".jspice/jspice.conf" );
		assertTrue( "vfile not null", vfile != null );
		assertEquals( "check nam", vfile.getNam(), "jspice" );
		assertEquals( "check ext", vfile.getExt(), "conf" );
	}
	
}
