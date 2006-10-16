package org.openspice.jspice.main.pragmas;

import org.openspice.jspice.main.Pragma;

public final class RegisterPragmas {

	public static void register() {
		//	Bind Pragmas
		Pragma.register( new AutoloadersPragma() );
		Pragma.register( new ManualPragma() );
		Pragma.register( new DebugPragma() );
		Pragma.register( new JavaPragma() );
		Pragma.register( new EntitiesPragma() );
		Pragma.register( new ListPragma() );
		Pragma.register( new LoadPragma() );
		Pragma.register( new QuitPragmaAction() );
		Pragma.register( new StylePragma() );
		Pragma.register( new VersionsPragma() );
	}
	
}
