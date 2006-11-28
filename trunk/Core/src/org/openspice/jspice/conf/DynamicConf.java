package org.openspice.jspice.conf;

import java.io.File;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.openspice.jspice.class_builder.JSpiceClassLoader;
import org.openspice.jspice.run.jline_stuff.PrefixFilterAccumulator;
import org.openspice.jspice.run.manual.Manual;
import org.openspice.vfs.VFile;
import org.openspice.vfs.VFolder;

public interface DynamicConf {

	public abstract String getPrompt();

	public abstract String getLoadConfFileName();

	public abstract String getLoadFolderName();

	public abstract char getExtensionChar(final File f);

	public abstract Set getInventories();

	public abstract void installInventoryConf(final VFolder inventory_path);

	//
	//	Given a package name, locate the package folder.  The answer must be unqiue
	//	even after searching every inventory.
	//
	public abstract VFolder locatePackage(final String pkg_name);

	public abstract String getLoaderBuilderClassName(final String extn,
			final boolean null_allowed);

	public abstract Collection getAutoloaders();

	public abstract boolean isDebugging();

	public abstract void setIsDebugging(final boolean _is_debugging);

	public abstract VFolder getUserHome();

	public abstract VFolder getHome();

	public abstract Manual getManualByName(final String mname);

	public abstract void findManualCompletions(final PrefixFilterAccumulator acc);

	public abstract VFile getLicenceFile();

	public abstract Map getEnvMap();

	public abstract Character decode(final String s);

	public abstract String encode(final char ch);

	public abstract List listEntities(final String regex);

	public abstract JSpiceClassLoader getClassLoader();

	public abstract String getInventoryConfNam();

	public abstract VFolder lookupInventoryNickname(String value);

}