package org.openspice.jspice.tools;

public class SysAlert extends org.openspice.alert.Alert {

	public SysAlert(String _snafu_message, char phase) {
		super(_snafu_message, phase);
		// TODO Auto-generated constructor stub
	}

	public SysAlert(String _complaint, String _explanation, char phase) {
		super(_complaint, _explanation, phase);
		// TODO Auto-generated constructor stub
	}

	public SysAlert(String _snafu_message, String _ok_message) {
		super(_snafu_message, _ok_message);
		// TODO Auto-generated constructor stub
	}

	public SysAlert(String _snafu_message) {
		super(_snafu_message);
		// TODO Auto-generated constructor stub
	}

	public SysAlert(Throwable t, String _complaint, String _explanation, char phase) {
		super(t, _complaint, _explanation, phase);
		// TODO Auto-generated constructor stub
	}

	public SysAlert(Throwable t, String _complaint, String _explanation) {
		super(t, _complaint, _explanation);
		// TODO Auto-generated constructor stub
	}

	public SysAlert(Throwable t, String _complaint) {
		super(t, _complaint);
		// TODO Auto-generated constructor stub
	}

	public String showToString( final Object x ) {
		return PrintTools.showToString( x );
	}
	
}
