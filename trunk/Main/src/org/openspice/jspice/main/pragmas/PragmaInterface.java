package org.openspice.jspice.main.pragmas;

import org.openspice.jspice.conf.DynamicConf;
import org.openspice.jspice.main.jline_stuff.PrefixFilterAccumulator;
import org.openspice.jspice.namespace.NameSpace;
import org.openspice.jspice.namespace.NameSpaceManager;

public interface PragmaInterface {

	public abstract DynamicConf getDynamicConf();

	public abstract NameSpace getNameSpace();

	public abstract NameSpaceManager getNameSpaceManager();

	public abstract void perform();

	public abstract void findPragmaCompletions(final PrefixFilterAccumulator acc);

}