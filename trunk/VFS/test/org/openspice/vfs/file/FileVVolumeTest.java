package org.openspice.vfs.file;

import java.io.File;
import java.util.Iterator;

import org.openspice.vfs.VFile;
import org.openspice.vfs.VFolder;

import junit.framework.TestCase;

public class FileVVolumeTest extends TestCase {
	
	public void testFileVVolume() {
		final VFolder folder = new FileVVolume( new File( "/usr" ) ).getRootVFolder();
		assertEquals( ((FileVFolder)folder).getName(), "usr" );
		for ( Iterator it = folder.listVFolders().iterator(); it.hasNext(); ) {
			final VFolder vfobj = (VFolder)it.next();
			assertTrue( new File( ((FileVFolder)vfobj).getPath() ).isDirectory() );
		}
		for ( Iterator it = folder.listVFiles().iterator(); it.hasNext(); ) {
			final VFile vf = (VFile)it.next();
			assertTrue( new File( ((FileVFolder)vf).getPath() ).isFile() );
		}
	}

}
