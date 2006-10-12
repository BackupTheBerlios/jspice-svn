package org.openspice.jspice.built_in;

import org.openspice.jspice.datatypes.proc.Unary1InvokeProc;

/**
 * User: sleach
 * Date: Oct 4, 2005
 * Time: 4:34:35 PM
 */
public class DataClassProc extends Unary1InvokeProc {

	{
		this.setDescription(
			"dataClass",
			"%p( item ) -> class",
			"returns the class of an item"
 		);
	}

//	public Object invoke( final Object x ) {
//		return ListLib.first( x );
//	}
//
//	public static final FirstProc FIRST_PROC = new FirstProc();


	public Object invoke( final Object x ) {
		return x.getClass();
	}

	public static final DataClassProc  DATA_CLASS_PROC = new DataClassProc(); 

}
