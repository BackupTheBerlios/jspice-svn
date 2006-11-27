/**
 *	JSpice, an Open Spice interpreter and library.
 *	Copyright (C) 2003, Stephen F. K. Leach
 *
 * 	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 * 	the Free Software Foundation; either version 2 of the License, or
 * 	(at your option) any later version.
 *
 * 	This program is distributed in the hope that it will be useful,
 * 	but WITHOUT ANY WARRANTY; without even the implied warranty of
 * 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 * 	along with this program; if not, write to the Free Software
 *	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
package org.openspice.jspice.vm_and_compiler;

import org.openspice.jspice.tools.PrintTools;
import org.openspice.jspice.datatypes.ImmutableList;
import org.openspice.jspice.boxes.StdStdio;
import org.openspice.jspice.boxes.Stdio;
import org.openspice.jspice.conf.DynamicConf;
import org.openspice.jspice.tools.SysAlert;
import org.openspice.tools.StackOfInt;

import java.util.*;
import java.io.PrintStream;

public final class VM {

	static class StackImpl {

		protected Object[] data = new Object[ 0 ];
		protected int top = 0;

		//	Grow by at least n
		protected void grow( int n ) {
			final Object[] d = this.data;
			if ( n < 64 ) n = 64;
			this.data = new Object[ d.length + n + d.length / 2 ];
			System.arraycopy( d, 0, this.data, 0, this.top );
		}

		int size() {
			return this.top;
		}

		Object getFromBase( final int n ) {
			assert n >= 0;
			try {
				return this.data[ n ];
			} catch ( Exception e ) {
				throw new RuntimeException( e );
			}
		}

		Object getFromTop0Index( final int n ) {
			assert n >= 0;
			try {
				return this.data[ this.top - 1 - n ];
			} catch ( Exception e ) {
				throw new RuntimeException( e );
			}
		}

		Object getFromTop1Index( final int n ) {
			assert n >= 1;
			try {
				return this.data[ this.top - n ];
			} catch ( Exception e ) {
				System.err.println( "array size: " + this.data.length );
				System.err.println( "top: " + this.top );
				System.err.println( "n: " + n  );
				throw new RuntimeException( e );
			}
		}

	}

	static final class ValueStack extends StackImpl {

		Object pop() {
			try {
				return this.data[ --top ];
			} catch ( ArrayIndexOutOfBoundsException ex ) {
				//	Intercepted underflow.  THIS NEVER HAPPENS.
				this.top = 0;
				throw new SysAlert( "Stack underflow" ).mishap();
			}
		}

		void drop( final int n ) {
			this.top -= n;
			if ( this.top < 0 ) {
				//	Intercepted underflow.  THIS NEVER HAPPENS.
				this.top = 0;
				throw new SysAlert( "Stack underflow" ).mishap();
			}
		}

		void pushCollection( final Collection c ) {
			if ( this.data.length - this.top < c.size() ) {
				this.grow( c.size() );
			}
			for ( Iterator it = c.iterator(); it.hasNext(); ) {
				this.data[ this.top++ ] = it.next();
			}
		}

		void push( final Object x ) {
			try {
				this.data[ this.top ] = x;
			} catch ( ArrayIndexOutOfBoundsException ex ) {
				this.grow( 1 );
			}
			this.top += 1;
		}

		void clear() {
			this.top = 0;
			Arrays.fill( this.data, null );
		}

		void copyNvalsToList( final int nvals, final List< Object > list ) {
			final int t = this.top;
			for ( int i = t - nvals; i < t; i++ ) {
				list.add( this.data[ i ] );
			}
		}

		void moveNvalsTo( final int nvals, final List< Object > list ) {
			final int t = this.top;
			for ( int i = t - nvals; i < t; i++ ) {
				list.add( this.data[ i ] );
			}
			this.top -= nvals;
		}

	}

	static final class CallStack extends StackImpl {

		void setSize( final int n ) {
			if ( n > this.data.length ) this.grow( this.data.length - n );	//	 not convinced I should have put this in
			this.top = n;				//	ooh - scarey
		}

		void set( final int n, final Object x ) {
//			System.err.println( "DATA# = " + data.length + "; n = " + n + "; x = " + x );
			this.data[ n ] = x;
		}

	}

	private ValueStack stack = new ValueStack();			//	todo: expensive!!
	private CallStack callstack = new CallStack();			//	todo: expensive!!
	private StackOfInt intstack = new StackOfInt();

	/**
	 * Virtual machines registers.  Can be used for anything in principle.
	 * However, n_args is used in function calls and v_args in assignments &
	 * initializations.
	 */
	int n_args;			//	How many arguments are waiting on the stack.
	int v_args;			//	How many values are waiting on the stack.

	private Stdio stdio = new StdStdio();
	
	public Stdio getStdio() {
		return this.stdio;
	}

	public void setStdio( final Stdio stdio ) {
		this.stdio = stdio;
	}

	private final DynamicConf dyn_conf;

	public VM( DynamicConf _jconf ) {
		this.dyn_conf = _jconf;
//		this.stack = new ValueStack();
//		this.callstack = new CallStack();
//		this.intstack = new StackOfInt();
	}

	public DynamicConf getDynamicConf() {
		return this.dyn_conf;
	}

	public int intpop() {
		return this.intstack.pop();
	}
	
	public void intpush( final int n ) {
		this.intstack.push( n );
	}

	//	Very inefficient!  Note that in the future we should be planning on
	//	using arraycopy to make this go faster! 
	public Object callpush( Object tos, final boolean[] args_named, final int nslots ) {
		assert nslots >= 0 && args_named != null;
		final int sz = this.callstack.size() + nslots;
		this.callstack.setSize( sz );
		int n = 1;
		for ( int i = args_named.length - 1; i >= 0; i-- ) {
			if ( args_named[ i ] ) {
				//System.out.println( "set[" + i + "]: " + tos );
				this.callstack.set( sz - n++, tos );
				tos = this.stack.pop();
			} else {
				//System.out.println( "drop " + tos );
				tos = this.stack.pop();
			}
		}
		return tos;
	}
	
	public void callpush( final int nslots ) {
		assert nslots >= 0;
		final int sz = this.callstack.size() + nslots;
		this.callstack.setSize( sz );
	}

	
	//	Very inefficient!
	public void calldrop( final int n ) {
		assert n >= 0;
		this.callstack.setSize( this.callstack.size() - n );
	}
	
	//	Very inefficient!
	public Object load( final int offset ) {
		//System.out.println( "load offset = " + offset );
//		return this.callstack.getFromTop0Index( this.callstack.size() - offset );
		return this.callstack.getFromTop1Index( offset );
	}
	
	//	Very inefficient!
	public void store( final int offset, final Object obj ) {
//		System.err.println( "CALLSTACK# = " + this.callstack.size() + "; OFFSET = " + offset + "; INDEX = " + (this.callstack.size() - offset) );
		this.callstack.set( this.callstack.size() - offset, obj );
	}
	
	public Object pop() {
		return this.stack.pop();
	}

	public static final Object[] nullArgs = new Object[ 0 ];

	public Object[] popArray( final int n ) {
		if ( n == 0 ) return nullArgs;
		final Object[] array = new Object[ n ];
		for ( int i = n - 1; i >= 0; i-- ) {
			array[ i ] = this.stack.pop();
		}
		return array;
	}
	

	public Object getFromBase( final int n ) {
		return this.stack.getFromBase( n );
	}

	public Object getFromTop0Index( final int n ) {
		return callstack.getFromTop0Index( n );
	}

	public Object getFromTop1Index( final int n ) {
		return callstack.getFromTop1Index( n );
	}


	public void drop() {
		this.stack.pop();
	}
	
	public void drop( final int n ) {
		//assert( n >= 0 );
		this.stack.drop( n );
		//this.stack.setSize( this.stack.size() - n );
	}
	
	public void conslist( final int n ) {
		assert( n >= 0 );
		final Object[] data = new Object[ n ];
		for ( int i = n - 1; i >= 0; i-- ) {
			data[ i ] = this.stack.pop();
		}
		this.stack.pushCollection( new ImmutableList( data ) );
	}
	
	public void push( Object x ) {
		this.stack.push( x );
	}
	
	public void save( final Object[] buffer ) {
		for ( int i = 0; i < buffer.length; i++ ) {
			buffer[ i ] = this.stack.pop();
		}
	}
	
	public void restore( final Object[] buffer ) {
		for ( int i = buffer.length - 1; i >= 0; i-- ) {
			this.stack.push( buffer[ i ] );
		}
	}
	
	public void clearAll() {
		this.stack.clear();
	}
	
	//	Might be the wrong place for this.
	public void showAll() {
		final int count = this.stack.size();
		for ( int i = 1; i < count; i++ ) {
			final Object obj = this.stack.getFromBase( i );
			PrintTools.showln( obj );
		}
	}

	private List saved_results = ImmutableList.EMPTY_LIST;
	
	public void saveAllResults() {
		final List< Object > list = new ArrayList< Object >();
		final int count = this.stack.size();
		for ( int i = 1; i < count; i++ ) {
			list.add( this.stack.getFromBase( i ) );
		}
		this.saved_results = list;
	}

	public List getAllResults() {
		return this.saved_results;
	}

	/**
	 * Because "run" assumes that we will always have a top of
	 * stack, we will end up with an extra value (null) at the
	 * start of the stack.
	 */
	public void run( final Pebble p ) {
		this.push( p.run( null, this ) );
	}
	
	public int length() { 
		return this.stack.size();
	}

	/**
	 * Ditch the extra null caused by invoking "run" that way.  Not
	 * very efficient - but it doesn't need to be.
	 */
	public void copyTo( final List< Object > list ) {
		this.stack.copyNvalsToList( this.stack.size() - 1, list );
	}

	public void moveNvalsTo( final int nvals, final List< Object > dst ) {
		this.stack.moveNvalsTo( nvals, dst );
	}

	/**
	 * Debugging routine
	 *
	 */
	public void show( final PrintStream s ) {
		s.println( "Value stack: " + this.stack.size() );
		for ( int i = 0; i < this.stack.size(); i++ ) {
			s.println( "[" + i + "] " + this.stack.getFromBase( i ) );
		}
	}


}