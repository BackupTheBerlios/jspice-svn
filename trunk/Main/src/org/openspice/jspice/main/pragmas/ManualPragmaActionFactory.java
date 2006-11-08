package org.openspice.jspice.main.pragmas;

import org.openspice.alert.Alert;
import org.openspice.jspice.main.Pragma;
import org.openspice.jspice.main.PragmaAction;
import org.openspice.jspice.main.PragmaActionFactory;
import org.openspice.jspice.main.manual.Manual;
import org.openspice.jspice.main.manual.SearchPhrase;

public class ManualPragmaActionFactory extends PragmaActionFactory {

	
	static final class ManualActionPragma implements PragmaAction {
		
		final Manual manual;

		public ManualActionPragma( final Manual manual ) {
			this.manual = manual;
		}

		public void doAction( final Pragma pragma ) {
			final SearchPhrase t = new SearchPhrase();
			for ( String s : pragma.getArgList() ) {
				t.add( s );
			}
			new ManualPragma().help( manual, t );
		}

		public String[] names() {
			throw Alert.unreachable();
		}
		
	}
	
	@Override
	public PragmaAction newInstance( final Pragma pragma, final String command ) {
		final Manual manual = pragma.getDynamicConf().getManualByName( command );
		if ( manual != null ) {
			return new ManualActionPragma( manual );
		} else {
			return null;
		}
	}
	
}
