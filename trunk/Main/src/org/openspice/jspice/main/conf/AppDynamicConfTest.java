package org.openspice.jspice.main.conf;

import org.openspice.jspice.conf.DynamicConf;
import org.openspice.vfs.VFolder;
import junit.framework.TestCase;

public class AppDynamicConfTest extends TestCase {
	
	public void testFileFVS() {
		final DynamicConf jconf = new AppDynamicConf();
		final VFolder home = jconf.getHome();
		assertEquals( home.getVFile( "jspice", "conf" ).getNam(), "jspice" );
	}

}
